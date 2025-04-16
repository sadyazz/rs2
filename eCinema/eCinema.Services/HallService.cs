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
    public class HallService : BaseCRUDService<HallResponse, HallSearchObject, Hall, HallUpsertRequest, HallUpsertRequest>, IHallService
    {
        private readonly eCinemaDBContext _context;
        public HallService(eCinemaDBContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
        }

        protected override IQueryable<Hall> ApplyFilter(IQueryable<Hall> query, HallSearchObject search)
        {
            if (!string.IsNullOrWhiteSpace(search.Name))
            {
                query = query.Where(x => x.Name.Contains(search.Name));
            }

            if (!string.IsNullOrWhiteSpace(search.Location))
            {
                query = query.Where(x => x.Location.Contains(search.Location));
            }

            if (!string.IsNullOrWhiteSpace(search.ScreenType))
            {
                query = query.Where(x => x.ScreenType != null && x.ScreenType.Contains(search.ScreenType));
            }

            if (!string.IsNullOrWhiteSpace(search.SoundSystem))
            {
                query = query.Where(x => x.SoundSystem != null && x.SoundSystem.Contains(search.SoundSystem));
            }

            if (search.MinCapacity.HasValue)
            {
                query = query.Where(x => x.Capacity >= search.MinCapacity.Value);
            }

            if (search.MaxCapacity.HasValue)
            {
                query = query.Where(x => x.Capacity <= search.MaxCapacity.Value);
            }

            if (search.IsActive.HasValue)
            {
                query = query.Where(x => x.IsActive == search.IsActive.Value);
            }

            return query;
        }

        protected override async Task BeforeInsert(Hall entity, HallUpsertRequest request)
        {
            if (await _context.Halls.AnyAsync(h => h.Name == request.Name))
            {
                throw new InvalidOperationException("A hall with this name already exists.");
            }
        }

        protected override async Task BeforeUpdate(Hall entity, HallUpsertRequest request)
        {
            if (await _context.Halls.AnyAsync(h => h.Name == request.Name && h.Id != entity.Id))
            {
                throw new InvalidOperationException("A hall with this name already exists.");
            }
        }
    }
} 