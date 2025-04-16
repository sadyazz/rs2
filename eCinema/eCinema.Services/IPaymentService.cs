using eCinema.Model;
using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;

namespace eCinema.Services;

public interface IPaymentService : ICRUDService<PaymentResponse, PaymentSearchObject, PaymentUpsertRequest, PaymentUpsertRequest>
{
} 