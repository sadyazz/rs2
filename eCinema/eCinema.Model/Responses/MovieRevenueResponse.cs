namespace eCinema.Model.Responses
{
    public class MovieRevenueResponse
    {
        public int MovieId { get; set; }
        public string MovieTitle { get; set; } = string.Empty;
        public string MovieImage { get; set; } = string.Empty;
        public int ReservationCount { get; set; }
        public decimal TotalRevenue { get; set; }
    }
} 