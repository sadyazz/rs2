namespace eCinema.Model.SearchObjects
{
    public class BaseSearchObject
    {

        public string? FTS {get; set;}
        public int? Page { get; set; }
        public int? PageSize { get; set; }

        public bool IncludeTotalCount {get;set;} = false;
        public bool IncludeDeleted { get; set; } = false;
    }
} 