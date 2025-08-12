using System.ComponentModel.DataAnnotations;

namespace eCinema.Model.Requests
{
    public class UserMovieListUpsertRequest
    {
        [Required]
        public int UserId { get; set; }
        
        [Required]
        public int MovieId { get; set; }
        
        [Required]
        [MaxLength(20)]
        public string ListType { get; set; } = string.Empty;
    }
} 