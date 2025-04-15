 using System.ComponentModel.DataAnnotations;

namespace eCinema.Model.Requests
{
    public class SeatInsertRequest
    {
        [Required]
        public int HallId { get; set; }
        
        [Required]
        public int SeatTypeId { get; set; }
        
        [Required]
        [Range(1, 100)]
        public int RowNumber { get; set; }
        
        [Required]
        [Range(1, 100)]
        public int SeatNumber { get; set; }
        
        public bool IsActive { get; set; } = true;
    }
}