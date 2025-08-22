using System;
using System.ComponentModel.DataAnnotations;

namespace eCinema.Model.Requests
{
    public class HallUpsertRequest
    {
        [Required]
        [MaxLength(50)]
        public string Name { get; set; } = string.Empty;
        
        [Required]
        [Range(1, int.MaxValue)]
        public int Capacity { get; set; } = 48;
    }
} 