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
    public class ReviewController : BaseCRUDController<ReviewResponse, ReviewSearchObject, ReviewUpsertRequest, ReviewUpsertRequest>
    {
        private readonly IReviewService _reviewService;

        public ReviewController(IReviewService service) : base(service)
        {
            _reviewService = service;
        }

        [HttpPost("{id}/toggle-spoiler")]
        public async Task<ActionResult<ReviewResponse>> ToggleSpoilerStatus(int id)
        {
            try
            {
                var updatedReview = await _reviewService.ToggleSpoilerAsync(id);
                return Ok(updatedReview);
            }
            catch (UnauthorizedAccessException ex)
            {
                return Forbid(ex.Message);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpPost]
        [Authorize(Roles = "user")]
        public override async Task<ReviewResponse> Create([FromBody] ReviewUpsertRequest request)
        {
            return await base.Create(request);
        }

        [HttpGet("has-reviewed/{movieId}")]
        [Authorize(Roles = "user")]
        public async Task<ActionResult<bool>> HasUserReviewedMovie(int movieId)
        {
            try
            {
                var hasReviewed = await _reviewService.HasUserReviewedMovieAsync(movieId);
                return Ok(hasReviewed);
            }
            catch (Exception ex)
            {
                return BadRequest($"Error checking if user has reviewed movie: {ex.Message}");
            }
        }
    }
} 