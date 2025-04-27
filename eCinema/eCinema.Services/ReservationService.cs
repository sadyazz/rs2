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
using eCinema.Services.ReservationStateMachine;

namespace eCinema.Services
{
    public class ReservationService : BaseCRUDService<ReservationResponse, ReservationSearchObject, Reservation, ReservationUpsertRequest, ReservationUpsertRequest>, IReservationService
    {
        protected readonly BaseReservationState _baseReservationState;
        public ReservationService(eCinemaDBContext context, IMapper mapper, BaseReservationState baseReservationState) : base(context, mapper)
        {
            _baseReservationState = baseReservationState;
        }

        protected override IQueryable<Reservation> ApplyFilter(IQueryable<Reservation> query, ReservationSearchObject search)
        {
            if (search.UserId.HasValue)
            {
                query = query.Where(x => x.UserId == search.UserId.Value);
            }

            if (search.ScreeningId.HasValue)
            {
                query = query.Where(x => x.ScreeningId == search.ScreeningId.Value);
            }

            if (search.SeatId.HasValue)
            {
                query = query.Where(x => x.SeatId == search.SeatId.Value);
            }

            if (search.PromotionId.HasValue)
            {
                query = query.Where(x => x.PromotionId == search.PromotionId.Value);
            }

            if (!string.IsNullOrWhiteSpace(search.Status))
            {
                query = query.Where(x => x.Status == search.Status);
            }

            if (search.FromReservationTime.HasValue)
            {
                query = query.Where(x => x.ReservationTime >= search.FromReservationTime.Value);
            }

            if (search.ToReservationTime.HasValue)
            {
                query = query.Where(x => x.ReservationTime <= search.ToReservationTime.Value);
            }

            if (search.MinTotalPrice.HasValue)
            {
                query = query.Where(x => x.TotalPrice >= search.MinTotalPrice.Value);
            }

            if (search.MaxTotalPrice.HasValue)
            {
                query = query.Where(x => x.TotalPrice <= search.MaxTotalPrice.Value);
            }

            if (search.HasPayment.HasValue)
            {
                if (search.HasPayment.Value)
                {
                    query = query.Where(x => x.Payment != null);
                }
                else
                {
                    query = query.Where(x => x.Payment == null);
                }
            }

            return query;
        }

        // protected override async Task BeforeInsert(Reservation entity, ReservationUpsertRequest insert)
        // {
        //     var existingReservation = await _context.Reservations
        //         .FirstOrDefaultAsync(x => x.ScreeningId == insert.ScreeningId && 
        //                            x.SeatId == insert.SeatId && 
        //                            x.IsActive);

        //     if (existingReservation != null)
        //     {
        //         throw new InvalidOperationException("This seat is already reserved for the selected screening.");
        //     }

        //     var screening = await _context.Screenings
        //         .Include(x => x.Movie)
        //         .FirstOrDefaultAsync(x => x.Id == insert.ScreeningId && x.IsActive);

        //     if (screening == null)
        //     {
        //         throw new InvalidOperationException("The selected screening does not exist or is not active.");
        //     }

        //     var seat = await _context.Seats
        //         .Include(x => x.SeatType)
        //         .FirstOrDefaultAsync(x => x.Id == insert.SeatId && x.IsActive);

        //     if (seat == null)
        //     {
        //         throw new InvalidOperationException("The selected seat does not exist or is not active.");
        //     }

        //     var user = await _context.Users.FirstOrDefaultAsync(x => x.Id == insert.UserId && x.IsActive);
        //     if (user == null)
        //     {
        //         throw new InvalidOperationException("The selected user does not exist or is not active.");
        //     }

        //     if (insert.PromotionId.HasValue)
        //     {
        //         var promotion = await _context.Promotions.FirstOrDefaultAsync(x => x.Id == insert.PromotionId.Value && x.IsActive);
        //         if (promotion == null)
        //         {
        //             throw new InvalidOperationException("The selected promotion does not exist or is not active.");
        //         }

        //         if (promotion.StartDate > DateTime.UtcNow || promotion.EndDate < DateTime.UtcNow)
        //         {
        //             throw new InvalidOperationException("The selected promotion is not valid at this time.");
        //         }
        //     }
        // }

        // protected override async Task BeforeUpdate(Reservation entity, ReservationUpsertRequest update)
        // {
        //     var existingReservation = await _context.Reservations
        //         .FirstOrDefaultAsync(x => x.ScreeningId == update.ScreeningId && 
        //                            x.SeatId == update.SeatId && 
        //                            x.Id != entity.Id && 
        //                            x.IsActive);

        //     if (existingReservation != null)
        //     {
        //         throw new InvalidOperationException("This seat is already reserved for the selected screening.");
        //     }

        //     var screening = await _context.Screenings
        //         .Include(x => x.Movie)
        //         .FirstOrDefaultAsync(x => x.Id == update.ScreeningId && x.IsActive);

        //     if (screening == null)
        //     {
        //         throw new InvalidOperationException("The selected screening does not exist or is not active.");
        //     }

        //     var seat = await _context.Seats
        //         .Include(x => x.SeatType)
        //         .FirstOrDefaultAsync(x => x.Id == update.SeatId && x.IsActive);

        //     if (seat == null)
        //     {
        //         throw new InvalidOperationException("The selected seat does not exist or is not active.");
        //     }

        //     var user = await _context.Users.FirstOrDefaultAsync(x => x.Id == update.UserId && x.IsActive);
        //     if (user == null)
        //     {
        //         throw new InvalidOperationException("The selected user does not exist or is not active.");
        //     }

        //     if (update.PromotionId.HasValue)
        //     {
        //         var promotion = await _context.Promotions.FirstOrDefaultAsync(x => x.Id == update.PromotionId.Value && x.IsActive);
        //         if (promotion == null)
        //         {
        //             throw new InvalidOperationException("The selected promotion does not exist or is not active.");
        //         }

        //         if (promotion.StartDate > DateTime.UtcNow || promotion.EndDate < DateTime.UtcNow)
        //         {
        //             throw new InvalidOperationException("The selected promotion is not valid at this time.");
        //         }
        //     }
        // }

        public override async Task<ReservationResponse> CreateAsync(ReservationUpsertRequest request)
        {
            var reservationState = _baseReservationState.GetReservationState("InitialReservationState");
            var result = await reservationState.CreateAsync(request);
            return result;
        }

        public override async Task<ReservationResponse?> UpdateAsync(int id, ReservationUpsertRequest request)
        {
            var entity = await _context.Reservations.FindAsync(id);
            var baseState = _baseReservationState.GetReservationState(entity.State);
            return await baseState.UpdateAsync(id, request);
        }

        public async Task<ReservationResponse?> ApproveAsync(int id)
        {
            var entity = await _context.Reservations.FindAsync(id);
            var baseState = _baseReservationState.GetReservationState(entity.State);
            return await baseState.ApproveAsync(id);
        }

        public async Task<ReservationResponse?> RejectAsync(int id)
        {
            var entity = await _context.Reservations.FindAsync(id);
            var baseState = _baseReservationState.GetReservationState(entity.State);
            return await baseState.RejectAsync(id);
        }

        public async Task<ReservationResponse?> ExpireAsync(int id)
        {
            var entity = await _context.Reservations.FindAsync(id);
            var baseState = _baseReservationState.GetReservationState(entity.State);
            return await baseState.ExpireAsync(id);
        }
    } 
} 