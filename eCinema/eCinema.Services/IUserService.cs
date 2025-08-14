using eCinema.Model;
using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace eCinema.Services
{
public interface IUserService : ICRUDService<UserResponse, UserSearchObject, UserUpsertRequest, UserUpsertRequest>
{
    Task<List<UserResponse>> GetAsync(UserSearchObject search);
    Task<UserResponse?> GetByIdAsync(int id);
    Task<UserResponse> CreateAsync(UserUpsertRequest request);
    Task<UserResponse?> UpdateAsync(int id, UserUpsertRequest request);
    Task<bool> DeleteAsync(int id);
    Task<UserResponse?> AuthenticateAsync(UserLoginRequest request);
    Task<UserResponse> RegisterAsync(UserUpsertRequest request);
} 
}