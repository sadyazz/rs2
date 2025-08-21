namespace eCinema.Model.SearchObjects
{
    public class SeatSearchObject : BaseSearchObject
    {
        public int? HallId { get; set; }
        public string Row { get; set; }
        public int? Number { get; set; }
    }
}