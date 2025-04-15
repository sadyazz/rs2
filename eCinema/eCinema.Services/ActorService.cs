using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;
using eCinema.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace eCinema.Services
{
    public class ActorService : BaseCRUDService<ActorResponse, ActorSearchObject, Database.Entities.Actor, ActorUpsertRequest, ActorUpsertRequest>, IActorService
    {
        private readonly eCinemaDBContext _context;
        public ActorService(eCinemaDBContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
        }

        protected override IQueryable<Database.Entities.Actor> ApplyFilter(IQueryable<Database.Entities.Actor> query, ActorSearchObject search)
        {
            if (!string.IsNullOrEmpty(search.FirstName))
            {
                query = query.Where(a => a.FirstName.Contains(search.FirstName));
            }

            if (!string.IsNullOrEmpty(search.LastName))
            {
                query = query.Where(a => a.LastName.Contains(search.LastName));
            }

            if (!string.IsNullOrEmpty(search.FTS))
            {
                query = query.Where(a => 
                    a.FirstName.Contains(search.FTS) || 
                    a.LastName.Contains(search.FTS) || 
                    a.Biography.Contains(search.FTS));
            }

            if (search.IsActive.HasValue)
            {
                query = query.Where(a => a.IsActive == search.IsActive.Value);
            }

            return query;
        }

        protected override async Task BeforeInsert(Database.Entities.Actor entity, ActorUpsertRequest request)
        {
            // Check for duplicate actor name
            if (await _context.Actors.AnyAsync(a => 
                a.FirstName == request.FirstName && 
                a.LastName == request.LastName))
            {
                throw new InvalidOperationException("An actor with this name already exists.");
            }
        }

        protected override async Task BeforeUpdate(Database.Entities.Actor entity, ActorUpsertRequest request)
        {
            // Check for duplicate actor name (excluding current actor)
            if (await _context.Actors.AnyAsync(a => 
                a.FirstName == request.FirstName && 
                a.LastName == request.LastName && 
                a.Id != entity.Id))
            {
                throw new InvalidOperationException("An actor with this name already exists.");
            }
        }
    }
} 