using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Services.Database.Entities
{
    public class Review
    {
        public int Id { get; set; }
        
        public int Rating { get; set; } // 1-5 stars
        
        [MaxLength(500)]
        public string? Comment { get; set; }
        
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        
        public DateTime? ModifiedAt { get; set; }
        
        public bool IsActive { get; set; } = true;
        
        public int UserId { get; set; }
        public int MovieId { get; set; }
        
        [ForeignKey(nameof(UserId))]
        public virtual User User { get; set; } = null!;
        
        [ForeignKey(nameof(MovieId))]
        public virtual Movie Movie { get; set; } = null!;
    }
} 