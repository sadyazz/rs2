using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eCinema.Services.Migrations
{
    /// <inheritdoc />
    public partial class AddCapacityToHall : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "Capacity",
                table: "Halls",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Capacity",
                table: "Halls");
        }
    }
}
