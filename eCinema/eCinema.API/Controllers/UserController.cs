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
    [Authorize]
    [ApiController]
    [Route("[controller]")]
    public class UserController : BaseCRUDController<UserResponse, UserSearchObject, UserUpsertRequest, UserUpdateRequest>
    {
        private readonly IUserService _userService;

        public UserController(IUserService service) : base(service)
        {
            _userService = service;
        }

        [HttpGet]
        public override async Task<PagedResult<UserResponse>> Get([FromQuery] UserSearchObject? search = null)
        {
            var result = await _userService.GetAsync(search ?? new UserSearchObject());
            return result;
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
            catch (Exception ex)
            {
                Console.WriteLine($"Error in Register: {ex.Message}");
                Console.WriteLine($"Stack trace: {ex.StackTrace}");
                return StatusCode(500, ex.Message);
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

        [HttpGet("{userId}/recommended-movies")]
        [AllowAnonymous]
        public async Task<ActionResult<List<MovieResponse>>> GetRecommendedMovies(int userId, [FromQuery] int numberOfRecommendations = 4)
        {
            try
            {
                var movies = await _userService.GetRecommendedMoviesAsync(userId, numberOfRecommendations);
                return Ok(movies);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet("train-model")]
        [Authorize(Roles = "admin,staff,user")]
        public async Task<IActionResult> TrainModel()
        {
            try
            {
                await _userService.TrainModelAsync();
                return Ok("Model training started successfully");
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"An error occurred while training the model: {ex.Message}");
            }
        }

        [HttpGet("test-recommender/{userId}")]
        [AllowAnonymous]
        public async Task<IActionResult> TestRecommender(int userId)
        {
            try
            {
                await _userService.TrainModelAsync();
                Console.WriteLine("Model trained successfully");

                var recommendations = await _userService.GetRecommendedMoviesAsync(userId);
                Console.WriteLine($"Got {recommendations.Count} recommendations");

                var reviews = await _userService.GetUserReviewsAsync(userId);

                return Ok(new {
                    Message = "Test completed successfully",
                    UserReviews = reviews,
                    RecommendedMovies = recommendations
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"An error occurred while testing: {ex.Message}");
            }
        }
    }
}