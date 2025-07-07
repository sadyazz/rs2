using System;

namespace eCinema.Model.Responses
{
    public class ScreeningResponse
    {
        public int Id { get; set; }
        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }
        public decimal BasePrice { get; set; }
        public string Language { get; set; } = string.Empty;
        public bool HasSubtitles { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
        public int MovieId { get; set; }
        public string MovieTitle { get; set; } = string.Empty;
        public byte[]? MovieImage { get; set; }
        public int HallId { get; set; }
        public string HallName { get; set; } = string.Empty;
        public int? ScreeningFormatId { get; set; }
        public string? ScreeningFormatName { get; set; }
        public decimal? ScreeningFormatPriceMultiplier { get; set; }
        public int ReservationsCount { get; set; }
        public int AvailableSeats { get; set; }
    }
} 