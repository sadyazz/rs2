using eCinema.Services.Database.Entities;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Services.Database
{
    public class eCinemaDBContext : DbContext
    {
        public eCinemaDBContext(DbContextOptions<eCinemaDBContext> options) : base(options)
        {
        }

        public DbSet<User> Users { get; set; } = null!;
        public DbSet<Role> Roles { get; set; } = null!;
        public DbSet<Hall> Halls { get; set; } = null!;
        public DbSet<Seat> Seats { get; set; } = null!;
        public DbSet<Actor> Actors { get; set; } = null!;
        public DbSet<Movie> Movies { get; set; } = null!;
        public DbSet<Genre> Genres { get; set; } = null!;
        public DbSet<MovieActor> MovieActors { get; set; } = null!;
        public DbSet<MovieGenre> MovieGenres { get; set; } = null!;
        public DbSet<Screening> Screenings { get; set; } = null!;
        public DbSet<ScreeningFormat> ScreeningFormats { get; set; } = null!;
        public DbSet<Reservation> Reservations { get; set; } = null!;
        public DbSet<ReservationSeat> ReservationSeats { get; set; } = null!;
        public DbSet<ScreeningSeat> ScreeningSeats { get; set; } = null!;
        public DbSet<StripePayment> StripePayments { get; set; } = null!;
        public DbSet<Review> Reviews { get; set; } = null!;
        public DbSet<Promotion> Promotions { get; set; } = null!;
        public DbSet<NewsArticle> NewsArticles { get; set; } = null!;
        public DbSet<UserMovieList> UserMovieLists { get; set; } = null!;
        public DbSet<UserPromotion> UserPromotions { get; set; } = null!;

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<StripePayment>(entity =>
            {
                entity.ToTable("StripePayments");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Amount).HasColumnType("decimal(10, 2)");
                entity.Property(e => e.TransactionId).HasMaxLength(100);
                entity.Property(e => e.PaymentDate);
                entity.Property(e => e.PaymentProvider).HasMaxLength(50);
            });

            modelBuilder.Entity<User>()
                .HasIndex(u => u.Username)
                .IsUnique();

            modelBuilder.Entity<User>()
                .HasIndex(u => u.Email)
                .IsUnique();

            modelBuilder.Entity<Role>()
                .HasIndex(r => r.Name)
                .IsUnique();

            modelBuilder.Entity<Actor>()
                .HasIndex(a => new { a.FirstName, a.LastName })
                .IsUnique();

            modelBuilder.Entity<Screening>()
                .HasOne(s => s.Movie)
                .WithMany(m => m.Screenings)
                .HasForeignKey(s => s.MovieId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Screening>()
                .HasOne(s => s.Hall)
                .WithMany()
                .HasForeignKey(s => s.HallId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Screening>()
                .HasOne(s => s.Format)
                .WithMany(sf => sf.Screenings)
                .HasForeignKey(s => s.ScreeningFormatId)
                .OnDelete(DeleteBehavior.SetNull);

            modelBuilder.Entity<Reservation>()
                .HasOne(r => r.User)
                .WithMany(u => u.Reservations)
                .HasForeignKey(r => r.UserId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Reservation>()
                .HasOne(r => r.Screening)
                .WithMany(s => s.Reservations)
                .HasForeignKey(r => r.ScreeningId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<ReservationSeat>()
                .HasKey(rs => new { rs.ReservationId, rs.SeatId });

            modelBuilder.Entity<ReservationSeat>()
                .HasOne(rs => rs.Reservation)
                .WithMany(r => r.ReservationSeats)
                .HasForeignKey(rs => rs.ReservationId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<ReservationSeat>()
                .HasOne(rs => rs.Seat)
                .WithMany()
                .HasForeignKey(rs => rs.SeatId);

            modelBuilder.Entity<ScreeningSeat>()
                .HasKey(ss => new { ss.ScreeningId, ss.SeatId });

            modelBuilder.Entity<ScreeningSeat>()
                .HasOne(ss => ss.Screening)
                .WithMany(s => s.ScreeningSeats)
                .HasForeignKey(ss => ss.ScreeningId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<ScreeningSeat>()
                .HasOne(ss => ss.Seat)
                .WithMany()
                .HasForeignKey(ss => ss.SeatId);

            modelBuilder.Entity<Reservation>()
                .HasOne(r => r.Promotion)
                .WithMany(p => p.Reservations)
                .HasForeignKey(r => r.PromotionId)
                .OnDelete(DeleteBehavior.SetNull);

            modelBuilder.Entity<Reservation>()
                .HasOne(r => r.Payment)
                .WithOne()
                .HasForeignKey<Reservation>(r => r.PaymentId)
                .OnDelete(DeleteBehavior.SetNull);

            modelBuilder.Entity<Review>()
                .HasOne(r => r.User)
                .WithMany(u => u.Reviews)
                .HasForeignKey(r => r.UserId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Review>()
                .HasOne(r => r.Movie)
                .WithMany(m => m.Reviews)
                .HasForeignKey(r => r.MovieId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Review>()
                .HasIndex(r => new { r.UserId, r.MovieId })
                .IsUnique()
                .HasFilter("IsDeleted = 0");

            modelBuilder.Entity<Promotion>()
                .HasIndex(p => p.Code)
                .IsUnique()
                .HasFilter("[Code] IS NOT NULL");

            modelBuilder.Entity<MovieActor>()
                .HasOne(ma => ma.Movie)
                .WithMany(m => m.Actors)
                .HasForeignKey(ma => ma.MovieId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<MovieActor>()
                .HasOne(ma => ma.Actor)
                .WithMany(a => a.MovieActors)
                .HasForeignKey(ma => ma.ActorId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<MovieGenre>()
                .HasOne(mg => mg.Movie)
                .WithMany(m => m.Genres)
                .HasForeignKey(mg => mg.MovieId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<MovieGenre>()
                .HasOne(mg => mg.Genre)
                .WithMany(g => g.MovieGenres)
                .HasForeignKey(mg => mg.GenreId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<UserMovieList>()
                .HasOne(uml => uml.User)
                .WithMany()
                .HasForeignKey(uml => uml.UserId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<UserMovieList>()
                .HasOne(uml => uml.Movie)
                .WithMany()
                .HasForeignKey(uml => uml.MovieId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<UserMovieList>()
                .HasIndex(uml => new { uml.UserId, uml.MovieId, uml.ListType })
                .IsUnique();

            modelBuilder.Entity<UserPromotion>(entity =>
            {
                entity.ToTable("UserPromotions");
                entity.HasKey(e => e.Id);

                entity.HasOne(d => d.User)
                    .WithMany(u => u.UserPromotions)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.Cascade);

                entity.HasOne(d => d.Promotion)
                    .WithMany(p => p.UserPromotions)
                    .HasForeignKey(d => d.PromotionId)
                    .OnDelete(DeleteBehavior.Cascade);

                entity.HasIndex(e => new { e.UserId, e.PromotionId })
                    .IsUnique();
            });

            modelBuilder.Entity<Screening>()
                .Property(s => s.BasePrice)
                .HasColumnType("decimal(10, 2)");

        // Roles
        modelBuilder.Entity<Role>().HasData(
            new Role { Id = 1, Name = "admin" },
            new Role { Id = 2, Name = "user" },
            new Role { Id = 3, Name = "staff" }
        );

        // ScreeningFormats
        modelBuilder.Entity<ScreeningFormat>().HasData(
            new ScreeningFormat
            {
                Id = 1,
                Name = "2D",
                Description = "Standard digital projection",
                PriceMultiplier = 1.0m,
                IsDeleted = false
            },
            new ScreeningFormat
            {
                Id = 2,
                Name = "3D",
                Description = "Immersive 3D experience with special glasses",
                PriceMultiplier = 1.3m,
                IsDeleted = false
            },
            new ScreeningFormat
            {
                Id = 3,
                Name = "IMAX",
                Description = "Premium large-format experience with enhanced picture and sound",
                PriceMultiplier = 1.8m,
                IsDeleted = false
            },
            new ScreeningFormat
            {
                Id = 4,
                Name = "4DX",
                Description = "Motion seats and environmental effects synchronized with the movie",
                PriceMultiplier = 2.0m,
                IsDeleted = false
            }
        );

        // Actors
        modelBuilder.Entity<Actor>().HasData(
            new Actor
            {
                Id = 1,
                FirstName = "Keira",
                LastName = "Knightley",
                DateOfBirth = new DateTime(1985, 3, 26),
                Biography = "English actress known for roles in Pride & Prejudice, Atonement, and Pirates of the Caribbean.",
                Image = null,
                IsDeleted = false
            },
            new Actor
            {
                Id = 2,
                FirstName = "Matthew",
                LastName = "Macfadyen",
                DateOfBirth = new DateTime(1974, 10, 17),
                Biography = "British actor, acclaimed for Succession, Pride & Prejudice, and Ripper Street.",
                Image = null,
                IsDeleted = false
            },
            new Actor
            {
                Id = 3,
                FirstName = "Rosamund",
                LastName = "Pike",
                DateOfBirth = new DateTime(1979, 1, 27),
                Biography = "English actress, Golden Globe winner, known for Gone Girl and Pride & Prejudice.",
                Image = null,
                IsDeleted = false
            },
            new Actor
            {
                Id = 4,
                FirstName = "Dakota",
                LastName = "Fanning",
                DateOfBirth = new DateTime(1994, 2, 23),
                Biography = "American actress and voice actress for Coraline Jones.",
                Image = null,
                IsDeleted = false
            },
            new Actor
            {
                Id = 5,
                FirstName = "Teri",
                LastName = "Hatcher",
                DateOfBirth = new DateTime(1964, 12, 8),
                Biography = "American actress, known for Desperate Housewives and the voice of Mel Jones in Coraline.",
                Image = null,
                IsDeleted = false
            },
            new Actor
            {
                Id = 6,
                FirstName = "Ryan",
                LastName = "Reynolds",
                DateOfBirth = new DateTime(1976, 10, 23),
                Biography = "Canadian actor and producer, best known for his role as Deadpool in the Marvel franchise.",
                Image = null,
                IsDeleted = false
            },
            new Actor
            {
                Id = 7,
                FirstName = "Hugh",
                LastName = "Jackman",
                DateOfBirth = new DateTime(1968, 10, 12),
                Biography = "Australian actor, singer, and producer, widely recognized for portraying Wolverine in the X-Men film series.",
                Image = null,
                IsDeleted = false
            },
            new Actor
            {
                Id = 10,
                FirstName = "Cillian",
                LastName = "Murphy",
                DateOfBirth = new DateTime(1976, 5, 25),
                Biography = "Irish actor known for Peaky Blinders, Inception, and portraying J. Robert Oppenheimer in Christopher Nolan's Oppenheimer.",
                Image = null,
                IsDeleted = false
            },
            new Actor
            {
                Id = 11,
                FirstName = "Robert",
                LastName = "Downey Jr.",
                DateOfBirth = new DateTime(1965, 4, 4),
                Biography = "American actor and producer, acclaimed for his roles in Iron Man, Sherlock Holmes, and Oppenheimer.",
                Image = null,
                IsDeleted = false
            },
            new Actor
            {
                Id = 12,
                FirstName = "Margot",
                LastName = "Robbie",
                DateOfBirth = new DateTime(1990, 7, 2),
                Biography = "Australian actress and producer, known for The Wolf of Wall Street, I, Tonya, and Barbie.",
                Image = null,
                IsDeleted = false
            },
            new Actor
            {
                Id = 13,
                FirstName = "Ryan",
                LastName = "Gosling",
                DateOfBirth = new DateTime(1980, 11, 12),
                Biography = "Canadian actor and musician, known for La La Land, Drive, and his role as Ken in Barbie.",
                Image = null,
                IsDeleted = false
            }
        );

        // Genres
        modelBuilder.Entity<Genre>().HasData(
            new Genre { Id = 1, Name = "Action", Description = "", IsDeleted = false },
            new Genre { Id = 2, Name = "Adventure", Description = "", IsDeleted = false },
            new Genre { Id = 3, Name = "Animation", Description = "", IsDeleted = false },
            new Genre { Id = 4, Name = "Comedy", Description = "", IsDeleted = false },
            new Genre { Id = 5, Name = "Crime", Description = "", IsDeleted = false },
            new Genre { Id = 6, Name = "Documentary", Description = "", IsDeleted = false },
            new Genre { Id = 7, Name = "Drama", Description = "", IsDeleted = false },
            new Genre { Id = 8, Name = "Fantasy", Description = "", IsDeleted = false },
            new Genre { Id = 9, Name = "Horror", Description = "", IsDeleted = false },
            new Genre { Id = 10, Name = "Mystery", Description = "", IsDeleted = false },
            new Genre { Id = 11, Name = "Romance", Description = "", IsDeleted = false },
            new Genre { Id = 12, Name = "Science Fiction", Description = "", IsDeleted = false },
            new Genre { Id = 13, Name = "Thriller", Description = "", IsDeleted = false },
            new Genre { Id = 14, Name = "test soft deleted genre", Description = "test", IsDeleted = false }
        );

        // Halls
        modelBuilder.Entity<Hall>().HasData(
            new Hall { Id = 2, Name = "Kids hall", IsDeleted = false },
            new Hall { Id = 3, Name = "Hall 1", IsDeleted = false },
            new Hall { Id = 4, Name = "Hall 2", IsDeleted = false },
            new Hall { Id = 5, Name = "4DX Hall", IsDeleted = false }
        );

        // Seats
        modelBuilder.Entity<Seat>().HasData(
            // Row A
            new Seat { Id = 1, Name = "A1" },
            new Seat { Id = 2, Name = "A2" },
            new Seat { Id = 3, Name = "A3" },
            new Seat { Id = 4, Name = "A4" },
            new Seat { Id = 5, Name = "A5" },
            new Seat { Id = 6, Name = "A6" },
            new Seat { Id = 7, Name = "A7" },
            new Seat { Id = 8, Name = "A8" },
            // Row B
            new Seat { Id = 9, Name = "B1" },
            new Seat { Id = 10, Name = "B2" },
            new Seat { Id = 11, Name = "B3" },
            new Seat { Id = 12, Name = "B4" },
            new Seat { Id = 13, Name = "B5" },
            new Seat { Id = 14, Name = "B6" },
            new Seat { Id = 15, Name = "B7" },
            new Seat { Id = 16, Name = "B8" },
            // Row C
            new Seat { Id = 17, Name = "C1" },
            new Seat { Id = 18, Name = "C2" },
            new Seat { Id = 19, Name = "C3" },
            new Seat { Id = 20, Name = "C4" },
            new Seat { Id = 21, Name = "C5" },
            new Seat { Id = 22, Name = "C6" },
            new Seat { Id = 23, Name = "C7" },
            new Seat { Id = 24, Name = "C8" },
            // Row D
            new Seat { Id = 25, Name = "D1" },
            new Seat { Id = 26, Name = "D2" },
            new Seat { Id = 27, Name = "D3" },
            new Seat { Id = 28, Name = "D4" },
            new Seat { Id = 29, Name = "D5" },
            new Seat { Id = 30, Name = "D6" },
            new Seat { Id = 31, Name = "D7" },
            new Seat { Id = 32, Name = "D8" },
            // Row E
            new Seat { Id = 33, Name = "E1" },
            new Seat { Id = 34, Name = "E2" },
            new Seat { Id = 35, Name = "E3" },
            new Seat { Id = 36, Name = "E4" },
            new Seat { Id = 37, Name = "E5" },
            new Seat { Id = 38, Name = "E6" },
            new Seat { Id = 39, Name = "E7" },
            new Seat { Id = 40, Name = "E8" },
            // Row F
            new Seat { Id = 41, Name = "F1" },
            new Seat { Id = 42, Name = "F2" },
            new Seat { Id = 43, Name = "F3" },
            new Seat { Id = 44, Name = "F4" },
            new Seat { Id = 45, Name = "F5" },
            new Seat { Id = 46, Name = "F6" },
            new Seat { Id = 47, Name = "F7" },
            new Seat { Id = 48, Name = "F8" }
        );

        // News Articles
        modelBuilder.Entity<NewsArticle>().HasData(
            new NewsArticle
            {
                Id = 1,
                Title = "Coraline Returns for a Halloween 3D Special",
                Content = "Get ready for a spooky night at the cinema! Coraline is back on the big screen in stunning 3D, just in time for Halloween. Don't miss the chance to experience this animated classic like never before.",
                PublishDate = new DateTime(2025, 8, 15, 18, 0, 0),
                IsDeleted = false,
                Type = "news",
                EventDate = null,
                AuthorId = 1,
            },
            new NewsArticle
            {
                Id = 3,
                Title = "Deadpool & Wolverine Premieres Next Month – Tickets on Sale Now!",
                Content = "The wait is almost over! Deadpool & Wolverine hits theaters next month. Secure your tickets today and be among the first to see Marvel's most chaotic duo on the big screen.",
                PublishDate = new DateTime(2025, 7, 10, 12, 0, 0),
                IsDeleted = false,
                Type = "news",
                EventDate = null,
                AuthorId = 1
            },
            new NewsArticle
            {
                Id = 4,
                Title = "Barbie Breaks Box Office Records Worldwide",
                Content = "Barbie has become a global phenomenon, smashing box office records and charming audiences everywhere. Don't miss your chance to watch the year's most talked-about film on the big screen.",
                PublishDate = new DateTime(2025, 8, 1, 10, 0, 0),
                IsDeleted = false,
                Type = "news",
                EventDate = null,
                AuthorId = 1
            },
            new NewsArticle
            {
                Id = 5,
                Title = "Romantic Classics Night: Pride and Prejudice Returns",
                Content = "Join us for a special screening of Pride and Prejudice, the timeless romantic drama that continues to capture hearts around the world. A perfect evening for fans of classic cinema and unforgettable love stories.",
                PublishDate = new DateTime(2025, 8, 20, 19, 0, 0),
                IsDeleted = false,
                Type = "news",
                EventDate = null,
                AuthorId = 1
            },
            new NewsArticle
            {
                Id = 7,
                Title = "Atonement Returns for a Special Screening",
                Content = "Join us for a special screening of Atonement, the timeless romantic drama that continues to capture hearts around the world. A perfect evening for fans of classic cinema and unforgettable love stories.",
                PublishDate = new DateTime(2025, 9, 4, 18, 37, 25, 39),
                IsDeleted = false,
                Type = "event",
                EventDate = new DateTime(2025, 9, 18, 12, 0, 0),
                AuthorId = 1
            },
            new NewsArticle
            {
                Id = 8,
                Title = "The Wolverine: Premiere Date Announced",
                Content = "Premiere Date for the Wolverine sequel has been announced. Don't miss your chance to see the movie on the big screen.",
                PublishDate = new DateTime(2025, 9, 4, 19, 10, 44, 5),
                IsDeleted = false,
                Type = "news",
                EventDate = null,
                AuthorId = 1
            },
            new NewsArticle
            {
                Id = 9,
                Title = "Summer Movie Marathon Announced",
                Content = "Get ready for an epic summer movie marathon! We've curated a lineup of classic and contemporary films that are perfect for a relaxing weekend at the cinema.",
                PublishDate = new DateTime(2025, 9, 4, 19, 11, 28, 554),
                IsDeleted = false,
                Type = "event",
                EventDate = new DateTime(2025, 9, 30, 12, 0, 0),
                AuthorId = 1
            }
        );

        // Promotions
        modelBuilder.Entity<Promotion>().HasData(
            new Promotion
            {
                Id = 2,
                Name = "New user promotion",
                Description = "Welcoming all our new users with a 20% discount on their first purchase.",
                Code = "899",
                DiscountPercentage = 20,
                StartDate = new DateTime(2025, 9, 4),
                EndDate = new DateTime(2025, 10, 31),
                IsDeleted = false
            },
            new Promotion
            {
                Id = 3,
                Name = "eCinema Summer Promotion",
                Description = "50% off",
                Code = "50",
                DiscountPercentage = 50,
                StartDate = new DateTime(2025, 9, 5, 0, 0, 0, 670),
                EndDate = new DateTime(2025, 10, 31),
                IsDeleted = false
            },
            new Promotion
            {
                Id = 4,
                Name = "September Sale",
                Description = "5% discount on all tickets in September.",
                Code = "SEP5",
                DiscountPercentage = 5,
                StartDate = new DateTime(2025, 9, 1),
                EndDate = new DateTime(2025, 9, 30, 23, 59, 59),
                IsDeleted = false
            }
        );

        // Movies
        modelBuilder.Entity<Movie>().HasData(
            new Movie
            {
                Id = 3,
                Title = "Pride and Prejudice",
                Description = "Sparks fly when spirited Elizabeth Bennet meets single, rich, and proud Mr. Darcy. But pride, prejudice and misunderstandings threaten to keep them apart.",
                DurationMinutes = 129,
                Director = "Joe Wright",
                ReleaseDate = new DateTime(2005, 9, 16),
                ReleaseYear = 2005,
                TrailerUrl = "https://www.youtube.com/watch?v=1dYv5u6v55Y",
                Grade = 5,
                Image = null,
                IsComingSoon = false,
                IsDeleted = false
            },
            new Movie
            {
                Id = 4,
                Title = "Coraline",
                Description = "An adventurous girl finds another world that is a strangely idealized version of her frustrating home, but it has sinister secrets.",
                DurationMinutes = 100,
                Director = "Henry Selick",
                ReleaseDate = new DateTime(2009, 2, 6),
                ReleaseYear = 2009,
                TrailerUrl = "https://www.youtube.com/watch?v=LO3n67BQvh0",
                Grade = 5,
                Image = null,
                IsComingSoon = false,
                IsDeleted = false
            },
            new Movie
            {
                Id = 5,
                Title = "Deadpool & Wolverine",
                Description = "Wolverine is recovering from his injuries when he crosses paths with the loudmouth Deadpool. They team up to defeat a common enemy.",
                DurationMinutes = 127,
                Director = "Shawn Levy",
                ReleaseDate = new DateTime(2024, 7, 26),
                ReleaseYear = 2024,
                TrailerUrl = "https://www.youtube.com/watch?v=73_1biulkYk",
                Grade = 5,
                Image = null,
                IsComingSoon = false,
                IsDeleted = false
            },
            new Movie
            {
                Id = 11,
                Title = "Atonement",
                Description = "A romantic drama that follows the consequences of a false accusation that forever changes the lives of two lovers and a young girl.",
                DurationMinutes = 123,
                Director = "Joe Wright",
                ReleaseDate = new DateTime(2025, 12, 1),
                ReleaseYear = 2007,
                TrailerUrl = "https://www.youtube.com/watch?v=rkVg3jWToW0",
                Grade = 0,
                Image = null,
                IsComingSoon = true,
                IsDeleted = false
            },
            new Movie
            {
                Id = 12,
                Title = "The Wolverine",
                Description = "Logan travels to Japan, where he confronts his past and faces a deadly battle that will change him forever.",
                DurationMinutes = 126,
                Director = "James Mangold",
                ReleaseDate = new DateTime(2025, 12, 15),
                ReleaseYear = 2013,
                TrailerUrl = "https://www.youtube.com/watch?v=th1NTVIhUQU",
                Grade = 0,
                Image = null,
                IsComingSoon = true,
                IsDeleted = false
            }
        );

        // MovieGenres
        modelBuilder.Entity<MovieGenre>().HasData(
            new MovieGenre { Id = 1, MovieId = 3, GenreId = 7 },
            new MovieGenre { Id = 2, MovieId = 3, GenreId = 11 },
            new MovieGenre { Id = 3, MovieId = 4, GenreId = 3 },
            new MovieGenre { Id = 4, MovieId = 4, GenreId = 9 },
            new MovieGenre { Id = 5, MovieId = 5, GenreId = 1 },
            new MovieGenre { Id = 6, MovieId = 5, GenreId = 4 },
            new MovieGenre { Id = 7, MovieId = 11, GenreId = 2 },
            new MovieGenre { Id = 8, MovieId = 11, GenreId = 11 },
            new MovieGenre { Id = 9, MovieId = 12, GenreId = 1 }
        );

        // MovieActors
        modelBuilder.Entity<MovieActor>().HasData(
            new MovieActor { Id = 1, MovieId = 3, ActorId = 1 },
            new MovieActor { Id = 2, MovieId = 3, ActorId = 2 },
            new MovieActor { Id = 3, MovieId = 3, ActorId = 3 },
            new MovieActor { Id = 4, MovieId = 4, ActorId = 4 },
            new MovieActor { Id = 5, MovieId = 4, ActorId = 5 },
            new MovieActor { Id = 6, MovieId = 5, ActorId = 6 },
            new MovieActor { Id = 7, MovieId = 5, ActorId = 7 },
            new MovieActor { Id = 8, MovieId = 11, ActorId = 1 },
            new MovieActor { Id = 9, MovieId = 11, ActorId = 3 },
            new MovieActor { Id = 10, MovieId = 12, ActorId = 7 }
        );

        // UserMovieLists
        modelBuilder.Entity<UserMovieList>().HasData(
            
            // User1 (ID: 2)
            new UserMovieList { Id = 3, UserId = 2, MovieId = 3, ListType = "watched", CreatedAt = new DateTime(2025, 9, 1), IsDeleted = false },
            new UserMovieList { Id = 4, UserId = 2, MovieId = 4, ListType = "watched", CreatedAt = new DateTime(2025, 9, 1), IsDeleted = false },
            new UserMovieList { Id = 5, UserId = 2, MovieId = 11, ListType = "favorites", CreatedAt = new DateTime(2025, 9, 1), IsDeleted = false },
            new UserMovieList { Id = 6, UserId = 2, MovieId = 12, ListType = "watchlist", CreatedAt = new DateTime(2025, 9, 1), IsDeleted = false },
            
            // User2 (ID: 3)
            new UserMovieList { Id = 7, UserId = 3, MovieId = 3, ListType = "watched", CreatedAt = new DateTime(2025, 9, 1), IsDeleted = false },
            new UserMovieList { Id = 8, UserId = 3, MovieId = 5, ListType = "watched", CreatedAt = new DateTime(2025, 9, 1), IsDeleted = false },
            new UserMovieList { Id = 9, UserId = 3, MovieId = 11, ListType = "favorites", CreatedAt = new DateTime(2025, 9, 1), IsDeleted = false },
            new UserMovieList { Id = 10, UserId = 3, MovieId = 4, ListType = "watchlist", CreatedAt = new DateTime(2025, 9, 1), IsDeleted = false }
        );

        // Reviews
        modelBuilder.Entity<Review>().HasData(
            new Review 
            { 
                Id = 1,
                UserId = 2,
                MovieId = 3, 
                Rating = 5,
                Comment = "A beautiful adaptation of the classic novel. The cinematography and performances are outstanding.",
                CreatedAt = new DateTime(2025, 9, 2),
                IsDeleted = false,
                IsSpoiler = false,
                IsEdited = false
            },
            new Review 
            { 
                Id = 2,
                UserId = 2,
                MovieId = 4,
                Rating = 4,
                Comment = "Visually stunning and delightfully creepy. Perfect for both kids and adults.",
                CreatedAt = new DateTime(2025, 9, 2),
                IsDeleted = false,
                IsSpoiler = false,
                IsEdited = false
            },
            
            new Review 
            { 
                Id = 3,
                UserId = 3,
                MovieId = 3,
                Rating = 4,
                Comment = "A classic romance brought to life with excellent performances.",
                CreatedAt = new DateTime(2025, 9, 2),
                IsDeleted = false,
                IsSpoiler = false,
                IsEdited = false
            },
            new Review 
            { 
                Id = 4,
                UserId = 3,
                MovieId = 5,
                Rating = 5,
                Comment = "The perfect blend of action and humor. Great chemistry between the leads!",
                CreatedAt = new DateTime(2025, 9, 2),
                IsDeleted = false,
                IsSpoiler = false,
                IsEdited = false
            }
        );

        // Reservations
        modelBuilder.Entity<Reservation>().HasData(
            new Reservation
            {
                Id = 1,
                ReservationTime = new DateTime(2024, 9, 8, 15, 0, 0),
                TotalPrice = 10.00m,
                OriginalPrice = 10.00m,
                DiscountPercentage = null,
                UserId = 2,
                ScreeningId = 1,
                PaymentId = null,
                PromotionId = null,
                NumberOfTickets = 2,
                PaymentType = "Cash",
                State = "UsedReservationState",
                QrcodeBase64 = "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",
                IsDeleted = false
            },
            // ,
            // new Reservation
            // {
            //     Id = 2,
            //     ReservationTime = new DateTime(2024, 9, 8, 15, 10, 0),
            //     TotalPrice = 10.00m,
            //     OriginalPrice = 10.00m,
            //     DiscountPercentage = null,
            //     UserId = 2,
            //     ScreeningId = 2,
            //     PaymentId = null,
            //     PromotionId = null,
            //     NumberOfTickets = 2,
            //     PaymentType = "Cash",
            //     State = "UsedReservationState",
            //     QrcodeBase64 = "",
            //     IsDeleted = false
            // },
            // new Reservation
            // {
            //     Id = 3,
            //     ReservationTime = new DateTime(2024, 3, 14, 12, 0, 0),
            //     TotalPrice = 24.00m,
            //     OriginalPrice = 24.00m,
            //     DiscountPercentage = null,
            //     UserId = 3,
            //     ScreeningId = 3,
            //     PaymentId = null,
            //     PromotionId = null,
            //     NumberOfTickets = 2,
            //     PaymentType = "Card",
            //     State = "Completed",
            //     QrcodeBase64 = "",
            //     IsDeleted = false
            // },
            // new Reservation
            // {
            //     Id = 4,
            //     ReservationTime = new DateTime(2024, 3, 14, 13, 0, 0),
            //     TotalPrice = 10.00m,
            //     OriginalPrice = 10.00m,
            //     DiscountPercentage = null,
            //     UserId = 3,
            //     ScreeningId = 1,
            //     PaymentId = null,
            //     PromotionId = null,
            //     NumberOfTickets = 1,
            //     PaymentType = "Cash",
            //     State = "UsedReservationState",
            //     QrcodeBase64 = "",
            //     IsDeleted = false
            // },
            // // Future reservations
            // new Reservation
            // {
            //     Id = 201,
            //     ReservationTime = new DateTime(2025, 9, 14, 10, 0, 0),
            //     TotalPrice = 20.00m,
            //     OriginalPrice = 20.00m,
            //     DiscountPercentage = null,
            //     UserId = 2,
            //     ScreeningId = 4,
            //     PaymentId = null,
            //     PromotionId = null,
            //     NumberOfTickets = 2,
            //     PaymentType = "Card",
            //     State = "ApprovedReservationState",
            //     QrcodeBase64 = "",
            //     IsDeleted = false
            // },
            // new Reservation
            // {
            //     Id = 202,
            //     ReservationTime = new DateTime(2025, 9, 14, 11, 0, 0),
            //     TotalPrice = 24.00m,
            //     OriginalPrice = 24.00m,
            //     DiscountPercentage = null,
            //     UserId = 2,
            //     ScreeningId = 6,
            //     PaymentId = null,
            //     PromotionId = null,
            //     NumberOfTickets = 2,
            //     PaymentType = "Card",
            //     State = "ApprovedReservationState",
            //     QrcodeBase64 = "",
            //     IsDeleted = false
            // },
            // new Reservation
            // {
            //     Id = 203,
            //     ReservationTime = new DateTime(2025, 9, 14, 12, 0, 0),
            //     TotalPrice = 8.00m,
            //     OriginalPrice = 8.00m,
            //     DiscountPercentage = null,
            //     UserId = 3,
            //     ScreeningId = 5,
            //     PaymentId = null,
            //     PromotionId = null,
            //     NumberOfTickets = 1,
            //     PaymentType = "Card",
            //     State = "ApprovedReservationState",
            //     QrcodeBase64 = "",
            //     IsDeleted = false
            //             },
            new Reservation
            {
                Id = 2,
                ReservationTime = new DateTime(2025, 9, 8, 15, 45, 6, 721),
                TotalPrice = 5.00m,
                OriginalPrice = 5.00m,
                DiscountPercentage = null,
                UserId = 3,
                ScreeningId = 3,
                PaymentId = null,
                PromotionId = null,
                NumberOfTickets = 1,
                PaymentType = null,
                State = "ApprovedReservationState",
                QrcodeBase64 = "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",
                IsDeleted = false
            }
        );

        // ReservationSeats
        modelBuilder.Entity<ReservationSeat>().HasData(
            // Past reservations
            // Reservation 1 seats (2 seats) - User1 watching Pride and Prejudice
            new ReservationSeat { ReservationId = 1, SeatId = 1, ReservedAt = new DateTime(2024, 3, 14, 10, 0, 0) },
            new ReservationSeat { ReservationId = 1, SeatId = 2, ReservedAt = new DateTime(2024, 3, 14, 10, 0, 0) },
            new ReservationSeat { ReservationId = 2, SeatId = 10, ReservedAt = new DateTime(2025, 9, 8, 15, 45, 6, 721) }
            // new ReservationSeat { ReservationId = 1, SeatId = 5, ReservedAt = new DateTime(2024, 3, 14, 10, 0, 0) },
            // // Reservation 2 seat (1 seat) - User1 watching Coraline
            // new ReservationSeat { ReservationId = 2, SeatId = 12, ReservedAt = new DateTime(2024, 3, 14, 11, 0, 0) },
            // // Reservation 3 seats (2 seats) - User2 watching Deadpool & Wolverine
            // new ReservationSeat { ReservationId = 3, SeatId = 44, ReservedAt = new DateTime(2024, 3, 14, 12, 0, 0) },
            // new ReservationSeat { ReservationId = 3, SeatId = 45, ReservedAt = new DateTime(2024, 3, 14, 12, 0, 0) },
            // // Reservation 104 seat (1 seat) - User2 watching Pride and Prejudice
            // new ReservationSeat { ReservationId = 4, SeatId = 6, ReservedAt = new DateTime(2024, 3, 14, 13, 0, 0) },
            
            // Future reservations
            // Reservation 201 seats (2 seats) - User1 booking Pride and Prejudice
            // new ReservationSeat { ReservationId = 201, SeatId = 7, ReservedAt = new DateTime(2025, 9, 14, 10, 0, 0) },
            // new ReservationSeat { ReservationId = 201, SeatId = 8, ReservedAt = new DateTime(2025, 9, 14, 10, 0, 0) },
            // // Reservation 202 seats (2 seats) - User1 booking Deadpool & Wolverine
            // new ReservationSeat { ReservationId = 202, SeatId = 46, ReservedAt = new DateTime(2025, 9, 14, 11, 0, 0) },
            // new ReservationSeat { ReservationId = 202, SeatId = 47, ReservedAt = new DateTime(2025, 9, 14, 11, 0, 0) },
            // // Reservation 203 seat (1 seat) - User2 booking Coraline
            // new ReservationSeat { ReservationId = 203, SeatId = 13, ReservedAt = new DateTime(2025, 9, 14, 12, 0, 0) }
        );

        // Screenings
        modelBuilder.Entity<Screening>().HasData(
            // Past screenings (for reviews)
            new Screening
            {
                Id = 1,
                StartTime = new DateTime(2025, 9, 8, 16, 0, 0),
                EndTime = new DateTime(2025, 9, 8, 18, 0, 0),
                BasePrice = 5.00m,
                Language = "English",
                HasSubtitles = false,
                IsDeleted = false,
                MovieId = 4,
                HallId = 3,
                ScreeningFormatId = 1
            },
            new Screening
            {
                Id = 2,
                StartTime = new DateTime(2025, 9, 8, 17, 0, 0),
                EndTime = new DateTime(2025, 9, 8, 18, 0, 0),
                BasePrice = 5.00m,
                Language = "English",
                HasSubtitles = false,
                IsDeleted = false,
                MovieId = 3,
                HallId = 3,
                ScreeningFormatId = 2
            },
            new Screening
            {
                Id = 3,
                StartTime = new DateTime(2025, 9, 8, 18, 20, 0),
                EndTime = new DateTime(2025, 9, 8, 20, 0, 0),
                BasePrice = 10.00m,
                Language = "English",
                HasSubtitles = false,
                IsDeleted = false,
                MovieId = 5,
                HallId = 3,
                ScreeningFormatId = 1
            },
            // Future screenings
            new Screening
            {
                Id = 4,
                StartTime = new DateTime(2025, 10, 8, 19, 0, 0),
                EndTime = new DateTime(2025, 9, 8, 21, 0, 0),
                BasePrice = 5.00m,
                Language = "English",
                HasSubtitles = false,
                IsDeleted = false,
                MovieId = 5,
                HallId = 5,
                ScreeningFormatId = 4
            },
            new Screening
            {
                Id = 5,
                StartTime = new DateTime(2025, 9, 30, 12, 0, 0),
                EndTime = new DateTime(2025, 9, 30, 14, 0, 0),
                BasePrice = 3.00m,
                Language = "English",
                HasSubtitles = true,
                IsDeleted = false,
                MovieId = 4,
                HallId = 2,
                ScreeningFormatId = 2
            },
            new Screening
            {
                Id = 6,
                StartTime = new DateTime(2025, 9, 29, 13, 0, 0),
                EndTime = new DateTime(2025, 9, 29, 15, 0, 0),
                BasePrice = 5.00m,
                Language = "English",
                HasSubtitles = false,
                IsDeleted = false,
                MovieId = 3,
                HallId = 4,
                ScreeningFormatId = 1
            }
        );

        // Users
        modelBuilder.Entity<User>().HasData(
            new User
            {
                Id = 1,
                FirstName = "Admin",
                LastName = "User",
                Username = "admin",
                Email = "admin@ecinema.com",
                PasswordHash = "J5qnG1xNtwotwXcoIJBDmmKs8ZiiQOzvLcargw5ZV+4=",
                PasswordSalt = "FV4HsweUjkWW7Fc6zXVdJA==",
                CreatedAt = new DateTime(2025, 1, 1),
                RoleId = 1,
                IsDeleted = false
            },
            new User
            {
                Id = 2,
                FirstName = "User",
                LastName = "One",
                Username = "user1",
                Email = "user1@ecinema.com",
                PasswordHash = "J5qnG1xNtwotwXcoIJBDmmKs8ZiiQOzvLcargw5ZV+4=",
                PasswordSalt = "FV4HsweUjkWW7Fc6zXVdJA==",
                CreatedAt = new DateTime(2025, 1, 1),
                RoleId = 2,
                IsDeleted = false
            },
            new User
            {
                Id = 3,
                FirstName = "User",
                LastName = "Two",
                Username = "user2",
                Email = "user2@ecinema.com",
                PasswordHash = "J5qnG1xNtwotwXcoIJBDmmKs8ZiiQOzvLcargw5ZV+4=",
                PasswordSalt = "FV4HsweUjkWW7Fc6zXVdJA==",
                CreatedAt = new DateTime(2025, 1, 1),
                RoleId = 2,
                IsDeleted = false
            },
            new User
            {
                Id = 4,
                FirstName = "Staff",
                LastName = "User",
                Username = "staff",
                Email = "staff@ecinema.com",
                PasswordHash = "J5qnG1xNtwotwXcoIJBDmmKs8ZiiQOzvLcargw5ZV+4=",
                PasswordSalt = "FV4HsweUjkWW7Fc6zXVdJA==",
                CreatedAt = new DateTime(2025, 1, 1),
                RoleId = 3,
                IsDeleted = false
            }
        );
        }
    }
}