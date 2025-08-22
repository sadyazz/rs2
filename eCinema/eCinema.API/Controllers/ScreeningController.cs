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

        [HttpPost]
        [Authorize(Roles = "admin")]
        public override async Task<ScreeningResponse> Create([FromBody] ScreeningUpsertRequest request)
        {
            return await base.Create(request);
        }

        [HttpPut("{id}")]
        [Authorize(Roles = "admin")]
        public override async Task<ScreeningResponse> Update(int id, [FromBody] ScreeningUpsertRequest request)
        {
            return await base.Update(id, request);
        }

        [HttpDelete("{id}")]
        [Authorize(Roles = "admin")]
        public override async Task<bool> Delete(int id)
        {
            return await base.Delete(id);
        }

        [HttpGet("{id}/seats")]
        public async Task<IActionResult> GetSeatsForScreening(int id)
        {
            try
            {
                var service = (IScreeningService)_crudService;
                var seats = await service.GetSeatsForScreeningAsync(id);
                return Ok(seats);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpPost("{id}/generate-seats")]
        public async Task<IActionResult> GenerateSeatsForScreening(int id)
        {
            try
            {
                var service = (IScreeningService)_crudService;
                var count = await service.GenerateSeatsForScreeningAsync(id);
                return Ok(new { message = $"Generated {count} screening seats for screening {id}" });
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }
    }
} 