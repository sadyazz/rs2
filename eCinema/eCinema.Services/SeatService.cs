using eCinema.Model.Responses;
using eCinema.Model.Requests;
using eCinema.Model.SearchObjects;
using eCinema.Services.Database;
using eCinema.Services.Database.Entities;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using eCinema.Model;

namespace eCinema.Services
{
    public class SeatService : BaseCRUDService<SeatResponse, SeatSearchObject, Seat, SeatUpsertRequest, SeatUpsertRequest>, ISeatService
    {
        private readonly eCinemaDBContext _context;
        
        private bool IsValidSeatName(string name)
        {
            if (string.IsNullOrWhiteSpace(name)) return false;
            var regex = new System.Text.RegularExpressions.Regex(@"^[A-Z][1-9][0-9]?$");
            return regex.IsMatch(name);
        }


        
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

        protected override IQueryable<Seat> ApplyFilter(IQueryable<Seat> query, SeatSearchObject search)
        {
            query = base.ApplyFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search.FTS))
            {
                query = query.Where(x => x.Name.Contains(search.FTS));
            }

            return query;
        }

        public async Task<int> GetSeatsCount()
        {
            var count = await _context.Seats.CountAsync();
            return count;
        }

        public override async Task<SeatResponse> CreateAsync(SeatUpsertRequest request)
        {
            if (!IsValidSeatName(request.Name))
            {
                throw new UserException("Invalid seat name format. Must be A1-F8");
            }

            var existingSeats = await _context.Seats.CountAsync();
            if (existingSeats >= 48)
            {
                throw new UserException("Maximum number of seats (48) has been reached");
            }

            return await base.CreateAsync(request);
        }

        public override async Task<SeatResponse> UpdateAsync(int id, SeatUpsertRequest request)
        {
            if (!IsValidSeatName(request.Name))
            {
                throw new UserException("Invalid seat name format. Must be A1-F8");
            }

            return await base.UpdateAsync(id, request);
        }

        public override async Task<bool> DeleteAsync(int id)
        {
            var seat = await _context.Seats.FindAsync(id);
            if (seat == null)
                return false;

            _context.Seats.Remove(seat);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<int> ClearAllSeats()
        {
            var existingSeats = await _context.Seats.CountAsync();

            if (existingSeats == 0)
            {
                return 0;
            }

            _context.Seats.RemoveRange(_context.Seats);
            await _context.SaveChangesAsync();
            
            return existingSeats;
        }

        public async Task<int> GenerateAllSeats()
        {
            var existingSeats = await _context.Seats.CountAsync();

            if (existingSeats >= 48)
            {
                return existingSeats;
            }

            var rows = new[] { "A", "B", "C", "D", "E", "F" };
            var seatsPerRow = 8;
            var totalSeats = rows.Length * seatsPerRow;


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
            
            return newCount;
        }
    }
}