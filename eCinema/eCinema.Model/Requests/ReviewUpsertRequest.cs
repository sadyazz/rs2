using System;
using System.ComponentModel.DataAnnotations;

namespace eCinema.Model.Requests
{
    public class ReviewUpsertRequest
    {
        [Required]
        [Range(1, 5, ErrorMessage = "Rating must be between 1 and 5")]
        public int Rating { get; set; }
        
        [MaxLength(500)]
        public string? Comment { get; set; }
        
        [Required]
        public int UserId { get; set; }
        
        [Required]
        public int MovieId { get; set; }
        
        public bool IsActive { get; set; } = true;

        public bool IsDeleted { get; set; } = false;
    }
} 