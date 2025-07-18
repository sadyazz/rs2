using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Services.Database.Entities
{
    public class Review
    {
        public int Id { get; set; }
        
        [Required]
        [Range(1, 5, ErrorMessage = "Rating must be between 1 and 5")]
        public int Rating { get; set; } // 1-5 stars
        
        [MaxLength(500)]
        public string? Comment { get; set; }
        
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        
        public DateTime? ModifiedAt { get; set; }
        
        public bool IsActive { get; set; } = true;

        public bool IsDeleted { get; set; } = false;
        
        public bool IsSpoiler { get; set; } = false;
        
        public bool IsEdited { get; set; } = false;
        
        [Required]
        public int UserId { get; set; }
        
        [Required]
        public int MovieId { get; set; }
        
        [ForeignKey(nameof(UserId))]
        public virtual User User { get; set; } = null!;
        
        [ForeignKey(nameof(MovieId))]
        public virtual Movie Movie { get; set; } = null!;
    }
} 