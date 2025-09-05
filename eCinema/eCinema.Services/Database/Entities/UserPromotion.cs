using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Services.Database.Entities
{
    public class UserPromotion
    {
        [Key]
        public int Id { get; set; }
        
        [Required]
        [ForeignKey(nameof(User))]
        public int UserId { get; set; }
        public virtual User User { get; set; } = null!;
        
        [Required]
        [ForeignKey(nameof(Promotion))]
        public int PromotionId { get; set; }
        public virtual Promotion Promotion { get; set; } = null!;
        
        [Required]
        public DateTime UsedDate { get; set; }
    }
}