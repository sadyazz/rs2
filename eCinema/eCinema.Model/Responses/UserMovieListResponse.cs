using System;

namespace eCinema.Model.Responses
{
    public class UserMovieListResponse
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public int MovieId { get; set; }
        public string ListType { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; }
        public bool IsDeleted { get; set; }
        public MovieResponse Movie { get; set; } = new MovieResponse();
    }
} 