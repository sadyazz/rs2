using System.ComponentModel.DataAnnotations;

namespace eCinema.Services.Database.Entities
{
    public class ScreeningSeat
    {
        public int ScreeningId { get; set; }
        
        public int SeatId { get; set; }
        
        public bool? IsReserved { get; set; }
        
        public virtual Screening Screening { get; set; } = null!;
        
        public virtual Seat Seat { get; set; } = null!;
    }
}
