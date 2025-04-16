namespace eCinema.Model.Responses
{
    public class SeatTypeResponse
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public decimal PriceMultiplier { get; set; }
        public string Color { get; set; } = string.Empty;
        public bool IsActive { get; set; }
    }
} 