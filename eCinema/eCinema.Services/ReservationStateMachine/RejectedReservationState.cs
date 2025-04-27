using eCinema.Model;
using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Services.Database;
using MapsterMapper;
using Microsoft.Extensions.DependencyInjection;

namespace eCinema.Services.ReservationStateMachine
{
    public class RejectedReservationState : BaseReservationState
    {
        public RejectedReservationState(IServiceProvider serviceProvider, IMapper mapper, eCinemaDBContext context) : base(serviceProvider, mapper, context)
        {
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