using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Services.Database.Entities
{
    public class Screening
    {
        public int Id { get; set; }
        
        public DateTime StartTime { get; set; }
        
        public DateTime EndTime { get; set; }
        
        [Column(TypeName = "decimal(10, 2)")]
        public decimal BasePrice { get; set; }
        
        [MaxLength(50)]
        public string Language { get; set; } = string.Empty;
        
        public bool HasSubtitles { get; set; }
        
        public bool IsActive { get; set; } = true;
        
        public int MovieId { get; set; }
        public int HallId { get; set; }
        public int? ScreeningFormatId { get; set; }
        
        [ForeignKey(nameof(MovieId))]
        public virtual Movie Movie { get; set; } = null!;
        
        [ForeignKey(nameof(HallId))]
        public virtual Hall Hall { get; set; } = null!;
        
        [ForeignKey(nameof(ScreeningFormatId))]
        public virtual ScreeningFormat? Format { get; set; }
        
        public virtual ICollection<Reservation> Reservations { get; set; } = new HashSet<Reservation>();
    }
} 