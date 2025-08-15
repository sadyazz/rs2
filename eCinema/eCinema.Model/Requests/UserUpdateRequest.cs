using System.ComponentModel.DataAnnotations;

namespace eCinema.Model.Requests
{
    public class UserUpdateRequest
    {
        [Required]
        [MaxLength(50)]
        public string FirstName { get; set; } = string.Empty;
        
        [Required]
        [MaxLength(50)]
        public string LastName { get; set; } = string.Empty;
        
        [Required]
        [MaxLength(50)]
        public string Username { get; set; } = string.Empty;
        
        [Required]
        [EmailAddress]
        [MaxLength(100)]
        public string Email { get; set; } = string.Empty;
        
        public string? PhoneNumber { get; set; }
        
        public byte[]? Image { get; set; }
    }
}
