namespace eCinema.Model.Requests;

public class UpdateUserRoleRequest
{
    public int RoleId { get; set; }
    public bool IsDeleted { get; set; }
}