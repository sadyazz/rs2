using eCinema.Services.Database;
using MapsterMapper;

namespace eCinema.Services.ReservationStateMachine
{
    public class RejectedReservationState : BaseReservationState
    {
        public RejectedReservationState(IServiceProvider serviceProvider, IMapper mapper, eCinemaDBContext context) : base(serviceProvider, mapper, context)
        {
        }
  
    }
}