using eCinema.Model;
using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;
using eCinema.Services;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace eCinema.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class UserController : BaseCRUDController<UserResponse, UserSearchObject, UserUpsertRequest, UserUpsertRequest>
    {
        private readonly IUserService _userService;

        public UserController(IUserService service) : base(service)
        {
            _userService = service;
        }

        [HttpPost("login")]
        public async Task<ActionResult<UserResponse>> Login(UserLoginRequest request)
        {
            var user = await _userService.AuthenticateAsync(request);
            return Ok(user);
        }

        // [HttpGet]
        // public async Task<ActionResult<List<UserResponse>>> Get([FromQuery] UserSearchObject search)
        // {
        //     var result = await _service.GetAsync(search);
        //     return Ok(result);
        // }

        // [HttpGet("{id}")]
        // public async Task<ActionResult<UserResponse>> GetById(int id)
        // {
        //     var result = await _service.GetByIdAsync(id);
        //     if (result == null)
        //         return NotFound();
        //     return Ok(result);
        // }

        // [HttpPost]
        // public async Task<ActionResult<UserResponse>> Create([FromBody] UserUpsertRequest request)
        // {
        //     var result = await _service.CreateAsync(request);
        //     return Ok(result);
        // }

        // [HttpPut("{id}")]
        // public async Task<ActionResult<UserResponse>> Update(int id, [FromBody] UserUpsertRequest request)
        // {
        //     var result = await _service.UpdateAsync(id, request);
        //     if (result == null)
        //         return NotFound();
        //     return Ok(result);
        // }

        // [HttpDelete("{id}")]
        // public async Task<ActionResult<bool>> Delete(int id)
        // {
        //     var result = await _service.DeleteAsync(id);
        //     if (!result)
        //         return NotFound();
        //     return Ok(result);
        // }
    }
} 