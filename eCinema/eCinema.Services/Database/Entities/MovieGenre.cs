using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Services.Database.Entities
{
    public class MovieGenre
    {
        public int Id { get; set; }
        
        // Foreign keys
        public int MovieId { get; set; }
        public int GenreId { get; set; }
        
        // Navigation properties
        [ForeignKey(nameof(MovieId))]
        public virtual Movie Movie { get; set; } = null!;
        
        [ForeignKey(nameof(GenreId))]
        public virtual Genre Genre { get; set; } = null!;
    }
} 