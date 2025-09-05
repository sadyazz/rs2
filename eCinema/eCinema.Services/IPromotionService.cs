using eCinema.Model;
using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;

namespace eCinema.Services;

public interface IPromotionService : ICRUDService<PromotionResponse, PromotionSearchObject, PromotionUpsertRequest, PromotionUpsertRequest>
{
    Task<PromotionResponse?> ValidatePromotionCode(string code, int userId);
} 