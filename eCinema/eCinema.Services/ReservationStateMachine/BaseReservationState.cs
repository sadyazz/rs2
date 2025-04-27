using eCinema.Model;
using eCinema.Model.Requests;
using eCinema.Model.Responses;
using Microsoft.Extensions.DependencyInjection;
using MapsterMapper;
using eCinema.Services.Database;
namespace eCinema.Services.ReservationStateMachine
{
    public class BaseReservationState
    {
        protected readonly IServiceProvider _serviceProvider;
        protected readonly IMapper _mapper;
        protected readonly eCinemaDBContext _context;
        public BaseReservationState(IServiceProvider serviceProvider, IMapper mapper, eCinemaDBContext context){
            _serviceProvider = serviceProvider; 
            _mapper = mapper;
            _context = context;
        }
        public virtual async Task<ReservationResponse> CreateAsync(ReservationUpsertRequest reservationUpsertRequest){
            throw new UserException("Action not allowed");
        }

        public virtual async Task<ReservationResponse?> UpdateAsync(int id, ReservationUpsertRequest reservationUpsertRequest){
            throw new UserException("Action not allowed");
        }
        public virtual async Task<ReservationResponse?> ApproveAsync(int id){
            throw new UserException("Action not allowed");
        }
        public virtual async Task<ReservationResponse?> RejectAsync(int id){
            throw new UserException("Action not allowed");
        }
        public virtual async Task<ReservationResponse?> ExpireAsync(int id){
            throw new UserException("Action not allowed");
        }   
        public BaseReservationState GetReservationState(string stateName){
           switch(stateName){
            case nameof(InitialReservationState):
                return _serviceProvider.GetService<InitialReservationState>();
            case nameof(PendingReservationState):
                return _serviceProvider.GetService<PendingReservationState>();
            case nameof(ApprovedReservationState):
                return _serviceProvider.GetService<ApprovedReservationState>();
            case nameof(RejectedReservationState):
                return _serviceProvider.GetService<RejectedReservationState>();
            case nameof(ExpiredReservationState):
                return _serviceProvider.GetService<ExpiredReservationState>();
            default:
                throw new Exception($"State {stateName} not defined");
           }
        }
    }
}