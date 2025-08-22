using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace eCinema.Services.Database.Entities
{
    public class Seat
    {
        public int Id { get; set; }
        
        [MaxLength(50)]
        public string? Name { get; set; }
        
        public virtual ICollection<ReservationSeat> ReservationSeats { get; set; } = new List<ReservationSeat>();
        public virtual ICollection<ScreeningSeat> ScreeningSeats { get; set; } = new List<ScreeningSeat>();
    }
} 