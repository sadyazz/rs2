using System;
using System.ComponentModel.DataAnnotations;

namespace eCinema.Model.Requests
{
    public class ReviewUpsertRequest
    {
        [Required]
        public int MovieId { get; set; }
        
        [Required]
        [Range(1, 5, ErrorMessage = "Rating must be between 1 and 5")]
        public int Rating { get; set; }
        
        [MaxLength(500)]
        public string? Comment { get; set; }
        
        public bool IsDeleted { get; set; } = false;
        
        public bool? IsSpoiler { get; set; }
        
        public bool IsEdited { get; set; } = false;
    }
} 