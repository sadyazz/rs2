using eCinema.Model;
using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;

namespace eCinema.Services;

public interface IReviewService : ICRUDService<ReviewResponse, ReviewSearchObject, ReviewUpsertRequest, ReviewUpsertRequest>
{
} 