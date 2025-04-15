 namespace eCinema.Model.Responses
{
    public class SeatResponse
    {
        public int Id { get; set; }
        public int HallId { get; set; }
        public int SeatTypeId { get; set; }
        public int RowNumber { get; set; }
        public int SeatNumber { get; set; }
        public bool IsActive { get; set; }
    }
}