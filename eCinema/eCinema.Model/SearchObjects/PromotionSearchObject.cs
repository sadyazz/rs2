using System;

namespace eCinema.Model.SearchObjects
{
    public class PromotionSearchObject : BaseSearchObject
    {
        public string? Name { get; set; }
        public string? Code { get; set; }
        public decimal? MinDiscount { get; set; }
        public decimal? MaxDiscount { get; set; }
        public DateTime? FromStartDate { get; set; }
        public DateTime? ToStartDate { get; set; }
        public DateTime? FromEndDate { get; set; }
        public DateTime? ToEndDate { get; set; }
    }
} 