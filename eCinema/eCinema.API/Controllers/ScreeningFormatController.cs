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
    public class ScreeningFormatController : BaseCRUDController<ScreeningFormatResponse, ScreeningFormatSearchObject, ScreeningFormatUpsertRequest, ScreeningFormatUpsertRequest>
    {
        public ScreeningFormatController(IScreeningFormatService service) : base(service)
        {
        }

        [HttpPost]
        [Authorize(Roles = "admin")]
        public override async Task<ScreeningFormatResponse> Create([FromBody] ScreeningFormatUpsertRequest request)
        {
            return await base.Create(request);
        }

        [HttpPut("{id}")]
        [Authorize(Roles = "admin")]
        public override async Task<ScreeningFormatResponse> Update(int id, [FromBody] ScreeningFormatUpsertRequest request)
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