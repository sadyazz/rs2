using eCinema.Model;
using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Services.Database;
using MapsterMapper;
using Microsoft.Extensions.DependencyInjection;

namespace eCinema.Services.ReservationStateMachine
{
    public class InitialReservationState : BaseReservationState
    {
        public InitialReservationState(IServiceProvider serviceProvider, IMapper mapper, eCinemaDBContext context) : base(serviceProvider, mapper, context)
        {
        }

        public override async Task<ReservationResponse> CreateAsync(ReservationUpsertRequest reservationUpsertRequest){
            var entity = new Database.Entities.Reservation();
            _mapper.Map(reservationUpsertRequest, entity);

            entity.State = nameof(PendingReservationState);

            _context.Reservations.Add(entity);
            await _context.SaveChangesAsync();

            return _mapper.Map<ReservationResponse>(entity);
        }   
    }
}