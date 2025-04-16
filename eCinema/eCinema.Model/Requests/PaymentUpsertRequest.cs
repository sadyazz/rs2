using System;
using System.ComponentModel.DataAnnotations;

namespace eCinema.Model.Requests
{
    public class PaymentUpsertRequest
    {
        [Required]
        [Range(0.01, double.MaxValue)]
        public decimal Amount { get; set; }
        
        public DateTime PaymentDate { get; set; } = DateTime.UtcNow;
        
        [Required]
        [MaxLength(50)]
        public string PaymentMethod { get; set; } = string.Empty;
        
        [MaxLength(100)]
        public string? TransactionId { get; set; }
        
        [Required]
        [MaxLength(50)]
        public string Status { get; set; } = "Completed";
        
        [Required]
        public int ReservationId { get; set; }
    }
} 