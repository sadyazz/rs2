using eCinema.Model.Responses;
using eCinema.Model.Requests;
using eCinema.Model.SearchObjects;
using eCinema.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.API.Controllers
{
    [Authorize]
    [ApiController]
    [Route("[controller]")]
    public class SeatController : BaseCRUDController<SeatResponse, BaseSearchObject, SeatUpsertRequest, SeatUpsertRequest>
    {
        private readonly ISeatService _seatService;

        public SeatController(ISeatService service) : base(service)
        {
            _seatService = service;
        }

        [HttpGet("screening/{screeningId}")]
        public async Task<List<SeatResponse>> GetSeatsForScreening(int screeningId)
        {
            return await _seatService.GetSeatsForScreening(screeningId);
        }

        [HttpGet("count")]
        public async Task<IActionResult> GetSeatsCount()
        {
            try
            {
                var count = await _seatService.GetSeatsCount();
                return Ok(new { totalSeats = count });
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpPost("generate-all")]
        public async Task<IActionResult> GenerateAllSeats()
        {
            try
            {
                var count = await _seatService.GenerateAllSeats();
                return Ok(new { message = $"Generated {count} new seats", totalSeats = count });
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpDelete("clear-all")]
        public async Task<IActionResult> ClearAllSeats()
        {
            try
            {
                var count = await _seatService.ClearAllSeats();
                return Ok(new { message = $"Cleared {count} seats", clearedSeats = count });
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }
    }
}