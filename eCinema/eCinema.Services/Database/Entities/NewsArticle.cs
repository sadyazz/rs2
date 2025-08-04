using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Services.Database.Entities
{
    public class NewsArticle
    {
        public int Id { get; set; }
        
        [Required]
        [MaxLength(100)]
        public string Title { get; set; } = string.Empty;
        
        [Required]
        public string Content { get; set; } = string.Empty;
            
        public byte[]? Image { get; set; }
        
        public DateTime PublishDate { get; set; } = DateTime.UtcNow;

        public bool IsDeleted { get; set; } = false;
        
        public int? AuthorId { get; set; }
        
        [ForeignKey(nameof(AuthorId))]
        public virtual User? Author { get; set; }
    }
} 