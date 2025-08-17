using System;

namespace eCinema.Model.Responses
{
    public class ReadyToReleaseMovieDto
    {
        public int Id { get; set; }
        public string? Title { get; set; }
        public DateTime ReleaseDate { get; set; }
    }
}
