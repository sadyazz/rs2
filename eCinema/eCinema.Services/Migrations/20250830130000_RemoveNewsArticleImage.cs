using Microsoft.EntityFrameworkCore.Migrations;

namespace eCinema.Services.Migrations
{
    public partial class RemoveNewsArticleImage : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Image",
                table: "NewsArticles");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<byte[]>(
                name: "Image",
                table: "NewsArticles",
                type: "varbinary(max)",
                nullable: true);
        }
    }
}
