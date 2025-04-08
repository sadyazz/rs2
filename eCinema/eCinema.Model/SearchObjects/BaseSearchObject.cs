namespace eCinema.Model.SearchObjects
{
    public class BaseSearchObject
    {

        public string? FTS {get; set;}
        public int? Page { get; set; } = 0;
        public int? PageSize { get; set; } = 10;
        public bool? IsActive { get; set; }

        public bool IncludeTotalCount {get;set;} = false;
    }
} 