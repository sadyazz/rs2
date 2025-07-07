using eCinema.Model;
using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;
using eCinema.Services.Database;
using eCinema.Services.Database.Entities;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MapsterMapper;

namespace eCinema.Services
{
    public class ScreeningService : BaseCRUDService<ScreeningResponse, ScreeningSearchObject, Screening, ScreeningUpsertRequest, ScreeningUpsertRequest>, IScreeningService
    {
        private readonly eCinemaDBContext _context;
        public ScreeningService(eCinemaDBContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
        }

        protected override IQueryable<Screening> ApplyFilter(IQueryable<Screening> query, ScreeningSearchObject search)
        {
            query = base.ApplyFilter(query, search);
            
            query = query
                .Include(x => x.Movie)
                .Include(x => x.Hall)
                .Include(x => x.Format);

            if (!string.IsNullOrWhiteSpace(search.FTS))
            {
                query = query.Where(x => 
                    x.Movie.Title.Contains(search.FTS) ||
                    x.Hall.Name.Contains(search.FTS) ||
                    x.Language.Contains(search.FTS) ||
                    (x.Format != null && x.Format.Name.Contains(search.FTS)));
            }

            if (search.MovieId.HasValue)
            {
                query = query.Where(x => x.MovieId == search.MovieId.Value);
            }

            if (search.HallId.HasValue)
            {
                query = query.Where(x => x.HallId == search.HallId.Value);
            }

            if (search.ScreeningFormatId.HasValue)
            {
                query = query.Where(x => x.ScreeningFormatId == search.ScreeningFormatId.Value);
            }

            if (!string.IsNullOrWhiteSpace(search.Language))
            {
                query = query.Where(x => x.Language == search.Language);
            }

            if (search.HasSubtitles.HasValue)
            {
                query = query.Where(x => x.HasSubtitles == search.HasSubtitles.Value);
            }

            if (search.FromStartTime.HasValue)
            {
                query = query.Where(x => x.StartTime >= search.FromStartTime.Value);
            }

            if (search.ToStartTime.HasValue)
            {
                query = query.Where(x => x.StartTime <= search.ToStartTime.Value);
            }

            if (search.MinBasePrice.HasValue)
            {
                query = query.Where(x => x.BasePrice >= search.MinBasePrice.Value);
            }

            if (search.MaxBasePrice.HasValue)
            {
                query = query.Where(x => x.BasePrice <= search.MaxBasePrice.Value);
            }

            if (search.HasAvailableSeats.HasValue)
            {
                if (search.HasAvailableSeats.Value)
                {
                    query = query.Where(x => x.Hall.Capacity > x.Reservations.Count);
                }
                else
                {
                    query = query.Where(x => x.Hall.Capacity <= x.Reservations.Count);
                }
            }

            return query;
        }

        protected override async Task BeforeInsert(Screening entity, ScreeningUpsertRequest insert)
        {
            var movie = await _context.Movies.FirstOrDefaultAsync(x => x.Id == insert.MovieId && x.IsActive);
            if (movie == null)
            {
                throw new InvalidOperationException("The selected movie does not exist or is not active.");
            }

            var hall = await _context.Halls.FirstOrDefaultAsync(x => x.Id == insert.HallId && x.IsActive);
            if (hall == null)
            {
                throw new InvalidOperationException("The selected hall does not exist or is not active.");
            }

            if (insert.ScreeningFormatId.HasValue)
            {
                var format = await _context.ScreeningFormats.FirstOrDefaultAsync(x => x.Id == insert.ScreeningFormatId.Value && x.IsActive);
                if (format == null)
                {
                    throw new InvalidOperationException("The selected screening format does not exist or is not active.");
                }
            }

            var overlappingScreening = await _context.Screenings
                .FirstOrDefaultAsync(x => x.HallId == insert.HallId &&
                                   x.IsActive &&
                                   ((x.StartTime <= insert.StartTime && x.EndTime > insert.StartTime) ||
                                    (x.StartTime < insert.EndTime && x.EndTime >= insert.EndTime) ||
                                    (x.StartTime >= insert.StartTime && x.EndTime <= insert.EndTime)));

            if (overlappingScreening != null)
            {
                throw new InvalidOperationException("There is already a screening scheduled in this hall during the specified time period.");
            }

            if (insert.EndTime <= insert.StartTime)
            {
                throw new InvalidOperationException("End time must be after start time.");
            }
        }

        protected override async Task BeforeUpdate(Screening entity, ScreeningUpsertRequest update)
        {
            var movie = await _context.Movies.FirstOrDefaultAsync(x => x.Id == update.MovieId && x.IsActive);
            if (movie == null)
            {
                throw new InvalidOperationException("The selected movie does not exist or is not active.");
            }

            var hall = await _context.Halls.FirstOrDefaultAsync(x => x.Id == update.HallId && x.IsActive);
            if (hall == null)
            {
                throw new InvalidOperationException("The selected hall does not exist or is not active.");
            }

            if (update.ScreeningFormatId.HasValue)
            {
                var format = await _context.ScreeningFormats.FirstOrDefaultAsync(x => x.Id == update.ScreeningFormatId.Value && x.IsActive);
                if (format == null)
                {
                    throw new InvalidOperationException("The selected screening format does not exist or is not active.");
                }
            }

            var overlappingScreening = await _context.Screenings
                .FirstOrDefaultAsync(x => x.HallId == update.HallId &&
                                   x.Id != entity.Id &&
                                   x.IsActive &&
                                   ((x.StartTime <= update.StartTime && x.EndTime > update.StartTime) ||
                                    (x.StartTime < update.EndTime && x.EndTime >= update.EndTime) ||
                                    (x.StartTime >= update.StartTime && x.EndTime <= update.EndTime)));

            if (overlappingScreening != null)
            {
                throw new InvalidOperationException("There is already a screening scheduled in this hall during the specified time period.");
            }

            if (update.EndTime <= update.StartTime)
            {
                throw new InvalidOperationException("End time must be after start time.");
            }
        }

        protected override ScreeningResponse MapToResponse(Screening entity)
        {
            var response = _mapper.Map<ScreeningResponse>(entity);
            
            response.MovieId = entity.MovieId;
            response.HallId = entity.HallId;
            response.ScreeningFormatId = entity.ScreeningFormatId;
            response.MovieTitle = entity.Movie?.Title ?? string.Empty;
            response.MovieImage = entity.Movie?.Image;
            response.HallName = entity.Hall?.Name ?? string.Empty;
            response.ScreeningFormatName = entity.Format?.Name;
            response.ScreeningFormatPriceMultiplier = entity.Format?.PriceMultiplier;
            
            response.AvailableSeats = entity.Hall?.Capacity - entity.Reservations?.Count ?? 0;
            response.ReservationsCount = entity.Reservations?.Count ?? 0;
            
            return response;
        }

        public override async Task<ScreeningResponse?> GetByIdAsync(int id)
        {
            var entity = await _context.Screenings
                .Include(x => x.Movie)
                .Include(x => x.Hall)
                .Include(x => x.Format)
                .FirstOrDefaultAsync(x => x.Id == id);

            if (entity == null)
                return null;

            var isDeletedProperty = typeof(Screening).GetProperty("IsDeleted");
            if (isDeletedProperty != null && isDeletedProperty.PropertyType == typeof(bool))
            {
                var isDeleted = (bool)isDeletedProperty.GetValue(entity);
                if (isDeleted)
                    return null;
            }

            return MapToResponse(entity);
        }
    }
} 