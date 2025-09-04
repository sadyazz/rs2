using System;

namespace eCinema.Model.Responses
{
    public class PaymentResponse
    {
        public int Id { get; set; }
        public string? Provider { get; set; }
        public string? TransactionId { get; set; }
        public decimal? Amount { get; set; }
        public DateTime? DateTime { get; set; }
    }
} 