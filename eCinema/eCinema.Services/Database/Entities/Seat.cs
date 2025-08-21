using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Services.Database.Entities
{
    public class Seat
    {
        public int Id { get; set; }
        
        [Required]
        [MaxLength(50)]
        public string Name { get; set; } = string.Empty;
        
        public int HallId { get; set; }
        
        [ForeignKey(nameof(HallId))]
        public virtual Hall Hall { get; set; } = null!;
        
        public virtual ICollection<ReservationSeat> ReservationSeats { get; set; } = new List<ReservationSeat>();
    }
} 