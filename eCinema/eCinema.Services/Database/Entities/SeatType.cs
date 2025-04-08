using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Services.Database.Entities
{
    public class SeatType
    {
        public int Id { get; set; }
        
        [Required]
        [MaxLength(50)]
        public string Name { get; set; } = string.Empty; // Regular, VIP, Premium, Accessible, etc.
        
        [MaxLength(200)]
        public string? Description { get; set; }
        
        [Column(TypeName = "decimal(10, 2)")]
        public decimal PriceMultiplier { get; set; } = 1.0m; // 1.0 = regular price, 1.5 = 50% more, etc.
        
        [MaxLength(50)]
        public string? Color { get; set; } // For UI display
        
        public bool Active { get; set; } = true;
        
        // Navigation properties
        public virtual ICollection<Seat> Seats { get; set; } = new HashSet<Seat>();
    }
} 