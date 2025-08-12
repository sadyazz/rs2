using eCinema.Model;
using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;
using eCinema.Services.Database;
using eCinema.Services.Database.Entities;
using eCinema.Services.Auth;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MapsterMapper;

namespace eCinema.Services
{
    public interface IUserMovieListService
    {
        Task<List<UserMovieListResponse>> GetAsync(UserMovieListSearchObject search);
        Task<UserMovieListResponse?> GetByIdAsync(int id);
        Task<List<UserMovieListResponse>> GetUserListsAsync(int userId, string listType);
        Task<bool> IsMovieInUserListAsync(int userId, int movieId, string listType);
        Task AddMovieToListAsync(int userId, int movieId, string listType);
        Task RemoveMovieFromListAsync(int userId, int movieId, string listType);
    }

    public class UserMovieListService : IUserMovieListService
    {
        private readonly eCinemaDBContext _context;
        private readonly IMapper _mapper;
        private readonly ICurrentUserService _currentUserService;

        public UserMovieListService(eCinemaDBContext context, IMapper mapper, ICurrentUserService currentUserService)
        {
            _context = context;
            _mapper = mapper;
            _currentUserService = currentUserService;
        }

        public async Task<List<UserMovieListResponse>> GetAsync(UserMovieListSearchObject search)
        {
            var query = _context.UserMovieLists.AsQueryable();
            query = ApplyFilter(query, search);
            
            var userMovieLists = await query
                .Include(uml => uml.Movie)
                .Include(uml => uml.User)
                .ToListAsync();
                
            return userMovieLists.Select(MapToResponse).ToList();
        }

        public async Task<UserMovieListResponse?> GetByIdAsync(int id)
        {
            var userMovieList = await _context.UserMovieLists
                .Include(uml => uml.Movie)
                .Include(uml => uml.User)
                .FirstOrDefaultAsync(uml => uml.Id == id);
                
            return userMovieList != null ? MapToResponse(userMovieList) : null;
        }

        public async Task<List<UserMovieListResponse>> GetUserListsAsync(int userId, string listType)
        {
            var currentUserId = await _currentUserService.GetUserIdAsync();
            if (currentUserId != userId)
            {
                throw new UnauthorizedAccessException("You can only view your own movie lists.");
            }

            var userMovieLists = await _context.UserMovieLists
                .Include(uml => uml.Movie)
                .Where(uml => uml.UserId == userId && 
                              uml.ListType.ToLower() == listType.ToLower() && 
                              !uml.IsDeleted)
                .ToListAsync();
                
            return userMovieLists.Select(MapToResponse).ToList();
        }

        public async Task<bool> IsMovieInUserListAsync(int userId, int movieId, string listType)
        {
            var currentUserId = await _currentUserService.GetUserIdAsync();
            if (currentUserId != userId)
            {
                throw new UnauthorizedAccessException("You can only check your own movie lists.");
            }

            return await _context.UserMovieLists
                .AnyAsync(uml => uml.UserId == userId && 
                                 uml.MovieId == movieId && 
                                 uml.ListType.ToLower() == listType.ToLower() && 
                                 !uml.IsDeleted);
        }

        public async Task AddMovieToListAsync(int userId, int movieId, string listType)
        {
            var currentUserId = await _currentUserService.GetUserIdAsync();
            if (currentUserId != userId)
            {
                throw new UnauthorizedAccessException("You can only add movies to your own lists.");
            }

            var existingEntry = await _context.UserMovieLists
                .FirstOrDefaultAsync(uml => uml.UserId == userId && 
                                           uml.MovieId == movieId && 
                                           uml.ListType.ToLower() == listType.ToLower());

            if (existingEntry != null)
            {
                if (existingEntry.IsDeleted)
                {
                    existingEntry.IsDeleted = false;
                    existingEntry.CreatedAt = DateTime.UtcNow;
                    await _context.SaveChangesAsync();
                }
            }
            else
            {
                var userMovieList = new UserMovieList
                {
                    UserId = userId,
                    MovieId = movieId,
                    ListType = listType,
                    CreatedAt = DateTime.UtcNow,
                    IsDeleted = false
                };

                _context.UserMovieLists.Add(userMovieList);
                await _context.SaveChangesAsync();
            }
        }

        public async Task RemoveMovieFromListAsync(int userId, int movieId, string listType)
        {
            var currentUserId = await _currentUserService.GetUserIdAsync();
            if (currentUserId != userId)
            {
                throw new UnauthorizedAccessException("You can only remove movies from your own lists.");
            }

            var userMovieList = await _context.UserMovieLists
                .FirstOrDefaultAsync(uml => uml.UserId == userId && 
                                           uml.MovieId == movieId && 
                                           uml.ListType.ToLower() == listType.ToLower() && 
                                           !uml.IsDeleted);

            if (userMovieList != null)
            {
                userMovieList.IsDeleted = true;
                await _context.SaveChangesAsync();
            }
        }

        private IQueryable<UserMovieList> ApplyFilter(IQueryable<UserMovieList> query, UserMovieListSearchObject search)
        {
            if (search.UserId.HasValue)
                query = query.Where(uml => uml.UserId == search.UserId.Value);

            if (search.MovieId.HasValue)
                query = query.Where(uml => uml.MovieId == search.MovieId.Value);

            if (!string.IsNullOrEmpty(search.ListType))
                query = query.Where(uml => uml.ListType.ToLower() == search.ListType.ToLower());

            query = query.Where(uml => !uml.IsDeleted);

            return query;
        }

        private UserMovieListResponse MapToResponse(UserMovieList userMovieList)
        {
            return new UserMovieListResponse
            {
                Id = userMovieList.Id,
                UserId = userMovieList.UserId,
                MovieId = userMovieList.MovieId,
                ListType = userMovieList.ListType,
                CreatedAt = userMovieList.CreatedAt,
                IsDeleted = userMovieList.IsDeleted,
                Movie = _mapper.Map<MovieResponse>(userMovieList.Movie)
            };
        }
    }
} 