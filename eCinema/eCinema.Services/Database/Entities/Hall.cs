using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace eCinema.Services.Database.Entities
{
    public class Hall
    {
        public int Id { get; set; }
        
        [MaxLength(50)]
        public string? Name { get; set; }
        
        public int Capacity { get; set; } = 48;
        
        public bool IsDeleted { get; set; } = false;
        
        public virtual ICollection<Screening> Screenings { get; set; } = new HashSet<Screening>();
    }
} 