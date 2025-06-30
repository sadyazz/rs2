using System;

namespace eCinema.Model.Responses
{
    public class ReviewResponse
    {
        public int Id { get; set; }
        public int Rating { get; set; }
        public string? Comment { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime? ModifiedAt { get; set; }
        public bool IsActive { get; set; }
        
        // Navigation properties
        public int UserId { get; set; }
        public string UserName { get; set; } = string.Empty;
        public string UserEmail { get; set; } = string.Empty;
        
        public int MovieId { get; set; }
        public string MovieTitle { get; set; } = string.Empty;
    }
} 