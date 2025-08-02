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
    public class MovieController : BaseCRUDController<MovieResponse, MovieSearchObject, MovieUpsertRequest, MovieUpsertRequest>
    {
        private readonly IMovieService _movieService;

        public MovieController(IMovieService service) : base(service)
        {
            _movieService = service;
        }

        [HttpGet("recommendation")]
        public async Task<ActionResult<MovieResponse>> GetRandomRecommendation(
            [FromQuery] string? genreName = null,
            [FromQuery] int? maxDuration = null,
            [FromQuery] float? minRating = null)
        {
            var recommendation = await _movieService.GetRandomMovieRecommendationAsync(genreName, maxDuration, minRating);
            
            if (recommendation == null)
                return NotFound("No movies found matching the criteria");
                
            return Ok(recommendation);
        }
    }
} 