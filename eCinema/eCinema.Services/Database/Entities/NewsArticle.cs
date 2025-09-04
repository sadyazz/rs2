using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Services.Database.Entities
{
    public enum NewsArticleType
    {
        News,
        Event
    }
    public class NewsArticle
    {
        public int Id { get; set; }
        
        [Required]
        [MaxLength(100)]
        public string Title { get; set; } = string.Empty;
        
        [Required]
        public string Content { get; set; } = string.Empty;
            
        public DateTime PublishDate { get; set; } = DateTime.UtcNow;

        public bool IsDeleted { get; set; } = false;

        [Required]
        [MaxLength(20)]
        public string Type { get; set; } = string.Empty;

        public DateTime? EventDate { get; set; }
        
        public int? AuthorId { get; set; }
        
        [ForeignKey(nameof(AuthorId))]
        public virtual User? Author { get; set; }

        [NotMapped]
        public NewsArticleType TypeEnum
        {
            get => Enum.TryParse<NewsArticleType>(Type, true, out var result) ? result : NewsArticleType.News;
            set => Type = value.ToString();
        }

        public static string GetTypeString(NewsArticleType type)
        {
            return type.ToString().ToLower();
        }

        public static NewsArticleType GetTypeFromString(string type)
        {
            return Enum.TryParse<NewsArticleType>(type, true, out var result) ? result : NewsArticleType.News;
        }
    }
} 