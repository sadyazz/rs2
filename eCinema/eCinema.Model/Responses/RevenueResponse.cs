using System;

namespace eCinema.Model.Responses
{
    public class RevenueResponse
    {
        public DateTime Date { get; set; }
        public decimal TotalRevenue { get; set; }
        public int ReservationCount { get; set; }
        public decimal AverageTicketPrice { get; set; }
        public string? MovieTitle { get; set; }
        public string? HallName { get; set; }
    }
}
