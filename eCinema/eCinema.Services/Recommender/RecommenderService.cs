using eCinema.Model.Responses;
using eCinema.Services.Database;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using Microsoft.ML.Data;

namespace eCinema.Services.Recommender
{
    public class RecommenderService : IRecommenderService
    {
        private static MLContext _mlContext = null;
        private static object _isLocked = new object();
        private static ITransformer _model = null;
        private const string ModelFilePath = "movie-recommender-model.zip";

        private readonly eCinemaDBContext Context;

        public RecommenderService(eCinemaDBContext context)
        {
            Context = context;
        }

        public List<MovieResponse> GetRecommendedMovies(int userId, int numberOfRecommendations = 4)
        {
            var allMovies = Context.Movies
                .Include(m => m.Reviews).ThenInclude(r => r.User)
                .Include(m => m.Genres).ThenInclude(mg => mg.Genre)
                .Include(m => m.Actors).ThenInclude(ma => ma.Actor)
                .Where(m => !m.IsDeleted)
                .Where(m => !m.IsComingSoon)
                .ToList();

            var userReviews = Context.Reviews
                .Where(r => r.UserId == userId)
                .Include(r => r.Movie)
                .ToList();

            var ratedMovies = userReviews.Select(r => r.Movie).Distinct().ToList();

            var candidatesForRecommendation = allMovies
                .Where(m => !ratedMovies.Any(rm => rm.Id == m.Id))
                .ToList();

            if (!userReviews.Any())
            {
                return allMovies
                    .Where(m => !m.IsComingSoon)
                    .OrderByDescending(m => m.Reviews.Any() ? m.Reviews.Average(r => r.Rating) : 0)
                    .Take(numberOfRecommendations)
                    .Select(m => new MovieResponse
                    {
                        Id = m.Id,
                        Title = m.Title,
                        Description = m.Description,
                        ReleaseDate = m.ReleaseDate,
                        DurationMinutes = m.DurationMinutes,
                        Director = m.Director,
                        ReleaseYear = m.ReleaseYear,
                        Genres = m.Genres?.Select(g => new GenreResponse { Id = g.Genre.Id, Name = g.Genre.Name }).ToList(),
                        Actors = m.Actors?.Select(a => new ActorResponse { Id = a.Actor.Id, FirstName = a.Actor.FirstName, LastName = a.Actor.LastName }).ToList(),
                        Grade = m.Reviews.Any() ? (float)m.Reviews.Average(r => r.Rating) : 0,
                        Image = m.Image,
                        TrailerUrl = m.TrailerUrl,
                        IsComingSoon = m.IsComingSoon,
                        IsDeleted = m.IsDeleted
                    }).ToList();
            }

            var movieTextData = candidatesForRecommendation.Select(m => new
            {
                Movie = m,
                Text = $"{m.Title} {m.Description} {m.Director} {string.Join(" ", m.Genres.Select(g => g.Genre.Name))} {string.Join(" ", m.Actors.Select(a => $"{a.Actor.FirstName} {a.Actor.LastName}"))}"
            }).ToList();

            var userProfileText = string.Join(" ", ratedMovies.Select(m => 
                $"{m.Title} {m.Description} {m.Director} {string.Join(" ", m.Genres.Select(g => g.Genre.Name))} {string.Join(" ", m.Actors.Select(a => $"{a.Actor.FirstName} {a.Actor.LastName}"))}"
            ));

            var mlContext = new MLContext();
            var data = movieTextData.Select(m => new MovieText { Text = m.Text }).ToList();
            data.Add(new MovieText { Text = userProfileText });

            var dataView = mlContext.Data.LoadFromEnumerable(data);
            var pipeline = mlContext.Transforms.Text.FeaturizeText("Features", nameof(MovieText.Text));
            var model = pipeline.Fit(dataView);
            var transformedData = model.Transform(dataView);

            var vectors = transformedData.GetColumn<float[]>("Features").ToArray();
            var userVector = vectors.Last();
            var movieVectors = vectors.Take(vectors.Length - 1).ToList();

            var recommendations = movieVectors.Select((v, i) => new
            {
                Score = CosineSimilarity(userVector, v),
                Movie = movieTextData[i].Movie
            })
            .OrderByDescending(s => s.Score)
            .Take(numberOfRecommendations)
            .Select(x => new MovieResponse
            {
                Id = x.Movie.Id,
                Title = x.Movie.Title,
                Description = x.Movie.Description,
                ReleaseDate = x.Movie.ReleaseDate,
                DurationMinutes = x.Movie.DurationMinutes,
                Director = x.Movie.Director,
                ReleaseYear = x.Movie.ReleaseYear,
                Genres = x.Movie.Genres?.Select(g => new GenreResponse { Id = g.Genre.Id, Name = g.Genre.Name }).ToList(),
                Actors = x.Movie.Actors?.Select(a => new ActorResponse { Id = a.Actor.Id, FirstName = a.Actor.FirstName, LastName = a.Actor.LastName }).ToList(),
                Grade = x.Movie.Reviews.Any() ? (float)x.Movie.Reviews.Average(r => r.Rating) : 0,
                Image = x.Movie.Image,
                TrailerUrl = x.Movie.TrailerUrl,
                IsComingSoon = x.Movie.IsComingSoon,
                IsDeleted = x.Movie.IsDeleted
            }).ToList();

            return recommendations;
        }

