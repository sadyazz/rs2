using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;
using eCinema.Services.Database;
using eCinema.Services.Database.Entities;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MapsterMapper;

namespace eCinema.Services
{
    public class MovieService : BaseCRUDService<MovieResponse, MovieSearchObject, Movie, MovieUpsertRequest, MovieUpsertRequest>, IMovieService
    {
        private readonly eCinemaDBContext _context;
        public MovieService(eCinemaDBContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
        }

        public override async Task<MovieResponse> GetByIdAsync(int id)
        {
            var movie = await _context.Movies
                .Include(m => m.Genres)
                .ThenInclude(mg => mg.Genre)
                .Include(m => m.Actors)
                .ThenInclude(ca => ca.Actor)
                .Include(m => m.Reviews.Where(r => !r.IsDeleted))
                .FirstOrDefaultAsync(m => m.Id == id);

            if (movie == null)
                return null;

            await RecalculateMovieGrade(movie);

            return MapToResponse(movie);
        }

        public override async Task<PagedResult<MovieResponse>> GetAsync(MovieSearchObject search)
        {
            var query = _context.Movies
                .Include(m => m.Genres)
                .ThenInclude(mg => mg.Genre)
                .Include(m => m.Actors)
                .ThenInclude(ca => ca.Actor)
                .Include(m => m.Reviews.Where(r => !r.IsDeleted))
                .AsQueryable();

            query = ApplyFilter(query, search);

            int? totalCount = null;
            if (search.IncludeTotalCount)
            {
                totalCount = await query.CountAsync();
            }

            if (search.Page.HasValue)
            {
                query = query.Skip(search.Page.Value * search.PageSize.Value);
            }

            if (search.PageSize.HasValue)
            {
                query = query.Take(search.PageSize.Value);
            }

            var movies = await query.ToListAsync();

            foreach (var movie in movies)
            {
                await RecalculateMovieGrade(movie);
            }

            return new PagedResult<MovieResponse>
            {
                Items = movies.Select(m => MapToResponse(m)).ToList(),
                TotalCount = totalCount
            };
        }

        private async Task RecalculateMovieGrade(Movie movie)
        {
            var activeReviews = movie.Reviews.Where(r => !r.IsDeleted).ToList();

            if (activeReviews.Any())
            {
                movie.Grade = (float)activeReviews.Average(r => r.Rating);
            }
            else
            {
                movie.Grade = 0;
            }

            await _context.SaveChangesAsync();
        }

        protected override IQueryable<Movie> ApplyFilter(IQueryable<Movie> query, MovieSearchObject search)
        {
            query = base.ApplyFilter(query, search);
            
            if (!string.IsNullOrWhiteSpace(search.Title))
            {
                query = query.Where(x => x.Title.Contains(search.Title));
            }

            if (!string.IsNullOrWhiteSpace(search.Director))
            {
                query = query.Where(x => x.Director.Contains(search.Director));
            }

            if (search.GenreIds != null && search.GenreIds.Any())
            {
                query = query.Where(x => x.Genres.Any(mg => search.GenreIds.Contains(mg.GenreId)));
            }

            if (search.MinDuration.HasValue)
            {
                query = query.Where(x => x.DurationMinutes >= search.MinDuration.Value);
            }

            if (search.MaxDuration.HasValue)
            {
                query = query.Where(x => x.DurationMinutes <= search.MaxDuration.Value);
            }

            if (search.MinGrade.HasValue)
            {
                query = query.Where(x => x.Grade >= search.MinGrade.Value);
            }

            if (search.MaxGrade.HasValue)
            {
                query = query.Where(x => x.Grade <= search.MaxGrade.Value);
            }

            if (search.ReleaseYear.HasValue)
            {
                query = query.Where(x => x.ReleaseYear == search.ReleaseYear.Value);
            }

            if (search.IsComingSoon.HasValue)
            {
                query = query.Where(x => x.IsComingSoon == search.IsComingSoon.Value);
            }

            return query;
        }

        protected override async Task BeforeInsert(Movie entity, MovieUpsertRequest request)
        {
            entity.IsComingSoon = request.IsComingSoon;
            
            if (request.GenreIds != null && request.GenreIds.Any())
            {
                var genres = await _context.Genres
                    .Where(g => request.GenreIds.Contains(g.Id))
                    .ToListAsync();

                foreach (var genre in genres)
                {
                    entity.Genres.Add(new MovieGenre
                    {
                        Movie = entity,
                        Genre = genre
                    });
                }
            }

            if (request.ActorIds != null && request.ActorIds.Any())
            {
                var actors = await _context.Actors
                    .Where(a => request.ActorIds.Contains(a.Id))
                    .ToListAsync();

                foreach (var actor in actors)
                {
                    entity.Actors.Add(new MovieActor
                    {
                        Movie = entity,
                        Actor = actor
                    });
                }
            }
        }

        protected override async Task BeforeUpdate(Movie entity, MovieUpsertRequest request)
        {
            entity.IsComingSoon = request.IsComingSoon;
            
            entity.Genres.Clear();

            if (request.GenreIds != null && request.GenreIds.Any())
            {
                var genres = await _context.Genres
                    .Where(g => request.GenreIds.Contains(g.Id))
                    .ToListAsync();

                foreach (var genre in genres)
                {
                    entity.Genres.Add(new MovieGenre
                    {
                        Movie = entity,
                        Genre = genre
                    });
                }
            }
            entity.Actors.Clear();

            if (request.ActorIds != null && request.ActorIds.Any())
            {
                var actors = await _context.Actors
                    .Where(a => request.ActorIds.Contains(a.Id))
                    .ToListAsync();

                foreach (var actor in actors)
                {
                    entity.Actors.Add(new MovieActor
                    {
                        Movie = entity,
                        Actor = actor
                    });
                }
            }

        }

        protected override MovieResponse MapToResponse(Movie movie)
        {
            var response = _mapper.Map<MovieResponse>(movie);

            response.Genres = movie.Genres?
                .Select(mg => _mapper.Map<GenreResponse>(mg.Genre))
                .ToList() ?? new List<GenreResponse>();

            response.Actors = movie.Actors?
                .Select(ma => _mapper.Map<ActorResponse>(ma.Actor))
                .ToList() ?? new List<ActorResponse>();

            return response;
        }

        public async Task<MovieResponse?> GetRandomMovieRecommendationAsync(string? genreName, int? maxDuration, float? minRating)
        {
            var query = _context.Movies
                .Include(m => m.Genres)
                .ThenInclude(mg => mg.Genre)
                .Include(m => m.Actors)
                .ThenInclude(ca => ca.Actor)
                .Include(m => m.Reviews.Where(r => !r.IsDeleted))
                .Where(m => !m.IsDeleted)
                .AsQueryable();

            if (!string.IsNullOrWhiteSpace(genreName) && genreName.ToLower() != "all")
            {
                query = query.Where(m => m.Genres.Any(mg => mg.Genre.Name.ToLower().Contains(genreName.ToLower())));
            }

            if (maxDuration.HasValue)
            {
                query = query.Where(m => m.DurationMinutes <= maxDuration.Value);
            }

            var movies = await query.ToListAsync();

            foreach (var movie in movies)
            {
                await RecalculateMovieGrade(movie);
            }

            if (minRating.HasValue)
            {
                movies = movies.Where(m => m.Grade >= minRating.Value).ToList();
            }

            if (!movies.Any())
                return null;

            var random = new Random();
            var randomMovie = movies[random.Next(movies.Count)];

            return MapToResponse(randomMovie);
        }
    }
}