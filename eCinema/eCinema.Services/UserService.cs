using eCinema.Model;
using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;
using eCinema.Services.Database;
using eCinema.Services.Database.Entities;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using BCrypt.Net;
using MapsterMapper;
using Microsoft.Data.SqlClient;
using System.Security.Cryptography;

namespace eCinema.Services
{
    public class UserService : BaseCRUDService<UserResponse, UserSearchObject, User, UserUpsertRequest, UserUpsertRequest>, IUserService
    {
        private readonly eCinemaDBContext _context;
        private const int SaltSize = 16;
        private const int KeySize = 32;
        private const int Iterations = 10000;
        
        public UserService(eCinemaDBContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
        }

        public async Task<List<UserResponse>> GetAsync(UserSearchObject search)
        {
            var query = _context.Users.AsQueryable();
            query = ApplyFilter(query, search);
            
            var users = await query.Include(u => u.Role).ToListAsync();
            return users.Select(MapToResponse).ToList();
        }

        public async Task<UserResponse?> GetByIdAsync(int id)
        {
            var user = await _context.Users.Include(u => u.Role).FirstOrDefaultAsync(u => u.Id == id);
            return user != null ? MapToResponse(user) : null;
        }

        private string HashPassword(string password, out byte[] salt)
        {
            salt = new byte[SaltSize];
            using (var rng = new RNGCryptoServiceProvider())
            {
                rng.GetBytes(salt);
            }

            using (var pbkdf2 = new Rfc2898DeriveBytes(password, salt, Iterations))
            {
                return Convert.ToBase64String(pbkdf2.GetBytes(KeySize));
            }
        }

        public async Task<UserResponse> CreateAsync(UserUpsertRequest request)
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
                IsActive = request.IsActive,
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

            return await GetUserResponseWithRoleAsync(user.Id);
        }

        public async Task<UserResponse?> UpdateAsync(int id, UserUpsertRequest request)
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
            user.Email = request.Email;
            user.Username = request.Username;
            user.PhoneNumber = request.PhoneNumber;
            user.IsActive = request.IsActive;
            user.RoleId = request.RoleId;

            if (!string.IsNullOrEmpty(request.Password))
            {
                byte[] salt;
                user.PasswordHash = HashPassword(request.Password, out salt);
                user.PasswordSalt = Convert.ToBase64String(salt);
            }
            
            await _context.SaveChangesAsync();
            return await GetUserResponseWithRoleAsync(user.Id);
        }

        public async Task<bool> DeleteAsync(int id)
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

            if (search.IsActive.HasValue)
                query = query.Where(x => x.IsActive == search.IsActive.Value);

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
            var salt = Convert.FromBase64String(passwordSalt);
            var hash = Convert.FromBase64String(passwordHash);
            var hashBytes = new Rfc2898DeriveBytes(password, salt, Iterations).GetBytes(KeySize);
            return hash.SequenceEqual(hashBytes);
        }
    }
} 