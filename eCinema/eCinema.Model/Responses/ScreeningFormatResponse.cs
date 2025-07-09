namespace eCinema.Model.Responses
{
    public class ScreeningFormatResponse
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string? Description { get; set; }
        public decimal PriceMultiplier { get; set; }
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
    }
} 