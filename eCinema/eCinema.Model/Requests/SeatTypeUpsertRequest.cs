using System.ComponentModel.DataAnnotations;

namespace eCinema.Model.Requests
{
    public class SeatTypeUpsertRequest
    {
        [Required]
        [MaxLength(50)]
        public string Name { get; set; } = string.Empty;
        
        [MaxLength(200)]
        public string? Description { get; set; } = string.Empty;
        
        public decimal PriceMultiplier { get; set; } = 1.0m;
        
        [MaxLength(50)]
        public string Color { get; set; } = string.Empty;
        
        public bool IsActive { get; set; } = true;
    }
} 