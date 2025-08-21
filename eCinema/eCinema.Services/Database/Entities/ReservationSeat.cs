using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Services.Database.Entities
{
    public class ReservationSeat
    {
        public int ReservationId { get; set; }
        
        public int SeatId { get; set; }
        
        public DateTime? ReservedAt { get; set; }
        
        [ForeignKey(nameof(ReservationId))]
        public virtual Reservation Reservation { get; set; } = null!;
        
        [ForeignKey(nameof(SeatId))]
        public virtual Seat Seat { get; set; } = null!;
    }
}
