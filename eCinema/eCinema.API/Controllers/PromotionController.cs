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
    public class PromotionController : BaseCRUDController<PromotionResponse, PromotionSearchObject, PromotionUpsertRequest, PromotionUpsertRequest>
    {
        public PromotionController(IPromotionService service) : base(service)
        {
        }

        [HttpPost]
        [Authorize(Roles = "admin")]
        public override async Task<PromotionResponse> Create([FromBody] PromotionUpsertRequest request)
        {
            return await base.Create(request);
        }

        [HttpPut("{id}")]
        [Authorize(Roles = "admin")]
        public override async Task<PromotionResponse> Update(int id, [FromBody] PromotionUpsertRequest request)
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