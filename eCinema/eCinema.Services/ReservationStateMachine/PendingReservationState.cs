using eCinema.Model;
using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

namespace eCinema.Services.ReservationStateMachine
{
    public class PendingReservationState : BaseReservationState
    {
        private const int LATE_ARRIVAL_MINUTES = 15;
        public PendingReservationState(IServiceProvider serviceProvider, IMapper mapper, eCinemaDBContext context) : base(serviceProvider, mapper, context)
        {
        }

        public override async Task<ReservationResponse?> ApproveAsync(int id)
        {
            var entity = await _context.Reservations
                .Include(r => r.Screening)
                .Include(r => r.ReservationSeats)
                .FirstOrDefaultAsync(r => r.Id == id);
                
            if (entity == null)
                throw new UserException("Reservation not found");

            var reservedSeats = await _context.ScreeningSeats
                .Where(ss => ss.ScreeningId == entity.ScreeningId && ss.IsReserved == true)
                .Select(ss => ss.SeatId)
                .ToListAsync();

            var requestedSeats = entity.ReservationSeats.Select(rs => rs.SeatId);
            if (reservedSeats.Intersect(requestedSeats).Any())
                throw new UserException("Some seats are no longer available");

            entity.State = nameof(ApprovedReservationState);

            await _context.SaveChangesAsync();
            return _mapper.Map<ReservationResponse>(entity);
        }

        public override async Task<ReservationResponse?> RejectAsync(int id)
        {
            var entity = await _context.Reservations.FindAsync(id);
            if (entity == null)
                return null;

            entity.State = nameof(RejectedReservationState);

            await _context.SaveChangesAsync();
            return _mapper.Map<ReservationResponse>(entity);
        }

        public override async Task<ReservationResponse?> ExpireAsync(int id)
        {
            var entity = await _context.Reservations
                .Include(r => r.Screening)
                .FirstOrDefaultAsync(r => r.Id == id);
                
            if (entity == null)
                throw new UserException("Reservation not found");

            var expirationTime = entity.Screening.StartTime.AddMinutes(LATE_ARRIVAL_MINUTES);
            if (DateTime.UtcNow < expirationTime)
                throw new UserException($"Cannot expire reservation until {LATE_ARRIVAL_MINUTES} minutes after screening start");

            entity.State = nameof(ExpiredReservationState);

            await _context.SaveChangesAsync();
            return _mapper.Map<ReservationResponse>(entity);
        }

        public override async Task<ReservationResponse?> CancelAsync(int id)
        {
            var entity = await _context.Reservations
                .Include(r => r.Screening)
                .Include(r => r.ReservationSeats)
                .FirstOrDefaultAsync(r => r.Id == id);
                
            if (entity == null)
                throw new UserException("Reservation not found");

            var cancellationDeadline = entity.Screening.StartTime.AddHours(-24);
            if (DateTime.UtcNow > cancellationDeadline)
                throw new UserException("Cancellation deadline has passed");

            entity.State = nameof(CancelledReservationState);

            var reservedSeatIds = entity.ReservationSeats.Select(rs => rs.SeatId).ToList();
            var screeningSeats = await _context.ScreeningSeats
                .Where(ss => ss.ScreeningId == entity.ScreeningId && reservedSeatIds.Contains(ss.SeatId))
                .ToListAsync();

            foreach (var seat in screeningSeats)
            {
                seat.IsReserved = false;
            }

            await _context.SaveChangesAsync();
            return _mapper.Map<ReservationResponse>(entity);
        }
    }
}