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
    public class ScreeningController : BaseCRUDController<ScreeningResponse, ScreeningSearchObject, ScreeningUpsertRequest, ScreeningUpsertRequest>
    {
        public ScreeningController(IScreeningService service) : base(service)
        {
        }
    }
} 