using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Services.Database.Entities
{
    public class Reservation
    {
        public int Id { get; set; }
        
        public DateTime ReservationTime { get; set; } = DateTime.UtcNow;
        
        [Column(TypeName = "decimal(10, 2)")]
        public decimal TotalPrice { get; set; }
        
        [Column(TypeName = "decimal(10, 2)")]
        public decimal? OriginalPrice { get; set; }
        
        [Column(TypeName = "decimal(5, 2)")]
        public decimal? DiscountPercentage { get; set; }
        
        public int UserId { get; set; }
        public int ScreeningId { get; set; }
        public int? PaymentId { get; set; }
        public int? PromotionId { get; set; }
        
        public int? NumberOfTickets { get; set; }
        
        [MaxLength(50)]
        public string? PaymentType { get; set; }
        
        [MaxLength(50)]
        public string State { get; set; } = string.Empty;
        
        public string? QrcodeBase64 { get; set; }
        
        public bool IsDeleted { get; set; } = false;
        
        [ForeignKey(nameof(UserId))]
        public virtual User User { get; set; } = null!;
        
        [ForeignKey(nameof(ScreeningId))]
        public virtual Screening Screening { get; set; } = null!;
        
        [ForeignKey(nameof(PaymentId))]
        public virtual StripePayment? Payment { get; set; }
        
        [ForeignKey(nameof(PromotionId))]
        public virtual Promotion? Promotion { get; set; }
        
        public virtual ICollection<ReservationSeat> ReservationSeats { get; set; } = new List<ReservationSeat>();
    }
}