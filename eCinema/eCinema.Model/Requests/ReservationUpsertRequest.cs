using System;
using System.ComponentModel.DataAnnotations;

namespace eCinema.Model.Requests
{
    public class ReservationUpsertRequest
    {
        [Required]
        public DateTime ReservationTime { get; set; } = DateTime.UtcNow;
        
        [Required]
        [Range(0.01, double.MaxValue)]
        public decimal TotalPrice { get; set; }
        
        [Required]
        [Range(0.01, double.MaxValue)]
        public decimal OriginalPrice { get; set; }
        
        [Range(0, 100)]
        public decimal? DiscountPercentage { get; set; }
        
        [Required]
        [MaxLength(50)]
        public string Status { get; set; } = "Reserved";
        
        public bool IsActive { get; set; } = true;
        
        [Required]
        public int UserId { get; set; }
        
        [Required]
        public int ScreeningId { get; set; }
        
        [Required]
        public int SeatId { get; set; }
        
        public int? PromotionId { get; set; }
    }
} 