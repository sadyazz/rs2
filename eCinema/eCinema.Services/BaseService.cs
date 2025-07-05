using eCinema.Services.Database;
using eCinema.Services.Database.Entities;
using eCinema.Model.SearchObjects;
using System.Linq;
using System;
using Microsoft.EntityFrameworkCore;
using eCinema.Model.Responses;
using MapsterMapper;

namespace eCinema.Services
{
    public abstract class BaseService<T, TSearch, TEntity> : IService<T, TSearch> where T : class where TSearch : BaseSearchObject where TEntity : class
    {
        private readonly eCinemaDBContext _context;
        protected readonly IMapper _mapper;

        public BaseService(eCinemaDBContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public virtual async Task<PagedResult<T>> GetAsync(TSearch search)
        {
            var query = _context.Set<TEntity>().AsQueryable();
            query = ApplyFilter(query, search);

            int? totalCount = null;
            if(search.IncludeTotalCount){
                totalCount = await query.CountAsync();
            }

            if(search.Page.HasValue)
            {
                query = query.Skip(search.Page.Value * search.PageSize.Value);
            }

            if(search.PageSize.HasValue)
            {
                query = query.Take(search.PageSize.Value);
            }

            var list = await query.ToListAsync();

            return new PagedResult<T>
            {
                Items = list.Select(MapToResponse).ToList(),
                TotalCount = totalCount
            };
        }

        protected virtual T MapToResponse(TEntity entity){
            return _mapper.Map<T>(entity);
        }

        public virtual async Task<T?> GetByIdAsync(int id)
        {
            var entity = await _context.Set<TEntity>().FindAsync(id);

            if (entity == null)
                return null;

            var isDeletedProperty = typeof(TEntity).GetProperty("IsDeleted");
            if (isDeletedProperty != null && isDeletedProperty.PropertyType == typeof(bool))
            {
                var isDeleted = (bool)isDeletedProperty.GetValue(entity);
                if (isDeleted)
                    return null;
            }

            return MapToResponse(entity);
        }

        protected virtual IQueryable<TEntity> ApplyFilter(IQueryable<TEntity> query, TSearch search)
        {
            if (!search.IncludeDeleted)
            {
                if (typeof(TEntity) == typeof(Database.Entities.Movie))
                {
                    query = query.Cast<Database.Entities.Movie>().Where(m => !m.IsDeleted).Cast<TEntity>();
                }
                else if (typeof(TEntity) == typeof(Database.Entities.Genre))
                {
                    query = query.Cast<Database.Entities.Genre>().Where(g => !g.IsDeleted).Cast<TEntity>();
                }
                else if (typeof(TEntity) == typeof(Database.Entities.Actor))
                {
                    query = query.Cast<Database.Entities.Actor>().Where(a => !a.IsDeleted).Cast<TEntity>();
                }
                else if (typeof(TEntity) == typeof(Database.Entities.Review))
                {
                    query = query.Cast<Database.Entities.Review>().Where(r => !r.IsDeleted).Cast<TEntity>();
                }
                else if (typeof(TEntity) == typeof(Database.Entities.Screening))
                {
                    query = query.Cast<Database.Entities.Screening>().Where(s => !s.IsDeleted).Cast<TEntity>();
                }
                else if (typeof(TEntity) == typeof(Database.Entities.Reservation))
                {
                    query = query.Cast<Database.Entities.Reservation>().Where(r => !r.IsDeleted).Cast<TEntity>();
                }
                else if (typeof(TEntity) == typeof(Database.Entities.Promotion))
                {
                    query = query.Cast<Database.Entities.Promotion>().Where(p => !p.IsDeleted).Cast<TEntity>();
                }
                else if (typeof(TEntity) == typeof(Database.Entities.NewsArticle))
                {
                    query = query.Cast<Database.Entities.NewsArticle>().Where(n => !n.IsDeleted).Cast<TEntity>();
                }
                else if (typeof(TEntity) == typeof(Database.Entities.User))
                {
                    query = query.Cast<Database.Entities.User>().Where(u => !u.isDeleted).Cast<TEntity>();
                }
            }

            if (search.IsActive.HasValue)
            {
                if (typeof(TEntity) == typeof(Database.Entities.Movie))
                {
                    query = query.Cast<Database.Entities.Movie>().Where(m => m.IsActive == search.IsActive.Value).Cast<TEntity>();
                }
                else if (typeof(TEntity) == typeof(Database.Entities.Genre))
                {
                    query = query.Cast<Database.Entities.Genre>().Where(g => g.IsActive == search.IsActive.Value).Cast<TEntity>();
                }
                else if (typeof(TEntity) == typeof(Database.Entities.Actor))
                {
                    query = query.Cast<Database.Entities.Actor>().Where(a => a.IsActive == search.IsActive.Value).Cast<TEntity>();
                }
                else if (typeof(TEntity) == typeof(Database.Entities.Review))
                {
                    query = query.Cast<Database.Entities.Review>().Where(r => r.IsActive == search.IsActive.Value).Cast<TEntity>();
                }
                else if (typeof(TEntity) == typeof(Database.Entities.Screening))
                {
                    query = query.Cast<Database.Entities.Screening>().Where(s => s.IsActive == search.IsActive.Value).Cast<TEntity>();
                }
                else if (typeof(TEntity) == typeof(Database.Entities.Reservation))
                {
                    query = query.Cast<Database.Entities.Reservation>().Where(r => r.IsActive == search.IsActive.Value).Cast<TEntity>();
                }
                else if (typeof(TEntity) == typeof(Database.Entities.Promotion))
                {
                    query = query.Cast<Database.Entities.Promotion>().Where(p => p.IsActive == search.IsActive.Value).Cast<TEntity>();
                }
                else if (typeof(TEntity) == typeof(Database.Entities.NewsArticle))
                {
                    query = query.Cast<Database.Entities.NewsArticle>().Where(n => n.IsActive == search.IsActive.Value).Cast<TEntity>();
                }
                else if (typeof(TEntity) == typeof(Database.Entities.User))
                {
                    query = query.Cast<Database.Entities.User>().Where(u => u.IsActive == search.IsActive.Value).Cast<TEntity>();
                }
            }

            return query;
        }
        
    }
}