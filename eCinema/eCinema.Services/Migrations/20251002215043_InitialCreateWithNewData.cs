using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace eCinema.Services.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreateWithNewData : Migration
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
                    { 3, "50", "50% off", 50m, new DateTime(2025, 11, 30, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "Fall Promotion", new DateTime(2025, 9, 20, 0, 0, 0, 670, DateTimeKind.Unspecified) },
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
                    { 4, 5.00m, new DateTime(2025, 10, 8, 21, 0, 0, 0, DateTimeKind.Unspecified), 5, false, false, "English", 5, 4, new DateTime(2025, 10, 8, 19, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 5, 3.00m, new DateTime(2025, 9, 30, 14, 0, 0, 0, DateTimeKind.Unspecified), 2, true, false, "English", 4, 2, new DateTime(2025, 9, 30, 12, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 6, 5.00m, new DateTime(2025, 9, 29, 15, 0, 0, 0, DateTimeKind.Unspecified), 4, false, false, "English", 3, 1, new DateTime(2025, 9, 29, 13, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 7, 5.00m, new DateTime(2025, 10, 5, 20, 0, 0, 0, DateTimeKind.Unspecified), 3, false, false, "English", 3, 1, new DateTime(2025, 10, 5, 18, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 8, 5.00m, new DateTime(2025, 10, 6, 20, 0, 0, 0, DateTimeKind.Unspecified), 4, false, false, "English", 3, 1, new DateTime(2025, 10, 6, 18, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 9, 4.00m, new DateTime(2025, 10, 7, 18, 0, 0, 0, DateTimeKind.Unspecified), 2, false, false, "English", 4, 1, new DateTime(2025, 10, 7, 16, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 10, 6.00m, new DateTime(2025, 10, 6, 22, 0, 0, 0, DateTimeKind.Unspecified), 2, false, false, "English", 4, 2, new DateTime(2025, 10, 6, 20, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 11, 10.00m, new DateTime(2025, 10, 8, 23, 0, 0, 0, DateTimeKind.Unspecified), 5, false, false, "English", 5, 4, new DateTime(2025, 10, 8, 21, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 12, 6.00m, new DateTime(2025, 10, 9, 16, 0, 0, 0, DateTimeKind.Unspecified), 4, false, false, "English", 3, 2, new DateTime(2025, 10, 9, 14, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 13, 8.00m, new DateTime(2025, 10, 10, 23, 0, 0, 0, DateTimeKind.Unspecified), 4, false, false, "English", 5, 2, new DateTime(2025, 10, 10, 21, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 14, 5.00m, new DateTime(2025, 10, 5, 14, 0, 0, 0, DateTimeKind.Unspecified), 4, false, false, "English", 3, 1, new DateTime(2025, 10, 5, 12, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 15, 5.00m, new DateTime(2025, 10, 6, 15, 0, 0, 0, DateTimeKind.Unspecified), 3, false, false, "English", 3, 1, new DateTime(2025, 10, 6, 13, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 16, 5.00m, new DateTime(2025, 10, 9, 17, 0, 0, 0, DateTimeKind.Unspecified), 3, false, false, "English", 3, 1, new DateTime(2025, 10, 9, 15, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 17, 3.00m, new DateTime(2025, 10, 6, 14, 0, 0, 0, DateTimeKind.Unspecified), 3, false, false, "English", 4, 1, new DateTime(2025, 10, 6, 12, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 18, 7.00m, new DateTime(2025, 10, 10, 14, 0, 0, 0, DateTimeKind.Unspecified), 4, false, false, "English", 4, 2, new DateTime(2025, 10, 10, 12, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 19, 10.00m, new DateTime(2025, 10, 10, 19, 0, 0, 0, DateTimeKind.Unspecified), 5, false, false, "English", 4, 4, new DateTime(2025, 10, 10, 17, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 20, 7.00m, new DateTime(2025, 10, 10, 14, 0, 0, 0, DateTimeKind.Unspecified), 3, false, false, "English", 5, 1, new DateTime(2025, 10, 10, 12, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 21, 9.00m, new DateTime(2025, 10, 10, 18, 0, 0, 0, DateTimeKind.Unspecified), 3, false, false, "English", 5, 2, new DateTime(2025, 10, 10, 16, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 22, 6.00m, new DateTime(2025, 10, 10, 16, 0, 0, 0, DateTimeKind.Unspecified), 4, false, false, "English", 3, 1, new DateTime(2025, 10, 10, 14, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 23, 7.00m, new DateTime(2025, 10, 11, 22, 0, 0, 0, DateTimeKind.Unspecified), 3, false, false, "English", 3, 1, new DateTime(2025, 10, 11, 20, 0, 0, 0, DateTimeKind.Unspecified) }
                });

            migrationBuilder.InsertData(
                table: "Users",
                columns: new[] { "Id", "CreatedAt", "DateOfBirth", "Email", "FirstName", "Image", "IsDeleted", "LastModifiedAt", "LastName", "PasswordHash", "PasswordSalt", "PhoneNumber", "ReceiveNotifications", "RoleId", "Username" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "admin@ecinema.com", "Admin", null, false, null, "User", "Pt4KIdrszd5pY6KqrbF+ZIe9Km0=", "r7GQxTDA6SxGl2NmUqHaDQ==", null, true, 1, "admin" },
                    { 2, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "user1@ecinema.com", "User", null, false, null, "One", "Pt4KIdrszd5pY6KqrbF+ZIe9Km0=", "r7GQxTDA6SxGl2NmUqHaDQ==", null, true, 2, "user1" },
                    { 3, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "user2@ecinema.com", "User", null, false, null, "Two", "Pt4KIdrszd5pY6KqrbF+ZIe9Km0=", "r7GQxTDA6SxGl2NmUqHaDQ==", null, true, 2, "user2" },
                    { 4, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, "staff@ecinema.com", "Staff", null, false, null, "User", "Pt4KIdrszd5pY6KqrbF+ZIe9Km0=", "r7GQxTDA6SxGl2NmUqHaDQ==", null, true, 3, "staff" }
                });

            migrationBuilder.InsertData(
                table: "NewsArticles",
                columns: new[] { "Id", "AuthorId", "Content", "EventDate", "IsDeleted", "PublishDate", "Title", "Type" },
                values: new object[,]
                {
                    { 1, 1, "Get ready for a spooky night at the cinema! Coraline is back on the big screen in stunning 3D, just in time for Halloween. Don't miss the chance to experience this animated classic like never before.", null, false, new DateTime(2025, 10, 1, 18, 0, 0, 0, DateTimeKind.Unspecified), "Coraline Returns for a Halloween 3D Special", "news" },
                    { 3, 1, "The wait is almost over! Deadpool & Wolverine hits theaters next month. Secure your tickets today and be among the first to see Marvel's most chaotic duo on the big screen.", null, false, new DateTime(2025, 7, 10, 12, 0, 0, 0, DateTimeKind.Unspecified), "Deadpool & Wolverine Premieres Next Month – Tickets on Sale Now!", "news" },
                    { 4, 1, "Barbie has become a global phenomenon, smashing box office records and charming audiences everywhere. Don't miss your chance to watch the year's most talked-about film on the big screen.", null, false, new DateTime(2025, 10, 2, 10, 0, 0, 0, DateTimeKind.Unspecified), "Barbie Breaks Box Office Records Worldwide", "news" },
                    { 5, 1, "Join us for a special screening of Pride and Prejudice, the timeless romantic drama that continues to capture hearts around the world. A perfect evening for fans of classic cinema and unforgettable love stories.", null, false, new DateTime(2025, 9, 20, 19, 0, 0, 0, DateTimeKind.Unspecified), "Romantic Classics Night: Pride and Prejudice Returns", "news" },
                    { 7, 1, "Join us for a special screening of Atonement, the timeless romantic drama that continues to capture hearts around the world. A perfect evening for fans of classic cinema and unforgettable love stories.", new DateTime(2025, 10, 10, 12, 0, 0, 0, DateTimeKind.Unspecified), false, new DateTime(2025, 9, 14, 18, 37, 25, 39, DateTimeKind.Unspecified), "Atonement Returns for a Special Screening", "event" },
                    { 8, 1, "Premiere Date for the Wolverine sequel has been announced. Don't miss your chance to see the movie on the big screen.", null, false, new DateTime(2025, 9, 4, 19, 10, 44, 5, DateTimeKind.Unspecified), "The Wolverine: Premiere Date Announced", "news" },
                    { 9, 1, "Get ready for an epic fall movie marathon! We've curated a lineup of classic and contemporary films that are perfect for a relaxing weekend at the cinema.", new DateTime(2025, 10, 1, 12, 0, 0, 0, DateTimeKind.Unspecified), false, new DateTime(2025, 9, 20, 19, 11, 28, 554, DateTimeKind.Unspecified), "Fall Movie Marathon Announced", "event" }
                });

            migrationBuilder.InsertData(
                table: "Reservations",
                columns: new[] { "Id", "DiscountPercentage", "IsDeleted", "NumberOfTickets", "OriginalPrice", "PaymentId", "PaymentType", "PromotionId", "QrcodeBase64", "ReservationTime", "ScreeningId", "State", "TotalPrice", "UserId" },
                values: new object[,]
                {
                    { 1, null, false, 2, 10.00m, null, "Cash", null, "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", new DateTime(2024, 9, 8, 15, 0, 0, 0, DateTimeKind.Unspecified), 1, "UsedReservationState", 10.00m, 2 },
                    { 2, null, false, 1, 5.00m, null, null, null, "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", new DateTime(2025, 9, 8, 15, 45, 6, 721, DateTimeKind.Unspecified), 3, "ApprovedReservationState", 5.00m, 3 },
                    { 3, 0.00m, false, 2, 10.00m, null, "Cash", null, "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", new DateTime(2025, 10, 2, 20, 0, 10, 83, DateTimeKind.Unspecified), 4, "ApprovedReservationState", 10.00m, 2 },
                    { 4, 0.00m, false, 2, 14.00m, null, "Cash", null, "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", new DateTime(2025, 10, 2, 20, 0, 33, 21, DateTimeKind.Unspecified), 20, "ApprovedReservationState", 14.00m, 2 },
                    { 5, 0.00m, false, 2, 6.00m, null, "Cash", null, "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", new DateTime(2025, 10, 2, 20, 0, 50, 11, DateTimeKind.Unspecified), 17, "UsedReservationState", 6.00m, 2 },
                    { 6, 0.00m, false, 2, 8.00m, null, "Cash", null, "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", new DateTime(2025, 10, 2, 20, 1, 3, 506, DateTimeKind.Unspecified), 9, "ApprovedReservationState", 8.00m, 2 },
                    { 7, 0.00m, false, 2, 14.00m, null, "Cash", null, "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", new DateTime(2025, 10, 2, 20, 1, 15, 772, DateTimeKind.Unspecified), 18, "ApprovedReservationState", 14.00m, 2 },
                    { 8, 0.00m, false, 2, 12.00m, null, "Cash", null, "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", new DateTime(2025, 10, 2, 20, 1, 35, 562, DateTimeKind.Unspecified), 22, "CancelledReservationState", 12.00m, 2 },
                    { 9, 0.00m, false, 2, 14.00m, null, "Cash", null, "iVBORw0KGgoAAAANSUhEUgAABgQAAAYEAQAAAAAK71yqAAALbklEQVR4nO3YQZLEtg0FUN5A97+lbtCpxOohCKDbrko4tFMPi6mWSAL/cacZr3943eN0gv+2CM4XwfkiOF8E54vgfBGcL4LzRXC+CM4XwfkiOF8E54vgfBGcL4LzRXC+CM4XwfkiOF8E54vgfBGcL4LzRXC+CM4XwfkiOF8E54vgfBGcL4LzRXC+CM4XwfkiOF8E54vgfBGcL4LzFQUj1/XHjvGfP+mxLMwG179/vTfP1ThobnnFzc+J2SX9StEICAgICAgICAgICAgICLYKri9znhGLNNGed6lBt68L/4qrXZb+kYCAgICAgICAgICAgIBgo+DJcTWPaWHOvn8yps0J9F6NadO7D4wuAQEBAQEBAQEBAQEBAQHBrwvinJmnm71YUooyNqWt0qfLa21AQEBAQEBAQEBAQEBAQPB3EczuX5DvxwRP+umLjO7sRUBAQEBAQEBAQEBAQEBwVNA/VkZaeN6l3NdPq3n2+nm8f/681ng16NdoBAQEBAQEBAQEBAQEBAR7BKME+Nv8qdEICAgICAgICAgICAgICLYKvtQdQQ/3ehamPu1Lm2eU+G6UfxDMprPf12gEBAQEBAQEBAQEBAQEBHsEd2wyM8Y81TIrplge07u/JLjXGMsMAgICAgICAgICAgICAoLfEExGF+8qGdPsRJvvulBp37M6B11x7sdVAgICAgICAgICAgICAoJ9gjtOjGnr7LSQosRftd+8gngZ6arSoHe+qCIgICAgICAgICAgICAg2CiYp7q9z+BlSwmwhC/DXuvZOi1eVc0df8WRBAQEBAQEBAQEBAQEBAQ7BF2T2emZmBgz99WkHT+trtJ5PqZ45diSqjAICAgICAgICAgICAgICHYJ7nI0thtxWIqcTsSM88SSOwUtqmVkugICAgICAgICAgICAgICgv2C58g72Wwcw7+a3N3ElOe19kvH6sh4YnlXioCAgICAgICAgICAgIBgj6DL2AWIGWOnECW9i6sjchOo/Kr31cwlICAgICAgICAgICAgINgmmClinmViUV2xe8qYks0/pVX32N3DNBMQEBAQEBAQEBAQEBAQ7BeMdeLSJIX6GD6O7Tq/1hMp6Hycqx+LgICAgICAgICAgICAgGC/YJQAqWcEvR9ng9hvCRV97xnzvvqmc+5yjICAgICAgICAgICAgIBgqyCer8PK4wyVruBa+12f2qcTd1mIqtqKgICAgICAgICAgICAgGCrII19ol7ruzns9bNlrHkqN85eTszN0dddxui3EBAQEBAQEBAQEBAQEBD8hmDEAKnJz9ExQalKgLRv3kP6z0EdFFfrZgICAgICAgICAgICAgKCfYL7T/Yuka+1e3cFs+lyIv4acfUjY0Z7zsYFAgICAgICAgICAgICAoIdgjh7jh1ldumZatmSJqYr6OKluV2X9V4JCAgICAgICAgICAgICHYIZp746/758yFU1F+lQXz8wOhP3P1ZAgICAgICAgICAgICAoJfEnQj4mf3GMvmWR2ohi8pZvur2bLcXFy9x1i7EBAQEBAQEBAQEBAQEBDsEHw59V6NybrZ73ely2KJyBq5v4wuPAEBAQEBAQEBAQEBAQHBbkHJM+tq8owysczppDVZupZOkIYTEBAQEBAQEBAQEBAQEGwVzB3xVGo8v8dH/JVGRGT1xS39x/uIm6/4rulHQEBAQEBAQEBAQEBAQLBN8Pya3efREX8lQaRdsd88llbj2bQ5IefIpTMBAQEBAQEBAQEBAQEBwWbBiCnmqTQnjpiP10+KD1FKq1G6xHtIq691yyu8IyAgICAgICAgICAgICDYIUgZ45yrmZhAH47F2fPE6+fYu8qxGXS5oKYLAQEBAQEBAQEBAQEBAcEewd18ZyfBYomb3wtzxBdzGjlPXOu1fIixNiAgICAgICAgICAgICAg2CN4Vz/xLlGi5RWRZXMy1y7R8hc2ExAQEBAQEBAQEBAQEBDsFqRT6UC0LNK0JdKu+C79I6E0S/806P6MuIWAgICAgICAgICAgICA4DcES9qpmp/iXxZqitS5v6C7tIpnaxYCAgICAgICAgICAgICgv2CeWCslWaXuuO+FG+C+ppN7zXePWpVFQEBAQEBAQEBAQEBAQHBZkG3N33BT1VHm6AuT+2cbq7cyIj9misgICAgICAgICAgICAgINgheJpc66k6LI14FrqxH1Wd71oHpRkfi4CAgICAgICAgICAgIBgjyAOe88uYyfoFaVpWHn3DhWv6o2M/T4wipmAgICAgICAgICAgICA4FcE8/wc8SXAkiKdLdw5e9lSkPdP09llrKDYioCAgICAgICAgICAgIBgj2DuGE27a+205I6qNPvbjUR4tZRpozlBQEBAQEBAQEBAQEBAQLBHkMbG8x/rKhNT5Ni5Y6Th813a/LEICAgICAgICAgICAgICLYK7rXTeyF+Yt9fUnTf7eXrf6xB6z8SumPxcr9+6RMQEBAQEBAQEBAQEBAQ/A8Ez6kPacu78TNnRHNc6JBLl7g6h49VcBXzmpmAgICAgICAgICAgICAYIcghq/xYtA77nvyLClivBq0qEbUl0HpguYVEBAQEBAQEBAQEBAQEBDsFyyR42P6br/LQvkyT1vqsdQ03WGqeEsEBAQEBAQEBAQEBAQEBLsFydI3/jYxxqv62ODb2Wd1Mad+MSsBAQEBAQEBAQEBAQEBwUbBaCr2fOdJ3Tt4BM3cVxPvWjeP5tis0oCAgICAgICAgICAgICAYKPg+pT2Q6cpiOGXfqlBv9DNrZdRZhAQEBAQEBAQEBAQEBAQ7BK8d8RkC2MuxF+jTCyPIwb4qOpW48K7CAgICAgICAgICAgICAj2C/rIc/YULH9msnIZHzrPYzHUvQ5KqrFuJiAgICAgICAgICAgICDYL5jd3026yF278q5G6bjlqmbkufm1zl1CEhAQEBAQEBAQEBAQEBDsEqTcfd1xTvlTo8Q8c7V+83czkrmEJyAgICAgICAgICAgICDYKuiiLI/Rdz8PJe1yrLuW0mp5VwRLvjiSgICAgICAgICAgICAgGCjoPseT6vpY7sP9U72/Kmhyj2kfXfOmBcijYCAgICAgICAgICAgIBgj+BpN9Zt6fwdY6YAKUrH6B7L8LvZnEDxkYCAgICAgICAgICAgIDgFwSTMS0paOn+Wjdfnxa6UPd6c6mW1RVOQEBAQEBAQEBAQEBAQLBDMBfHWl2yQrt+uowybJ2YG0TQXJ3VpSIgICAgICAgICAgICAg+BVBqRnv/T3e7euCxgbLZaSg8Uu/+2/CclUlAQEBAQEBAQEBAQEBAQHBVkHtHmvpNIP2qqVSxjhoTkv61GXJR0BAQEBAQEBAQEBAQECwVdBVyf1qfnWMZU6JNxnL9SVa6XKtgQgICAgICAgICAgICAgINgpGruVo/FUDzHepQRqb/nSCvsG13kOcS0BAQEBAQEBAQEBAQECwR9D1vNbcXYD64Z+2PLO77/ba/q+fICAgICAgICAgICAgICDYLRh/1NI4+t4ZU/duxGjqOTZr2RdXuwZXuWYCAgICAgICAgICAgICgt8UlACvJuP7V1RVabmWez37WuPd69w7+ggICAgICAgICAgICAgI/j6C1L1HfqS9G8Q8y2riRnNCEhAQEBAQEBAQEBAQEBDsFhTQPL9MjD1n1dnlHpY8M3wUdDPSlngZBAQEBAQEBAQEBAQEBAR7BKnSgW+C11rxXbf5blaXtJPWr84iICAgICAgICAgICAgINgj+GcWwfkiOF8E54vgfBGcL4LzRXC+CM4XwfkiOF8E54vgfBGcL4LzRXC+CM4XwfkiOF8E54vgfBGcL4LzRXC+CM4XwfkiOF8E54vgfBGcL4LzRXC+CM4XwfkiOF8E54vgfBGcL4LzRXC+/g8E/wJ/kQ/VxoIG1QAAAABJRU5ErkJggg==", new DateTime(2025, 10, 2, 20, 1, 49, 240, DateTimeKind.Unspecified), 23, "ApprovedReservationState", 14.00m, 2 },
                    { 10, 0.00m, false, 2, 12.00m, null, "Cash", null, "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", new DateTime(2025, 10, 2, 20, 2, 22, 773, DateTimeKind.Unspecified), 12, "ApprovedReservationState", 12.00m, 2 },
                    { 11, 0.00m, false, 3, 15.00m, null, "Cash", null, "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", new DateTime(2025, 10, 2, 20, 38, 53, 363, DateTimeKind.Unspecified), 7, "UsedReservationState", 15.00m, 3 },
                    { 12, 0.00m, false, 3, 15.00m, null, "Cash", null, "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", new DateTime(2025, 10, 2, 20, 39, 6, 156, DateTimeKind.Unspecified), 8, "ApprovedReservationState", 15.00m, 3 },
                    { 13, 0.00m, false, 3, 18.00m, null, "Cash", null, "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", new DateTime(2025, 10, 2, 20, 39, 20, 407, DateTimeKind.Unspecified), 22, "ApprovedReservationState", 18.00m, 3 },
                    { 14, 0.00m, false, 2, 12.00m, null, "Cash", null, "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", new DateTime(2025, 10, 2, 20, 39, 34, 959, DateTimeKind.Unspecified), 10, "ApprovedReservationState", 12.00m, 3 },
                    { 15, 0.00m, false, 2, 8.00m, null, "Cash", null, "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", new DateTime(2025, 10, 2, 20, 39, 45, 456, DateTimeKind.Unspecified), 9, "CancelledReservationState", 8.00m, 3 },
                    { 16, 0.00m, false, 3, 30.00m, null, "Cash", null, "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", new DateTime(2025, 10, 2, 20, 39, 57, 511, DateTimeKind.Unspecified), 19, "ApprovedReservationState", 30.00m, 3 },
                    { 17, 0.00m, false, 2, 10.00m, null, "Cash", null, "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", new DateTime(2025, 10, 2, 20, 40, 8, 158, DateTimeKind.Unspecified), 4, "ApprovedReservationState", 10.00m, 3 },
                    { 18, 0.00m, false, 4, 32.00m, null, "Cash", null, "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", new DateTime(2025, 10, 2, 20, 41, 10, 63, DateTimeKind.Unspecified), 13, "ApprovedReservationState", 32.00m, 3 }
                });

            migrationBuilder.InsertData(
                table: "Reviews",
                columns: new[] { "Id", "Comment", "CreatedAt", "IsDeleted", "IsEdited", "IsSpoiler", "ModifiedAt", "MovieId", "Rating", "UserId" },
                values: new object[,]
                {
                    { 1, "A beautiful adaptation of the classic novel. The cinematography and performances are outstanding.", new DateTime(2025, 9, 2, 0, 0, 0, 0, DateTimeKind.Unspecified), false, false, false, null, 3, 5, 2 },
                    { 2, "Visually stunning and delightfully creepy. Perfect for both kids and adults.", new DateTime(2025, 10, 2, 0, 0, 0, 0, DateTimeKind.Unspecified), false, false, false, null, 4, 4, 2 },
                    { 3, "A classic romance brought to life with excellent performances.", new DateTime(2025, 10, 2, 0, 0, 0, 0, DateTimeKind.Unspecified), false, false, false, null, 3, 4, 3 },
                    { 4, "The perfect blend of action and humor. Great chemistry between the leads!", new DateTime(2025, 10, 2, 0, 0, 0, 0, DateTimeKind.Unspecified), false, false, false, null, 5, 5, 3 }
                });

            migrationBuilder.InsertData(
                table: "ScreeningSeats",
                columns: new[] { "ScreeningId", "SeatId", "IsReserved" },
                values: new object[,]
                {
                    { 1, 1, false },
                    { 1, 2, false },
                    { 1, 3, false },
                    { 1, 4, false },
                    { 1, 5, false },
                    { 1, 6, false },
                    { 1, 7, false },
                    { 1, 8, false },
                    { 1, 9, false },
                    { 1, 10, false },
                    { 1, 11, false },
                    { 1, 12, false },
                    { 1, 13, false },
                    { 1, 14, false },
                    { 1, 15, false },
                    { 1, 16, false },
                    { 1, 17, false },
                    { 1, 18, false },
                    { 1, 19, false },
                    { 1, 20, false },
                    { 1, 21, false },
                    { 1, 22, false },
                    { 1, 23, false },
                    { 1, 24, false },
                    { 1, 25, false },
                    { 1, 26, false },
                    { 1, 27, false },
                    { 1, 28, false },
                    { 1, 29, false },
                    { 1, 30, false },
                    { 1, 31, false },
                    { 1, 32, false },
                    { 1, 33, false },
                    { 1, 34, false },
                    { 1, 35, false },
                    { 1, 36, false },
                    { 1, 37, false },
                    { 1, 38, false },
                    { 1, 39, false },
                    { 1, 40, false },
                    { 1, 41, false },
                    { 1, 42, false },
                    { 1, 43, false },
                    { 1, 44, false },
                    { 1, 45, false },
                    { 1, 46, false },
                    { 1, 47, false },
                    { 1, 48, false },
                    { 2, 1, false },
                    { 2, 2, false },
                    { 2, 3, false },
                    { 2, 4, false },
                    { 2, 5, false },
                    { 2, 6, false },
                    { 2, 7, false },
                    { 2, 8, false },
                    { 2, 9, false },
                    { 2, 10, false },
                    { 2, 11, false },
                    { 2, 12, false },
                    { 2, 13, false },
                    { 2, 14, false },
                    { 2, 15, false },
                    { 2, 16, false },
                    { 2, 17, false },
                    { 2, 18, false },
                    { 2, 19, false },
                    { 2, 20, false },
                    { 2, 21, false },
                    { 2, 22, false },
                    { 2, 23, false },
                    { 2, 24, false },
                    { 2, 25, false },
                    { 2, 26, false },
                    { 2, 27, false },
                    { 2, 28, false },
                    { 2, 29, false },
                    { 2, 30, false },
                    { 2, 31, false },
                    { 2, 32, false },
                    { 2, 33, false },
                    { 2, 34, false },
                    { 2, 35, false },
                    { 2, 36, false },
                    { 2, 37, false },
                    { 2, 38, false },
                    { 2, 39, false },
                    { 2, 40, false },
                    { 2, 41, false },
                    { 2, 42, false },
                    { 2, 43, false },
                    { 2, 44, false },
                    { 2, 45, false },
                    { 2, 46, false },
                    { 2, 47, false },
                    { 2, 48, false },
                    { 3, 1, false },
                    { 3, 2, false },
                    { 3, 3, false },
                    { 3, 4, false },
                    { 3, 5, false },
                    { 3, 6, false },
                    { 3, 7, false },
                    { 3, 8, false },
                    { 3, 9, false },
                    { 3, 10, false },
                    { 3, 11, false },
                    { 3, 12, false },
                    { 3, 13, false },
                    { 3, 14, false },
                    { 3, 15, false },
                    { 3, 16, false },
                    { 3, 17, false },
                    { 3, 18, false },
                    { 3, 19, false },
                    { 3, 20, false },
                    { 3, 21, false },
                    { 3, 22, false },
                    { 3, 23, false },
                    { 3, 24, false },
                    { 3, 25, false },
                    { 3, 26, false },
                    { 3, 27, false },
                    { 3, 28, false },
                    { 3, 29, false },
                    { 3, 30, false },
                    { 3, 31, false },
                    { 3, 32, false },
                    { 3, 33, false },
                    { 3, 34, false },
                    { 3, 35, false },
                    { 3, 36, false },
                    { 3, 37, false },
                    { 3, 38, false },
                    { 3, 39, false },
                    { 3, 40, false },
                    { 3, 41, false },
                    { 3, 42, false },
                    { 3, 43, false },
                    { 3, 44, false },
                    { 3, 45, false },
                    { 3, 46, false },
                    { 3, 47, false },
                    { 3, 48, false },
                    { 4, 1, false },
                    { 4, 2, false },
                    { 4, 3, false },
                    { 4, 4, false },
                    { 4, 5, false },
                    { 4, 6, false },
                    { 4, 7, false },
                    { 4, 8, false },
                    { 4, 9, false },
                    { 4, 10, true },
                    { 4, 11, true },
                    { 4, 12, false },
                    { 4, 13, false },
                    { 4, 14, false },
                    { 4, 15, false },
                    { 4, 16, false },
                    { 4, 17, false },
                    { 4, 18, false },
                    { 4, 19, false },
                    { 4, 20, false },
                    { 4, 21, false },
                    { 4, 22, false },
                    { 4, 23, false },
                    { 4, 24, false },
                    { 4, 25, false },
                    { 4, 26, false },
                    { 4, 27, false },
                    { 4, 28, false },
                    { 4, 29, true },
                    { 4, 30, true },
                    { 4, 31, false },
                    { 4, 32, false },
                    { 4, 33, false },
                    { 4, 34, false },
                    { 4, 35, false },
                    { 4, 36, false },
                    { 4, 37, false },
                    { 4, 38, false },
                    { 4, 39, false },
                    { 4, 40, false },
                    { 4, 41, false },
                    { 4, 42, false },
                    { 4, 43, false },
                    { 4, 44, false },
                    { 4, 45, false },
                    { 4, 46, false },
                    { 4, 47, false },
                    { 4, 48, false },
                    { 5, 1, false },
                    { 5, 2, false },
                    { 5, 3, false },
                    { 5, 4, false },
                    { 5, 5, false },
                    { 5, 6, false },
                    { 5, 7, false },
                    { 5, 8, false },
                    { 5, 9, false },
                    { 5, 10, false },
                    { 5, 11, false },
                    { 5, 12, false },
                    { 5, 13, false },
                    { 5, 14, false },
                    { 5, 15, false },
                    { 5, 16, false },
                    { 5, 17, false },
                    { 5, 18, false },
                    { 5, 19, false },
                    { 5, 20, false },
                    { 5, 21, false },
                    { 5, 22, false },
                    { 5, 23, false },
                    { 5, 24, false },
                    { 5, 25, false },
                    { 5, 26, false },
                    { 5, 27, false },
                    { 5, 28, false },
                    { 5, 29, false },
                    { 5, 30, false },
                    { 5, 31, false },
                    { 5, 32, false },
                    { 5, 33, false },
                    { 5, 34, false },
                    { 5, 35, false },
                    { 5, 36, false },
                    { 5, 37, false },
                    { 5, 38, false },
                    { 5, 39, false },
                    { 5, 40, false },
                    { 5, 41, false },
                    { 5, 42, false },
                    { 5, 43, false },
                    { 5, 44, false },
                    { 5, 45, false },
                    { 5, 46, false },
                    { 5, 47, false },
                    { 5, 48, false },
                    { 6, 1, false },
                    { 6, 2, false },
                    { 6, 3, false },
                    { 6, 4, false },
                    { 6, 5, false },
                    { 6, 6, false },
                    { 6, 7, false },
                    { 6, 8, false },
                    { 6, 9, false },
                    { 6, 10, false },
                    { 6, 11, false },
                    { 6, 12, false },
                    { 6, 13, false },
                    { 6, 14, false },
                    { 6, 15, false },
                    { 6, 16, false },
                    { 6, 17, false },
                    { 6, 18, false },
                    { 6, 19, false },
                    { 6, 20, false },
                    { 6, 21, false },
                    { 6, 22, false },
                    { 6, 23, false },
                    { 6, 24, false },
                    { 6, 25, false },
                    { 6, 26, false },
                    { 6, 27, false },
                    { 6, 28, false },
                    { 6, 29, false },
                    { 6, 30, false },
                    { 6, 31, false },
                    { 6, 32, false },
                    { 6, 33, false },
                    { 6, 34, false },
                    { 6, 35, false },
                    { 6, 36, false },
                    { 6, 37, false },
                    { 6, 38, false },
                    { 6, 39, false },
                    { 6, 40, false },
                    { 6, 41, false },
                    { 6, 42, false },
                    { 6, 43, false },
                    { 6, 44, false },
                    { 6, 45, false },
                    { 6, 46, false },
                    { 6, 47, false },
                    { 6, 48, false },
                    { 7, 1, false },
                    { 7, 2, false },
                    { 7, 3, false },
                    { 7, 4, false },
                    { 7, 5, false },
                    { 7, 6, false },
                    { 7, 7, false },
                    { 7, 8, false },
                    { 7, 9, false },
                    { 7, 10, false },
                    { 7, 11, true },
                    { 7, 12, true },
                    { 7, 13, true },
                    { 7, 14, false },
                    { 7, 15, false },
                    { 7, 16, false },
                    { 7, 17, false },
                    { 7, 18, false },
                    { 7, 19, false },
                    { 7, 20, false },
                    { 7, 21, false },
                    { 7, 22, false },
                    { 7, 23, false },
                    { 7, 24, false },
                    { 7, 25, false },
                    { 7, 26, false },
                    { 7, 27, false },
                    { 7, 28, false },
                    { 7, 29, false },
                    { 7, 30, false },
                    { 7, 31, false },
                    { 7, 32, false },
                    { 7, 33, false },
                    { 7, 34, false },
                    { 7, 35, false },
                    { 7, 36, false },
                    { 7, 37, false },
                    { 7, 38, false },
                    { 7, 39, false },
                    { 7, 40, false },
                    { 7, 41, false },
                    { 7, 42, false },
                    { 7, 43, false },
                    { 7, 44, false },
                    { 7, 45, false },
                    { 7, 46, false },
                    { 7, 47, false },
                    { 7, 48, false },
                    { 8, 1, false },
                    { 8, 2, false },
                    { 8, 3, false },
                    { 8, 4, false },
                    { 8, 5, false },
                    { 8, 6, false },
                    { 8, 7, false },
                    { 8, 8, false },
                    { 8, 9, false },
                    { 8, 10, false },
                    { 8, 11, true },
                    { 8, 12, true },
                    { 8, 13, true },
                    { 8, 14, false },
                    { 8, 15, false },
                    { 8, 16, false },
                    { 8, 17, false },
                    { 8, 18, false },
                    { 8, 19, false },
                    { 8, 20, false },
                    { 8, 21, false },
                    { 8, 22, false },
                    { 8, 23, false },
                    { 8, 24, false },
                    { 8, 25, false },
                    { 8, 26, false },
                    { 8, 27, false },
                    { 8, 28, false },
                    { 8, 29, false },
                    { 8, 30, false },
                    { 8, 31, false },
                    { 8, 32, false },
                    { 8, 33, false },
                    { 8, 34, false },
                    { 8, 35, false },
                    { 8, 36, false },
                    { 8, 37, false },
                    { 8, 38, false },
                    { 8, 39, false },
                    { 8, 40, false },
                    { 8, 41, false },
                    { 8, 42, false },
                    { 8, 43, false },
                    { 8, 44, false },
                    { 8, 45, false },
                    { 8, 46, false },
                    { 8, 47, false },
                    { 8, 48, false },
                    { 9, 1, true },
                    { 9, 2, true },
                    { 9, 3, false },
                    { 9, 4, false },
                    { 9, 5, false },
                    { 9, 6, false },
                    { 9, 7, false },
                    { 9, 8, false },
                    { 9, 9, false },
                    { 9, 10, false },
                    { 9, 11, false },
                    { 9, 12, false },
                    { 9, 13, false },
                    { 9, 14, false },
                    { 9, 15, false },
                    { 9, 16, false },
                    { 9, 17, false },
                    { 9, 18, false },
                    { 9, 19, false },
                    { 9, 20, false },
                    { 9, 21, false },
                    { 9, 22, false },
                    { 9, 23, false },
                    { 9, 24, false },
                    { 9, 25, false },
                    { 9, 26, false },
                    { 9, 27, false },
                    { 9, 28, false },
                    { 9, 29, false },
                    { 9, 30, false },
                    { 9, 31, false },
                    { 9, 32, false },
                    { 9, 33, false },
                    { 9, 34, false },
                    { 9, 35, false },
                    { 9, 36, false },
                    { 9, 37, false },
                    { 9, 38, false },
                    { 9, 39, false },
                    { 9, 40, false },
                    { 9, 41, false },
                    { 9, 42, false },
                    { 9, 43, false },
                    { 9, 44, false },
                    { 9, 45, false },
                    { 9, 46, false },
                    { 9, 47, false },
                    { 9, 48, false },
                    { 10, 1, false },
                    { 10, 2, false },
                    { 10, 3, false },
                    { 10, 4, false },
                    { 10, 5, false },
                    { 10, 6, false },
                    { 10, 7, false },
                    { 10, 8, false },
                    { 10, 9, false },
                    { 10, 10, false },
                    { 10, 11, false },
                    { 10, 12, false },
                    { 10, 13, false },
                    { 10, 14, false },
                    { 10, 15, false },
                    { 10, 16, false },
                    { 10, 17, false },
                    { 10, 18, false },
                    { 10, 19, false },
                    { 10, 20, false },
                    { 10, 21, false },
                    { 10, 22, false },
                    { 10, 23, false },
                    { 10, 24, false },
                    { 10, 25, false },
                    { 10, 26, false },
                    { 10, 27, false },
                    { 10, 28, true },
                    { 10, 29, true },
                    { 10, 30, false },
                    { 10, 31, false },
                    { 10, 32, false },
                    { 10, 33, false },
                    { 10, 34, false },
                    { 10, 35, false },
                    { 10, 36, false },
                    { 10, 37, false },
                    { 10, 38, false },
                    { 10, 39, false },
                    { 10, 40, false },
                    { 10, 41, false },
                    { 10, 42, false },
                    { 10, 43, false },
                    { 10, 44, false },
                    { 10, 45, false },
                    { 10, 46, false },
                    { 10, 47, false },
                    { 10, 48, false },
                    { 11, 1, false },
                    { 11, 2, false },
                    { 11, 3, false },
                    { 11, 4, false },
                    { 11, 5, false },
                    { 11, 6, false },
                    { 11, 7, false },
                    { 11, 8, false },
                    { 11, 9, false },
                    { 11, 10, false },
                    { 11, 11, false },
                    { 11, 12, false },
                    { 11, 13, false },
                    { 11, 14, false },
                    { 11, 15, false },
                    { 11, 16, false },
                    { 11, 17, false },
                    { 11, 18, false },
                    { 11, 19, false },
                    { 11, 20, false },
                    { 11, 21, false },
                    { 11, 22, false },
                    { 11, 23, false },
                    { 11, 24, false },
                    { 11, 25, false },
                    { 11, 26, false },
                    { 11, 27, false },
                    { 11, 28, false },
                    { 11, 29, false },
                    { 11, 30, false },
                    { 11, 31, false },
                    { 11, 32, false },
                    { 11, 33, false },
                    { 11, 34, false },
                    { 11, 35, false },
                    { 11, 36, false },
                    { 11, 37, false },
                    { 11, 38, false },
                    { 11, 39, false },
                    { 11, 40, false },
                    { 11, 41, false },
                    { 11, 42, false },
                    { 11, 43, false },
                    { 11, 44, false },
                    { 11, 45, false },
                    { 11, 46, false },
                    { 11, 47, false },
                    { 11, 48, false },
                    { 12, 1, true },
                    { 12, 2, true },
                    { 12, 3, false },
                    { 12, 4, false },
                    { 12, 5, false },
                    { 12, 6, false },
                    { 12, 7, false },
                    { 12, 8, false },
                    { 12, 9, false },
                    { 12, 10, false },
                    { 12, 11, false },
                    { 12, 12, false },
                    { 12, 13, false },
                    { 12, 14, false },
                    { 12, 15, false },
                    { 12, 16, false },
                    { 12, 17, false },
                    { 12, 18, false },
                    { 12, 19, false },
                    { 12, 20, false },
                    { 12, 21, false },
                    { 12, 22, false },
                    { 12, 23, false },
                    { 12, 24, false },
                    { 12, 25, false },
                    { 12, 26, false },
                    { 12, 27, false },
                    { 12, 28, false },
                    { 12, 29, false },
                    { 12, 30, false },
                    { 12, 31, false },
                    { 12, 32, false },
                    { 12, 33, false },
                    { 12, 34, false },
                    { 12, 35, false },
                    { 12, 36, false },
                    { 12, 37, false },
                    { 12, 38, false },
                    { 12, 39, false },
                    { 12, 40, false },
                    { 12, 41, false },
                    { 12, 42, false },
                    { 12, 43, false },
                    { 12, 44, false },
                    { 12, 45, false },
                    { 12, 46, false },
                    { 12, 47, false },
                    { 12, 48, false },
                    { 13, 1, false },
                    { 13, 2, false },
                    { 13, 3, false },
                    { 13, 4, false },
                    { 13, 5, false },
                    { 13, 6, false },
                    { 13, 7, false },
                    { 13, 8, false },
                    { 13, 9, false },
                    { 13, 10, false },
                    { 13, 11, false },
                    { 13, 12, false },
                    { 13, 13, false },
                    { 13, 14, false },
                    { 13, 15, false },
                    { 13, 16, false },
                    { 13, 17, false },
                    { 13, 18, false },
                    { 13, 19, false },
                    { 13, 20, false },
                    { 13, 21, false },
                    { 13, 22, false },
                    { 13, 23, false },
                    { 13, 24, false },
                    { 13, 25, false },
                    { 13, 26, false },
                    { 13, 27, false },
                    { 13, 28, false },
                    { 13, 29, false },
                    { 13, 30, false },
                    { 13, 31, false },
                    { 13, 32, false },
                    { 13, 33, false },
                    { 13, 34, false },
                    { 13, 35, true },
                    { 13, 36, true },
                    { 13, 37, true },
                    { 13, 38, true },
                    { 13, 39, false },
                    { 13, 40, false },
                    { 13, 41, false },
                    { 13, 42, false },
                    { 13, 43, false },
                    { 13, 44, false },
                    { 13, 45, false },
                    { 13, 46, false },
                    { 13, 47, false },
                    { 13, 48, false },
                    { 14, 1, false },
                    { 14, 2, false },
                    { 14, 3, false },
                    { 14, 4, false },
                    { 14, 5, false },
                    { 14, 6, false },
                    { 14, 7, false },
                    { 14, 8, false },
                    { 14, 9, false },
                    { 14, 10, false },
                    { 14, 11, false },
                    { 14, 12, false },
                    { 14, 13, false },
                    { 14, 14, false },
                    { 14, 15, false },
                    { 14, 16, false },
                    { 14, 17, false },
                    { 14, 18, false },
                    { 14, 19, false },
                    { 14, 20, false },
                    { 14, 21, false },
                    { 14, 22, false },
                    { 14, 23, false },
                    { 14, 24, false },
                    { 14, 25, false },
                    { 14, 26, false },
                    { 14, 27, false },
                    { 14, 28, false },
                    { 14, 29, false },
                    { 14, 30, false },
                    { 14, 31, false },
                    { 14, 32, false },
                    { 14, 33, false },
                    { 14, 34, false },
                    { 14, 35, false },
                    { 14, 36, false },
                    { 14, 37, false },
                    { 14, 38, false },
                    { 14, 39, false },
                    { 14, 40, false },
                    { 14, 41, false },
                    { 14, 42, false },
                    { 14, 43, false },
                    { 14, 44, false },
                    { 14, 45, false },
                    { 14, 46, false },
                    { 14, 47, false },
                    { 14, 48, false },
                    { 15, 1, false },
                    { 15, 2, false },
                    { 15, 3, false },
                    { 15, 4, false },
                    { 15, 5, false },
                    { 15, 6, false },
                    { 15, 7, false },
                    { 15, 8, false },
                    { 15, 9, false },
                    { 15, 10, false },
                    { 15, 11, false },
                    { 15, 12, false },
                    { 15, 13, false },
                    { 15, 14, false },
                    { 15, 15, false },
                    { 15, 16, false },
                    { 15, 17, false },
                    { 15, 18, false },
                    { 15, 19, false },
                    { 15, 20, false },
                    { 15, 21, false },
                    { 15, 22, false },
                    { 15, 23, false },
                    { 15, 24, false },
                    { 15, 25, false },
                    { 15, 26, false },
                    { 15, 27, false },
                    { 15, 28, false },
                    { 15, 29, false },
                    { 15, 30, false },
                    { 15, 31, false },
                    { 15, 32, false },
                    { 15, 33, false },
                    { 15, 34, false },
                    { 15, 35, false },
                    { 15, 36, false },
                    { 15, 37, false },
                    { 15, 38, false },
                    { 15, 39, false },
                    { 15, 40, false },
                    { 15, 41, false },
                    { 15, 42, false },
                    { 15, 43, false },
                    { 15, 44, false },
                    { 15, 45, false },
                    { 15, 46, false },
                    { 15, 47, false },
                    { 15, 48, false },
                    { 16, 1, false },
                    { 16, 2, false },
                    { 16, 3, false },
                    { 16, 4, false },
                    { 16, 5, false },
                    { 16, 6, false },
                    { 16, 7, false },
                    { 16, 8, false },
                    { 16, 9, false },
                    { 16, 10, false },
                    { 16, 11, false },
                    { 16, 12, false },
                    { 16, 13, false },
                    { 16, 14, false },
                    { 16, 15, false },
                    { 16, 16, false },
                    { 16, 17, false },
                    { 16, 18, false },
                    { 16, 19, false },
                    { 16, 20, false },
                    { 16, 21, false },
                    { 16, 22, false },
                    { 16, 23, false },
                    { 16, 24, false },
                    { 16, 25, false },
                    { 16, 26, false },
                    { 16, 27, false },
                    { 16, 28, false },
                    { 16, 29, false },
                    { 16, 30, false },
                    { 16, 31, false },
                    { 16, 32, false },
                    { 16, 33, false },
                    { 16, 34, false },
                    { 16, 35, false },
                    { 16, 36, false },
                    { 16, 37, false },
                    { 16, 38, false },
                    { 16, 39, false },
                    { 16, 40, false },
                    { 16, 41, false },
                    { 16, 42, false },
                    { 16, 43, false },
                    { 16, 44, false },
                    { 16, 45, false },
                    { 16, 46, false },
                    { 16, 47, false },
                    { 16, 48, false },
                    { 17, 1, false },
                    { 17, 2, false },
                    { 17, 3, false },
                    { 17, 4, false },
                    { 17, 5, false },
                    { 17, 6, false },
                    { 17, 7, false },
                    { 17, 8, false },
                    { 17, 9, false },
                    { 17, 10, false },
                    { 17, 11, true },
                    { 17, 12, true },
                    { 17, 13, false },
                    { 17, 14, false },
                    { 17, 15, false },
                    { 17, 16, false },
                    { 17, 17, false },
                    { 17, 18, false },
                    { 17, 19, false },
                    { 17, 20, false },
                    { 17, 21, false },
                    { 17, 22, false },
                    { 17, 23, false },
                    { 17, 24, false },
                    { 17, 25, false },
                    { 17, 26, false },
                    { 17, 27, false },
                    { 17, 28, false },
                    { 17, 29, false },
                    { 17, 30, false },
                    { 17, 31, false },
                    { 17, 32, false },
                    { 17, 33, false },
                    { 17, 34, false },
                    { 17, 35, false },
                    { 17, 36, false },
                    { 17, 37, false },
                    { 17, 38, false },
                    { 17, 39, false },
                    { 17, 40, false },
                    { 17, 41, false },
                    { 17, 42, false },
                    { 17, 43, false },
                    { 17, 44, false },
                    { 17, 45, false },
                    { 17, 46, false },
                    { 17, 47, false },
                    { 17, 48, false },
                    { 18, 1, true },
                    { 18, 2, true },
                    { 18, 3, false },
                    { 18, 4, false },
                    { 18, 5, false },
                    { 18, 6, false },
                    { 18, 7, false },
                    { 18, 8, false },
                    { 18, 9, false },
                    { 18, 10, false },
                    { 18, 11, false },
                    { 18, 12, false },
                    { 18, 13, false },
                    { 18, 14, false },
                    { 18, 15, false },
                    { 18, 16, false },
                    { 18, 17, false },
                    { 18, 18, false },
                    { 18, 19, false },
                    { 18, 20, false },
                    { 18, 21, false },
                    { 18, 22, false },
                    { 18, 23, false },
                    { 18, 24, false },
                    { 18, 25, false },
                    { 18, 26, false },
                    { 18, 27, false },
                    { 18, 28, false },
                    { 18, 29, false },
                    { 18, 30, false },
                    { 18, 31, false },
                    { 18, 32, false },
                    { 18, 33, false },
                    { 18, 34, false },
                    { 18, 35, false },
                    { 18, 36, false },
                    { 18, 37, false },
                    { 18, 38, false },
                    { 18, 39, false },
                    { 18, 40, false },
                    { 18, 41, false },
                    { 18, 42, false },
                    { 18, 43, false },
                    { 18, 44, false },
                    { 18, 45, false },
                    { 18, 46, false },
                    { 18, 47, false },
                    { 18, 48, false },
                    { 19, 1, false },
                    { 19, 2, false },
                    { 19, 3, false },
                    { 19, 4, false },
                    { 19, 5, false },
                    { 19, 6, false },
                    { 19, 7, false },
                    { 19, 8, false },
                    { 19, 9, false },
                    { 19, 10, false },
                    { 19, 11, false },
                    { 19, 12, false },
                    { 19, 13, false },
                    { 19, 14, false },
                    { 19, 15, false },
                    { 19, 16, false },
                    { 19, 17, false },
                    { 19, 18, false },
                    { 19, 19, true },
                    { 19, 20, true },
                    { 19, 21, true },
                    { 19, 22, false },
                    { 19, 23, false },
                    { 19, 24, false },
                    { 19, 25, false },
                    { 19, 26, false },
                    { 19, 27, false },
                    { 19, 28, false },
                    { 19, 29, false },
                    { 19, 30, false },
                    { 19, 31, false },
                    { 19, 32, false },
                    { 19, 33, false },
                    { 19, 34, false },
                    { 19, 35, false },
                    { 19, 36, false },
                    { 19, 37, false },
                    { 19, 38, false },
                    { 19, 39, false },
                    { 19, 40, false },
                    { 19, 41, false },
                    { 19, 42, false },
                    { 19, 43, false },
                    { 19, 44, false },
                    { 19, 45, false },
                    { 19, 46, false },
                    { 19, 47, false },
                    { 19, 48, false },
                    { 20, 1, false },
                    { 20, 2, false },
                    { 20, 3, false },
                    { 20, 4, false },
                    { 20, 5, false },
                    { 20, 6, false },
                    { 20, 7, false },
                    { 20, 8, false },
                    { 20, 9, false },
                    { 20, 10, false },
                    { 20, 11, true },
                    { 20, 12, true },
                    { 20, 13, false },
                    { 20, 14, false },
                    { 20, 15, false },
                    { 20, 16, false },
                    { 20, 17, false },
                    { 20, 18, false },
                    { 20, 19, false },
                    { 20, 20, false },
                    { 20, 21, false },
                    { 20, 22, false },
                    { 20, 23, false },
                    { 20, 24, false },
                    { 20, 25, false },
                    { 20, 26, false },
                    { 20, 27, false },
                    { 20, 28, false },
                    { 20, 29, false },
                    { 20, 30, false },
                    { 20, 31, false },
                    { 20, 32, false },
                    { 20, 33, false },
                    { 20, 34, false },
                    { 20, 35, false },
                    { 20, 36, false },
                    { 20, 37, false },
                    { 20, 38, false },
                    { 20, 39, false },
                    { 20, 40, false },
                    { 20, 41, false },
                    { 20, 42, false },
                    { 20, 43, false },
                    { 20, 44, false },
                    { 20, 45, false },
                    { 20, 46, false },
                    { 20, 47, false },
                    { 20, 48, false },
                    { 21, 1, false },
                    { 21, 2, false },
                    { 21, 3, false },
                    { 21, 4, false },
                    { 21, 5, false },
                    { 21, 6, false },
                    { 21, 7, false },
                    { 21, 8, false },
                    { 21, 9, false },
                    { 21, 10, false },
                    { 21, 11, false },
                    { 21, 12, false },
                    { 21, 13, false },
                    { 21, 14, false },
                    { 21, 15, false },
                    { 21, 16, false },
                    { 21, 17, false },
                    { 21, 18, false },
                    { 21, 19, false },
                    { 21, 20, false },
                    { 21, 21, false },
                    { 21, 22, false },
                    { 21, 23, false },
                    { 21, 24, false },
                    { 21, 25, false },
                    { 21, 26, false },
                    { 21, 27, false },
                    { 21, 28, false },
                    { 21, 29, false },
                    { 21, 30, false },
                    { 21, 31, false },
                    { 21, 32, false },
                    { 21, 33, false },
                    { 21, 34, false },
                    { 21, 35, false },
                    { 21, 36, false },
                    { 21, 37, false },
                    { 21, 38, false },
                    { 21, 39, false },
                    { 21, 40, false },
                    { 21, 41, false },
                    { 21, 42, false },
                    { 21, 43, false },
                    { 21, 44, false },
                    { 21, 45, false },
                    { 21, 46, false },
                    { 21, 47, false },
                    { 21, 48, false },
                    { 22, 1, false },
                    { 22, 2, false },
                    { 22, 3, false },
                    { 22, 4, false },
                    { 22, 5, false },
                    { 22, 6, false },
                    { 22, 7, false },
                    { 22, 8, false },
                    { 22, 9, false },
                    { 22, 10, false },
                    { 22, 11, true },
                    { 22, 12, true },
                    { 22, 13, true },
                    { 22, 14, false },
                    { 22, 15, false },
                    { 22, 16, false },
                    { 22, 17, false },
                    { 22, 18, false },
                    { 22, 19, false },
                    { 22, 20, false },
                    { 22, 21, false },
                    { 22, 22, false },
                    { 22, 23, false },
                    { 22, 24, false },
                    { 22, 25, false },
                    { 22, 26, false },
                    { 22, 27, false },
                    { 22, 28, false },
                    { 22, 29, false },
                    { 22, 30, false },
                    { 22, 31, false },
                    { 22, 32, false },
                    { 22, 33, false },
                    { 22, 34, false },
                    { 22, 35, false },
                    { 22, 36, false },
                    { 22, 37, false },
                    { 22, 38, false },
                    { 22, 39, false },
                    { 22, 40, false },
                    { 22, 41, false },
                    { 22, 42, false },
                    { 22, 43, false },
                    { 22, 44, false },
                    { 22, 45, false },
                    { 22, 46, false },
                    { 22, 47, false },
                    { 22, 48, false },
                    { 23, 1, true },
                    { 23, 2, true },
                    { 23, 3, false },
                    { 23, 4, false },
                    { 23, 5, false },
                    { 23, 6, false },
                    { 23, 7, false },
                    { 23, 8, false },
                    { 23, 9, false },
                    { 23, 10, false },
                    { 23, 11, false },
                    { 23, 12, false },
                    { 23, 13, false },
                    { 23, 14, false },
                    { 23, 15, false },
                    { 23, 16, false },
                    { 23, 17, false },
                    { 23, 18, false },
                    { 23, 19, false },
                    { 23, 20, false },
                    { 23, 21, false },
                    { 23, 22, false },
                    { 23, 23, false },
                    { 23, 24, false },
                    { 23, 25, false },
                    { 23, 26, false },
                    { 23, 27, false },
                    { 23, 28, false },
                    { 23, 29, false },
                    { 23, 30, false },
                    { 23, 31, false },
                    { 23, 32, false },
                    { 23, 33, false },
                    { 23, 34, false },
                    { 23, 35, false },
                    { 23, 36, false },
                    { 23, 37, false },
                    { 23, 38, false },
                    { 23, 39, false },
                    { 23, 40, false },
                    { 23, 41, false },
                    { 23, 42, false },
                    { 23, 43, false },
                    { 23, 44, false },
                    { 23, 45, false },
                    { 23, 46, false },
                    { 23, 47, false },
                    { 23, 48, false }
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
                    { 9, new DateTime(2025, 9, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), true, "favorites", 11, 3 },
                    { 10, new DateTime(2025, 9, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "watchlist", 4, 3 },
                    { 11, new DateTime(2025, 10, 2, 17, 57, 15, 343, DateTimeKind.Unspecified), false, "favorites", 3, 2 },
                    { 12, new DateTime(2025, 10, 2, 18, 3, 25, 825, DateTimeKind.Unspecified), false, "watchlist", 12, 3 },
                    { 13, new DateTime(2025, 10, 2, 18, 3, 52, 579, DateTimeKind.Unspecified), false, "favorites", 5, 3 }
                });

            migrationBuilder.InsertData(
                table: "ReservationSeats",
                columns: new[] { "ReservationId", "SeatId", "ReservedAt" },
                values: new object[,]
                {
                    { 1, 1, new DateTime(2024, 3, 14, 10, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 1, 2, new DateTime(2024, 3, 14, 10, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 2, 10, new DateTime(2025, 9, 8, 15, 45, 6, 721, DateTimeKind.Unspecified) },
                    { 3, 10, new DateTime(2025, 10, 2, 18, 0, 11, 47, DateTimeKind.Unspecified) },
                    { 3, 11, new DateTime(2025, 10, 2, 18, 0, 11, 52, DateTimeKind.Unspecified) },
                    { 4, 11, new DateTime(2025, 10, 2, 18, 0, 33, 255, DateTimeKind.Unspecified) },
                    { 4, 12, new DateTime(2025, 10, 2, 18, 0, 33, 255, DateTimeKind.Unspecified) },
                    { 5, 11, new DateTime(2025, 10, 2, 18, 0, 50, 53, DateTimeKind.Unspecified) },
                    { 5, 12, new DateTime(2025, 10, 2, 18, 0, 50, 53, DateTimeKind.Unspecified) },
                    { 6, 1, new DateTime(2025, 10, 2, 18, 1, 3, 546, DateTimeKind.Unspecified) },
                    { 6, 2, new DateTime(2025, 10, 2, 18, 1, 3, 546, DateTimeKind.Unspecified) },
                    { 7, 1, new DateTime(2025, 10, 2, 18, 1, 15, 804, DateTimeKind.Unspecified) },
                    { 7, 2, new DateTime(2025, 10, 2, 18, 1, 15, 805, DateTimeKind.Unspecified) },
                    { 8, 1, new DateTime(2025, 10, 2, 18, 1, 35, 615, DateTimeKind.Unspecified) },
                    { 8, 2, new DateTime(2025, 10, 2, 18, 1, 35, 615, DateTimeKind.Unspecified) },
                    { 9, 1, new DateTime(2025, 10, 2, 18, 1, 49, 282, DateTimeKind.Unspecified) },
                    { 9, 2, new DateTime(2025, 10, 2, 18, 1, 49, 282, DateTimeKind.Unspecified) },
                    { 10, 1, new DateTime(2025, 10, 2, 18, 2, 22, 810, DateTimeKind.Unspecified) },
                    { 10, 2, new DateTime(2025, 10, 2, 18, 2, 22, 813, DateTimeKind.Unspecified) },
                    { 11, 11, new DateTime(2025, 10, 2, 18, 38, 54, 26, DateTimeKind.Unspecified) },
                    { 11, 12, new DateTime(2025, 10, 2, 18, 38, 54, 27, DateTimeKind.Unspecified) },
                    { 11, 13, new DateTime(2025, 10, 2, 18, 38, 54, 27, DateTimeKind.Unspecified) },
                    { 12, 11, new DateTime(2025, 10, 2, 18, 39, 6, 760, DateTimeKind.Unspecified) },
                    { 12, 12, new DateTime(2025, 10, 2, 18, 39, 6, 761, DateTimeKind.Unspecified) },
                    { 12, 13, new DateTime(2025, 10, 2, 18, 39, 6, 761, DateTimeKind.Unspecified) },
                    { 13, 11, new DateTime(2025, 10, 2, 18, 39, 21, 8, DateTimeKind.Unspecified) },
                    { 13, 12, new DateTime(2025, 10, 2, 18, 39, 21, 9, DateTimeKind.Unspecified) },
                    { 13, 13, new DateTime(2025, 10, 2, 18, 39, 21, 9, DateTimeKind.Unspecified) },
                    { 14, 28, new DateTime(2025, 10, 2, 18, 39, 35, 564, DateTimeKind.Unspecified) },
                    { 14, 29, new DateTime(2025, 10, 2, 18, 39, 35, 564, DateTimeKind.Unspecified) },
                    { 15, 28, new DateTime(2025, 10, 2, 18, 39, 46, 62, DateTimeKind.Unspecified) },
                    { 15, 29, new DateTime(2025, 10, 2, 18, 39, 46, 62, DateTimeKind.Unspecified) },
                    { 16, 19, new DateTime(2025, 10, 2, 18, 39, 58, 124, DateTimeKind.Unspecified) },
                    { 16, 20, new DateTime(2025, 10, 2, 18, 39, 58, 124, DateTimeKind.Unspecified) },
                    { 16, 21, new DateTime(2025, 10, 2, 18, 39, 58, 124, DateTimeKind.Unspecified) },
                    { 17, 29, new DateTime(2025, 10, 2, 18, 40, 8, 755, DateTimeKind.Unspecified) },
                    { 17, 30, new DateTime(2025, 10, 2, 18, 40, 8, 755, DateTimeKind.Unspecified) },
                    { 18, 35, new DateTime(2025, 10, 2, 18, 41, 10, 852, DateTimeKind.Unspecified) },
                    { 18, 36, new DateTime(2025, 10, 2, 18, 41, 10, 854, DateTimeKind.Unspecified) },
                    { 18, 37, new DateTime(2025, 10, 2, 18, 41, 10, 854, DateTimeKind.Unspecified) },
                    { 18, 38, new DateTime(2025, 10, 2, 18, 41, 10, 854, DateTimeKind.Unspecified) }
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
