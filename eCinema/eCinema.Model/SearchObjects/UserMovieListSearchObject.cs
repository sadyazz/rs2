using eCinema.Model.SearchObjects;

namespace eCinema.Model.SearchObjects
{
    public class UserMovieListSearchObject : BaseSearchObject
    {
        public int? UserId { get; set; }
        public int? MovieId { get; set; }
        public string? ListType { get; set; }
    }
} 