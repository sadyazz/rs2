using eCinema.Model.Requests;
using eCinema.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Stripe;

namespace eCinema.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class PaymentController : ControllerBase
    {
        private readonly PaymentService _paymentService;
        private readonly ILogger<PaymentController> _logger;

        public PaymentController(PaymentService paymentService, ILogger<PaymentController> logger)
        {
            _paymentService = paymentService;
            _logger = logger;
        }

        [HttpPost("create-payment-intent")]
        public async Task<IActionResult> CreatePaymentIntent([FromBody] PaymentIntentCreateRequest request)
        {
            try
            {
                _logger.LogInformation("Creating payment intent for amount: {Amount}", request.Amount);
                
                var paymentIntent = await _paymentService.CreatePaymentIntentAsync(request.Amount);
                
                _logger.LogInformation("Payment intent created successfully. ID: {Id}", paymentIntent.Id);
                
                return Ok(new { 
                    clientSecret = paymentIntent.ClientSecret,
                    id = paymentIntent.Id
                });
            }
            catch (StripeException e)
            {
                _logger.LogError(e, "Stripe error while creating payment intent");
                return BadRequest(new { error = e.StripeError?.Message ?? e.Message });
            }
            catch (Exception e)
            {
                _logger.LogError(e, "Error while creating payment intent");
                return BadRequest(new { error = e.Message });
            }
        }
    }
}