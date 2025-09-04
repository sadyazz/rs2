using eCinema.Services.Database;
using eCinema.Services.Database.Entities;
using Stripe;

namespace eCinema.Services
{
    public class PaymentService : IPaymentService
    {
        private readonly eCinemaDBContext _context;

        public PaymentService(string stripeSecretKey, eCinemaDBContext context)
        {
            if (string.IsNullOrEmpty(stripeSecretKey))
            {
                throw new ArgumentException("Stripe secret key is required", nameof(stripeSecretKey));
            }
            StripeConfiguration.ApiKey = stripeSecretKey;
            _context = context;
        }

        public StripePayment ProcessStripePayment(string paymentIntentId, decimal amount)
        {
            try
            {
                var service = new PaymentIntentService();
                var paymentIntent = service.Get(paymentIntentId);
                
                switch (paymentIntent.Status)
                {
                    case "succeeded":
                        break;
                    case "requires_payment_method":
                        throw new InvalidOperationException("Payment method required");
                    case "requires_confirmation":
                        throw new InvalidOperationException("Payment needs confirmation");
                    case "requires_action":
                        throw new InvalidOperationException("Additional action required (e.g. 3D Secure)");
                    case "processing":
                        throw new InvalidOperationException("Payment is still processing");
                    case "canceled":
                        throw new InvalidOperationException("Payment was canceled");
                    default:
                        throw new InvalidOperationException($"Unexpected payment status: {paymentIntent.Status}");
                }

                var payment = new StripePayment
                {
                    PaymentProvider = "Stripe",
                    TransactionId = paymentIntent.Id,
                    Amount = amount,
                    PaymentDate = DateTime.Now
                };

                _context.StripePayments.Add(payment);

                return payment;
            }
            catch (StripeException e)
            {
                throw new InvalidOperationException($"Stripe error: {e.StripeError?.Message ?? e.Message}");
            }
            catch (Exception e)
            {
                throw new InvalidOperationException($"Error processing payment: {e.Message}");
            }
        }

        public async Task<PaymentIntent> CreatePaymentIntentAsync(int amount)
        {
            try
            {
                var options = new PaymentIntentCreateOptions
                {
                    Amount = amount,
                    Currency = "usd",
                    PaymentMethodTypes = new List<string> { "card" },
                    CaptureMethod = "automatic",
                };

                var service = new PaymentIntentService();
                var intent = await service.CreateAsync(options);

                if (intent == null)
                {
                    throw new InvalidOperationException("Failed to create payment intent");
                }

                return intent;
            }
            catch (StripeException e)
            {
                Console.WriteLine($"Stripe error creating payment intent: {e.StripeError?.Message}");
                throw new InvalidOperationException($"Stripe error: {e.StripeError?.Message ?? e.Message}");
            }
            catch (Exception e)
            {
                Console.WriteLine($"Error creating payment intent: {e.Message}");
                throw new InvalidOperationException($"Error creating payment intent: {e.Message}");
            }
        }
    }
}