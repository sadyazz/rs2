namespace eCinema.Model.SearchObjects
{
    public class UserSearchObject : BaseSearchObject
    {
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public string? Username { get; set; }
        public string? Email { get; set; }
        public int? RoleId { get; set; }
    }
} 