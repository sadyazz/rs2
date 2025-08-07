using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;
using eCinema.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.API.Controllers
{
    [Authorize]
    [ApiController]
    [Route("[controller]")]
    public class ActorController : BaseCRUDController<ActorResponse, ActorSearchObject, ActorUpsertRequest, ActorUpsertRequest>
    {
        public ActorController(IActorService service) : base(service)
        {
        }

        [HttpPost]
        [Authorize(Roles = "admin")]
        public override async Task<ActorResponse> Create([FromBody] ActorUpsertRequest request)
        {
            return await base.Create(request);
        }

        [HttpPut("{id}")]
        [Authorize(Roles = "admin")]
        public override async Task<ActorResponse> Update(int id, [FromBody] ActorUpsertRequest request)
        {
            return await base.Update(id, request);
        }

        [HttpDelete("{id}")]
        [Authorize(Roles = "admin")]
        public override async Task<bool> Delete(int id)
        {
            return await base.Delete(id);
        }
    }
} 