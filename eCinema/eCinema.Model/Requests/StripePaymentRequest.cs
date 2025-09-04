using System.Collections.Generic;

namespace eCinema.Model.Requests
{
    public class StripePaymentRequest
    {
        public string PaymentIntentId { get; set; } = null!;
        public decimal Amount { get; set; }
        public int ScreeningId { get; set; }
        public List<int> SeatIds { get; set; } = new();
    }
}