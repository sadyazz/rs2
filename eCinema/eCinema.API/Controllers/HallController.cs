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
    public class HallController : BaseCRUDController<HallResponse, HallSearchObject, HallUpsertRequest, HallUpsertRequest>
    {
        public HallController(IHallService service) : base(service)
        {
        }
    }
} 