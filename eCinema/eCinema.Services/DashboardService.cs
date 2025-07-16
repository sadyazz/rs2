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
                    .Where(s => s.StartTime.Date == DateTime.Now.Date && s.IsActive && !s.IsDeleted)
                    .CountAsync()
            };

            return stats;
        }
    }
} 