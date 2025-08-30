using Microsoft.EntityFrameworkCore.Migrations;

namespace eCinema.Services.Migrations
{
    public partial class MakeMovieIsActiveNullable : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<bool>(
                name: "IsActive",
                table: "Movies",
                type: "bit",
                nullable: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<bool>(
                name: "IsActive",
                table: "Movies",
                type: "bit",
                nullable: false,
                defaultValue: true);
        }
    }
}
