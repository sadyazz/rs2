using System;
using System.ComponentModel.DataAnnotations;

namespace eCinema.Model.Requests
{
    public class PromotionUpsertRequest
    {
        [Required]
        [MaxLength(100)]
        public string Name { get; set; } = string.Empty;
        
        [MaxLength(500)]
        public string Description { get; set; } = string.Empty;
        
        [MaxLength(20)]
        public string? Code { get; set; }
        
        [Required]
        [Range(0, 100)]
        public decimal DiscountPercentage { get; set; }
        
        [Required]
        public DateTime StartDate { get; set; }
        
        [Required]
        public DateTime EndDate { get; set; }

        public bool IsDeleted { get; set; } = false;
    }
} 