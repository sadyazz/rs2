using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Services.Database.Entities
{
    public class MovieActor
    {
        public int Id { get; set; }
        
        [MaxLength(100)]
        public string? CharacterName { get; set; }
        
        [MaxLength(200)]
        public string? Role { get; set; } // e.g., "Lead Actor", "Supporting Actor", etc.
        
        // Foreign keys
        public int MovieId { get; set; }
        public int ActorId { get; set; }
        
        // Navigation properties
        [ForeignKey(nameof(MovieId))]
        public virtual Movie Movie { get; set; } = null!;
        
        [ForeignKey(nameof(ActorId))]
        public virtual Actor Actor { get; set; } = null!;
    }
} 