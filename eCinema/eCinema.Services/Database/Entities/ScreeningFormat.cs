using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Services.Database.Entities
{
    public class ScreeningFormat
    {
        public int Id { get; set; }
        
        [Required]
        [MaxLength(50)]
        public string Name { get; set; } = string.Empty; // 2D, 3D, IMAX, etc.
        
        [MaxLength(200)]
        public string? Description { get; set; }
        
        [Column(TypeName = "decimal(10, 2)")]
        public decimal PriceMultiplier { get; set; } = 1.0m; // 1.0 = regular price, 1.5 = 50% more, etc.
        
        public bool IsDeleted { get; set; } = false;
        
        public virtual ICollection<Screening> Screenings { get; set; } = new HashSet<Screening>();
    }
} 