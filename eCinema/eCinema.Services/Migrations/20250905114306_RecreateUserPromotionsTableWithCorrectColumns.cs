using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eCinema.Services.Migrations
{
    /// <inheritdoc />
    public partial class RecreateUserPromotionsTableWithCorrectColumns : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_UserPromotions_Promotions_PromotionId",
                table: "UserPromotions");

            migrationBuilder.DropForeignKey(
                name: "FK_UserPromotions_Promotions_PromotionId1",
                table: "UserPromotions");

            migrationBuilder.DropForeignKey(
                name: "FK_UserPromotions_Users_UserId",
                table: "UserPromotions");

            migrationBuilder.DropForeignKey(
                name: "FK_UserPromotions_Users_UserId1",
                table: "UserPromotions");

            migrationBuilder.DropIndex(
                name: "IX_UserPromotions_PromotionId1",
                table: "UserPromotions");

            migrationBuilder.DropIndex(
                name: "IX_UserPromotions_UserId1",
                table: "UserPromotions");

            migrationBuilder.DropColumn(
                name: "PromotionId1",
                table: "UserPromotions");

            migrationBuilder.DropColumn(
                name: "UserId1",
                table: "UserPromotions");

            migrationBuilder.AddForeignKey(
                name: "FK_UserPromotions_Promotions_PromotionId",
                table: "UserPromotions",
                column: "PromotionId",
                principalTable: "Promotions",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_UserPromotions_Users_UserId",
                table: "UserPromotions",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_UserPromotions_Promotions_PromotionId",
                table: "UserPromotions");

            migrationBuilder.DropForeignKey(
                name: "FK_UserPromotions_Users_UserId",
                table: "UserPromotions");

            migrationBuilder.AddColumn<int>(
                name: "PromotionId1",
                table: "UserPromotions",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "UserId1",
                table: "UserPromotions",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_UserPromotions_PromotionId1",
                table: "UserPromotions",
                column: "PromotionId1");

            migrationBuilder.CreateIndex(
                name: "IX_UserPromotions_UserId1",
                table: "UserPromotions",
                column: "UserId1");

            migrationBuilder.AddForeignKey(
                name: "FK_UserPromotions_Promotions_PromotionId",
                table: "UserPromotions",
                column: "PromotionId",
                principalTable: "Promotions",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_UserPromotions_Promotions_PromotionId1",
                table: "UserPromotions",
                column: "PromotionId1",
                principalTable: "Promotions",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_UserPromotions_Users_UserId",
                table: "UserPromotions",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_UserPromotions_Users_UserId1",
                table: "UserPromotions",
                column: "UserId1",
                principalTable: "Users",
                principalColumn: "Id");
        }
    }
}
