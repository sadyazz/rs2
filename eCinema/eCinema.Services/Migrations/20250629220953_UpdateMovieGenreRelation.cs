﻿using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eCinema.Services.Migrations
{
    /// <inheritdoc />
    public partial class UpdateMovieGenreRelation : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Genre",
                table: "Movies");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Genre",
                table: "Movies",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: false,
                defaultValue: "");
        }
    }
}
