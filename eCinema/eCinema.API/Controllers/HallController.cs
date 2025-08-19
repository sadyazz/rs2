using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;
using eCinema.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;

namespace eCinema.API.Controllers
{
    [Authorize]
    [ApiController]
    [Route("[controller]")]
    public class HallController : BaseCRUDController<HallResponse, HallSearchObject, HallUpsertRequest, HallUpsertRequest>
    {
        private readonly IHallService _hallService;

        public HallController(IHallService service) : base(service)
        {
            _hallService = service;
        }

        [HttpPost]
        [Authorize(Roles = "admin")]
        public override async Task<HallResponse> Create([FromBody] HallUpsertRequest request)
        {
            return await base.Create(request);
        }

        [HttpPut("{id}")]
        [Authorize(Roles = "admin")]
        public override async Task<HallResponse> Update(int id, [FromBody] HallUpsertRequest request)
        {
            return await base.Update(id, request);
        }

        [HttpDelete("{id}")]
        [Authorize(Roles = "admin")]
        public override async Task<bool> Delete(int id)
        {
            return await base.Delete(id);
        }

        [HttpPost("{id}/generate-seats")]
        [Authorize(Roles = "admin")]
        public async Task<IActionResult> GenerateSeats(int id, [FromBody] GenerateSeatsRequest request)
        {
            try
            {
                await _hallService.GenerateSeatsForHall(id, request.Capacity);
                return Ok("Seats generated successfully");
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
} 