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