using System;

namespace eCinema.Model.SearchObjects
{
    public class NewsArticleSearchObject : BaseSearchObject
    {
        public string? Title { get; set; }
        public string? Content { get; set; }
        public string? Type { get; set; }
        public DateTime? FromPublishDate { get; set; }
        public DateTime? ToPublishDate { get; set; }
        public int? AuthorId { get; set; }
        public DateTime? FromEventDate { get; set; }
        public DateTime? ToEventDate { get; set; }
    }
} 