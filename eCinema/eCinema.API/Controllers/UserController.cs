using eCinema.Model;
using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;
using eCinema.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;

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
        [AllowAnonymous]
        [HttpPost("login")]
        public async Task<ActionResult<UserResponse>> Login(UserLoginRequest request)
        {
            var user = await _userService.AuthenticateAsync(request);
            if (user == null)
            {
                return Unauthorized("Wrong username or password.");
            }
            return Ok(user);
        }

        [AllowAnonymous]
        [HttpPost("register")]
        public async Task<ActionResult<UserResponse>> Register(UserUpsertRequest request)
        {
            try
            {
                var user = await _userService.RegisterAsync(request);
                return Ok(user);
            }
            catch (InvalidOperationException ex)
            {
                return BadRequest(ex.Message);
            }
            catch (Exception)
            {
                return StatusCode(500, "An error occurred while creating the user.");
            }
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

        [HttpPut("{id}/role")]
        [Authorize(Roles = "admin")]
        public async Task<ActionResult<UserResponse>> UpdateUserRole(int id, [FromBody] UpdateUserRoleRequest request)
        {
            try
            {
                var user = await _userService.GetByIdAsync(id);
                if (user == null)
                    return NotFound();

                var updateRequest = new UserUpsertRequest
                {
                    FirstName = user.FirstName,
                    LastName = user.LastName,
                    Email = user.Email,
                    Username = user.Username,
                    PhoneNumber = user.PhoneNumber,
                    Password = string.Empty,
                    RoleId = request.RoleId
                };

                var updatedUser = await _userService.UpdateAsync(id, updateRequest);
                if (updatedUser == null)
                    return NotFound();

                if (request.IsDeleted)
                {
                    await _userService.SoftDeleteAsync(id);
                }
                else if (user.IsDeleted)
                {
                    await _userService.RestoreAsync(id);
                }

                var finalUser = await _userService.GetByIdAsync(id);
                return Ok(finalUser);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }

    public class UpdateUserRoleRequest
    {
        public int RoleId { get; set; }
        public bool IsDeleted { get; set; }
    }
} 