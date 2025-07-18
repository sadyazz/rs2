using System;

namespace eCinema.Model.SearchObjects
{
    public class ScreeningSearchObject : BaseSearchObject
    {
        public int? MovieId { get; set; }
        public string? MovieTitle { get; set; }
        public int? HallId { get; set; }
        public string? HallName { get; set; }
        public int? ScreeningFormatId { get; set; }
        public string? ScreeningFormatName { get; set; }
        public string? Language { get; set; }
        public bool? HasSubtitles { get; set; }
        public DateTime? FromStartTime { get; set; }
        public DateTime? ToStartTime { get; set; }
        public decimal? MinBasePrice { get; set; }
        public decimal? MaxBasePrice { get; set; }
        public bool? HasAvailableSeats { get; set; }
    }
} 