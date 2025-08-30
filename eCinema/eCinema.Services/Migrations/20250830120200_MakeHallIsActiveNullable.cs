using Microsoft.EntityFrameworkCore.Migrations;

namespace eCinema.Services.Migrations
{
    public partial class MakeHallIsActiveNullable : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<bool>(
                name: "IsActive",
                table: "Halls",
                type: "bit",
                nullable: true,
                defaultValue: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<bool>(
                name: "IsActive",
                table: "Halls",
                type: "bit",
                nullable: false);
        }
    }
}
