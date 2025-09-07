using System.Collections.Generic;
using eCinema.Model.Responses;

namespace eCinema.Services.Recommender
{
    public interface IRecommenderService
    {
        Task TrainModelAsync();
        List<MovieResponse> GetRecommendedMovies(int userId, int numberOfRecommendations = 4);
    }
}
