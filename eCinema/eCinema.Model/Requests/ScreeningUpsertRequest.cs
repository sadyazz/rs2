using System;
using System.ComponentModel.DataAnnotations;

namespace eCinema.Model.Requests
{
    public class ScreeningUpsertRequest
    {
        [Required]
        public DateTime StartTime { get; set; }
        
        [Required]
        public DateTime EndTime { get; set; }
        
        [Required]
        [Range(0.01, double.MaxValue)]
        public decimal BasePrice { get; set; }
        
        [Required]
        [MaxLength(50)]
        public string Language { get; set; } = string.Empty;
        
        public bool HasSubtitles { get; set; }
        
        public bool IsActive { get; set; } = true;
        
        [Required]
        public int MovieId { get; set; }
        
        [Required]
        public int HallId { get; set; }
        
        public int? ScreeningFormatId { get; set; }
    }
} 