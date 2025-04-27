using eCinema.Model;
using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Services.Database;
using MapsterMapper;
using Microsoft.Extensions.DependencyInjection;

namespace eCinema.Services.ReservationStateMachine
{
    public class PendingReservationState : BaseReservationState
    {
        public PendingReservationState(IServiceProvider serviceProvider, IMapper mapper, eCinemaDBContext context) : base(serviceProvider, mapper, context)
        {
        }

        public override async Task<ReservationResponse?> ApproveAsync(int id)
        {
            var entity = await _context.Reservations.FindAsync(id);
            if (entity == null)
                return null;

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
            var entity = await _context.Reservations.FindAsync(id);
            if (entity == null)
                return null;    

            entity.State = nameof(ExpiredReservationState);

            await _context.SaveChangesAsync();
            return _mapper.Map<ReservationResponse>(entity);
        }
        
        
    }
}