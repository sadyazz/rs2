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
    public class ScreeningFormatService : BaseCRUDService<ScreeningFormatResponse, ScreeningFormatSearchObject, ScreeningFormat, ScreeningFormatUpsertRequest, ScreeningFormatUpsertRequest>, IScreeningFormatService
    {
        private readonly eCinemaDBContext _context;
        public ScreeningFormatService(eCinemaDBContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
        }

        protected override IQueryable<ScreeningFormat> ApplyFilter(IQueryable<ScreeningFormat> query, ScreeningFormatSearchObject search)
        {
            query = base.ApplyFilter(query, search);
            
            if (!string.IsNullOrWhiteSpace(search.Name))
            {
                query = query.Where(x => x.Name.Contains(search.Name));
            }

            return query;
        }

        protected override async Task BeforeInsert(ScreeningFormat entity, ScreeningFormatUpsertRequest insert)
        {
            var existingFormat = await _context.ScreeningFormats
                .FirstOrDefaultAsync(x => x.Name.ToLower() == insert.Name.ToLower());

            if (existingFormat != null)
            {
                throw new InvalidOperationException("A screening format with this name already exists.");
            }
        }

        protected override async Task BeforeUpdate(ScreeningFormat entity, ScreeningFormatUpsertRequest update)
        {
            var existingFormat = await _context.ScreeningFormats
                .FirstOrDefaultAsync(x => x.Name.ToLower() == update.Name.ToLower() && x.Id != entity.Id);

            if (existingFormat != null)
            {
                throw new InvalidOperationException("A screening format with this name already exists.");
            }
        }
    }
} 