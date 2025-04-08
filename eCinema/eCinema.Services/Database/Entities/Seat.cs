using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Services.Database.Entities
{
    public class Seat
    {
        public int Id { get; set; }
        
        [Required]
        public string Row { get; set; } = string.Empty;
        
        [Required]
        public int Number { get; set; }
        
        public bool Active { get; set; } = true;
        
        // Foreign keys
        public int HallId { get; set; }
        public int? SeatTypeId { get; set; }
        
        // Navigation properties
        // [ForeignKey(nameof(HallId))]
        // public virtual Hall Hall { get; set; } = null!;
        
        // [ForeignKey(nameof(SeatTypeId))]
        // public virtual SeatType? SeatType { get; set; }
        
        // public virtual ICollection<Reservation> Reservations { get; set; } = new HashSet<Reservation>();
    }
} 