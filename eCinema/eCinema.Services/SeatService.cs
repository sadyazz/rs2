using eCinema.Model.Responses;
using eCinema.Model.Requests;
using eCinema.Model.SearchObjects;
using eCinema.Services.Database;
using eCinema.Services.Database.Entities;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Services
{
    public class SeatService : BaseCRUDService<SeatResponse, BaseSearchObject, Seat, SeatUpsertRequest, SeatUpsertRequest>, ISeatService
    {
        private readonly eCinemaDBContext _context;
        
        public SeatService(eCinemaDBContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
        }

        public async Task<List<SeatResponse>> GetSeatsForScreening(int screeningId)
        {
            var screening = await _context.Screenings
                .Include(x => x.Hall)
                .FirstOrDefaultAsync(x => x.Id == screeningId && !x.IsDeleted);

            if (screening == null)
            {
                throw new InvalidOperationException($"Screening with ID {screeningId} not found.");
            }
            
            var allSeats = await _context.Seats
                .Where(s => s.HallId == screening.HallId)
                .ToListAsync();
            
            if (allSeats.Count == 0 || allSeats.Count < screening.Hall.Capacity)
            {
                await GenerateSeatsForHall(screening.HallId, screening.Hall.Capacity);
                
                allSeats = await _context.Seats
                    .Where(s => s.HallId == screening.HallId)
                    .ToListAsync();
            }

            var reservedSeats = await _context.ScreeningSeats
                .Where(ss => ss.ScreeningId == screeningId && ss.IsReserved == true)
                .Select(ss => ss.SeatId)
                .ToListAsync();

            return allSeats.Select(seat => new SeatResponse
            {
                Id = seat.Id,
                HallId = seat.HallId,
                Name = seat.Name,
                IsReserved = reservedSeats.Contains(seat.Id)
            }).ToList();
        }

        public async Task GenerateSeatsForHall(int hallId, int capacity)
        {
            
            var hall = await _context.Halls.FindAsync(hallId);
            if (hall == null)
            {
                throw new InvalidOperationException("Hall not found.");
            }

            var existingSeats = await _context.Seats
                .Include(s => s.ReservationSeats)
                .Where(s => s.HallId == hallId)
                .ToListAsync();

            foreach (var seat in existingSeats)
            {
                var reservationSeats = await _context.ReservationSeats
                    .Where(rs => rs.SeatId == seat.Id)
                    .ToListAsync();
                _context.ReservationSeats.RemoveRange(reservationSeats);

                var screeningSeats = await _context.ScreeningSeats
                    .Where(ss => ss.SeatId == seat.Id)
                    .ToListAsync();
                _context.ScreeningSeats.RemoveRange(screeningSeats);
            }
            await _context.SaveChangesAsync();

            _context.Seats.RemoveRange(existingSeats);
            await _context.SaveChangesAsync();

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