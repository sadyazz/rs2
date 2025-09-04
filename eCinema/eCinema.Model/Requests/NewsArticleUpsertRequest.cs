using System;
using System.ComponentModel.DataAnnotations;

namespace eCinema.Model.Requests
{
    public class NewsArticleUpsertRequest
    {
        [Required]
        [MaxLength(100)]
        public string Title { get; set; } = string.Empty;
        
        [Required]
        public string Content { get; set; } = string.Empty;
        
        public DateTime PublishDate { get; set; } = DateTime.UtcNow;
                
        public bool IsDeleted { get; set; } = false;

        [Required]
        [MaxLength(20)]
        public string Type { get; set; } = "news";

        public DateTime? EventDate { get; set; }
        
        public int? AuthorId { get; set; }
    }
} 