using System;

namespace eCinema.Model.SearchObjects
{
    public class ReservationSearchObject : BaseSearchObject
    {
        public int? UserId { get; set; }
        public int? ScreeningId { get; set; }
        public int? SeatId { get; set; }
        public int? PromotionId { get; set; }
        public string? State { get; set; }
        public DateTime? FromReservationTime { get; set; }
        public DateTime? ToReservationTime { get; set; }
        public decimal? MinTotalPrice { get; set; }
        public decimal? MaxTotalPrice { get; set; }
        public bool? HasPayment { get; set; }
    }
} 