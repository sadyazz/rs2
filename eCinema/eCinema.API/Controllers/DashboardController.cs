using eCinema.Model.Responses;
using eCinema.Services;
using eCinema.Services.Auth;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eCinema.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize(Roles = "admin")]
    public class DashboardController : ControllerBase
    {
        private readonly IDashboardService _dashboardService;
        private readonly ICurrentUserService _currentUserService;

        public DashboardController(IDashboardService dashboardService, ICurrentUserService currentUserService)
        {
            _dashboardService = dashboardService;
            _currentUserService = currentUserService;
        }

        [HttpGet("debug-user")]
        [AllowAnonymous]
        public async Task<IActionResult> DebugUser()
        {
            var userId = await _currentUserService.GetUserIdAsync();
            var userName = await _currentUserService.GetUserNameAsync();
            var userRole = await _currentUserService.GetUserRoleAsync();
            var isAdmin = await _currentUserService.IsAdminAsync();
            var currentUser = await _currentUserService.GetCurrentUserAsync();
            
            return Ok(new { 
                UserId = userId,
                UserName = userName,
                UserRole = userRole,
                IsAdmin = isAdmin,
                CurrentUser = currentUser != null ? new { 
                    currentUser.Id, 
                    currentUser.Username, 
                    currentUser.Role?.Name 
                } : null
            });
        }

        [HttpGet("stats")]
        public async Task<ActionResult<DashboardStatsResponse>> GetDashboardStats()
        {
            try
            {
                var stats = await _dashboardService.GetDashboardStatsAsync();
                return Ok(stats);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Error retrieving dashboard statistics", error = ex.Message });
            }
        }

        [HttpGet("user-count")]
        public async Task<IActionResult> GetUserCount()
        {
            try
            {
                var userCount = await _dashboardService.GetUserCountAsync();
                return Ok(new { UserCount = userCount });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Error retrieving user count", error = ex.Message });
            }
        }

        [HttpGet("user-count-by-role")]
        public async Task<IActionResult> GetUserCountByRole()
        {
            try
            {
                var userCountByRole = await _dashboardService.GetUserCountByRoleAsync();
                return Ok(userCountByRole);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Error retrieving user count by role", error = ex.Message });
            }
        }

        [HttpGet("total-income")]
        public async Task<IActionResult> GetTotalCinemaIncome()
        {
            try
            {
                var totalIncome = await _dashboardService.GetTotalCinemaIncomeAsync();
                return Ok(new { TotalIncome = totalIncome });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Error retrieving total income", error = ex.Message });
            }
        }

        [HttpGet("top-5-watched-movies")]
        public async Task<IActionResult> GetTop5ReservedMovies()
        {
            try
            {
                var top5Movies = await _dashboardService.GetTop5WatchedMoviesAsync();
                return Ok(top5Movies);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Error retrieving top 5 watched movies", error = ex.Message });
            }
        }

        [HttpGet("revenue-by-movie")]
        public async Task<IActionResult> GetRevenueByMovie()
        {
            try
            {
                var movieRevenues = await _dashboardService.GetRevenueByMovieAsync();
                return Ok(movieRevenues);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Error retrieving revenue by movie", error = ex.Message });
            }
        }

        [HttpGet("top-5-customers")]
        public async Task<IActionResult> GetTop5Customers()
        {
            try
            {
                var top5Customers = await _dashboardService.GetTop5CustomersAsync();
                return Ok(top5Customers);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Error retrieving top 5 customers", error = ex.Message });
            }
        }

        [HttpGet("today-screenings")]
        public async Task<IActionResult> GetTodayScreenings()
        {
            try
            {
                var todayScreenings = await _dashboardService.GetTodayScreeningsAsync();
                return Ok(todayScreenings);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Error retrieving today's screenings", error = ex.Message });
            }
        }

        [HttpGet("ticket-sales")]
        public async Task<IActionResult> GetTicketSales([FromQuery] DateTime startDate, [FromQuery] DateTime endDate, [FromQuery] int? movieId = null, [FromQuery] int? hallId = null)
        {
            try
            {
                var ticketSales = await _dashboardService.GetTicketSalesAsync(startDate, endDate, movieId, hallId);
                return Ok(ticketSales);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Error retrieving ticket sales", error = ex.Message });
            }
        }

        [HttpGet("screening-attendance")]
        public async Task<IActionResult> GetScreeningAttendance([FromQuery] DateTime startDate, [FromQuery] DateTime endDate, [FromQuery] int? movieId = null, [FromQuery] int? hallId = null)
        {
            try
            {
                var attendance = await _dashboardService.GetScreeningAttendanceAsync(startDate, endDate, movieId, hallId);
                return Ok(attendance);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Error retrieving screening attendance", error = ex.Message });
            }
        }

        [HttpGet("revenue")]
        public async Task<IActionResult> GetRevenue([FromQuery] DateTime startDate, [FromQuery] DateTime endDate, [FromQuery] int? movieId = null, [FromQuery] int? hallId = null)
        {
            try
            {
                var revenue = await _dashboardService.GetRevenueAsync(startDate, endDate, movieId, hallId);
                return Ok(revenue);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Error retrieving revenue", error = ex.Message });
            }
        }
    }
} 