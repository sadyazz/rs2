using System;
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
        public decimal OriginalPrice { get; set; }
        
        [Column(TypeName = "decimal(5, 2)")]
        public decimal? DiscountPercentage { get; set; }
        
        [MaxLength(50)]
        public string Status { get; set; } = "Reserved"; // Reserved, Paid, Cancelled, etc.
        
        public bool IsActive { get; set; } = true;
        
        public int UserId { get; set; }
        public int ScreeningId { get; set; }
        public int SeatId { get; set; }
        public int? PromotionId { get; set; }
        
        [ForeignKey(nameof(UserId))]
        public virtual User User { get; set; } = null!;
        
        [ForeignKey(nameof(ScreeningId))]
        public virtual Screening Screening { get; set; } = null!;
        
        [ForeignKey(nameof(SeatId))]
        public virtual Seat Seat { get; set; } = null!;
        
        [ForeignKey(nameof(PromotionId))]
        public virtual Promotion? Promotion { get; set; }
        
        public virtual Payment? Payment { get; set; }

        [MaxLength(50)]
        public string State { get; set; } = string.Empty;
    }
} 