using System;

namespace eCinema.Model.Responses
{
    public class MovieResponse
    {
        public int Id { get; set; }
        public string Title { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public int DurationMinutes { get; set; }
        public string Director { get; set; } = string.Empty;
        public string Cast { get; set; } = string.Empty;
        public DateTime ReleaseDate { get; set; }
        public int ReleaseYear { get; set; }
        public string Genre { get; set; } = string.Empty;
        public string? TrailerUrl { get; set; }
        public float Grade { get; set; }
        public bool IsActive { get; set; }
    }
} 