using eCinema.Model.Responses;
using eCinema.Services.Database;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Services
{
    public class DashboardService : IDashboardService
    {
        private readonly eCinemaDBContext _context;

        public DashboardService(eCinemaDBContext context)
        {
            _context = context;
        }

        public async Task<DashboardStatsResponse> GetDashboardStatsAsync()
        {
            var stats = new DashboardStatsResponse
            {
                TotalMovies = await _context.Movies.CountAsync(),
                TotalActors = await _context.Actors.CountAsync(),
                TotalGenres = await _context.Genres.CountAsync(),
                TotalUsers = await _context.Users.CountAsync(),
                TotalHalls = await _context.Halls.CountAsync(),
                TotalShows = await _context.Screenings.CountAsync(),
                TotalReservations = await _context.Reservations.CountAsync(),
                ActiveShows = await _context.Screenings
                    .Where(s => s.StartTime.Date == DateTime.Now.Date && !s.IsDeleted)
                    .CountAsync()
            };

            return stats;
        }

        public async Task<int> GetUserCountAsync()
        {
            return await _context.Users.CountAsync();
        }

        public async Task<decimal> GetTotalCinemaIncomeAsync()
        {
            return await _context.Reservations
                .Where(r => r.Status == "Paid")
                .SumAsync(r => r.TotalPrice);
        }

        public async Task<List<MovieRevenueResponse>> GetTop5WatchedMoviesAsync()
        {
            return await _context.Reservations
                .Where(r => r.Status == "Paid")
                .GroupBy(r => r.Screening.Movie)
                .Select(g => new MovieRevenueResponse
                {
                    MovieId = g.Key.Id,
                    MovieTitle = g.Key.Title,
                    MovieImage = g.Key.Image != null ? Convert.ToBase64String(g.Key.Image) : null,
                    ReservationCount = g.Count(),
                    TotalRevenue = g.Sum(r => r.TotalPrice)
                })
                .OrderByDescending(m => m.ReservationCount)
                .Take(5)
                .ToListAsync();
        }

        public async Task<List<MovieRevenueResponse>> GetRevenueByMovieAsync()
        {
            return await _context.Reservations
                .Where(r => r.Status == "Paid")
                .GroupBy(r => r.Screening.Movie)
                .Select(g => new MovieRevenueResponse
                {
                    MovieId = g.Key.Id,
                    MovieTitle = g.Key.Title,
                    MovieImage = g.Key.Image != null ? Convert.ToBase64String(g.Key.Image) : null,
                    ReservationCount = g.Count(),
                    TotalRevenue = g.Sum(r => r.TotalPrice)
                })
                .OrderByDescending(m => m.TotalRevenue)
                .ToListAsync();
        }

        public async Task<List<TopCustomerResponse>> GetTop5CustomersAsync()
        {
            return await _context.Reservations
                .Where(r => r.Status == "Paid")
                .GroupBy(r => r.User)
                .Select(g => new TopCustomerResponse
                {
                    UserId = g.Key.Id,
                    UserName = g.Key.FirstName + " " + g.Key.LastName,
                    Email = g.Key.Email,
                    ReservationCount = g.Count(),
                    TotalSpent = g.Sum(r => r.TotalPrice)
                })
                .OrderByDescending(c => c.TotalSpent)
                .Take(5)
                .ToListAsync();
        }
    }
} 