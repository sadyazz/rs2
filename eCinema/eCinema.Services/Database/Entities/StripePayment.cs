using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Services.Database.Entities
{
    public class StripePayment
    {
        public int Id { get; set; }

        [Column(TypeName = "decimal(10, 2)")]
        public decimal? Amount { get; set; }

        [MaxLength(100)]
        public string? TransactionId { get; set; }

        public DateTime? PaymentDate { get; set; }

        [MaxLength(50)]
        public string? PaymentProvider { get; set; }
    }
}
