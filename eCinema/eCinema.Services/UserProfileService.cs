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
    public class UserProfileService : IUserProfileService
    {
        private readonly eCinemaDBContext _context;
        
        public UserProfileService(eCinemaDBContext context)
        {
            _context = context;
        }

        public async Task<List<UserProfileResponse>> GetAsync(UserProfileSearchObject search)
        {
            var query = _context.UserProfiles.AsQueryable();

            if (!string.IsNullOrWhiteSpace(search.FirstName))
                query = query.Where(x => x.FirstName.Contains(search.FirstName));

            if (!string.IsNullOrWhiteSpace(search.LastName))
                query = query.Where(x => x.LastName.Contains(search.LastName));

            if (!string.IsNullOrWhiteSpace(search.Email))
                query = query.Where(x => x.Email.Contains(search.Email));

            if (!string.IsNullOrWhiteSpace(search.PhoneNumber))
                query = query.Where(x => x.PhoneNumber.Contains(search.PhoneNumber));

            if (search.Active.HasValue)
                query = query.Where(x => x.Active == search.Active.Value);

            // Add pagination if page number and size are provided
            if (search.PageNumber.HasValue && search.PageSize.HasValue)
            {
                query = query.Skip((search.PageNumber.Value - 1) * search.PageSize.Value)
                             .Take(search.PageSize.Value);
            }

            var userProfiles = await query.ToListAsync();

            return userProfiles.Select(MapToUserProfileResponse).ToList();
        }

        public async Task<UserProfileResponse?> GetByIdAsync(int id)
        {
            var userProfile = await _context.UserProfiles.FindAsync(id);
            
            if (userProfile == null)
                return null;
                
            return MapToUserProfileResponse(userProfile);
        }

        public async Task<UserProfileResponse> CreateAsync(UserProfileUpsertRequest request)
        {
            var userProfile = new UserProfile
            {
                UserId = request.UserId,
                FirstName = request.FirstName,
                LastName = request.LastName,
                Email = request.Email,
                PhoneNumber = request.PhoneNumber,
                Address = request.Address,
                Active = request.Active
            };
            
            _context.UserProfiles.Add(userProfile);
            await _context.SaveChangesAsync();
            
            return MapToUserProfileResponse(userProfile);
        }

        public async Task<UserProfileResponse?> UpdateAsync(int id, UserProfileUpsertRequest request)
        {
            var userProfile = await _context.UserProfiles.FindAsync(id);
            
            if (userProfile == null)
                return null;
                
            userProfile.UserId = request.UserId;
            userProfile.FirstName = request.FirstName;
            userProfile.LastName = request.LastName;
            userProfile.Email = request.Email;
            userProfile.PhoneNumber = request.PhoneNumber;
            userProfile.Address = request.Address;
            userProfile.Active = request.Active;
            
            await _context.SaveChangesAsync();
            
            return MapToUserProfileResponse(userProfile);
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var userProfile = await _context.UserProfiles.FindAsync(id);
            
            if (userProfile == null)
                return false;
                
            // Soft delete - just mark as inactive
            userProfile.Active = false;
            
            await _context.SaveChangesAsync();
            
            return true;
        }
        
        private UserProfileResponse MapToUserProfileResponse(UserProfile userProfile)
        {
            return new UserProfileResponse
            {
                Id = userProfile.Id,
                UserId = userProfile.UserId,
                FirstName = userProfile.FirstName,
                LastName = userProfile.LastName,
                Email = userProfile.Email,
                PhoneNumber = userProfile.PhoneNumber,
                Address = userProfile.Address,
                Active = userProfile.Active
            };
        }
    }
} 