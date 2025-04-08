    using eCinema.Services.Database;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using eCinema.Model.Responses;
    using eCinema.Model.Requests;
    using eCinema.Model.SearchObjects;

    
    namespace eCinema.Services
    {
        public interface IService<T, TSearch> where T : class where TSearch : BaseSearchObject
        {
            Task<PagedResult<T>> GetAsync(TSearch search);
            Task<T?> GetByIdAsync(int id);
        }
    }