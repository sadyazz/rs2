using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Services.Database.Entities
{
    public class ScreeningSeat
    {
        [Key]
        public int ScreeningId { get; set; }
        
        [Key]
        public int SeatId { get; set; }
        
        public bool? IsReserved { get; set; }
        
        [ForeignKey(nameof(ScreeningId))]
        public virtual Screening Screening { get; set; } = null!;
        
        [ForeignKey(nameof(SeatId))]
        public virtual Seat Seat { get; set; } = null!;
    }
}
