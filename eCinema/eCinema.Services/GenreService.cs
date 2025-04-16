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
    public class GenreService : BaseCRUDService<GenreResponse, GenreSearchObject, Genre, GenreUpsertRequest, GenreUpsertRequest>, IGenreService
    {
        private readonly eCinemaDBContext _context;
        public GenreService(eCinemaDBContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
        }

        protected override IQueryable<Genre> ApplyFilter(IQueryable<Genre> query, GenreSearchObject search)
        {
            if (!string.IsNullOrWhiteSpace(search.Name))
            {
                query = query.Where(x => x.Name.Contains(search.Name));
            }

            if (!string.IsNullOrWhiteSpace(search.Description))
            {
                query = query.Where(x => x.Description != null && x.Description.Contains(search.Description));
            }

            if (search.IsActive.HasValue)
            {
                query = query.Where(x => x.IsActive == search.IsActive.Value);
            }

            return query;
        }

        protected override async Task BeforeInsert(Genre entity, GenreUpsertRequest request)
        {
            if (await _context.Genres.AnyAsync(g => g.Name == request.Name))
            {
                throw new InvalidOperationException("A genre with this name already exists.");
            }
        }

        protected override async Task BeforeUpdate(Genre entity, GenreUpsertRequest request)
        {
            if (await _context.Genres.AnyAsync(g => g.Name == request.Name && g.Id != entity.Id))
            {
                throw new InvalidOperationException("A genre with this name already exists.");
            }
        }
    }
} 