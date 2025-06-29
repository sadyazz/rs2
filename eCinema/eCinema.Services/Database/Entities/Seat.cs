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
        
        public bool IsActive { get; set; } = true;
        
        public int HallId { get; set; }
        
        [ForeignKey(nameof(HallId))]
        public virtual Hall Hall { get; set; } = null!;
        
        public virtual ICollection<Reservation> Reservations { get; set; } = new HashSet<Reservation>();
    }
} 