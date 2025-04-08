using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Services.Database.Entities
{
    public class UserProfile
    {
        public int Id { get; set; }
        
        [MaxLength(255)]
        public string? AvatarUrl { get; set; }
        
        public DateTime? DateOfBirth { get; set; }
        
        [MaxLength(100)]
        public string? Address { get; set; }
        
        [MaxLength(50)]
        public string? City { get; set; }
        
        [MaxLength(20)]
        public string? ZipCode { get; set; }
        
        [MaxLength(50)]
        public string? Country { get; set; }
        
        [MaxLength(500)]
        public string? Bio { get; set; }
        
        public bool ReceiveNotifications { get; set; } = true;
        
        public bool ReceivePromotions { get; set; } = true;
        
        // Foreign key (one-to-one with User)
        public int UserId { get; set; }
        
        // Navigation property
        [ForeignKey(nameof(UserId))]
        public virtual User User { get; set; } = null!;
    }
} 