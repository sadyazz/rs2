using eCinema.Model;
using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;
using eCinema.Services.Database;
using eCinema.Services.Database.Entities;
using eCinema.Services.Auth;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Threading.Tasks;
using MapsterMapper;

namespace eCinema.Services
{
    public class ReviewService : BaseCRUDService<ReviewResponse, ReviewSearchObject, Review, ReviewUpsertRequest, ReviewUpsertRequest>, IReviewService
    {
        private readonly eCinemaDBContext _context;
        private readonly ICurrentUserService _currentUserService;
        
        public ReviewService(eCinemaDBContext context, IMapper mapper, ICurrentUserService currentUserService) : base(context, mapper)
        {
            _context = context;
            _currentUserService = currentUserService;
        }

        private async Task<bool> IsAdminAsync()
        {
            return await _currentUserService.IsAdminAsync();
        }

        public override async Task<ReviewResponse> CreateAsync(ReviewUpsertRequest request)
        {
            var currentUser = await _currentUserService.GetCurrentUserAsync();
            if (currentUser == null)
            {
                throw new UnauthorizedAccessException("User not authenticated.");
            }
            
            var entity = _mapper.Map<Review>(request);
            entity.UserId = currentUser.Id;
            entity.MovieId = request.MovieId;
            entity.CreatedAt = DateTime.UtcNow;
            entity.IsActive = true;
            entity.IsDeleted = false;
            entity.IsEdited = false;
            entity.IsSpoiler = request.IsSpoiler ?? false;

            await BeforeInsert(entity, request);
            
            _context.Set<Review>().Add(entity);
            await _context.SaveChangesAsync();
            
            await RecalculateMovieGrade(entity.MovieId);
            
            return MapToResponse(entity);
        }

        public override async Task<ReviewResponse> UpdateAsync(int id, ReviewUpsertRequest request)
        {
            var entity = await _context.Set<Review>().FindAsync(id);
            if (entity == null)
            {
                throw new InvalidOperationException("Review not found.");
            }

            var currentUser = await _currentUserService.GetCurrentUserAsync();
            if (currentUser == null)
            {
                throw new UnauthorizedAccessException("User not authenticated.");
            }
            var isAdmin = await IsAdminAsync();
            var isOwnReview = currentUser.Id == entity.UserId;

            if (!isAdmin && !isOwnReview)
            {
                throw new UnauthorizedAccessException("You can only edit your own reviews.");
            }

            if (isAdmin && !isOwnReview)
            {
                if (request.IsSpoiler == null)
                {
                    throw new UnauthorizedAccessException("Admins must specify the spoiler status when editing reviews.");
                }

                var originalReview = await _context.Reviews
                    .AsNoTracking()
                    .FirstOrDefaultAsync(x => x.Id == id);

                if (originalReview == null)
                {
                    throw new InvalidOperationException("Review not found.");
                }

                var hasChangesOtherThanSpoiler = 
                    originalReview.Rating != request.Rating ||
                    originalReview.Comment != request.Comment ||
                    originalReview.IsActive != request.IsActive ||
                    originalReview.IsDeleted != request.IsDeleted;

                if (hasChangesOtherThanSpoiler)
                {
                    throw new UnauthorizedAccessException("Admins can only modify the spoiler status of reviews.");
                }

                entity.IsSpoiler = request.IsSpoiler.Value;
            }
            else
            {
                entity.Rating = request.Rating;
                entity.Comment = request.Comment;
                entity.IsEdited = true;
                if (request.IsSpoiler.HasValue)
                    entity.IsSpoiler = request.IsSpoiler.Value;
            }

            entity.ModifiedAt = DateTime.UtcNow;

            await BeforeUpdate(entity, request);
            
            await _context.SaveChangesAsync();
            await RecalculateMovieGrade(entity.MovieId);
            
            return MapToResponse(entity);
        }

        public override async Task<bool> DeleteAsync(int id)
        {
            var entity = await _context.Set<Review>().FindAsync(id);
            if (entity == null)
            {
                throw new InvalidOperationException("Review not found.");
            }

            var currentUser = await _currentUserService.GetCurrentUserAsync();
            if (currentUser == null)
            {
                throw new UnauthorizedAccessException("User not authenticated.");
            }
            var isAdmin = await IsAdminAsync();
            var isOwnReview = currentUser.Id == entity.UserId;

            if (!isAdmin && !isOwnReview)
            {
                throw new UnauthorizedAccessException("You can only delete your own reviews.");
            }

            var movieId = entity.MovieId;
            
            var result = await base.DeleteAsync(id);
            
            if (result && movieId > 0)
            {
                await RecalculateMovieGrade(movieId);
            }
            
            return result;
        }

        public override async Task<bool> SoftDeleteAsync(int id)
        {
            var entity = await _context.Set<Review>().FindAsync(id);
            if (entity == null)
            {
                throw new InvalidOperationException("Review not found.");
            }

            var currentUser = await _currentUserService.GetCurrentUserAsync();
            if (currentUser == null)
            {
                throw new UnauthorizedAccessException("User not authenticated.");
            }
            var isAdmin = await IsAdminAsync();
            var isOwnReview = currentUser.Id == entity.UserId;

            if (!isAdmin && !isOwnReview)
            {
                throw new UnauthorizedAccessException("You can only delete your own reviews.");
            }

            var movieId = entity.MovieId;
            
            var result = await base.SoftDeleteAsync(id);
            
            if (result && movieId > 0)
            {
                await RecalculateMovieGrade(movieId);
            }
            
            return result;
        }

