using System;
using System.ComponentModel.DataAnnotations;

namespace eCinema.Model.Requests
{
    public class HallUpsertRequest
    {
        [Required]
        [MaxLength(50)]
        public string Name { get; set; } = string.Empty;
        
        [Required]
        [Range(1, int.MaxValue)]
        public int Capacity { get; set; }
        
        [MaxLength(100)]
        public string? ScreenType { get; set; }
        
        [MaxLength(100)]
        public string? SoundSystem { get; set; }
        
        [Required]
        [MaxLength(200)]
        public string Location { get; set; } = string.Empty;
        
        public bool IsActive { get; set; } = true;
    }
} 