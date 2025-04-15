using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Services.Database.Entities
{
    public class User
    {
        public int Id { get; set; }
        
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
        
        [Required]
        public string PasswordHash { get; set; } = string.Empty;
        
        public string? PasswordSalt { get; set; }
        
        public string? PhoneNumber { get; set; }
        
        public DateTime? DateOfBirth { get; set; }
        
        public bool IsActive { get; set; } = true;
        
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        
        public DateTime? LastModifiedAt { get; set; }
        
        public bool ReceiveNotifications { get; set; } = true;

        public bool isDeleted { get; set; } = false;

        public virtual ICollection<UserRole> UserRoles { get; set; } = new List<UserRole>();
        
        // Navigation properties
        // public virtual ICollection<Reservation> Reservations { get; set; } = new HashSet<Reservation>();
        // public virtual ICollection<Review> Reviews { get; set; } = new HashSet<Review>();
        // public virtual ICollection<NewsArticle> NewsArticles { get; set; } = new HashSet<NewsArticle>();
    }
} 