        public async Task TrainModelAsync()
        {
            await Task.Run(() =>
            {
                lock (_isLocked)
                {
                    if (_mlContext == null)
                    {
                        _mlContext = new MLContext();
                    }

                    if (File.Exists(ModelFilePath))
                    {
                        using (var stream = new FileStream(ModelFilePath, FileMode.Open, FileAccess.Read, FileShare.Read))
                        {
                            _model = _mlContext.Model.Load(stream, out var _);
                        }
                    }
                    else
                    {
                        var allReviews = Context.Reviews.ToList();
                        var data = allReviews.Select(r => new UserMovieInteraction
                        {
                            UserId = (uint)r.UserId,
                            MovieId = (uint)r.MovieId,
                            Label = r.Rating / 5.0f
                        }).ToList();

                        var trainingData = _mlContext.Data.LoadFromEnumerable(data);
                        var options = new Microsoft.ML.Trainers.MatrixFactorizationTrainer.Options
                        {
                            MatrixColumnIndexColumnName = nameof(UserMovieInteraction.UserId),
                            MatrixRowIndexColumnName = nameof(UserMovieInteraction.MovieId),
                            LabelColumnName = nameof(UserMovieInteraction.Label),
                            LossFunction = Microsoft.ML.Trainers.MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass,
                            Alpha = 0.01f,
                            Lambda = 0.025f,
                            NumberOfIterations = 100,
                            ApproximationRank = 100
                        };

                        var est = _mlContext.Recommendation().Trainers.MatrixFactorization(options);
                        _model = est.Fit(trainingData);

                        using (var stream = new FileStream(ModelFilePath, FileMode.Create, FileAccess.Write, FileShare.Write))
                        {
                            _mlContext.Model.Save(_model, trainingData.Schema, stream);
                        }
                    }
                }
            });
        }

        private class UserMovieInteraction
        {
            [KeyType(count: 1000)]
            public uint UserId { get; set; }
            [KeyType(count: 1000)]
            public uint MovieId { get; set; }
            public float Label { get; set; }
        }

        private class MoviePrediction
        {
            public float Score { get; set; }
        }

        private class MovieText
        {
            public string Text { get; set; } = "";
        }

        private float CosineSimilarity(float[] v1, float[] v2)
        {
            float dot = 0;
            float normA = 0;
            float normB = 0;

            for (int i = 0; i < v1.Length; i++)
            {
                dot += v1[i] * v2[i];
                normA += v1[i] * v1[i];
                normB += v2[i] * v2[i];
            }

            return dot / ((float)Math.Sqrt(normA) * (float)Math.Sqrt(normB) + 1e-5f);
        }
    }
}