        public override async Task<bool> RestoreAsync(int id)
        {
            var entity = await _context.Set<Review>().FindAsync(id);
            if (entity == null)
            {
                throw new InvalidOperationException("Review not found.");
            }

            var isAdmin = await IsAdminAsync();

            if (!isAdmin)
            {
                throw new UnauthorizedAccessException("Only admins can restore reviews.");
            }

            var movieId = entity.MovieId;
            
            var result = await base.RestoreAsync(id);
            
            if (result && movieId > 0)
            {
                await RecalculateMovieGrade(movieId);
            }
            
            return result;
        }

        public async Task<ReviewResponse> ToggleSpoilerAsync(int id)
        {
            var entity = await _context.Set<Review>().FindAsync(id);
            if (entity == null)
            {
                throw new InvalidOperationException("Review not found.");
            }

            var currentUser = await _currentUserService.GetCurrentUserAsync();
            if (currentUser == null)
            {
                throw new UnauthorizedAccessException("User not authenticated.");
            }
            var isAdmin = await IsAdminAsync();
            var isOwnReview = currentUser.Id == entity.UserId;

            if (!isAdmin && !isOwnReview)
            {
                throw new UnauthorizedAccessException("You can only toggle spoiler status on your own reviews.");
            }

            entity.IsSpoiler = !entity.IsSpoiler;
            entity.ModifiedAt = DateTime.UtcNow;

            await _context.SaveChangesAsync();

            return MapToResponse(entity);
        }

        private async Task RecalculateMovieGrade(int movieId)
        {
            var movie = await _context.Movies
                .Include(m => m.Reviews.Where(r => r.IsActive))
                .FirstOrDefaultAsync(m => m.Id == movieId);

            if (movie != null)
            {
                var activeReviews = movie.Reviews.Where(r => r.IsActive).ToList();
                
                if (activeReviews.Any())
                {
                    movie.Grade = (float)activeReviews.Average(r => r.Rating);
                }
                else
                {
                    movie.Grade = 0;
                }

                await _context.SaveChangesAsync();
            }
        }

        protected override IQueryable<Review> ApplyFilter(IQueryable<Review> query, ReviewSearchObject search)
        {
            query = base.ApplyFilter(query, search);
            
            query = query
                .Include(x => x.User)
                .Include(x => x.Movie);

            if (search.UserId.HasValue)
            {
                query = query.Where(x => x.UserId == search.UserId.Value);
            }

            if (search.MovieId.HasValue)
            {
                query = query.Where(x => x.MovieId == search.MovieId.Value);
            }

            if (search.MinRating.HasValue)
            {
                query = query.Where(x => x.Rating >= search.MinRating.Value);
            }

            if (search.MaxRating.HasValue)
            {
                query = query.Where(x => x.Rating <= search.MaxRating.Value);
            }

            if (search.FromDate.HasValue)
            {
                query = query.Where(x => x.CreatedAt >= search.FromDate.Value);
            }

            if (search.ToDate.HasValue)
            {
                query = query.Where(x => x.CreatedAt <= search.ToDate.Value);
            }

            if (search.HasComment.HasValue)
            {
                if (search.HasComment.Value)
                {
                    query = query.Where(x => !string.IsNullOrWhiteSpace(x.Comment));
                }
                else
                {
                    query = query.Where(x => string.IsNullOrWhiteSpace(x.Comment));
                }
            }

            return query;
        }

        protected override async Task BeforeInsert(Review entity, ReviewUpsertRequest insert)
        {
            var movie = await _context.Movies.FirstOrDefaultAsync(x => x.Id == entity.MovieId && x.IsActive);
            if (movie == null)
            {
                throw new InvalidOperationException("The selected movie does not exist or is not active.");
            }

            var existingReview = await _context.Reviews
                .FirstOrDefaultAsync(x => x.UserId == entity.UserId && x.MovieId == entity.MovieId && x.IsActive);

            if (existingReview != null)
            {
                throw new InvalidOperationException("User has already reviewed this movie.");
            }
        }

        protected override async Task BeforeUpdate(Review entity, ReviewUpsertRequest update)
        {
            var movie = await _context.Movies.FirstOrDefaultAsync(x => x.Id == entity.MovieId && x.IsActive);
            if (movie == null)
            {
                throw new InvalidOperationException("The selected movie does not exist or is not active.");
            }

            var existingReview = await _context.Reviews
                .FirstOrDefaultAsync(x => x.UserId == entity.UserId && 
                                        x.MovieId == entity.MovieId && 
                                        x.Id != entity.Id && 
                                        x.IsActive);

            if (existingReview != null)
            {
                throw new InvalidOperationException("User has already reviewed this movie.");
            }
        }

        protected override ReviewResponse MapToResponse(Review entity)
        {
            var response = _mapper.Map<ReviewResponse>(entity);
            
            response.UserName = entity.User?.Username ?? string.Empty;
            response.UserEmail = entity.User?.Email ?? string.Empty;
            response.MovieTitle = entity.Movie?.Title ?? string.Empty;
            
            return response;
        }
    }
} 