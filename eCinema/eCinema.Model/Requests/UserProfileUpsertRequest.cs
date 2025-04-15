using System.ComponentModel.DataAnnotations;

namespace eCinema.Model.Requests
{
    public class UserProfileUpsertRequest
    {
        [Required]
        [MaxLength(50)]
        public string FirstName { get; set; }
        
        [Required]
        [MaxLength(50)]
        public string LastName { get; set; }
        
        [Required]
        [EmailAddress]
        [MaxLength(100)]
        public string Email { get; set; }
        
        [MaxLength(20)]
        public string PhoneNumber { get; set; }
        
        [MaxLength(200)]
        public string Address { get; set; }
        
        [MaxLength(50)]
        public string City { get; set; }
        
        [MaxLength(50)]
        public string Country { get; set; }
        
        [MaxLength(10)]
        public string PostalCode { get; set; }
        
        public bool IsActive { get; set; } = true;
    }
} 