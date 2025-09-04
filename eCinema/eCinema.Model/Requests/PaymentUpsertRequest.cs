using System;
using System.ComponentModel.DataAnnotations;

namespace eCinema.Model.Requests
{
    public class PaymentUpsertRequest
    {
        [MaxLength(50)]
        public string? Provider { get; set; }
        
        [MaxLength(100)]
        public string? TransactionId { get; set; }

        [Range(0.01, double.MaxValue)]
        public decimal? Amount { get; set; }
        
        public DateTime? DateTime { get; set; }
    }
} 