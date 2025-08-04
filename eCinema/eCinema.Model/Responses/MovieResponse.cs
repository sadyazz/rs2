using System;
using System.Collections.Generic;

namespace eCinema.Model.Responses
{
    public class MovieResponse
    {
        public int Id { get; set; }
        public string Title { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public int DurationMinutes { get; set; }
        public string Director { get; set; } = string.Empty;
        public DateTime ReleaseDate { get; set; }
        public int ReleaseYear { get; set; }
        public List<GenreResponse> Genres { get; set; } = new List<GenreResponse>();
        public string? TrailerUrl { get; set; }
        public float Grade { get; set; }
        public byte[]? Image { get; set; }
        public List<ActorResponse> Actors { get; set; } = new List<ActorResponse>();
        public bool IsComingSoon { get; set; }
        public bool IsDeleted { get; set; }
    }
}