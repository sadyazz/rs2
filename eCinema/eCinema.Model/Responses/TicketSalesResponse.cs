using System;

namespace eCinema.Model.Responses
{
    public class TicketSalesResponse
    {
        public DateTime Date { get; set; }
        public int TicketCount { get; set; }
        public decimal TotalRevenue { get; set; }
    }
}
