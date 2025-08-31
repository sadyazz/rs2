using eCinema.Services.Database;
using MapsterMapper;

namespace eCinema.Services.ReservationStateMachine
{
    public class CancelledReservationState : BaseReservationState
    {
        public CancelledReservationState(IServiceProvider serviceProvider, IMapper mapper, eCinemaDBContext context) 
            : base(serviceProvider, mapper, context)
        {
        }
    }
}
