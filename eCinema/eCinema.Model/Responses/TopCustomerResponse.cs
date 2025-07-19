namespace eCinema.Model.Responses
{
    public class TopCustomerResponse
    {
        public int UserId { get; set; }
        public string UserName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public int ReservationCount { get; set; }
        public decimal TotalSpent { get; set; }
    }
} 