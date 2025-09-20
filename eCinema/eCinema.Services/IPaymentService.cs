using eCinema.Services.Database.Entities;
using Stripe;
using System.Threading.Tasks;

namespace eCinema.Services
{
    public interface IPaymentService
    {
        Task<PaymentIntent> CreatePaymentIntentAsync(int amount);
        Task<StripePayment> ProcessStripePayment(string paymentIntentId, decimal amount);
    }
}