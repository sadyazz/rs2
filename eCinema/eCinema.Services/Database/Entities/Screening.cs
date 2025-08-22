using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace eCinema.Services.Database.Entities
{
    public class Screening
    {
        public int Id { get; set; }
        
        public DateTime StartTime { get; set; }
        
        public DateTime EndTime { get; set; }
        
        public decimal BasePrice { get; set; }
        
        [MaxLength(50)]
        public string Language { get; set; } = string.Empty;
        
        public bool HasSubtitles { get; set; }

        public bool IsDeleted { get; set; } = false;
        
        public int MovieId { get; set; }
        public int HallId { get; set; }
        public int? ScreeningFormatId { get; set; }
        
        public virtual Movie Movie { get; set; } = null!;
        
        public virtual Hall Hall { get; set; } = null!;
        
        public virtual ScreeningFormat? Format { get; set; }
        
        public virtual ICollection<Reservation> Reservations { get; set; } = new HashSet<Reservation>();
        public virtual ICollection<ScreeningSeat> ScreeningSeats { get; set; } = new HashSet<ScreeningSeat>();
    }
} 