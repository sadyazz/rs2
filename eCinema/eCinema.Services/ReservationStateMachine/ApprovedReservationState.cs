using eCinema.Model;
using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

namespace eCinema.Services.ReservationStateMachine
{
    public class ApprovedReservationState : BaseReservationState
    {
        private const int LATE_ARRIVAL_MINUTES = 15;
        public ApprovedReservationState(IServiceProvider serviceProvider, IMapper mapper, eCinemaDBContext context) : base(serviceProvider, mapper, context)
        {
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

        public override async Task<ReservationResponse?> MarkAsUsedAsync(int id)
        {
            var entity = await _context.Reservations.FindAsync(id);
            if (entity == null)
                return null;

            entity.State = nameof(UsedReservationState);

            await _context.SaveChangesAsync();
            return _mapper.Map<ReservationResponse>(entity);
        }

        public override async Task<ReservationResponse?> CancelAsync(int id)
        {
            var entity = await _context.Reservations.FindAsync(id);
            if (entity == null)
                return null;

            entity.State = nameof(CancelledReservationState);

            await _context.SaveChangesAsync();
            return _mapper.Map<ReservationResponse>(entity);
        }
    }
}