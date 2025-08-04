using System;
using System.Collections.Generic;

namespace eCinema.Model.SearchObjects
{
    public class MovieSearchObject : BaseSearchObject
    {
        public string? Title { get; set; }
        public string? Director { get; set; }
        public int? MinDuration { get; set; }
        public int? MaxDuration { get; set; }
        public float? MinGrade { get; set; }
        public float? MaxGrade { get; set; }
        public int? ReleaseYear { get; set; }
        public bool? IsComingSoon { get; set; }
        public List<int> GenreIds { get; set; } = new List<int>();
    }
} 