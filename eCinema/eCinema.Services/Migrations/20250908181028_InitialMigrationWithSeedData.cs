using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace eCinema.Services.Migrations
{
    /// <inheritdoc />
    public partial class InitialMigrationWithSeedData : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Actors",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    FirstName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    LastName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    DateOfBirth = table.Column<DateTime>(type: "datetime2", nullable: true),
                    Biography = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: true),
                    Image = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Actors", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Genres",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Genres", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Halls",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Halls", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Movies",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Title = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: false),
                    DurationMinutes = table.Column<int>(type: "int", nullable: false),
                    Director = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    ReleaseDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ReleaseYear = table.Column<int>(type: "int", nullable: false),
                    Image = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    TrailerUrl = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: true),
                    Grade = table.Column<float>(type: "real", nullable: false),
                    IsComingSoon = table.Column<bool>(type: "bit", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Movies", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Promotions",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: false),
                    Code = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: true),
                    DiscountPercentage = table.Column<decimal>(type: "decimal(5,2)", nullable: false),
                    StartDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    EndDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Promotions", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Roles",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Roles", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "ScreeningFormats",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: true),
                    PriceMultiplier = table.Column<decimal>(type: "decimal(10,2)", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ScreeningFormats", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Seats",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Seats", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "StripePayments",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Amount = table.Column<decimal>(type: "decimal(10,2)", nullable: true),
                    TransactionId = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    PaymentDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    PaymentProvider = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_StripePayments", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "MovieActors",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    CharacterName = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    Role = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: true),
                    MovieId = table.Column<int>(type: "int", nullable: false),
                    ActorId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MovieActors", x => x.Id);
                    table.ForeignKey(
                        name: "FK_MovieActors_Actors_ActorId",
                        column: x => x.ActorId,
                        principalTable: "Actors",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_MovieActors_Movies_MovieId",
                        column: x => x.MovieId,
                        principalTable: "Movies",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "MovieGenres",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    MovieId = table.Column<int>(type: "int", nullable: false),
                    GenreId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MovieGenres", x => x.Id);
                    table.ForeignKey(
                        name: "FK_MovieGenres_Genres_GenreId",
                        column: x => x.GenreId,
                        principalTable: "Genres",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_MovieGenres_Movies_MovieId",
                        column: x => x.MovieId,
                        principalTable: "Movies",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Users",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    FirstName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    LastName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Username = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Email = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    PasswordHash = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PasswordSalt = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    PhoneNumber = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    DateOfBirth = table.Column<DateTime>(type: "datetime2", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    LastModifiedAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    ReceiveNotifications = table.Column<bool>(type: "bit", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    Image = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    RoleId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Users", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Users_Roles_RoleId",
                        column: x => x.RoleId,
                        principalTable: "Roles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Screenings",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    StartTime = table.Column<DateTime>(type: "datetime2", nullable: false),
                    EndTime = table.Column<DateTime>(type: "datetime2", nullable: false),
                    BasePrice = table.Column<decimal>(type: "decimal(10,2)", nullable: false),
                    Language = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    HasSubtitles = table.Column<bool>(type: "bit", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    MovieId = table.Column<int>(type: "int", nullable: false),
                    HallId = table.Column<int>(type: "int", nullable: false),
                    ScreeningFormatId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Screenings", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Screenings_Halls_HallId",
                        column: x => x.HallId,
                        principalTable: "Halls",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Screenings_Movies_MovieId",
                        column: x => x.MovieId,
                        principalTable: "Movies",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Screenings_ScreeningFormats_ScreeningFormatId",
                        column: x => x.ScreeningFormatId,
                        principalTable: "ScreeningFormats",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.SetNull);
                });

            migrationBuilder.CreateTable(
                name: "NewsArticles",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Title = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Content = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PublishDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    Type = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    EventDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    AuthorId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_NewsArticles", x => x.Id);
                    table.ForeignKey(
                        name: "FK_NewsArticles_Users_AuthorId",
                        column: x => x.AuthorId,
                        principalTable: "Users",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Reviews",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Rating = table.Column<int>(type: "int", nullable: false),
                    Comment = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ModifiedAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    IsSpoiler = table.Column<bool>(type: "bit", nullable: false),
                    IsEdited = table.Column<bool>(type: "bit", nullable: false),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    MovieId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Reviews", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Reviews_Movies_MovieId",
                        column: x => x.MovieId,
                        principalTable: "Movies",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Reviews_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "UserMovieLists",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    MovieId = table.Column<int>(type: "int", nullable: false),
                    ListType = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserMovieLists", x => x.Id);
                    table.ForeignKey(
                        name: "FK_UserMovieLists_Movies_MovieId",
                        column: x => x.MovieId,
                        principalTable: "Movies",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_UserMovieLists_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "UserPromotions",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    PromotionId = table.Column<int>(type: "int", nullable: false),
                    UsedDate = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserPromotions", x => x.Id);
                    table.ForeignKey(
                        name: "FK_UserPromotions_Promotions_PromotionId",
                        column: x => x.PromotionId,
                        principalTable: "Promotions",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_UserPromotions_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Reservations",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ReservationTime = table.Column<DateTime>(type: "datetime2", nullable: false),
                    TotalPrice = table.Column<decimal>(type: "decimal(10,2)", nullable: false),
                    OriginalPrice = table.Column<decimal>(type: "decimal(10,2)", nullable: true),
                    DiscountPercentage = table.Column<decimal>(type: "decimal(5,2)", nullable: true),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    ScreeningId = table.Column<int>(type: "int", nullable: false),
                    PaymentId = table.Column<int>(type: "int", nullable: true),
                    PromotionId = table.Column<int>(type: "int", nullable: true),
                    NumberOfTickets = table.Column<int>(type: "int", nullable: true),
                    PaymentType = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    State = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    QrcodeBase64 = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Reservations", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Reservations_Promotions_PromotionId",
                        column: x => x.PromotionId,
                        principalTable: "Promotions",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.SetNull);
                    table.ForeignKey(
                        name: "FK_Reservations_Screenings_ScreeningId",
                        column: x => x.ScreeningId,
                        principalTable: "Screenings",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Reservations_StripePayments_PaymentId",
                        column: x => x.PaymentId,
                        principalTable: "StripePayments",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.SetNull);
                    table.ForeignKey(
                        name: "FK_Reservations_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "ScreeningSeats",
                columns: table => new
                {
                    ScreeningId = table.Column<int>(type: "int", nullable: false),
                    SeatId = table.Column<int>(type: "int", nullable: false),
                    IsReserved = table.Column<bool>(type: "bit", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ScreeningSeats", x => new { x.ScreeningId, x.SeatId });
                    table.ForeignKey(
                        name: "FK_ScreeningSeats_Screenings_ScreeningId",
                        column: x => x.ScreeningId,
                        principalTable: "Screenings",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ScreeningSeats_Seats_SeatId",
                        column: x => x.SeatId,
                        principalTable: "Seats",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "ReservationSeats",
                columns: table => new
                {
                    ReservationId = table.Column<int>(type: "int", nullable: false),
                    SeatId = table.Column<int>(type: "int", nullable: false),
                    ReservedAt = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ReservationSeats", x => new { x.ReservationId, x.SeatId });
                    table.ForeignKey(
                        name: "FK_ReservationSeats_Reservations_ReservationId",
                        column: x => x.ReservationId,
                        principalTable: "Reservations",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ReservationSeats_Seats_SeatId",
                        column: x => x.SeatId,
                        principalTable: "Seats",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.InsertData(
                table: "Actors",
                columns: new[] { "Id", "Biography", "DateOfBirth", "FirstName", "Image", "IsDeleted", "LastName" },
                values: new object[,]
                {
                    { 1, "English actress known for roles in Pride & Prejudice, Atonement, and Pirates of the Caribbean.", new DateTime(1985, 3, 26, 0, 0, 0, 0, DateTimeKind.Unspecified), "Keira", null, false, "Knightley" },
                    { 2, "British actor, acclaimed for Succession, Pride & Prejudice, and Ripper Street.", new DateTime(1974, 10, 17, 0, 0, 0, 0, DateTimeKind.Unspecified), "Matthew", null, false, "Macfadyen" },
                    { 3, "English actress, Golden Globe winner, known for Gone Girl and Pride & Prejudice.", new DateTime(1979, 1, 27, 0, 0, 0, 0, DateTimeKind.Unspecified), "Rosamund", null, false, "Pike" },
                    { 4, "American actress and voice actress for Coraline Jones.", new DateTime(1994, 2, 23, 0, 0, 0, 0, DateTimeKind.Unspecified), "Dakota", null, false, "Fanning" },
                    { 5, "American actress, known for Desperate Housewives and the voice of Mel Jones in Coraline.", new DateTime(1964, 12, 8, 0, 0, 0, 0, DateTimeKind.Unspecified), "Teri", null, false, "Hatcher" },
                    { 6, "Canadian actor and producer, best known for his role as Deadpool in the Marvel franchise.", new DateTime(1976, 10, 23, 0, 0, 0, 0, DateTimeKind.Unspecified), "Ryan", null, false, "Reynolds" },
                    { 7, "Australian actor, singer, and producer, widely recognized for portraying Wolverine in the X-Men film series.", new DateTime(1968, 10, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), "Hugh", null, false, "Jackman" },
                    { 10, "Irish actor known for Peaky Blinders, Inception, and portraying J. Robert Oppenheimer in Christopher Nolan's Oppenheimer.", new DateTime(1976, 5, 25, 0, 0, 0, 0, DateTimeKind.Unspecified), "Cillian", null, false, "Murphy" },
                    { 11, "American actor and producer, acclaimed for his roles in Iron Man, Sherlock Holmes, and Oppenheimer.", new DateTime(1965, 4, 4, 0, 0, 0, 0, DateTimeKind.Unspecified), "Robert", null, false, "Downey Jr." },
                    { 12, "Australian actress and producer, known for The Wolf of Wall Street, I, Tonya, and Barbie.", new DateTime(1990, 7, 2, 0, 0, 0, 0, DateTimeKind.Unspecified), "Margot", null, false, "Robbie" },
                    { 13, "Canadian actor and musician, known for La La Land, Drive, and his role as Ken in Barbie.", new DateTime(1980, 11, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), "Ryan", null, false, "Gosling" }
                });

            migrationBuilder.InsertData(
                table: "Genres",
                columns: new[] { "Id", "Description", "IsDeleted", "Name" },
                values: new object[,]
                {
                    { 1, "", false, "Action" },
                    { 2, "", false, "Adventure" },
                    { 3, "", false, "Animation" },
                    { 4, "", false, "Comedy" },
                    { 5, "", false, "Crime" },
                    { 6, "", false, "Documentary" },
                    { 7, "", false, "Drama" },
                    { 8, "", false, "Fantasy" },
                    { 9, "", false, "Horror" },
                    { 10, "", false, "Mystery" },
                    { 11, "", false, "Romance" },
                    { 12, "", false, "Science Fiction" },
                    { 13, "", false, "Thriller" },
                    { 14, "test", false, "test soft deleted genre" }
                });

            migrationBuilder.InsertData(
                table: "Halls",
                columns: new[] { "Id", "IsDeleted", "Name" },
                values: new object[,]
                {
                    { 2, false, "Kids hall" },
                    { 3, false, "Hall 1" },
                    { 4, false, "Hall 2" },
                    { 5, false, "4DX Hall" }
                });

            migrationBuilder.InsertData(
                table: "Movies",
                columns: new[] { "Id", "Description", "Director", "DurationMinutes", "Grade", "Image", "IsComingSoon", "IsDeleted", "ReleaseDate", "ReleaseYear", "Title", "TrailerUrl" },
                values: new object[,]
                {
                    { 3, "Sparks fly when spirited Elizabeth Bennet meets single, rich, and proud Mr. Darcy. But pride, prejudice and misunderstandings threaten to keep them apart.", "Joe Wright", 129, 5f, null, false, false, new DateTime(2005, 9, 16, 0, 0, 0, 0, DateTimeKind.Unspecified), 2005, "Pride and Prejudice", "https://www.youtube.com/watch?v=1dYv5u6v55Y" },
                    { 4, "An adventurous girl finds another world that is a strangely idealized version of her frustrating home, but it has sinister secrets.", "Henry Selick", 100, 5f, null, false, false, new DateTime(2009, 2, 6, 0, 0, 0, 0, DateTimeKind.Unspecified), 2009, "Coraline", "https://www.youtube.com/watch?v=LO3n67BQvh0" },
                    { 5, "Wolverine is recovering from his injuries when he crosses paths with the loudmouth Deadpool. They team up to defeat a common enemy.", "Shawn Levy", 127, 5f, null, false, false, new DateTime(2024, 7, 26, 0, 0, 0, 0, DateTimeKind.Unspecified), 2024, "Deadpool & Wolverine", "https://www.youtube.com/watch?v=73_1biulkYk" },
                    { 11, "A romantic drama that follows the consequences of a false accusation that forever changes the lives of two lovers and a young girl.", "Joe Wright", 123, 0f, null, true, false, new DateTime(2025, 12, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 2007, "Atonement", "https://www.youtube.com/watch?v=rkVg3jWToW0" },
                    { 12, "Logan travels to Japan, where he confronts his past and faces a deadly battle that will change him forever.", "James Mangold", 126, 0f, null, true, false, new DateTime(2025, 12, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), 2013, "The Wolverine", "https://www.youtube.com/watch?v=th1NTVIhUQU" }
                });

            migrationBuilder.InsertData(
                table: "Promotions",
                columns: new[] { "Id", "Code", "Description", "DiscountPercentage", "EndDate", "IsDeleted", "Name", "StartDate" },
                values: new object[,]
                {
                    { 2, "899", "Welcoming all our new users with a 20% discount on their first purchase.", 20m, new DateTime(2025, 10, 31, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "New user promotion", new DateTime(2025, 9, 4, 0, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 3, "50", "50% off", 50m, new DateTime(2025, 10, 31, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "eCinema Summer Promotion", new DateTime(2025, 9, 5, 0, 0, 0, 670, DateTimeKind.Unspecified) },
                    { 4, "SEP5", "5% discount on all tickets in September.", 5m, new DateTime(2025, 9, 30, 23, 59, 59, 0, DateTimeKind.Unspecified), false, "September Sale", new DateTime(2025, 9, 1, 0, 0, 0, 0, DateTimeKind.Unspecified) }
                });

            migrationBuilder.InsertData(
                table: "Roles",
                columns: new[] { "Id", "Name" },
                values: new object[,]
                {
                    { 1, "admin" },
                    { 2, "user" },
                    { 3, "staff" }
                });

            migrationBuilder.InsertData(
                table: "ScreeningFormats",
                columns: new[] { "Id", "Description", "IsDeleted", "Name", "PriceMultiplier" },
                values: new object[,]
                {
                    { 1, "Standard digital projection", false, "2D", 1.0m },
                    { 2, "Immersive 3D experience with special glasses", false, "3D", 1.3m },
                    { 3, "Premium large-format experience with enhanced picture and sound", false, "IMAX", 1.8m },
                    { 4, "Motion seats and environmental effects synchronized with the movie", false, "4DX", 2.0m }
                });

            migrationBuilder.InsertData(
                table: "Seats",
                columns: new[] { "Id", "Name" },
                values: new object[,]
                {
                    { 1, "A1" },
                    { 2, "A2" },
                    { 3, "A3" },
                    { 4, "A4" },
                    { 5, "A5" },
                    { 6, "A6" },
                    { 7, "A7" },
                    { 8, "A8" },
                    { 9, "B1" },
                    { 10, "B2" },
                    { 11, "B3" },
                    { 12, "B4" },
                    { 13, "B5" },
                    { 14, "B6" },
                    { 15, "B7" },
                    { 16, "B8" },
                    { 17, "C1" },
                    { 18, "C2" },
                    { 19, "C3" },
                    { 20, "C4" },
                    { 21, "C5" },
                    { 22, "C6" },
                    { 23, "C7" },
                    { 24, "C8" },
                    { 25, "D1" },
                    { 26, "D2" },
                    { 27, "D3" },
                    { 28, "D4" },
                    { 29, "D5" },
                    { 30, "D6" },
                    { 31, "D7" },
                    { 32, "D8" },
                    { 33, "E1" },
                    { 34, "E2" },
                    { 35, "E3" },
                    { 36, "E4" },
                    { 37, "E5" },
                    { 38, "E6" },
                    { 39, "E7" },
                    { 40, "E8" },
                    { 41, "F1" },
                    { 42, "F2" },
                    { 43, "F3" },
                    { 44, "F4" },
                    { 45, "F5" },
                    { 46, "F6" },
                    { 47, "F7" },
                    { 48, "F8" }
                });

            migrationBuilder.InsertData(
                table: "MovieActors",
                columns: new[] { "Id", "ActorId", "CharacterName", "MovieId", "Role" },
                values: new object[,]
                {
                    { 1, 1, null, 3, null },
                    { 2, 2, null, 3, null },
                    { 3, 3, null, 3, null },
                    { 4, 4, null, 4, null },
                    { 5, 5, null, 4, null },
                    { 6, 6, null, 5, null },
                    { 7, 7, null, 5, null },
                    { 8, 1, null, 11, null },
                    { 9, 3, null, 11, null },
                    { 10, 7, null, 12, null }
                });

            migrationBuilder.InsertData(
                table: "MovieGenres",
                columns: new[] { "Id", "GenreId", "MovieId" },
                values: new object[,]
                {
                    { 1, 7, 3 },
                    { 2, 11, 3 },
                    { 3, 3, 4 },
                    { 4, 9, 4 },
                    { 5, 1, 5 },
                    { 6, 4, 5 },
                    { 7, 2, 11 },
                    { 8, 11, 11 },
                    { 9, 1, 12 }
                });

            migrationBuilder.InsertData(
                table: "Screenings",
                columns: new[] { "Id", "BasePrice", "EndTime", "HallId", "HasSubtitles", "IsDeleted", "Language", "MovieId", "ScreeningFormatId", "StartTime" },
                values: new object[,]
                {
                    { 1, 5.00m, new DateTime(2025, 9, 8, 18, 0, 0, 0, DateTimeKind.Unspecified), 3, false, false, "English", 4, 1, new DateTime(2025, 9, 8, 16, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 2, 5.00m, new DateTime(2025, 9, 8, 18, 0, 0, 0, DateTimeKind.Unspecified), 3, false, false, "English", 3, 2, new DateTime(2025, 9, 8, 17, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 3, 10.00m, new DateTime(2025, 9, 8, 20, 0, 0, 0, DateTimeKind.Unspecified), 3, false, false, "English", 5, 1, new DateTime(2025, 9, 8, 18, 20, 0, 0, DateTimeKind.Unspecified) },
                    { 4, 5.00m, new DateTime(2025, 9, 8, 21, 0, 0, 0, DateTimeKind.Unspecified), 5, false, false, "English", 5, 4, new DateTime(2025, 10, 8, 19, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 5, 3.00m, new DateTime(2025, 9, 30, 14, 0, 0, 0, DateTimeKind.Unspecified), 2, true, false, "English", 4, 2, new DateTime(2025, 9, 30, 12, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 6, 5.00m, new DateTime(2025, 9, 29, 15, 0, 0, 0, DateTimeKind.Unspecified), 4, false, false, "English", 3, 1, new DateTime(2025, 9, 29, 13, 0, 0, 0, DateTimeKind.Unspecified) }
                });

            migrationBuilder.InsertData(
                table: "Users",
                columns: new[] { "Id", "CreatedAt", "DateOfBirth", "Email", "FirstName", "Image", "IsDeleted", "LastModifiedAt", "LastName", "PasswordHash", "PasswordSalt", "PhoneNumber", "ReceiveNotifications", "RoleId", "Username" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "admin@ecinema.com", "Admin", null, false, null, "User", "6EqP+3jBodPH1qKpQDCsf+2BUV5iJqY5NDC+rWpfFKw=", "bw7nttYe6MqZzgQhTB1LXQ==", null, true, 1, "admin" },
                    { 2, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "user1@ecinema.com", "User", null, false, null, "One", "6EqP+3jBodPH1qKpQDCsf+2BUV5iJqY5NDC+rWpfFKw=", "bw7nttYe6MqZzgQhTB1LXQ==", null, true, 2, "user1" },
                    { 3, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "user2@ecinema.com", "User", null, false, null, "Two", "6EqP+3jBodPH1qKpQDCsf+2BUV5iJqY5NDC+rWpfFKw=", "bw7nttYe6MqZzgQhTB1LXQ==", null, true, 2, "user2" },
                    { 4, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "staff@ecinema.com", "Staff", null, false, null, "User", "6EqP+3jBodPH1qKpQDCsf+2BUV5iJqY5NDC+rWpfFKw=", "bw7nttYe6MqZzgQhTB1LXQ==", null, true, 3, "staff" }
                });

            migrationBuilder.InsertData(
                table: "NewsArticles",
                columns: new[] { "Id", "AuthorId", "Content", "EventDate", "IsDeleted", "PublishDate", "Title", "Type" },
                values: new object[,]
                {
                    { 1, 1, "Get ready for a spooky night at the cinema! Coraline is back on the big screen in stunning 3D, just in time for Halloween. Don't miss the chance to experience this animated classic like never before.", null, false, new DateTime(2025, 8, 15, 18, 0, 0, 0, DateTimeKind.Unspecified), "Coraline Returns for a Halloween 3D Special", "news" },
                    { 3, 1, "The wait is almost over! Deadpool & Wolverine hits theaters next month. Secure your tickets today and be among the first to see Marvel's most chaotic duo on the big screen.", null, false, new DateTime(2025, 7, 10, 12, 0, 0, 0, DateTimeKind.Unspecified), "Deadpool & Wolverine Premieres Next Month – Tickets on Sale Now!", "news" },
                    { 4, 1, "Barbie has become a global phenomenon, smashing box office records and charming audiences everywhere. Don't miss your chance to watch the year's most talked-about film on the big screen.", null, false, new DateTime(2025, 8, 1, 10, 0, 0, 0, DateTimeKind.Unspecified), "Barbie Breaks Box Office Records Worldwide", "news" },
                    { 5, 1, "Join us for a special screening of Pride and Prejudice, the timeless romantic drama that continues to capture hearts around the world. A perfect evening for fans of classic cinema and unforgettable love stories.", null, false, new DateTime(2025, 8, 20, 19, 0, 0, 0, DateTimeKind.Unspecified), "Romantic Classics Night: Pride and Prejudice Returns", "news" },
                    { 7, 1, "Join us for a special screening of Atonement, the timeless romantic drama that continues to capture hearts around the world. A perfect evening for fans of classic cinema and unforgettable love stories.", new DateTime(2025, 9, 18, 12, 0, 0, 0, DateTimeKind.Unspecified), false, new DateTime(2025, 9, 4, 18, 37, 25, 39, DateTimeKind.Unspecified), "Atonement Returns for a Special Screening", "event" },
                    { 8, 1, "Premiere Date for the Wolverine sequel has been announced. Don't miss your chance to see the movie on the big screen.", null, false, new DateTime(2025, 9, 4, 19, 10, 44, 5, DateTimeKind.Unspecified), "The Wolverine: Premiere Date Announced", "news" },
                    { 9, 1, "Get ready for an epic summer movie marathon! We've curated a lineup of classic and contemporary films that are perfect for a relaxing weekend at the cinema.", new DateTime(2025, 9, 30, 12, 0, 0, 0, DateTimeKind.Unspecified), false, new DateTime(2025, 9, 4, 19, 11, 28, 554, DateTimeKind.Unspecified), "Summer Movie Marathon Announced", "event" }
                });

            migrationBuilder.InsertData(
                table: "Reservations",
                columns: new[] { "Id", "DiscountPercentage", "IsDeleted", "NumberOfTickets", "OriginalPrice", "PaymentId", "PaymentType", "PromotionId", "QrcodeBase64", "ReservationTime", "ScreeningId", "State", "TotalPrice", "UserId" },
                values: new object[,]
                {
                    { 1, null, false, 2, 10.00m, null, "Cash", null, "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", new DateTime(2024, 9, 8, 15, 0, 0, 0, DateTimeKind.Unspecified), 1, "UsedReservationState", 10.00m, 2 },
                    { 2, null, false, 1, 5.00m, null, null, null, "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", new DateTime(2025, 9, 8, 15, 45, 6, 721, DateTimeKind.Unspecified), 3, "ApprovedReservationState", 5.00m, 3 }
                });

            migrationBuilder.InsertData(
                table: "Reviews",
                columns: new[] { "Id", "Comment", "CreatedAt", "IsDeleted", "IsEdited", "IsSpoiler", "ModifiedAt", "MovieId", "Rating", "UserId" },
                values: new object[,]
                {
                    { 1, "A beautiful adaptation of the classic novel. The cinematography and performances are outstanding.", new DateTime(2025, 9, 2, 0, 0, 0, 0, DateTimeKind.Unspecified), false, false, false, null, 3, 5, 2 },
                    { 2, "Visually stunning and delightfully creepy. Perfect for both kids and adults.", new DateTime(2025, 9, 2, 0, 0, 0, 0, DateTimeKind.Unspecified), false, false, false, null, 4, 4, 2 },
                    { 3, "A classic romance brought to life with excellent performances.", new DateTime(2025, 9, 2, 0, 0, 0, 0, DateTimeKind.Unspecified), false, false, false, null, 3, 4, 3 },
                    { 4, "The perfect blend of action and humor. Great chemistry between the leads!", new DateTime(2025, 9, 2, 0, 0, 0, 0, DateTimeKind.Unspecified), false, false, false, null, 5, 5, 3 }
                });

            migrationBuilder.InsertData(
                table: "UserMovieLists",
                columns: new[] { "Id", "CreatedAt", "IsDeleted", "ListType", "MovieId", "UserId" },
                values: new object[,]
                {
                    { 3, new DateTime(2025, 9, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "watched", 3, 2 },
                    { 4, new DateTime(2025, 9, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "watched", 4, 2 },
                    { 5, new DateTime(2025, 9, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "favorites", 11, 2 },
                    { 6, new DateTime(2025, 9, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "watchlist", 12, 2 },
                    { 7, new DateTime(2025, 9, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "watched", 3, 3 },
                    { 8, new DateTime(2025, 9, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "watched", 5, 3 },
                    { 9, new DateTime(2025, 9, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "favorites", 11, 3 },
                    { 10, new DateTime(2025, 9, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "watchlist", 4, 3 }
                });

            migrationBuilder.InsertData(
                table: "ReservationSeats",
                columns: new[] { "ReservationId", "SeatId", "ReservedAt" },
                values: new object[,]
                {
                    { 1, 1, new DateTime(2024, 3, 14, 10, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 1, 2, new DateTime(2024, 3, 14, 10, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 2, 10, new DateTime(2025, 9, 8, 15, 45, 6, 721, DateTimeKind.Unspecified) }
                });

            migrationBuilder.CreateIndex(
                name: "IX_Actors_FirstName_LastName",
                table: "Actors",
                columns: new[] { "FirstName", "LastName" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_MovieActors_ActorId",
                table: "MovieActors",
                column: "ActorId");

            migrationBuilder.CreateIndex(
                name: "IX_MovieActors_MovieId",
                table: "MovieActors",
                column: "MovieId");

            migrationBuilder.CreateIndex(
                name: "IX_MovieGenres_GenreId",
                table: "MovieGenres",
                column: "GenreId");

            migrationBuilder.CreateIndex(
                name: "IX_MovieGenres_MovieId",
                table: "MovieGenres",
                column: "MovieId");

            migrationBuilder.CreateIndex(
                name: "IX_NewsArticles_AuthorId",
                table: "NewsArticles",
                column: "AuthorId");

            migrationBuilder.CreateIndex(
                name: "IX_Promotions_Code",
                table: "Promotions",
                column: "Code",
                unique: true,
                filter: "[Code] IS NOT NULL");

            migrationBuilder.CreateIndex(
                name: "IX_Reservations_PaymentId",
                table: "Reservations",
                column: "PaymentId",
                unique: true,
                filter: "[PaymentId] IS NOT NULL");

            migrationBuilder.CreateIndex(
                name: "IX_Reservations_PromotionId",
                table: "Reservations",
                column: "PromotionId");

            migrationBuilder.CreateIndex(
                name: "IX_Reservations_ScreeningId",
                table: "Reservations",
                column: "ScreeningId");

            migrationBuilder.CreateIndex(
                name: "IX_Reservations_UserId",
                table: "Reservations",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_ReservationSeats_SeatId",
                table: "ReservationSeats",
                column: "SeatId");

            migrationBuilder.CreateIndex(
                name: "IX_Reviews_MovieId",
                table: "Reviews",
                column: "MovieId");

            migrationBuilder.CreateIndex(
                name: "IX_Reviews_UserId_MovieId",
                table: "Reviews",
                columns: new[] { "UserId", "MovieId" },
                unique: true,
                filter: "IsDeleted = 0");

            migrationBuilder.CreateIndex(
                name: "IX_Roles_Name",
                table: "Roles",
                column: "Name",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Screenings_HallId",
                table: "Screenings",
                column: "HallId");

            migrationBuilder.CreateIndex(
                name: "IX_Screenings_MovieId",
                table: "Screenings",
                column: "MovieId");

            migrationBuilder.CreateIndex(
                name: "IX_Screenings_ScreeningFormatId",
                table: "Screenings",
                column: "ScreeningFormatId");

            migrationBuilder.CreateIndex(
                name: "IX_ScreeningSeats_SeatId",
                table: "ScreeningSeats",
                column: "SeatId");

            migrationBuilder.CreateIndex(
                name: "IX_UserMovieLists_MovieId",
                table: "UserMovieLists",
                column: "MovieId");

            migrationBuilder.CreateIndex(
                name: "IX_UserMovieLists_UserId_MovieId_ListType",
                table: "UserMovieLists",
                columns: new[] { "UserId", "MovieId", "ListType" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_UserPromotions_PromotionId",
                table: "UserPromotions",
                column: "PromotionId");

            migrationBuilder.CreateIndex(
                name: "IX_UserPromotions_UserId_PromotionId",
                table: "UserPromotions",
                columns: new[] { "UserId", "PromotionId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Users_Email",
                table: "Users",
                column: "Email",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Users_RoleId",
                table: "Users",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "IX_Users_Username",
                table: "Users",
                column: "Username",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "MovieActors");

            migrationBuilder.DropTable(
                name: "MovieGenres");

            migrationBuilder.DropTable(
                name: "NewsArticles");

            migrationBuilder.DropTable(
                name: "ReservationSeats");

            migrationBuilder.DropTable(
                name: "Reviews");

            migrationBuilder.DropTable(
                name: "ScreeningSeats");

            migrationBuilder.DropTable(
                name: "UserMovieLists");

            migrationBuilder.DropTable(
                name: "UserPromotions");

            migrationBuilder.DropTable(
                name: "Actors");

            migrationBuilder.DropTable(
                name: "Genres");

            migrationBuilder.DropTable(
                name: "Reservations");

            migrationBuilder.DropTable(
                name: "Seats");

            migrationBuilder.DropTable(
                name: "Promotions");

            migrationBuilder.DropTable(
                name: "Screenings");

            migrationBuilder.DropTable(
                name: "StripePayments");

            migrationBuilder.DropTable(
                name: "Users");

            migrationBuilder.DropTable(
                name: "Halls");

            migrationBuilder.DropTable(
                name: "Movies");

            migrationBuilder.DropTable(
                name: "ScreeningFormats");

            migrationBuilder.DropTable(
                name: "Roles");
        }
    }
}
