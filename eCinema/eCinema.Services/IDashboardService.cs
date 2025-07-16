using eCinema.Model.Responses;

namespace eCinema.Services
{
    public interface IDashboardService
    {
        Task<DashboardStatsResponse> GetDashboardStatsAsync();
    }
} 