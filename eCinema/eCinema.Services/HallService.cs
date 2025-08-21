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

            if (!string.IsNullOrWhiteSpace(search.Location))
            {
                query = query.Where(x => x.Location.Contains(search.Location));
            }

            if (!string.IsNullOrWhiteSpace(search.ScreenType))
            {
                query = query.Where(x => x.ScreenType != null && x.ScreenType.Contains(search.ScreenType));
            }

            if (!string.IsNullOrWhiteSpace(search.SoundSystem))
            {
                query = query.Where(x => x.SoundSystem != null && x.SoundSystem.Contains(search.SoundSystem));
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

            var currentSeatCount = await _context.Seats.CountAsync(s => s.HallId == entity.Id);
            if (currentSeatCount != request.Capacity)
            {
                throw new InvalidOperationException(
                    $"Cannot update hall capacity to {request.Capacity}. Current seat count is {currentSeatCount}. " +
                    "Please adjust the seats first or use the auto-generate feature.");
            }
        }

        public async Task GenerateSeatsForHall(int hallId, int capacity)
        {   
            var hall = await _context.Halls.FindAsync(hallId);
            if (hall == null)
            {
                throw new InvalidOperationException("Hall not found.");
            }

            var existingSeats = await _context.Seats.Where(s => s.HallId == hallId).ToListAsync();
            _context.Seats.RemoveRange(existingSeats);

            var newSeats = new List<Seat>();
            var rows = new[] { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O" };
            var seatsPerRow = 12;

            
            for (int rowIndex = 0; rowIndex < rows.Length && newSeats.Count < capacity; rowIndex++)
            {
                var currentRow = rows[rowIndex];
                
                for (int seatNumber = 1; seatNumber <= seatsPerRow && newSeats.Count < capacity; seatNumber++)
                {
                    var seatName = $"{currentRow}{seatNumber}";
                    
                    var seat = new Seat
                    {
                        HallId = hallId,
                        Name = seatName
                    };

                    newSeats.Add(seat);
                }
            }

            _context.Seats.AddRange(newSeats);
            await _context.SaveChangesAsync();
        }
    }
} 