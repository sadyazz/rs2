using System;

namespace eCinema.Model.Responses
{
    public class ReservationResponse
    {
        public int Id { get; set; }
        public DateTime ReservationTime { get; set; }
        public decimal TotalPrice { get; set; }
        public decimal OriginalPrice { get; set; }
        public decimal? DiscountPercentage { get; set; }
        public string Status { get; set; } = string.Empty;
        public bool IsDeleted { get; set; }
        public int UserId { get; set; }
        public string UserName { get; set; } = string.Empty;
        public int ScreeningId { get; set; }
        public string MovieTitle { get; set; } = string.Empty;
        public DateTime ScreeningStartTime { get; set; }
        public int SeatId { get; set; }
        public string SeatInfo { get; set; } = string.Empty;
        public int? PromotionId { get; set; }
        public string? PromotionName { get; set; }
        public int? PaymentId { get; set; }
        public string? PaymentStatus { get; set; }
        public string ReservationState { get; set; } = string.Empty;
    }
} 