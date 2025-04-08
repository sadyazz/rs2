using eCinema.Model;
using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;
using eCinema.Services;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace eCinema.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UserProfileController : BaseController<UserProfileResponse, UserProfileSearchObject, UserProfileUpsertRequest, UserProfileUpsertRequest>
    {
        private readonly IUserProfileService _service;

        public UserProfileController(IUserProfileService service) : base(service)
        {
            _service = service;
        }

        [HttpGet]
        public async Task<ActionResult<List<UserProfileResponse>>> Get([FromQuery] UserProfileSearchObject search)
        {
            var result = await _service.GetAsync(search);
            return Ok(result);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<UserProfileResponse>> GetById(int id)
        {
            var result = await _service.GetByIdAsync(id);
            if (result == null)
                return NotFound();
            return Ok(result);
        }

        [HttpPost]
        public async Task<ActionResult<UserProfileResponse>> Create([FromBody] UserProfileUpsertRequest request)
        {
            var result = await _service.CreateAsync(request);
            return Ok(result);
        }

        [HttpPut("{id}")]
        public async Task<ActionResult<UserProfileResponse>> Update(int id, [FromBody] UserProfileUpsertRequest request)
        {
            var result = await _service.UpdateAsync(id, request);
            if (result == null)
                return NotFound();
            return Ok(result);
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult<bool>> Delete(int id)
        {
            var result = await _service.DeleteAsync(id);
            if (!result)
                return NotFound();
            return Ok(result);
        }
    }
} 