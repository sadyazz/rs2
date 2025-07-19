using eCinema.Model.Responses;

namespace eCinema.Services
{
    public interface IDashboardService
    {
        Task<DashboardStatsResponse> GetDashboardStatsAsync();
        Task<int> GetUserCountAsync();
        Task<decimal> GetTotalCinemaIncomeAsync();
        Task<List<MovieRevenueResponse>> GetTop5WatchedMoviesAsync();
        Task<List<MovieRevenueResponse>> GetRevenueByMovieAsync();
        Task<List<TopCustomerResponse>> GetTop5CustomersAsync();
    }
} 