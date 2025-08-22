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
            if (!search.IncludeDeleted)
            {
                query = query.Where(x => !x.IsDeleted);
            }
            query = base.ApplyFilter(query, search);
            
            if (!string.IsNullOrWhiteSpace(search.Name))
            {
                query = query.Where(x => x.Name.Contains(search.Name));
            }

            if (search.MinCapacity.HasValue)
            {
                query = query.Where(x => x.Capacity >= search.MinCapacity.Value);
            }

            if (search.MaxCapacity.HasValue)
            {
                query = query.Where(x => x.Capacity <= search.MaxCapacity.Value);
            }

            return query;
        }

        protected override async Task BeforeInsert(Hall entity, HallUpsertRequest request)
        {
            if (await _context.Halls.AnyAsync(h => h.Name == request.Name))
            {
                throw new InvalidOperationException("A hall with this name already exists.");
            }

            if (request.Capacity <= 0)
            {
                throw new InvalidOperationException("Hall capacity must be greater than 0.");
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