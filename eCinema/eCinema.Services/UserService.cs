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

namespace eCinema.Services
{
    public class UserService : IUserService
    {
        private readonly eCinemaDBContext _context;
        
        public UserService(eCinemaDBContext context)
        {
            _context = context;
        }

        public async Task<List<UserResponse>> GetAsync(UserSearchObject search)
        {
            var query = _context.Users.AsQueryable();

            if (!string.IsNullOrWhiteSpace(search.Username))
                query = query.Where(x => x.Username.Contains(search.Username));

            if (!string.IsNullOrWhiteSpace(search.Email))
                query = query.Where(x => x.Email.Contains(search.Email));

            if (!string.IsNullOrWhiteSpace(search.FirstName))
                query = query.Where(x => x.FirstName.Contains(search.FirstName));

            if (!string.IsNullOrWhiteSpace(search.LastName))
                query = query.Where(x => x.LastName.Contains(search.LastName));

            if (search.RoleId.HasValue)
                query = query.Where(x => x.RoleId == search.RoleId.Value);

            if (search.Active.HasValue)
                query = query.Where(x => x.Active == search.Active.Value);

            // Add pagination if page number and size are provided
            if (search.PageNumber.HasValue && search.PageSize.HasValue)
            {
                query = query.Skip((search.PageNumber.Value - 1) * search.PageSize.Value)
                             .Take(search.PageSize.Value);
            }

            var users = await query.ToListAsync();

            return users.Select(MapToUserResponse).ToList();
        }

        public async Task<UserResponse?> GetByIdAsync(int id)
        {
            var user = await _context.Users.FindAsync(id);
            
            if (user == null)
                return null;
                
            return MapToUserResponse(user);
        }

        public async Task<UserResponse> CreateAsync(UserUpsertRequest request)
        {
            var user = new User
            {
                FirstName = request.FirstName,
                LastName = request.LastName,
                Username = request.Username,
                Email = request.Email,
                PasswordHash = request.Password, // Should be hashed in a real app
                PhoneNumber = request.PhoneNumber,
                Active = request.Active,
                RoleId = request.RoleId
            };
            
            _context.Users.Add(user);
            await _context.SaveChangesAsync();
            
            return MapToUserResponse(user);
        }

        public async Task<UserResponse?> UpdateAsync(int id, UserUpsertRequest request)
        {
            var user = await _context.Users.FindAsync(id);
            
            if (user == null)
                return null;
                
            user.FirstName = request.FirstName;
            user.LastName = request.LastName;
            user.Username = request.Username;
            user.Email = request.Email;
            if (!string.IsNullOrEmpty(request.Password))
                user.PasswordHash = request.Password; // Should be hashed in a real app
            user.PhoneNumber = request.PhoneNumber;
            user.Active = request.Active;
            user.RoleId = request.RoleId;
            
            await _context.SaveChangesAsync();
            
            return MapToUserResponse(user);
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var user = await _context.Users.FindAsync(id);
            
            if (user == null)
                return false;
                
            // Soft delete - just mark as inactive
            user.Active = false;
            
            await _context.SaveChangesAsync();
            
            return true;
        }
        
        private UserResponse MapToUserResponse(User user)
        {
            return new UserResponse
            {
                Id = user.Id,
                FirstName = user.FirstName,
                LastName = user.LastName,
                Username = user.Username,
                Email = user.Email,
                PhoneNumber = user.PhoneNumber,
                Active = user.Active,
                RoleId = user.RoleId
            };
        }

        public async Task<UserResponse?> AuthenticateAsync(UserLoginRequest request)
        {
            var user = await _context.Users.FirstOrDefaultAsync(x => x.Username == request.Username);
            
            if (user == null)
                return null;

            if (!VerifyPassword(request.Password, user.PasswordHash))
                return null;

            return MapToUserResponse(user);
        }

        private bool VerifyPassword(string password, string hashedPassword)
        {
            return BCrypt.Net.BCrypt.Verify(password, hashedPassword);
        }

    }
} 