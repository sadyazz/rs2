namespace eCinema.Model.SearchObjects
{
    public class SeatSearchObject : BaseSearchObject
    {
        public int? HallId { get; set; }
        public int? RowNumber { get; set; }
        public int? SeatNumber { get; set; }
    }
} 