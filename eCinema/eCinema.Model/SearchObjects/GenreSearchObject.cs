using System;

namespace eCinema.Model.SearchObjects
{
    public class GenreSearchObject : BaseSearchObject
    {
        public string? Name { get; set; }
        public string? Description { get; set; }
        public bool? IsActive { get; set; }
    }
} 