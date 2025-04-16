using System;

namespace eCinema.Model.SearchObjects
{
    public class PaymentSearchObject : BaseSearchObject
    {
        public decimal? MinAmount { get; set; }
        public decimal? MaxAmount { get; set; }
        public DateTime? FromPaymentDate { get; set; }
        public DateTime? ToPaymentDate { get; set; }
        public string? PaymentMethod { get; set; }
        public string? Status { get; set; }
        public int? ReservationId { get; set; }
    }
} 