using eCinema.Model.Responses;

namespace eCinema.Services
{
    public interface IDashboardService
    {
        Task<DashboardStatsResponse> GetDashboardStatsAsync();
        Task<int> GetUserCountAsync();
        Task<Dictionary<string, int>> GetUserCountByRoleAsync();
        Task<decimal> GetTotalCinemaIncomeAsync();
        Task<List<MovieRevenueResponse>> GetTop5WatchedMoviesAsync();
        Task<List<MovieRevenueResponse>> GetRevenueByMovieAsync();
        Task<List<TopCustomerResponse>> GetTop5CustomersAsync();
        Task<List<ScreeningResponse>> GetTodayScreeningsAsync();
        Task<List<TicketSalesResponse>> GetTicketSalesAsync(DateTime startDate, DateTime endDate, int? movieId = null, int? hallId = null);
        Task<List<ScreeningAttendanceResponse>> GetScreeningAttendanceAsync(DateTime startDate, DateTime endDate, int? movieId = null, int? hallId = null);
        Task<List<RevenueResponse>> GetRevenueAsync(DateTime startDate, DateTime endDate, int? movieId = null, int? hallId = null);
    }
} 