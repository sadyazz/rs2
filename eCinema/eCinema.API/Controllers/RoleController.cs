using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;
using eCinema.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace eCinema.API.Controllers
{
    // [Authorize(Roles = "Administrator")]
    [AllowAnonymous]
    public class RoleController : BaseCRUDController<RoleResponse, RoleSearchObject, RoleUpsertRequest, RoleUpsertRequest>
    {
        public RoleController(IRoleService service) : base(service)
        {
        }
        
        // // Allow anonymous access to GET endpoints only
        // [HttpGet]
        // [AllowAnonymous]
        // public override async Task<PagedResult<RoleResponse>> Get([FromQuery] RoleSearchObject? search = null)
        // {
        //     return await _service.GetAsync(search ?? new RoleSearchObject());
        // }
        
        // [HttpGet("{id}")]
        // [AllowAnonymous]
        // public override async Task<RoleResponse?> GetById(int id)
        // {
        //     return await _service.GetByIdAsync(id);
        // }
    }
} 