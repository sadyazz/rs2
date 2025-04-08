using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;
using eCinema.Services;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class BaseCRUDController<T, TSearch, TInsert, TUpdate> : BaseController<T, TSearch> where T : class where TSearch : BaseSearchObject, new() where TInsert : class where TUpdate : class
    {
        private readonly ICRUDService<T, TSearch, TInsert, TUpdate> _crudService;

        public BaseCRUDController(ICRUDService<T, TSearch, TInsert, TUpdate> service) : base(service)
        {
            _crudService = service;
        }

        [HttpPost]
        public async Task<T> Create([FromBody] TInsert request){
            return await _crudService.CreateAsync(request);
        }

        [HttpPut("{id}")]   
        public async Task<T> Update(int id, [FromBody] TUpdate request){
            return await _crudService.UpdateAsync(id, request);
        }

        [HttpDelete("{id}")]
        public async Task<bool> Delete(int id){
            return await _crudService.DeleteAsync(id);
        }
    }
}