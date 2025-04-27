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
    public class SeatTypeService : BaseCRUDService<SeatTypeResponse, SeatTypeSearchObject, SeatType, SeatTypeUpsertRequest, SeatTypeUpsertRequest>, ISeatTypeService
    {
        private readonly eCinemaDBContext _context;
        public SeatTypeService(eCinemaDBContext context, IMapper mapper): base(context, mapper)
        {
            _context = context;
        }

        protected override IQueryable<SeatType> ApplyFilter(IQueryable<SeatType> query, SeatTypeSearchObject search)
        {
            if (!string.IsNullOrWhiteSpace(search.Name))
            {
                query = query.Where(x => x.Name.Contains(search.Name));
            }
            return query;
        }

        protected override Task BeforeInsert(SeatType entity, SeatTypeUpsertRequest request)
        {
            throw new UserException("not allowed");
            return base.BeforeInsert(entity, request);
        }
    }
} 