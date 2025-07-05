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
        public virtual async Task<T> Create([FromBody] TInsert request){
            return await _crudService.CreateAsync(request);
        }

        [HttpPut("{id}")]   
        public virtual async Task<T> Update(int id, [FromBody] TUpdate request){
            return await _crudService.UpdateAsync(id, request);
        }

        [HttpDelete("{id}")]
        public virtual async Task<bool> Delete(int id){
            return await _crudService.DeleteAsync(id);
        }

        [HttpDelete("{id}/soft")]
        public virtual async Task<IActionResult> SoftDelete(int id)
        {
            var result = await _crudService.SoftDeleteAsync(id);
            if (!result)
                return NotFound();

            return Ok(new { message = "Entity soft deleted successfully" });
        }

        [HttpPost("{id}/restore")]
        public virtual async Task<IActionResult> Restore(int id)
        {
            var result = await _crudService.RestoreAsync(id);
            if (!result)
                return NotFound();

            return Ok(new { message = "Entity restored successfully" });
        }
    }
}