     using System.ComponentModel.DataAnnotations;

namespace eCinema.Model.Requests
{
    public class SeatUpdateRequest
    {
        [Required]
        public int HallId { get; set; }
        
        [Required]
        [Range(1, 100)]
        public int RowNumber { get; set; }
        
        [Required]
        [Range(1, 100)]
        public int SeatNumber { get; set; }
    }
}