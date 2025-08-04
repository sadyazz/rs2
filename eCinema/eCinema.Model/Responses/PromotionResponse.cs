using System;

namespace eCinema.Model.Responses
{
    public class PromotionResponse
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public string? Code { get; set; }
        public decimal DiscountPercentage { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public int ReservationCount { get; set; }
        public bool IsDeleted { get; set; }
    }
} 