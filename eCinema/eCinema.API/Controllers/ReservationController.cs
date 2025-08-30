using eCinema.Model.Requests;
using eCinema.Model.SearchObjects;
using eCinema.Model.Responses;
using eCinema.Services;
using eCinema.Services.Database.Entities;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;

namespace eCinema.API.Controllers
{
    [Authorize]
    [ApiController]
    [Route("[controller]")]
    public class ReservationController : BaseCRUDController<ReservationResponse, ReservationSearchObject, ReservationUpsertRequest, ReservationUpsertRequest>
    {
        private readonly IReservationService _reservationService;

        public ReservationController(IReservationService service) : base(service)
        {
            _reservationService = service;
        }

        [HttpGet("available-seats/{screeningId}")]
        public async Task<ActionResult<List<Seat>>> GetAvailableSeats(int screeningId)
        {
            try
            {
                var availableSeats = await _reservationService.GetAvailableSeatsForScreening(screeningId);
                return Ok(availableSeats);
            }
            catch (Exception ex)
            {
                return BadRequest($"Error getting available seats: {ex.Message}");
            }
        }

        [HttpPost("verify/{reservationId}")]
        [Authorize]
        public async Task<ActionResult<ReservationResponse>> VerifyReservation(int reservationId)
        {
            try
            {
                var result = await _reservationService.VerifyReservation(reservationId);
                return Ok(result);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpPost("cancel/{reservationId}")]
        public async Task<ActionResult<ReservationResponse>> CancelReservation(int reservationId)
        {
            try
            {
                var result = await _reservationService.CancelReservation(reservationId);
                return Ok(result);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet("user/{userId}")]
        public ActionResult<List<ReservationResponse>> GetUserReservations(int userId, [FromQuery] bool? isFuture)
        {
            try
            {
                var reservations = _reservationService.GetReservationsByUserId(userId, isFuture);
                return Ok(reservations);
            }
            catch (Exception ex)
            {
                return BadRequest($"Error getting user reservations: {ex.Message}");
            }
        }
    }
} 