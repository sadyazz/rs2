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
    public class PromotionService : BaseCRUDService<PromotionResponse, PromotionSearchObject, Promotion, PromotionUpsertRequest, PromotionUpsertRequest>, IPromotionService
    {
        private readonly eCinemaDBContext _context;
        public PromotionService(eCinemaDBContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
        }

        protected override IQueryable<Promotion> ApplyFilter(IQueryable<Promotion> query, PromotionSearchObject search)
        {
            query = base.ApplyFilter(query, search);
            
            if (!string.IsNullOrWhiteSpace(search.Name))
            {
                query = query.Where(x => x.Name.Contains(search.Name));
            }

            if (!string.IsNullOrWhiteSpace(search.Code))
            {
                query = query.Where(x => x.Code == search.Code);
            }

            if (search.MinDiscount.HasValue)
            {
                query = query.Where(x => x.DiscountPercentage >= search.MinDiscount.Value);
            }

            if (search.MaxDiscount.HasValue)
            {
                query = query.Where(x => x.DiscountPercentage <= search.MaxDiscount.Value);
            }

            if (search.FromStartDate.HasValue)
            {
                query = query.Where(x => x.StartDate >= search.FromStartDate.Value);
            }

            if (search.ToStartDate.HasValue)
            {
                query = query.Where(x => x.StartDate <= search.ToStartDate.Value);
            }

            if (search.FromEndDate.HasValue)
            {
                query = query.Where(x => x.EndDate >= search.FromEndDate.Value);
            }

            if (search.ToEndDate.HasValue)
            {
                query = query.Where(x => x.EndDate <= search.ToEndDate.Value);
            }

            return query;
        }
    }
} 