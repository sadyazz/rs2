using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace eCinema.Model.Requests
{
    public class ReservationUpsertRequest
    {
        [Required]
        public DateTime ReservationTime { get; set; }
        
        [Required]
        [Range(0.01, double.MaxValue, ErrorMessage = "Total price must be greater than 0")]
        public decimal TotalPrice { get; set; }
        
        public decimal? OriginalPrice { get; set; }
        
        [Range(0, 100, ErrorMessage = "Discount percentage must be between 0 and 100")]
        public decimal? DiscountPercentage { get; set; }
        
        [Required]
        [StringLength(50)]
        public string Status { get; set; } = "Reserved";
        
        [Required]
        public int UserId { get; set; }
        
        [Required]
        public int ScreeningId { get; set; }
        
        public int? PaymentId { get; set; }
        
        public int? PromotionId { get; set; }
        
        public int? NumberOfTickets { get; set; }
        
        [StringLength(50)]
        public string? PaymentType { get; set; }
        
        [StringLength(50)]
        public string State { get; set; } = "InitialReservationState";
        
        public bool IsDeleted { get; set; } = false;
        
        [Required]
        public List<int> SeatIds { get; set; } = new List<int>();
    }
} 