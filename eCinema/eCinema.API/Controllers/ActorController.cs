using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;
using eCinema.Services;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ActorController : BaseCRUDController<ActorResponse, ActorSearchObject, ActorUpsertRequest, ActorUpsertRequest>
    {
        public ActorController(IActorService service) : base(service)
        {
        }
    }
} 