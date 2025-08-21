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

        [HttpPost("hall/{hallId}/generate")]
        public async Task<IActionResult> GenerateSeats(int hallId, [FromQuery] int capacity)
        {
            await _seatService.GenerateSeatsForHall(hallId, capacity);
            return Ok();
        }
    }
}