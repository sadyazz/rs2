using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;
using eCinema.Services;
using eCinema.Services.Auth;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;

namespace eCinema.API.Controllers
{
    [Authorize]
    [ApiController]
    [Route("[controller]")]
    public class UserMovieListController : ControllerBase
    {
        private readonly IUserMovieListService _userMovieListService;
        private readonly ICurrentUserService _currentUserService;

        public UserMovieListController(IUserMovieListService service, ICurrentUserService currentUserService)
        {
            _userMovieListService = service;
            _currentUserService = currentUserService;
        }

        [HttpGet]
        public async Task<ActionResult<List<UserMovieListResponse>>> Get([FromQuery] UserMovieListSearchObject search)
        {
            var result = await _userMovieListService.GetAsync(search);
            return Ok(result);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<UserMovieListResponse>> GetById(int id)
        {
            var result = await _userMovieListService.GetByIdAsync(id);
            if (result == null)
                return NotFound();
            return Ok(result);
        }

        [HttpGet("user/{userId}/list/{listType}")]
        public async Task<ActionResult<List<UserMovieListResponse>>> GetUserLists(int userId, string listType)
        {
            var currentUserId = await _currentUserService.GetUserIdAsync();
            if (currentUserId != userId)
            {
                return Forbid("You can only view your own movie lists.");
            }

            var result = await _userMovieListService.GetUserListsAsync(userId, listType);
            return Ok(result);
        }

        [HttpGet("user/{userId}/movie/{movieId}/list/{listType}")]
        public async Task<ActionResult<bool>> IsMovieInUserList(int userId, int movieId, string listType)
        {
            var currentUserId = await _currentUserService.GetUserIdAsync();
            if (currentUserId != userId)
            {
                return Forbid("You can only check your own movie lists.");
            }

            var result = await _userMovieListService.IsMovieInUserListAsync(userId, movieId, listType);
            return Ok(result);
        }

        [HttpPost("add")]
        public async Task<ActionResult<object>> AddMovieToList([FromBody] UserMovieListUpsertRequest request)
        {
            var currentUserId = await _currentUserService.GetUserIdAsync();
            if (currentUserId != request.UserId)
            {
                return Forbid("You can only add movies to your own lists.");
            }

            await _userMovieListService.AddMovieToListAsync(request.UserId, request.MovieId, request.ListType);
            return Ok(new { 
                message = "Movie successfully added to list",
                userId = request.UserId,
                movieId = request.MovieId,
                listType = request.ListType
            });
        }

        [HttpDelete("remove")]
        public async Task<ActionResult<object>> RemoveMovieFromList([FromBody] UserMovieListUpsertRequest request)
        {
            var currentUserId = await _currentUserService.GetUserIdAsync();
            if (currentUserId != request.UserId)
            {
                return Forbid("You can only remove movies from your own lists.");
            }

            await _userMovieListService.RemoveMovieFromListAsync(request.UserId, request.MovieId, request.ListType);
            return Ok(new { 
                message = "Movie successfully removed from list",
                userId = request.UserId,
                movieId = request.MovieId,
                listType = request.ListType
            });
        }
    }
} 