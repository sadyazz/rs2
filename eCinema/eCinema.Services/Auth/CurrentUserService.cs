using Microsoft.AspNetCore.Http;
using System.Security.Claims;
using eCinema.Services.Database;
using eCinema.Services.Database.Entities;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Services.Auth
{
    public class CurrentUserService : ICurrentUserService
    {
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly eCinemaDBContext _context;

        public CurrentUserService(IHttpContextAccessor httpContextAccessor, eCinemaDBContext context)
        {
            _httpContextAccessor = httpContextAccessor;
            _context = context;
        }

        public Task<int?> GetUserIdAsync(CancellationToken cancellationToken = default)
        {
            var userIdClaim = _httpContextAccessor.HttpContext?.User?.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int userId))
            {
                return Task.FromResult<int?>(null);
            }

            return Task.FromResult<int?>(userId);
        }

        public Task<string?> GetUserNameAsync(CancellationToken cancellationToken = default)
        {
            var userName = _httpContextAccessor.HttpContext?.User?.FindFirst(ClaimTypes.Name)?.Value;
            return Task.FromResult(userName);
        }

        public Task<string?> GetUserRoleAsync(CancellationToken cancellationToken = default)
        {
            var userRole = _httpContextAccessor.HttpContext?.User?.FindFirst(ClaimTypes.Role)?.Value;
            return Task.FromResult(userRole);
        }

        public async Task<bool> IsAdminAsync(CancellationToken cancellationToken = default)
        {
            var userRole = await GetUserRoleAsync(cancellationToken);
            return userRole?.ToLower() == "admin";
        }

        public async Task<User?> GetCurrentUserAsync(CancellationToken cancellationToken = default)
        {
            var userId = await GetUserIdAsync(cancellationToken);
            if (!userId.HasValue)
            {
                return null;
            }

            var user = await _context.Users
                .Include(u => u.Role)
                .FirstOrDefaultAsync(x => x.Id == userId.Value && x.IsActive, cancellationToken);

            return user;
        }
    }
} 