using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eCinema.Services.Migrations
{
    /// <inheritdoc />
    public partial class RemoveHallIdFromSeat : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Seats_Halls_HallId",
                table: "Seats");

            migrationBuilder.AlterColumn<string>(
                name: "Name",
                table: "Seats",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(50)",
                oldMaxLength: 50);

            migrationBuilder.AlterColumn<int>(
                name: "HallId",
                table: "Seats",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AddColumn<int>(
                name: "ScreeningId1",
                table: "ScreeningSeats",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "SeatId1",
                table: "ScreeningSeats",
                type: "int",
                nullable: true);

            migrationBuilder.AlterColumn<decimal>(
                name: "BasePrice",
                table: "Screenings",
                type: "decimal(18,2)",
                nullable: false,
                oldClrType: typeof(decimal),
                oldType: "decimal(10,2)");

            migrationBuilder.AlterColumn<string>(
                name: "Name",
                table: "Halls",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(50)",
                oldMaxLength: 50);

            migrationBuilder.AlterColumn<string>(
                name: "Location",
                table: "Halls",
                type: "nvarchar(200)",
                maxLength: 200,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(200)",
                oldMaxLength: 200);

            migrationBuilder.CreateIndex(
                name: "IX_ScreeningSeats_ScreeningId1",
                table: "ScreeningSeats",
                column: "ScreeningId1");

            migrationBuilder.CreateIndex(
                name: "IX_ScreeningSeats_SeatId1",
                table: "ScreeningSeats",
                column: "SeatId1");

            migrationBuilder.AddForeignKey(
                name: "FK_ScreeningSeats_Screenings_ScreeningId1",
                table: "ScreeningSeats",
                column: "ScreeningId1",
                principalTable: "Screenings",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_ScreeningSeats_Seats_SeatId1",
                table: "ScreeningSeats",
                column: "SeatId1",
                principalTable: "Seats",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Seats_Halls_HallId",
                table: "Seats",
                column: "HallId",
                principalTable: "Halls",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ScreeningSeats_Screenings_ScreeningId1",
                table: "ScreeningSeats");

            migrationBuilder.DropForeignKey(
                name: "FK_ScreeningSeats_Seats_SeatId1",
                table: "ScreeningSeats");

            migrationBuilder.DropForeignKey(
                name: "FK_Seats_Halls_HallId",
                table: "Seats");

            migrationBuilder.DropIndex(
                name: "IX_ScreeningSeats_ScreeningId1",
                table: "ScreeningSeats");

            migrationBuilder.DropIndex(
                name: "IX_ScreeningSeats_SeatId1",
                table: "ScreeningSeats");

            migrationBuilder.DropColumn(
                name: "ScreeningId1",
                table: "ScreeningSeats");

            migrationBuilder.DropColumn(
                name: "SeatId1",
                table: "ScreeningSeats");

            migrationBuilder.AlterColumn<string>(
                name: "Name",
                table: "Seats",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: false,
                defaultValue: "",
                oldClrType: typeof(string),
                oldType: "nvarchar(50)",
                oldMaxLength: 50,
                oldNullable: true);

            migrationBuilder.AlterColumn<int>(
                name: "HallId",
                table: "Seats",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AlterColumn<decimal>(
                name: "BasePrice",
                table: "Screenings",
                type: "decimal(10,2)",
                nullable: false,
                oldClrType: typeof(decimal),
                oldType: "decimal(18,2)");

            migrationBuilder.AlterColumn<string>(
                name: "Name",
                table: "Halls",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: false,
                defaultValue: "",
                oldClrType: typeof(string),
                oldType: "nvarchar(50)",
                oldMaxLength: 50,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "Location",
                table: "Halls",
                type: "nvarchar(200)",
                maxLength: 200,
                nullable: false,
                defaultValue: "",
                oldClrType: typeof(string),
                oldType: "nvarchar(200)",
                oldMaxLength: 200,
                oldNullable: true);

            migrationBuilder.AddForeignKey(
                name: "FK_Seats_Halls_HallId",
                table: "Seats",
                column: "HallId",
                principalTable: "Halls",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
