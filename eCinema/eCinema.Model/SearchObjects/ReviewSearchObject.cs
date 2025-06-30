using System;

namespace eCinema.Model.SearchObjects
{
    public class ReviewSearchObject : BaseSearchObject
    {
        public int? UserId { get; set; }
        public int? MovieId { get; set; }
        public int? MinRating { get; set; }
        public int? MaxRating { get; set; }
        public DateTime? FromDate { get; set; }
        public DateTime? ToDate { get; set; }
        public bool? HasComment { get; set; }
    }
} 