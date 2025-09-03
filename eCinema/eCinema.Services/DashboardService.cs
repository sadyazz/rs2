using eCinema.Model.Responses;
using eCinema.Services.Database;
using eCinema.Services.ReservationStateMachine;
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
                    .CountAsync(),
                UserCountByRole = await GetUserCountByRoleAsync()
            };

            return stats;
        }

        public async Task<int> GetUserCountAsync()
        {
            return await _context.Users.CountAsync();
        }

        public async Task<Dictionary<string, int>> GetUserCountByRoleAsync()
        {
            return await _context.Users
                .Where(u => u.Role != null)
                .GroupBy(u => u.Role.Name)
                .ToDictionaryAsync(g => g.Key, g => g.Count());
        }

        public async Task<decimal> GetTotalCinemaIncomeAsync()
        {
            return await _context.Reservations
                .Where(r => !r.IsDeleted && 
                           (r.State == nameof(ApprovedReservationState) || 
                            r.State == nameof(UsedReservationState) ||
                            r.State == nameof(PendingReservationState) ||
                            r.State == nameof(InitialReservationState)))
                .SumAsync(r => r.TotalPrice);
        }

        public async Task<List<MovieRevenueResponse>> GetTop5WatchedMoviesAsync()
        {
            return await _context.Reservations
                .Where(r => !r.IsDeleted && 
                           (r.State == nameof(ApprovedReservationState) || 
                            r.State == nameof(UsedReservationState) ||
                            r.State == nameof(PendingReservationState) ||
                            r.State == nameof(InitialReservationState)))
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
                .Where(r => !r.IsDeleted && 
                           (r.State == nameof(ApprovedReservationState) || 
                            r.State == nameof(UsedReservationState) ||
                            r.State == nameof(PendingReservationState) ||
                            r.State == nameof(InitialReservationState)))
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
                .Where(r => !r.IsDeleted && 
                           (r.State == nameof(ApprovedReservationState) || 
                            r.State == nameof(UsedReservationState) ||
                            r.State == nameof(PendingReservationState) ||
                            r.State == nameof(InitialReservationState)))
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

        public async Task<List<ScreeningResponse>> GetTodayScreeningsAsync()
        {
            var today = DateTime.Now.Date;
            return await _context.Screenings
                .Where(s => s.StartTime.Date == today && !s.IsDeleted)
                .Include(s => s.Movie)
                .Include(s => s.Hall)
                .Include(s => s.Format)
                .OrderBy(s => s.StartTime)
                .Select(s => new ScreeningResponse
                {
                    Id = s.Id,
                    StartTime = s.StartTime,
                    EndTime = s.EndTime,
                    BasePrice = s.BasePrice,
                    Language = s.Language,
                    HasSubtitles = s.HasSubtitles,
                    IsDeleted = s.IsDeleted,
                    MovieId = s.Movie.Id,
                    MovieTitle = s.Movie.Title,
                    MovieImage = s.Movie.Image,
                    HallId = s.Hall.Id,
                    HallName = s.Hall.Name,
                    ScreeningFormatId = s.Format != null ? s.Format.Id : null,
                    ScreeningFormatName = s.Format != null ? s.Format.Name : null,
                    ScreeningFormatPriceMultiplier = s.Format != null ? s.Format.PriceMultiplier : null,
                    ReservationsCount = s.Reservations.Count(r => !r.IsDeleted),
                    AvailableSeats = s.ScreeningSeats.Count(ss => ss.IsReserved != true)
                })
                .ToListAsync();
        }

        public async Task<List<TicketSalesResponse>> GetTicketSalesAsync(DateTime startDate, DateTime endDate, int? movieId = null, int? hallId = null)
        {

            var query = _context.Reservations
                .Include(r => r.ReservationSeats)
                .Include(r => r.Screening)
                    .ThenInclude(s => s.Movie)
                .Include(r => r.Screening)
                    .ThenInclude(s => s.Hall)
                .Where(r => !r.IsDeleted &&
                           (r.State == nameof(ApprovedReservationState) || 
                            r.State == nameof(UsedReservationState) ||
                            r.State == nameof(PendingReservationState) ||
                            r.State == nameof(InitialReservationState)) &&
                           r.ReservationTime.Date >= startDate.Date &&
                           r.ReservationTime.Date <= endDate.Date);

            if (movieId.HasValue)
            {
                query = query.Where(r => r.Screening.MovieId == movieId.Value);
            }

            if (hallId.HasValue)
            {
                query = query.Where(r => r.Screening.HallId == hallId.Value);
            }

            var reservationSeats = await query
                .SelectMany(r => r.ReservationSeats.Select(rs => new { r.ReservationTime.Date, r.Id }))
                .GroupBy(x => x.Date)
                .Select(g => new
                {
                    Date = g.Key,
                    TicketCount = g.Count()
                })
                .ToDictionaryAsync(x => x.Date);

            var revenue = await query
                .GroupBy(r => r.ReservationTime.Date)
                .Select(g => new
                {
                    Date = g.Key,
                    TotalRevenue = g.Sum(r => r.TotalPrice)
                })
                .ToDictionaryAsync(x => x.Date);

            var allDates = new List<TicketSalesResponse>();
            for (var date = startDate.Date; date <= endDate.Date; date = date.AddDays(1))
            {
                var hasReservations = reservationSeats.TryGetValue(date, out var seats);
                var hasRevenue = revenue.TryGetValue(date, out var rev);

                allDates.Add(new TicketSalesResponse
                {
                    Date = date,
                    TicketCount = hasReservations ? seats.TicketCount : 0,
                    TotalRevenue = hasRevenue ? rev.TotalRevenue : 0
                });
            }

            return allDates.OrderBy(r => r.Date).ToList();
        }

        public async Task<List<ScreeningAttendanceResponse>> GetScreeningAttendanceAsync(DateTime startDate, DateTime endDate, int? movieId = null, int? hallId = null)
        {
            var query = _context.Screenings
                .Where(s => !s.IsDeleted &&
                           s.StartTime.Date >= startDate.Date &&
                           s.StartTime.Date <= endDate.Date);

            if (movieId.HasValue)
            {
                query = query.Where(s => s.MovieId == movieId.Value);
            }

            if (hallId.HasValue)
            {
                query = query.Where(s => s.HallId == hallId.Value);
            }

            return await query
                .Select(s => new ScreeningAttendanceResponse
                {
                    ScreeningId = s.Id,
                    MovieTitle = s.Movie.Title,
                    HallName = s.Hall.Name,
                    StartTime = s.StartTime,
                    TotalSeats = s.ScreeningSeats.Count,
                    ReservedSeats = s.ScreeningSeats.Count(ss => ss.IsReserved ?? false),
                    OccupancyRate = s.ScreeningSeats.Count > 0 
                        ? (decimal)s.ScreeningSeats.Count(ss => ss.IsReserved ?? false) / s.ScreeningSeats.Count * 100 
                        : 0
                })
                .OrderByDescending(s => s.OccupancyRate)
                .ToListAsync();
        }

        public async Task<List<RevenueResponse>> GetRevenueAsync(DateTime startDate, DateTime endDate, int? movieId = null, int? hallId = null)
        {
            
            var query = _context.Reservations
                .Where(r => !r.IsDeleted &&
                           (r.State == nameof(ApprovedReservationState) || 
                            r.State == nameof(UsedReservationState) ||
                            r.State == nameof(PendingReservationState) ||
                            r.State == nameof(InitialReservationState)) &&
                           r.ReservationTime.Date >= startDate.Date &&
                           r.ReservationTime.Date <= endDate.Date);

            if (movieId.HasValue)
            {
                query = query.Where(r => r.Screening.MovieId == movieId.Value);
            }

            if (hallId.HasValue)
            {
                query = query.Where(r => r.Screening.HallId == hallId.Value);
            }
            var revenueData = await query
                .GroupBy(r => new 
                { 
                    Date = r.ReservationTime.Date,
                    MovieTitle = movieId.HasValue ? r.Screening.Movie.Title : null,
                    HallName = hallId.HasValue ? r.Screening.Hall.Name : null
                })
                .Select(g => new RevenueResponse
                {
                    Date = g.Key.Date,
                    MovieTitle = g.Key.MovieTitle,
                    HallName = g.Key.HallName,
                    TotalRevenue = g.Sum(r => r.TotalPrice),
                    ReservationCount = g.Count(),
                    AverageTicketPrice = g.Sum(r => r.TotalPrice) / g.Count()
                })
                .ToDictionaryAsync(r => r.Date.Date);

            var allDates = new List<RevenueResponse>();
            for (var date = startDate.Date; date <= endDate.Date; date = date.AddDays(1))
            {
                if (revenueData.TryGetValue(date, out var revenue))
                {
                    allDates.Add(revenue);
                }
                else
                {
                    allDates.Add(new RevenueResponse
                    {
                        Date = date,
                        MovieTitle = null,
                        HallName = null,
                        TotalRevenue = 0,
                        ReservationCount = 0,
                        AverageTicketPrice = 0
                    });
                }
            }

            var result = allDates.OrderBy(r => r.Date).ToList();

            Console.WriteLine($"Final revenue result for {startDate:yyyy-MM-dd} to {endDate:yyyy-MM-dd}: {System.Text.Json.JsonSerializer.Serialize(result)}");
            
            return result;
        }
    }
} 