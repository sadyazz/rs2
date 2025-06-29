using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace eCinema.Model.Requests
{
    public class MovieUpsertRequest
    {
        [Required]
        [MaxLength(100)]
        public string Title { get; set; } = string.Empty;
        
        [MaxLength(500)]
        public string Description { get; set; } = string.Empty;
        
        [Required]
        [Range(1, 500)]
        public int DurationMinutes { get; set; }
        
        [Required]
        [MaxLength(50)]
        public string Director { get; set; } = string.Empty;
        
        [MaxLength(200)]
        public string Cast { get; set; } = string.Empty;
        
        [Required]
        public DateTime ReleaseDate { get; set; }
        
        [Required]
        public int ReleaseYear { get; set; }

        public List<int> GenreIds { get; set; } = new List<int>();
        
        [MaxLength(255)]
        public string? TrailerUrl { get; set; }
        
        public float Grade { get; set; }

        public byte[]? Image { get; set; }
        
        public bool IsActive { get; set; } = true;
    }
} 