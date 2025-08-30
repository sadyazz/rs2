using Microsoft.EntityFrameworkCore.Migrations;

namespace eCinema.Services.Migrations
{
    public partial class RemoveHallIsActive : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "IsActive",
                table: "Halls");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "IsActive",
                table: "Halls",
                type: "bit",
                nullable: true,
                defaultValue: true);
        }
    }
}
