using eCinema.Model.Responses;
using eCinema.Model.Requests;
using eCinema.Model.SearchObjects;

namespace eCinema.Services
{
    public interface ISeatService : ICRUDService<SeatResponse, BaseSearchObject, SeatUpsertRequest, SeatUpsertRequest>
    {
        Task<List<SeatResponse>> GetSeatsForScreening(int screeningId);
        Task<int> GetSeatsCount();
        Task<int> GenerateAllSeats();
        Task<int> ClearAllSeats();
    }
}