using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eCinema.Services.Migrations
{
    /// <inheritdoc />
    public partial class RemoveThingsFromHall : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
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
                name: "IX_Seats_HallId",
                table: "Seats");

            migrationBuilder.DropIndex(
                name: "IX_ScreeningSeats_ScreeningId1",
                table: "ScreeningSeats");

            migrationBuilder.DropIndex(
                name: "IX_ScreeningSeats_SeatId1",
                table: "ScreeningSeats");

            migrationBuilder.DropColumn(
                name: "HallId",
                table: "Seats");

            migrationBuilder.DropColumn(
                name: "ScreeningId1",
                table: "ScreeningSeats");

            migrationBuilder.DropColumn(
                name: "SeatId1",
                table: "ScreeningSeats");

            migrationBuilder.DropColumn(
                name: "Capacity",
                table: "Halls");

            migrationBuilder.DropColumn(
                name: "Location",
                table: "Halls");

            migrationBuilder.DropColumn(
                name: "ScreenType",
                table: "Halls");

            migrationBuilder.DropColumn(
                name: "SoundSystem",
                table: "Halls");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "HallId",
                table: "Seats",
                type: "int",
                nullable: true);

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

            migrationBuilder.AddColumn<int>(
                name: "Capacity",
                table: "Halls",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<string>(
                name: "Location",
                table: "Halls",
                type: "nvarchar(200)",
                maxLength: 200,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "ScreenType",
                table: "Halls",
                type: "nvarchar(100)",
                maxLength: 100,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "SoundSystem",
                table: "Halls",
                type: "nvarchar(100)",
                maxLength: 100,
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Seats_HallId",
                table: "Seats",
                column: "HallId");

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
    }
}
