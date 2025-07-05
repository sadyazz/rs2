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
    public class RoleService : BaseCRUDService<RoleResponse, RoleSearchObject, Database.Entities.Role, RoleUpsertRequest, RoleUpsertRequest>, IRoleService
    {
        public RoleService(eCinemaDBContext context, IMapper mapper) : base(context, mapper)
        {
        }

        protected override IQueryable<Database.Entities.Role> ApplyFilter(IQueryable<Database.Entities.Role> query, RoleSearchObject search)
        {
            query = base.ApplyFilter(query, search);
            
            if (!string.IsNullOrEmpty(search.Name))
            {
                query = query.Where(r => r.Name.Contains(search.Name));
            }

            if (!string.IsNullOrEmpty(search.FTS))
            {
                query = query.Where(r => r.Name.Contains(search.FTS));
            }

            if (search.IsActive.HasValue)
            {
                query = query.Where(r => r.IsActive == search.IsActive.Value);
            }

            return query;
        }

        // protected override async Task BeforeInsert(Database.Entities.Role entity, RoleUpsertRequest request)
        // {
        //     // Check for duplicate role name
        //     if (await _context.Roles.AnyAsync(r => r.Name == request.Name))
        //     {
        //         throw new InvalidOperationException("A role with this name already exists.");
        //     }
        // }

        // protected override async Task BeforeUpdate(Database.Entities.Role entity, RoleUpsertRequest request)
        // {
        //     // Check for duplicate role name (excluding current role)
        //     if (await _context.Roles.AnyAsync(r => r.Name == request.Name && r.Id != entity.Id))
        //     {
        //         throw new InvalidOperationException("A role with this name already exists.");
        //     }
        // }
    }
} 