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
        
        [MaxLength(200)]
        public string Cast { get; set; } = string.Empty;
        
        [Required]
        public DateTime ReleaseDate { get; set; }
        
        [Required]
        public int ReleaseYear { get; set; }
        
        [Required]
        [MaxLength(50)]
        public string Genre { get; set; } = string.Empty;
        
        // [MaxLength(255)]
        // public string? PosterUrl { get; set; }
        
        [MaxLength(255)]
        public string? TrailerUrl { get; set; }
        
        public float Grade { get; set; }
        
        public bool IsActive { get; set; } = true;
        
        public virtual ICollection<Screening> Screenings { get; set; } = new HashSet<Screening>();
        public virtual ICollection<Review> Reviews { get; set; } = new HashSet<Review>();
        public virtual ICollection<MovieGenre> MovieGenres { get; set; } = new HashSet<MovieGenre>();
        public virtual ICollection<MovieActor> MovieActors { get; set; } = new HashSet<MovieActor>();
    }
} 