using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;

namespace eCinema.Services
{
    public interface ISeatService : ICRUDService<SeatResponse, SeatSearchObject, SeatInsertRequest, SeatUpdateRequest>
    {
    }
} 