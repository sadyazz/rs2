using eCinema.Model;
using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace eCinema.Services;

public interface IUserProfileService
{
    Task<List<UserProfileResponse>> GetAsync(UserProfileSearchObject search);
    Task<UserProfileResponse?> GetByIdAsync(int id);
    Task<UserProfileResponse> CreateAsync(UserProfileUpsertRequest request);
    Task<UserProfileResponse?> UpdateAsync(int id, UserProfileUpsertRequest request);
    Task<bool> DeleteAsync(int id);
} 