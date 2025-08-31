using eCinema.Model;
using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Services.ReservationStateMachine
{
    public class InitialReservationState : BaseReservationState
    {
        public InitialReservationState(IServiceProvider serviceProvider, IMapper mapper, eCinemaDBContext context) : base(serviceProvider, mapper, context)
        {
        }

        public override async Task<ReservationResponse> CreateAsync(ReservationUpsertRequest reservationUpsertRequest){
            var screening = await _context.Screenings
                .FirstOrDefaultAsync(s => s.Id == reservationUpsertRequest.ScreeningId);
            if (screening == null || screening.IsDeleted)
                throw new UserException("Screening not found");

            if (screening.StartTime <= DateTime.UtcNow)
                throw new UserException("Cannot make reservation for past screenings");

            var existingReservation = await _context.Reservations
                .AnyAsync(r => r.UserId == reservationUpsertRequest.UserId 
                    && r.ScreeningId == reservationUpsertRequest.ScreeningId
                    && !r.IsDeleted
                    && r.State != nameof(CancelledReservationState)
                    && r.State != nameof(RejectedReservationState));
            if (existingReservation)
                throw new UserException("You already have a reservation for this screening");

            var entity = new Database.Entities.Reservation();
            _mapper.Map(reservationUpsertRequest, entity);

            entity.State = nameof(PendingReservationState);

            _context.Reservations.Add(entity);
            await _context.SaveChangesAsync();

            return _mapper.Map<ReservationResponse>(entity);
        }   
    }
}