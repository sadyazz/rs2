using eCinema.Model;
using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;
using eCinema.Services.Database;
using eCinema.Services;
using eCinema.Services.Database.Entities;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MapsterMapper;

namespace eCinema.Services
{
    public class SeatService : BaseCRUDService<SeatResponse, SeatSearchObject, Database.Entities.Seat, SeatInsertRequest, SeatUpdateRequest>, ISeatService
    {
        public SeatService(eCinemaDBContext context, IMapper mapper) : base(context, mapper)
        {
        }

        protected override SeatResponse MapToResponse(Database.Entities.Seat entity)
        {
            int rowNumber = 0;
            if (!string.IsNullOrEmpty(entity.Row))
            {
                if (int.TryParse(entity.Row, out var parsedRow))
                {
                    rowNumber = parsedRow;
                }
            }
            
            var response = new SeatResponse
            {
                Id = entity.Id,
                HallId = entity.HallId,
                RowNumber = rowNumber,
                SeatNumber = entity.Number
            };
            
            return response;
        }

        protected override IQueryable<Database.Entities.Seat> ApplyFilter(IQueryable<Database.Entities.Seat> query, SeatSearchObject search)
        {
            query = base.ApplyFilter(query, search);
            
            if (search.HallId.HasValue)
            {
                query = query.Where(s => s.HallId == search.HallId.Value);
            }

            if (search.RowNumber.HasValue)
            {
                query = query.Where(s => s.Row == search.RowNumber.Value.ToString());
            }

            if (search.SeatNumber.HasValue)
            {
                query = query.Where(s => s.Number == search.SeatNumber.Value);
            }

            return query;
        }

        protected override Database.Entities.Seat MapInsertToEntity(Database.Entities.Seat entity, SeatInsertRequest request)
        {
            entity.HallId = request.HallId;
            entity.Row = request.RowNumber.ToString();
            entity.Number = request.SeatNumber;
            return entity;
        }

        protected override void MapUpdateToEntity(Database.Entities.Seat entity, SeatUpdateRequest request)
        {
            entity.HallId = request.HallId;
            entity.Row = request.RowNumber.ToString();
            entity.Number = request.SeatNumber;
        }

        protected override async Task BeforeInsert(Database.Entities.Seat entity, SeatInsertRequest request)
        {
            await base.BeforeInsert(entity, request);
            
            var currentSeatCount = await _context.Set<Database.Entities.Seat>()
                .Where(s => s.HallId == request.HallId)
                .CountAsync();
                
            var hall = await _context.Set<Database.Entities.Hall>()
                .Where(h => h.Id == request.HallId && !h.IsDeleted)
                .FirstOrDefaultAsync();
                
            if (hall != null && currentSeatCount >= hall.Capacity)
            {
                throw new Exception($"Cannot add more seats. Hall capacity is {hall.Capacity} and current seat count is {currentSeatCount}.");
            }
        }

        public override async Task<SeatResponse> CreateAsync(SeatInsertRequest request)
        {
            var entity = new Database.Entities.Seat();
            MapInsertToEntity(entity, request);
            _context.Set<Database.Entities.Seat>().Add(entity);

            await BeforeInsert(entity, request);

            await _context.SaveChangesAsync();
            return MapToResponse(entity);
        }

        protected override async Task BeforeUpdate(Database.Entities.Seat entity, SeatUpdateRequest request)
        {
            await base.BeforeUpdate(entity, request);
            
            if (request.HallId != entity.HallId)
            {
                var currentSeatCount = await _context.Set<Database.Entities.Seat>()
                    .Where(s => s.HallId == request.HallId)
                    .CountAsync();
                    
                var hall = await _context.Set<Database.Entities.Hall>()
                    .Where(h => h.Id == request.HallId && !h.IsDeleted)
                    .FirstOrDefaultAsync();
                    
                if (hall != null && currentSeatCount >= hall.Capacity)
                {
                    throw new Exception($"Cannot move seat to this hall. Hall capacity is {hall.Capacity} and current seat count is {currentSeatCount}.");
                }
            }
        }

        public override async Task<SeatResponse> UpdateAsync(int id, SeatUpdateRequest request)
        {
            var entity = await _context.Set<Database.Entities.Seat>().FindAsync(id);
            if (entity == null)
            {
                throw new Exception("Entity not found");
            }

            await BeforeUpdate(entity, request);
            MapUpdateToEntity(entity, request);

            await _context.SaveChangesAsync();
            return MapToResponse(entity);
        }
    }
} 