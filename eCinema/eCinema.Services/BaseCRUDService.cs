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
    public abstract class BaseCRUDService<T, TSearch, TEntity, TInsert, TUpdate> : BaseService<T, TSearch, TEntity>, ICRUDService<T, TSearch, TInsert, TUpdate> where T : class where TSearch : BaseSearchObject where TEntity : class, new() where TInsert : class where TUpdate : class
    {
        protected readonly eCinemaDBContext _context;
        public BaseCRUDService(eCinemaDBContext context, IMapper mapper): base(context, mapper)
        {
            _context = context;
        }

        public virtual async Task<T> CreateAsync(TInsert request){

            var entity = new TEntity();
            MapInsertToEntity(entity, request);
            _context.Set<TEntity>().Add(entity);

            await BeforeInsert(entity, request);

            await _context.SaveChangesAsync();
            return MapToResponse(entity);
        }

        protected virtual TEntity MapInsertToEntity(TEntity entity, TInsert request){
            return _mapper.Map(request, entity);
        }

        protected virtual async Task BeforeInsert(TEntity entity, TInsert request){
            
        }

        public virtual async Task<T> UpdateAsync(int id, TUpdate request){
            var entity = await _context.Set<TEntity>().FindAsync(id);
            if (entity == null){
                throw new Exception("Entity not found");
            }

            await BeforeUpdate(entity, request);
            MapUpdateToEntity(entity, request);

            await _context.SaveChangesAsync();
            return MapToResponse(entity);
        }

        protected virtual void MapUpdateToEntity(TEntity entity, TUpdate request){
            _mapper.Map(request, entity);
        }

        protected virtual async Task BeforeUpdate(TEntity entity, TUpdate request){
            
        }

        public virtual async Task<bool> DeleteAsync(int id){
            var entity = await _context.Set<TEntity>().FindAsync(id);
            if (entity == null){
                return false;
            }

            await BeforeDelete(entity);

            _context.Set<TEntity>().Remove(entity);
            await _context.SaveChangesAsync();
            return true;
        }

        protected virtual async Task BeforeDelete(TEntity entity){

        }

    }
} 