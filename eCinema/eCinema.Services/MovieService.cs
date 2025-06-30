using eCinema.Model;
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

        // Override getById to automatically calculate grade
        public override async Task<MovieResponse> GetByIdAsync(int id)
        {
            var movie = await _context.Movies
                .Include(m => m.MovieGenres)
                .ThenInclude(mg => mg.Genre)
                .Include(m => m.Reviews.Where(r => r.IsActive))
                .FirstOrDefaultAsync(m => m.Id == id);

            if (movie == null)
                return null;

            // Automatically calculate and update grade
            await RecalculateMovieGrade(movie);

            return MapToResponse(movie);
        }

        // Override get to automatically calculate grades for all movies
        public override async Task<PagedResult<MovieResponse>> GetAsync(MovieSearchObject search)
        {
            var query = _context.Movies
                .Include(m => m.MovieGenres)
                .ThenInclude(mg => mg.Genre)
                .Include(m => m.Reviews.Where(r => r.IsActive))
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

            // Automatically calculate grades for all movies
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

        // Private method to recalculate movie grade
        private async Task RecalculateMovieGrade(Movie movie)
        {
            var activeReviews = movie.Reviews.Where(r => r.IsActive).ToList();
            
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
                query = query.Where(x => x.MovieGenres.Any(mg => search.GenreIds.Contains(mg.GenreId)));
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

            return query;
        }

        protected override async Task BeforeInsert(Movie entity, MovieUpsertRequest request)
        {
            if (request.GenreIds != null && request.GenreIds.Any())
            {
                var genres = await _context.Genres
                    .Where(g => request.GenreIds.Contains(g.Id))
                    .ToListAsync();

                foreach (var genre in genres)
                {
                    entity.MovieGenres.Add(new MovieGenre
                    {
                        Movie = entity,
                        Genre = genre
                    });
                }
            }
        }

        protected override async Task BeforeUpdate(Movie entity, MovieUpsertRequest request)
        {
            entity.MovieGenres.Clear();

            if (request.GenreIds != null && request.GenreIds.Any())
            {
                var genres = await _context.Genres
                    .Where(g => request.GenreIds.Contains(g.Id))
                    .ToListAsync();

                foreach (var genre in genres)
                {
                    entity.MovieGenres.Add(new MovieGenre
                    {
                        Movie = entity,
                        Genre = genre
                    });
                }
            }
        }
    }
}