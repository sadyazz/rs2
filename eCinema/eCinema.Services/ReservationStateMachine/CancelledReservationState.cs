using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Services.Database;
using MapsterMapper;
using Microsoft.Extensions.DependencyInjection;

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
