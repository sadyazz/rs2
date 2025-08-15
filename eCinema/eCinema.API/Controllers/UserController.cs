using eCinema.Model;
using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;
using eCinema.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;

namespace eCinema.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class UserController : BaseCRUDController<UserResponse, UserSearchObject, UserUpsertRequest, UserUpdateRequest>
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




        [HttpPut("{id}/role")]
        [Authorize(Roles = "admin")]
        public async Task<ActionResult<UserResponse>> UpdateUserRole(int id, [FromBody] UpdateUserRoleRequest request)
        {
            try
            {
                var user = await _userService.GetByIdAsync(id);
                if (user == null)
                    return NotFound();

                var updatedUser = await _userService.UpdateUserRoleAsync(id, request.RoleId);
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

        [HttpPut("change-password")]
        [Authorize]
        public async Task<ActionResult> ChangePassword([FromBody] ChangePasswordRequest request)
        {
            try
            {
                var userId = int.Parse(User.Claims.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier)?.Value);

                var result = await _userService.ChangePasswordAsync(userId, request.CurrentPassword, request.NewPassword);

                if (!result)
                    return BadRequest("Current password is incorrect");

                return Ok("Password changed successfully");
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}