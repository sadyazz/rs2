using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace eCinema.Services.Database.Entities
{
    public class Actor
    {
        public int Id { get; set; }
        
        [Required]
        [MaxLength(50)]
        public string FirstName { get; set; } = string.Empty;
        
        [Required]
        [MaxLength(50)]
        public string LastName { get; set; } = string.Empty;
        
        public DateTime? DateOfBirth { get; set; }
        
        [MaxLength(500)]
        public string? Biography { get; set; }
        
        // [MaxLength(255)]
        // public string? PhotoUrl { get; set; }
        
        public bool IsActive { get; set; } = true;
        
        public virtual ICollection<MovieActor> MovieActors { get; set; } = new HashSet<MovieActor>();
    }
} 