namespace eCinema.Model.SearchObjects
{
    public class UserSearchObject : BaseSearchObject
    {
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public string? Username { get; set; }
        public string? Email { get; set; }
        public bool? IsActive { get; set; }
        public int? RoleId { get; set; }
        
        public int? PageNumber { get; set; }
        public int? PageSize { get; set; }
    }
} 