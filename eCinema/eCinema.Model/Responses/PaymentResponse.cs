using System;

namespace eCinema.Model.Responses
{
    public class PaymentResponse
    {
        public int Id { get; set; }
        public decimal Amount { get; set; }
        public DateTime PaymentDate { get; set; }
        public string PaymentMethod { get; set; } = string.Empty;
        public string? TransactionId { get; set; }
        public string Status { get; set; } = string.Empty;
        public int ReservationId { get; set; }
        public string? ReservationDetails { get; set; }
    }
} 