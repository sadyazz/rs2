namespace eCinema.Model.Responses
{
    public class SeatTypeResponse
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public decimal PriceMultiplier { get; set; }
        public string Color { get; set; }
        public bool Active { get; set; }
    }
} 