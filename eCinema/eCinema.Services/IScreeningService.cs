using eCinema.Model;
using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;

namespace eCinema.Services;

public interface IScreeningService : ICRUDService<ScreeningResponse, ScreeningSearchObject, ScreeningUpsertRequest, ScreeningUpsertRequest>
{
    Task<List<SeatResponse>> GetSeatsForScreeningAsync(int screeningId);
    Task<int> GenerateSeatsForScreeningAsync(int screeningId);
} 