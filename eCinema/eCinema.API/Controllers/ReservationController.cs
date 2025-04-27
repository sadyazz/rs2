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
    public class ReservationController : BaseCRUDController<ReservationResponse, ReservationSearchObject, ReservationUpsertRequest, ReservationUpsertRequest>
    {
        private readonly IReservationService _service;
        public ReservationController(IReservationService service) : base(service)
        {
            _service = service;
        }

        [HttpPost("approve/{id}")]
        public virtual async Task<ReservationResponse?> ApproveAsync(int id)
        {
            return await _service.ApproveAsync(id);
        }       

        [HttpPost("reject/{id}")]
        public virtual async Task<ReservationResponse?> RejectAsync(int id)
        {
            return await _service.RejectAsync(id);
        }

        [HttpPost("expire/{id}")]
        public virtual async Task<ReservationResponse?> ExpireAsync(int id)
        {
            return await _service.ExpireAsync(id);
        }
    }
} 