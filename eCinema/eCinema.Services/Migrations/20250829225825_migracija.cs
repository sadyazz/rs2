using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eCinema.Services.Migrations
{
    /// <inheritdoc />
    public partial class migracija : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "StateMachine",
                table: "Reservations");

            migrationBuilder.DropColumn(
                name: "Capacity",
                table: "Halls");

            migrationBuilder.AddColumn<string>(
                name: "Status",
                table: "Reservations",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Status",
                table: "Reservations");

            migrationBuilder.AddColumn<string>(
                name: "StateMachine",
                table: "Reservations",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "Capacity",
                table: "Halls",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }
    }
}
