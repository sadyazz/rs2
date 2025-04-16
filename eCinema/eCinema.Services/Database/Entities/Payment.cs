using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Services.Database.Entities
{
    public class Payment
    {
        public int Id { get; set; }
        
        [Column(TypeName = "decimal(10, 2)")]
        public decimal Amount { get; set; }
        
        public DateTime PaymentDate { get; set; } = DateTime.UtcNow;
        
        [MaxLength(50)]
        public string PaymentMethod { get; set; } = string.Empty; // Credit Card, PayPal, etc.
        
        [MaxLength(100)]
        public string? TransactionId { get; set; }
        
        [MaxLength(50)]
        public string Status { get; set; } = "Completed"; // Pending, Completed, Failed, etc.
        
        public int ReservationId { get; set; }
        
        [ForeignKey(nameof(ReservationId))]
        public virtual Reservation Reservation { get; set; } = null!;
    }
} 