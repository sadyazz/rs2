using System;
using System.ComponentModel.DataAnnotations;

namespace eCinema.Model.Requests
{
    public class ActorUpsertRequest
    {
        [Required]
        [MaxLength(50)]
        public string FirstName { get; set; } = string.Empty;
        
        [Required]
        [MaxLength(50)]
        public string LastName { get; set; } = string.Empty;
        
        public DateTime? DateOfBirth { get; set; }
        
        [MaxLength(500)]
        public string? Biography { get; set; }
        public byte[]? Image { get; set; }
        
        public bool IsDeleted { get; set; } = false;
    }
} 