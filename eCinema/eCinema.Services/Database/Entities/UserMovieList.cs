using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace eCinema.Services.Database.Entities
{
    public enum MovieListType
    {
        Watched,
        Watchlist,
        Favorites
    }

    public class UserMovieList
    {
        public int Id { get; set; }
        
        [Required]
        public int UserId { get; set; }
        
        [Required]
        public int MovieId { get; set; }
        
        [Required]
        [MaxLength(20)]
        public string ListType { get; set; } = string.Empty;
        
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        
        public bool IsDeleted { get; set; } = false;

        [ForeignKey(nameof(UserId))]
        public virtual User User { get; set; } = null!;
        
        [ForeignKey(nameof(MovieId))]
        public virtual Movie Movie { get; set; } = null!;

        [NotMapped]
        public MovieListType ListTypeEnum
        {
            get => Enum.TryParse<MovieListType>(ListType, true, out var result) ? result : MovieListType.Watchlist;
            set => ListType = value.ToString();
        }

        public static string GetListTypeString(MovieListType listType)
        {
            return listType.ToString().ToLower();
        }

        public static MovieListType GetListTypeFromString(string listType)
        {
            return Enum.TryParse<MovieListType>(listType, true, out var result) ? result : MovieListType.Watchlist;
        }
    }
}
