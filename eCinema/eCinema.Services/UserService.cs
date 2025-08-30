using eCinema.Model;
using eCinema.Model.Messages;
using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;
using eCinema.Services.Database;
using eCinema.Services.Database.Entities;
using eCinema.Services.RabbitMQ;
using Microsoft.EntityFrameworkCore;
using MapsterMapper;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;

namespace eCinema.Services
{
    public class UserService : BaseCRUDService<UserResponse, UserSearchObject, User, UserUpsertRequest, UserUpdateRequest>, IUserService
    {
        private readonly IRabbitMQService _rabbitMQService;
        private const int SaltSize = 16;
        private const int KeySize = 32;
        private const int Iterations = 10000;
        
        public UserService(eCinemaDBContext context, IMapper mapper, IRabbitMQService rabbitMQService) : base(context, mapper)
        {
            _rabbitMQService = rabbitMQService;
        }

        public override async Task<PagedResult<UserResponse>> GetAsync(UserSearchObject search)
        {
            var query = _context.Users.AsQueryable();
            query = ApplyFilter(query, search);
            
            var users = await query.Include(u => u.Role).ToListAsync();
            var userResponses = users.Select(MapToResponse).ToList();
            
            return new PagedResult<UserResponse>
            {
                Items = userResponses,
                TotalCount = userResponses.Count
            };
        }

        public override async Task<UserResponse?> GetByIdAsync(int id)
        {
            var user = await _context.Users.Include(u => u.Role).FirstOrDefaultAsync(u => u.Id == id);
            return user != null ? MapToResponse(user) : null;
        }

        private string HashPassword(string password, out byte[] salt)
        {
            salt = new byte[SaltSize];
            salt = RandomNumberGenerator.GetBytes(SaltSize);

            using (var pbkdf2 = new Rfc2898DeriveBytes(password, salt, Iterations, HashAlgorithmName.SHA256))
            {
                return Convert.ToBase64String(pbkdf2.GetBytes(KeySize));
            }
        }

        public override async Task<UserResponse> CreateAsync(UserUpsertRequest request)
        {
            if (await _context.Users.AnyAsync(u => u.Email == request.Email))
            {
                throw new InvalidOperationException("A user with this email already exists.");
            }
            
            if (await _context.Users.AnyAsync(u => u.Username == request.Username))
            {
                throw new InvalidOperationException("A user with this username already exists.");
            }
            
            var user = new User
            {
                FirstName = request.FirstName,
                LastName = request.LastName,
                Email = request.Email,
                Username = request.Username,
                PhoneNumber = request.PhoneNumber,
                RoleId = request.RoleId,
                CreatedAt = DateTime.UtcNow
            };

            if (!string.IsNullOrEmpty(request.Password))
            {
                byte[] salt;
                user.PasswordHash = HashPassword(request.Password, out salt);
                user.PasswordSalt = Convert.ToBase64String(salt);
            }

            _context.Users.Add(user);
            await _context.SaveChangesAsync();

            var userRole = await _context.Roles.FirstOrDefaultAsync(r => r.Id == user.RoleId);
            if (userRole?.Name == "staff")
            {
                var email = new Email
                {
                    To = user.Email,
                    FirstName = user.FirstName,
                    LastName = user.LastName,
                    Subject = "Your eCinema Staff Account Credentials",
                    Body = $"Username: {user.Username}\nPassword: {request.Password}",
                    Type = EmailType.StaffCredentials
                };
                await _rabbitMQService.SendEmail(email);
            }

            return await GetUserResponseWithRoleAsync(user.Id);
        }

        public override async Task<UserResponse> UpdateAsync(int id, UserUpdateRequest request)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null)
                return null;

                        if (await _context.Users.AnyAsync(u => u.Email == request.Email && u.Id != id))
            {
                throw new InvalidOperationException("A user with this email already exists.");
            }
            
            if (await _context.Users.AnyAsync(u => u.Username == request.Username && u.Id != id))
            {
                throw new InvalidOperationException("A user with this username already exists.");
            }

            user.FirstName = request.FirstName;
            user.LastName = request.LastName;
            user.Username = request.Username;
            user.Email = request.Email;
            user.PhoneNumber = request.PhoneNumber;
            if (request.RoleId.HasValue)
            {
                user.RoleId = request.RoleId.Value;
            }

            if (request.Image != null)
            {
                user.Image = request.Image;
            }
            
