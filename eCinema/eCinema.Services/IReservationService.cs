using eCinema.Model;
using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;

namespace eCinema.Services;

public interface IReservationService : ICRUDService<ReservationResponse, ReservationSearchObject, ReservationUpsertRequest, ReservationUpsertRequest>
{
    Task<ReservationResponse?> ApproveAsync(int id);
    Task<ReservationResponse?> RejectAsync(int id);
    Task<ReservationResponse?> ExpireAsync(int id);
} 