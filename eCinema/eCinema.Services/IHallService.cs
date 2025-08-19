using eCinema.Model;
using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;

namespace eCinema.Services;

public interface IHallService : ICRUDService<HallResponse, HallSearchObject, HallUpsertRequest, HallUpsertRequest>
{
    Task GenerateSeatsForHall(int hallId, int capacity);
} 