            await _context.SaveChangesAsync();
            return await GetUserResponseWithRoleAsync(user.Id);
        }

        public override async Task<bool> DeleteAsync(int id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null)
                return false;

            _context.Users.Remove(user);
            await _context.SaveChangesAsync();
            return true;
        }

        protected override IQueryable<User> ApplyFilter(IQueryable<User> query, UserSearchObject search)
        {
            query = base.ApplyFilter(query, search);
            
            if (!string.IsNullOrWhiteSpace(search.Username))
                query = query.Where(x => x.Username.Contains(search.Username));

            if (!string.IsNullOrWhiteSpace(search.Email))
                query = query.Where(x => x.Email.Contains(search.Email));

            if (!string.IsNullOrWhiteSpace(search.FirstName))
                query = query.Where(x => x.FirstName.Contains(search.FirstName));

            if (!string.IsNullOrWhiteSpace(search.LastName))
                query = query.Where(x => x.LastName.Contains(search.LastName));

            if (!string.IsNullOrWhiteSpace(search.FTS))
            {
                query = query.Where(x => 
                    x.FirstName.Contains(search.FTS) || 
                    x.LastName.Contains(search.FTS) || 
                    x.Username.Contains(search.FTS) || 
                    x.Email.Contains(search.FTS));
            }

            if (search.RoleId.HasValue)
                query = query.Where(x => x.RoleId == search.RoleId.Value);

            if (!string.IsNullOrWhiteSpace(search.RoleName))
                query = query.Where(x => x.Role.Name.Contains(search.RoleName));

            return query;
        }

        private async Task<UserResponse> GetUserResponseWithRoleAsync(int userId)
        {
            var user = await _context.Users
                .Include(u => u.Role)
                .FirstOrDefaultAsync(u => u.Id == userId);
            
            if (user == null)
                throw new InvalidOperationException("User not found");
            
            var response = MapToResponse(user);
            
            response.Role = new RoleResponse
            {
                Id = user.Role.Id,
                Name = user.Role.Name
            };
            
            return response;
        }

        public async Task<UserResponse?> AuthenticateAsync(UserLoginRequest request)
        {
            var user = await _context.Users
                .Include(u => u.Role)
                .FirstOrDefaultAsync(u => u.Username == request.Username);
            
            if (user == null)
                return null;

            if (!VerifyPassword(request.Password!, user.PasswordHash, user.PasswordSalt))
                return null;

            await _context.SaveChangesAsync();

            var response = MapToResponse(user);
            
            response.Role = new RoleResponse
            {
                Id = user.Role.Id,
                Name = user.Role.Name
            };
            
            return response;
        }

        private bool VerifyPassword(string password, string passwordHash, string passwordSalt)
        {
            if (string.IsNullOrEmpty(passwordSalt)) return false;
            
            var salt = Convert.FromBase64String(passwordSalt);
            var hash = Convert.FromBase64String(passwordHash);
            var hashBytes = new Rfc2898DeriveBytes(password, salt, Iterations, HashAlgorithmName.SHA256).GetBytes(KeySize);
            return hash.SequenceEqual(hashBytes);
        }

        public async Task<UserResponse> RegisterAsync(UserUpsertRequest request)
        {
            if (await _context.Users.AnyAsync(u => u.Email == request.Email))
            {
                throw new InvalidOperationException("A user with this email already exists.");
            }
            
            if (await _context.Users.AnyAsync(u => u.Username == request.Username))
            {
                throw new InvalidOperationException("A user with this username already exists.");
            }
            
            var user = new User
            {
                FirstName = request.FirstName,
                LastName = request.LastName,
                Email = request.Email,
                Username = request.Username,
                PhoneNumber = request.PhoneNumber,
                RoleId = request.RoleId,
                CreatedAt = DateTime.UtcNow
            };

            if (!string.IsNullOrEmpty(request.Password))
            {
                byte[] salt;
                user.PasswordHash = HashPassword(request.Password, out salt);
                user.PasswordSalt = Convert.ToBase64String(salt);
            }

            _context.Users.Add(user);
            await _context.SaveChangesAsync();

            var userRole = await _context.Roles
                .FirstOrDefaultAsync(r => r.Id == user.RoleId);

            if (userRole?.Name == "user")
            {
                var email = new Email
                {
                    To = user.Email,
                    FirstName = user.FirstName,
                    LastName = user.LastName,
                    Subject = "Welcome to eCinema!",
                    Body = "",
                    Type = EmailType.Welcome
                };
                await _rabbitMQService.SendEmail(email);
            }

            return await GetUserResponseWithRoleAsync(user.Id);
        }

        public async Task<bool> ChangePasswordAsync(int userId, string currentPassword, string newPassword)
{
    var user = await _context.Users.FindAsync(userId);
    if (user == null)
        throw new InvalidOperationException("User not found");

    if (!VerifyPassword(currentPassword, user.PasswordHash, user.PasswordSalt))
        return false;

    byte[] salt;
    user.PasswordHash = HashPassword(newPassword, out salt);
    user.PasswordSalt = Convert.ToBase64String(salt);

    await _context.SaveChangesAsync();
    return true;
}

    public async Task<UserResponse?> UpdateUserRoleAsync(int id, int roleId)
    {
        var user = await _context.Users.FindAsync(id);
        if (user == null)
            return null;

        user.RoleId = roleId;
        await _context.SaveChangesAsync();

        return await GetUserResponseWithRoleAsync(user.Id);
    }
    }
} 