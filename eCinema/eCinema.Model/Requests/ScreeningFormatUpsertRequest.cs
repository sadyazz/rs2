using System.ComponentModel.DataAnnotations;

namespace eCinema.Model.Requests
{
    public class ScreeningFormatUpsertRequest
    {
        [Required]
        [MaxLength(50)]
        public string Name { get; set; } = string.Empty;
        
        [MaxLength(200)]
        public string? Description { get; set; }
        
        [Required]
        [Range(0.1, 10.0)]
        public decimal PriceMultiplier { get; set; } = 1.0m;
        
        public bool IsActive { get; set; } = true;
    }
} 