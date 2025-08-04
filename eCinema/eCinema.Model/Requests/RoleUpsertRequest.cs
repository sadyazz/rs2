using System.ComponentModel.DataAnnotations;

namespace eCinema.Model.Requests
{
    public class RoleUpsertRequest
    {
        [Required]
        [MaxLength(50)]
        public string Name { get; set; } = string.Empty;
    }
} 