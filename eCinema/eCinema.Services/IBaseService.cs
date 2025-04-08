using eCinema.Model;
using eCinema.Model.Requests;
using eCinema.Model.SearchObjects;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace eCinema.Services
{
    public interface IBaseService<TResponse, TSearchObject, TCreateRequest, TUpdateRequest>
        where TResponse : class
        where TSearchObject : BaseSearchObject
        where TCreateRequest : class
        where TUpdateRequest : class
    {
        Task<List<TResponse>> GetAsync(TSearchObject search = null);
        Task<TResponse> GetByIdAsync(int id);
        Task<TResponse> CreateAsync(TCreateRequest request);
        Task<TResponse> UpdateAsync(int id, TUpdateRequest request);
        Task<bool> DeleteAsync(int id);
    }
} 