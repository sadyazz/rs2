using System;

namespace eCinema.Model.Responses
{
    public class ScreeningAttendanceResponse
    {
        public int ScreeningId { get; set; }
        public string MovieTitle { get; set; }
        public string HallName { get; set; }
        public DateTime StartTime { get; set; }
        public int TotalSeats { get; set; }
        public int ReservedSeats { get; set; }
        public decimal OccupancyRate { get; set; }
    }
}
