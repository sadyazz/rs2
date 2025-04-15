using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace eCinema.Services.Database.Entities
{
    public class Hall
    {
        public int Id { get; set; }
        
        [Required]
        [MaxLength(50)]
        public string Name { get; set; } = string.Empty;
        
        public int Capacity { get; set; }
        
        [MaxLength(100)]
        public string? ScreenType { get; set; } // Regular, IMAX, 3D, etc.
        
        [MaxLength(100)]
        public string? SoundSystem { get; set; } // Dolby, SDDS, etc.
        
        [MaxLength(200)]
        public string Location { get; set; } = string.Empty;
        
        public bool IsActive { get; set; } = true;
        
        public virtual ICollection<Screening> Screenings { get; set; } = new HashSet<Screening>();
        public virtual ICollection<Seat> Seats { get; set; } = new HashSet<Seat>();
    }
} 