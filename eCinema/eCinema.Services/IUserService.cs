using eCinema.Model;
using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;
using eCinema.Model.Requests;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace eCinema.Services
{
public interface IUserService : ICRUDService<UserResponse, UserSearchObject, UserUpsertRequest, UserUpdateRequest>
{
    Task<PagedResult<UserResponse>> GetAsync(UserSearchObject search);
    Task<UserResponse?> GetByIdAsync(int id);
    Task<UserResponse> CreateAsync(UserUpsertRequest request);
    Task<UserResponse?> UpdateAsync(int id, UserUpdateRequest request);
    Task<bool> DeleteAsync(int id);
    Task<UserResponse?> AuthenticateAsync(UserLoginRequest request);
    Task<UserResponse> RegisterAsync(UserUpsertRequest request);
    Task<bool> ChangePasswordAsync(int userId, string currentPassword, string newPassword);
    Task<UserResponse?> UpdateUserRoleAsync(int id, int roleId);
        Task<List<MovieResponse>> GetRecommendedMoviesAsync(int userId, int numberOfRecommendations = 4);
        Task TrainModelAsync();
        Task<List<object>> GetUserReviewsAsync(int userId);
} 
}