using eCinema.Model;
using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;

namespace eCinema.Services;

public interface IMovieService : ICRUDService<MovieResponse, MovieSearchObject, MovieUpsertRequest, MovieUpsertRequest>
{
    Task<MovieResponse?> GetRandomMovieRecommendationAsync(string? genreName, int? maxDuration, float? minRating);
    Task<List<ReadyToReleaseMovieDto>> GetReadyToReleaseMoviesAsync();
} 