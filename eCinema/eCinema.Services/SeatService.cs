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
            var screeningSeats = await _context.ScreeningSeats
                .Where(ss => ss.ScreeningId == screeningId)
                .Include(ss => ss.Seat)
                .ToListAsync();

            Console.WriteLine($"🔍 GetSeatsForScreening: Found {screeningSeats?.Count ?? 0} seats for screening {screeningId}");

            if (screeningSeats == null || !screeningSeats.Any())
            {
                Console.WriteLine($"⚠️ No seats found for screening {screeningId}");
                return new List<SeatResponse>();
            }

            var result = screeningSeats.Select(ss => new SeatResponse
            {
                Id = ss.SeatId,
                Name = ss.Seat.Name,
                IsReserved = ss.IsReserved
            }).ToList();

            Console.WriteLine($"✅ Returning {result.Count} seats for screening {screeningId}");
            Console.WriteLine($"📊 Reserved seats: {result.Count(s => s.IsReserved == true)}");
            Console.WriteLine($"📊 Available seats: {result.Count(s => s.IsReserved != true)}");

            return result;
        }

        public async Task<int> GetSeatsCount()
        {
            var count = await _context.Seats.CountAsync();
            Console.WriteLine($"🔍 GetSeatsCount: Found {count} seats in database");
            return count;
        }

        public async Task<int> GenerateAllSeats()
        {
            var existingSeats = await _context.Seats.CountAsync();
            Console.WriteLine($"🔍 GenerateAllSeats: Found {existingSeats} existing seats");

            if (existingSeats >= 48)
            {
                Console.WriteLine($"✅ Already have {existingSeats} seats, no need to generate more");
                return existingSeats;
            }

            var rows = new[] { "A", "B", "C", "D", "E", "F", "G", "H" };
            var seatsPerRow = 6;
            var totalSeats = 48;

            Console.WriteLine($"⚠️ Generating {totalSeats} new seats...");

            for (int i = 0; i < totalSeats; i++)
            {
                var rowIndex = i / seatsPerRow;
                var seatNumber = (i % seatsPerRow) + 1;
                
                if (rowIndex < rows.Length)
                {
                    var seatName = $"{rows[rowIndex]}{seatNumber}";
                    var seat = new Seat { Name = seatName };
                    _context.Seats.Add(seat);
                }
            }

            await _context.SaveChangesAsync();
            
            var newCount = await _context.Seats.CountAsync();
            Console.WriteLine($"✅ Generated {newCount - existingSeats} new seats. Total: {newCount}");
            
            return newCount;
        }
    }
}