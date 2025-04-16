using System;
using System.ComponentModel.DataAnnotations;

namespace eCinema.Model.Requests
{
    public class GenreUpsertRequest
    {
        [Required]
        [MaxLength(50)]
        public string Name { get; set; } = string.Empty;
        
        [MaxLength(200)]
        public string? Description { get; set; }
        
        public bool IsActive { get; set; } = true;
    }
} 