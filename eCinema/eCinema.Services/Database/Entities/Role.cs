using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace eCinema.Services.Database.Entities
{
    public class Role
    {
        public int Id { get; set; }
        
        [Required]
        [MaxLength(50)]
        public string Name { get; set; } = string.Empty;
        
        [Required]
        public bool IsActive { get; set; } = true;
        
        public ICollection<UserRole> UserRoles { get; set; } = new List<UserRole>();
    }
} 