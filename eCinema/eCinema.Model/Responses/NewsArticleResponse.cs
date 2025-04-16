using System;

namespace eCinema.Model.Responses
{
    public class NewsArticleResponse
    {
        public int Id { get; set; }
        public string Title { get; set; } = string.Empty;
        public string Content { get; set; } = string.Empty;
        public DateTime PublishDate { get; set; }
        public bool IsActive { get; set; }
        public int? AuthorId { get; set; }
        public string? AuthorName { get; set; }
    }
} 