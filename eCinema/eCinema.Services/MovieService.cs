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

            if (!string.IsNullOrWhiteSpace(search.Genre))
            {
                query = query.Where(x => x.Genre.Contains(search.Genre));
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
    }
} 