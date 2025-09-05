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

        public override async Task<PromotionResponse> CreateAsync(PromotionUpsertRequest request)
        {
            request.StartDate = request.StartDate.Date;
            request.EndDate = request.EndDate.Date.AddDays(1).AddSeconds(-1);
            return await base.CreateAsync(request);
        }

        public override async Task<PromotionResponse> UpdateAsync(int id, PromotionUpsertRequest request)
        {
            request.StartDate = request.StartDate.Date;
            request.EndDate = request.EndDate.Date.AddDays(1).AddSeconds(-1);
            return await base.UpdateAsync(id, request);
        }

        public async Task<PromotionResponse?> ValidatePromotionCode(string code, int userId)
        {
            Console.WriteLine($"Validating code: {code}");
            
            var promotion = await _context.Promotions
                .Where(p => p.Code == code)
                .FirstOrDefaultAsync();

            Console.WriteLine($"Found promotion: {promotion?.Id}, Code: {promotion?.Code}, IsDeleted: {promotion?.IsDeleted}");
            
            if (promotion != null)
            {
                var currentDate = DateTime.UtcNow.Date;
                var startDate = promotion.StartDate.Date;
                var endDate = promotion.EndDate.Date;
                
                if (promotion.IsDeleted || currentDate < startDate || currentDate > endDate)
                {
                    Console.WriteLine("Promotion invalid or expired");
                    return null;
                }
            }
            else
            {
                Console.WriteLine("Promotion not found");
                return null;
            }

            var hasUsed = await _context.UserPromotions
                .AnyAsync(up => up.UserId == userId && up.PromotionId == promotion.Id);

            if (hasUsed)
                throw new UserException("You have already used this promotion code");

            return _mapper.Map<PromotionResponse>(promotion);
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