using eCinema.Model;
using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;
using eCinema.Services.Database;
using eCinema.Services.Database.Entities;
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
        
        public ReviewService(eCinemaDBContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
        }

        public override async Task<ReviewResponse> CreateAsync(ReviewUpsertRequest request)
        {
            var result = await base.CreateAsync(request);
            
            await RecalculateMovieGrade(request.MovieId);
            
            return result;
        }

        public override async Task<ReviewResponse> UpdateAsync(int id, ReviewUpsertRequest request)
        {
            var result = await base.UpdateAsync(id, request);
            
            await RecalculateMovieGrade(request.MovieId);
            
            return result;
        }

        public override async Task<bool> DeleteAsync(int id)
        {
            var entity = await _context.Set<Review>().FindAsync(id);
            var movieId = entity?.MovieId ?? 0;
            
            var result = await base.DeleteAsync(id);
            
            if (result && movieId > 0)
            {
                await RecalculateMovieGrade(movieId);
            }
            
            return result;
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
            var user = await _context.Users.FirstOrDefaultAsync(x => x.Id == insert.UserId && x.IsActive);
            if (user == null)
            {
                throw new InvalidOperationException("The selected user does not exist or is not active.");
            }

            var movie = await _context.Movies.FirstOrDefaultAsync(x => x.Id == insert.MovieId && x.IsActive);
            if (movie == null)
            {
                throw new InvalidOperationException("The selected movie does not exist or is not active.");
            }

            // Check if user already reviewed this movie
            var existingReview = await _context.Reviews
                .FirstOrDefaultAsync(x => x.UserId == insert.UserId && x.MovieId == insert.MovieId && x.IsActive);

            if (existingReview != null)
            {
                throw new InvalidOperationException("User has already reviewed this movie.");
            }
        }

        protected override async Task BeforeUpdate(Review entity, ReviewUpsertRequest update)
        {
            var user = await _context.Users.FirstOrDefaultAsync(x => x.Id == update.UserId && x.IsActive);
            if (user == null)
            {
                throw new InvalidOperationException("The selected user does not exist or is not active.");
            }

            var movie = await _context.Movies.FirstOrDefaultAsync(x => x.Id == update.MovieId && x.IsActive);
            if (movie == null)
            {
                throw new InvalidOperationException("The selected movie does not exist or is not active.");
            }

            // Check if another user already reviewed this movie (for the same movie)
            var existingReview = await _context.Reviews
                .FirstOrDefaultAsync(x => x.UserId == update.UserId && 
                                        x.MovieId == update.MovieId && 
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