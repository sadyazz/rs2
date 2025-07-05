using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace eCinema.Services.Database.Entities
{
    public class Movie
    {
        public int Id { get; set; }
        
        [Required]
        [MaxLength(100)]
        public string Title { get; set; } = string.Empty;
        
        [MaxLength(500)]
        public string Description { get; set; } = string.Empty;
        
        [Required]
        [Range(1, 500)]
        public int DurationMinutes { get; set; }
        
        [Required]
        [MaxLength(50)]
        public string Director { get; set; } = string.Empty;
        
        [Required]
        public DateTime ReleaseDate { get; set; }
        
        [Required]
        public int ReleaseYear { get; set; }
        
        public byte[]? Image { get; set; }
        
        [MaxLength(255)]
        public string? TrailerUrl { get; set; }
        
        public float Grade { get; set; }
        
        public bool IsActive { get; set; } = true;
        
        public bool IsDeleted { get; set; } = false;
        
        public virtual ICollection<Screening> Screenings { get; set; } = new List<Screening>();
        public virtual ICollection<Review> Reviews { get; set; } = new List<Review>();
        public virtual ICollection<MovieGenre> Genres { get; set; } = new List<MovieGenre>();
        public virtual ICollection<MovieActor> Actors { get; set; } = new List<MovieActor>();
    }
} 