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
                PublishDate = new DateTime(2025, 10, 1, 18, 0, 0),
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
                PublishDate = new DateTime(2025, 10, 2, 10, 0, 0),
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
                PublishDate = new DateTime(2025, 9, 20, 19, 0, 0),
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
                PublishDate = new DateTime(2025, 9, 14, 18, 37, 25, 39),
                IsDeleted = false,
                Type = "event",
                EventDate = new DateTime(2025, 10, 10, 12, 0, 0),
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
                Title = "Fall Movie Marathon Announced",
                Content = "Get ready for an epic fall movie marathon! We've curated a lineup of classic and contemporary films that are perfect for a relaxing weekend at the cinema.",
                PublishDate = new DateTime(2025, 9, 20, 19, 11, 28, 554),
                IsDeleted = false,
                Type = "event",
                EventDate = new DateTime(2025, 10, 1, 12, 0, 0),
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
                Name = "Fall Promotion",
                Description = "50% off",
                Code = "50",
                DiscountPercentage = 50,
                StartDate = new DateTime(2025, 9, 20, 0, 0, 0, 670),
                EndDate = new DateTime(2025, 11, 30),
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
            new UserMovieList { Id = 3, UserId = 2, MovieId = 3, ListType = "watched", CreatedAt = new DateTime(2025, 9, 1), IsDeleted = false },
            new UserMovieList { Id = 4, UserId = 2, MovieId = 4, ListType = "watched", CreatedAt = new DateTime(2025, 9, 1), IsDeleted = false },
            new UserMovieList { Id = 5, UserId = 2, MovieId = 11, ListType = "favorites", CreatedAt = new DateTime(2025, 9, 1), IsDeleted = false },
            new UserMovieList { Id = 6, UserId = 2, MovieId = 12, ListType = "watchlist", CreatedAt = new DateTime(2025, 9, 1), IsDeleted = false },
            new UserMovieList { Id = 7, UserId = 3, MovieId = 3, ListType = "watched", CreatedAt = new DateTime(2025, 9, 1), IsDeleted = false },
            new UserMovieList { Id = 8, UserId = 3, MovieId = 5, ListType = "watched", CreatedAt = new DateTime(2025, 9, 1), IsDeleted = false },
            new UserMovieList { Id = 9, UserId = 3, MovieId = 11, ListType = "favorites", CreatedAt = new DateTime(2025, 9, 1), IsDeleted = true },
            new UserMovieList { Id = 10, UserId = 3, MovieId = 4, ListType = "watchlist", CreatedAt = new DateTime(2025, 9, 1), IsDeleted = false },
            new UserMovieList { Id = 11, UserId = 2, MovieId = 3, ListType = "favorites", CreatedAt = new DateTime(2025, 10, 2, 17, 57, 15, 343), IsDeleted = false },
            new UserMovieList { Id = 12, UserId = 3, MovieId = 12, ListType = "watchlist", CreatedAt = new DateTime(2025, 10, 2, 18, 3, 25, 825), IsDeleted = false },
            new UserMovieList { Id = 13, UserId = 3, MovieId = 5, ListType = "favorites", CreatedAt = new DateTime(2025, 10, 2, 18, 3, 52, 579), IsDeleted = false }
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
                CreatedAt = new DateTime(2025, 10, 2),
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
                CreatedAt = new DateTime(2025, 10, 2),
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
                CreatedAt = new DateTime(2025, 10, 2),
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

        // New Reservation
        modelBuilder.Entity<Reservation>().HasData(
            new Reservation
            {
                Id = 3,
                ReservationTime = new DateTime(2025, 10, 2, 20, 0, 10, 83),
                TotalPrice = 10.00m,
                OriginalPrice = 10.00m,
                DiscountPercentage = 0.00m,
                UserId = 2,
                ScreeningId = 4,
                PaymentId = null,
                PromotionId = null,
                NumberOfTickets = 2,
                PaymentType = "Cash",
                State = "ApprovedReservationState",
                QrcodeBase64 = "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",
                IsDeleted = false
            },
            new Reservation
            {
                Id = 4,
                ReservationTime = new DateTime(2025, 10, 2, 20, 0, 33, 21),
                TotalPrice = 14.00m,
                OriginalPrice = 14.00m,
                DiscountPercentage = 0.00m,
                UserId = 2,
                ScreeningId = 20,
                PaymentId = null,
                PromotionId = null,
                NumberOfTickets = 2,
                PaymentType = "Cash",
                State = "ApprovedReservationState",
                QrcodeBase64 = "iVBORw0KGgoAAAANSUhEUgAABgQAAAYEAQAAAAAK71yqAAALdElEQVR4nO3ZUa4Dtw0FUO1g9r/L2YGLtLZJkbIbIJHVFIcfhseSqHv4N++Nxz+87nE6wV8tgvNFcL4IzhfB+SI4XwTni+B8EZwvgvNFcL4IzhfB+SI4XwTni+B8EZwvgvNFcL4IzhfB+SI4XwTni+B8EZwvgvNFcL4IzhfB+SI4XwTni+B8EZwvgvNFcL4IzhfB+SI4XwTni+B8ZcGodf3x2/Vc+GPvf357H037/v347FK2XG1zfOQTd766nejRCAgICAgICAgICAgICAg2C+L3x+KKSfqMfC8u68iPTVuy6DzVx2gEBAQEBAQEBAQEBAQEBFsFqyjtceRk+UTU1Y7Fi3/5LY+lx/gejYCAgICAgICAgICAgIDgt4I7N85v4f19fJXxmSz+LBD7Xgs57bRQxkdAQEBAQEBAQEBAQEBAcFqQH0vjKUCRjFp9GKvITX8REBAQEBAQEBAQEBAQEBwVNNDq7pIsQH0OZfV9bfXFQ7ntYzQCAgICAgICAgICAgICgs2CsWj8P/LRoxEQEBAQEBAQEBAQEBAQbBWs634fmF7Pn+bofrWT8Vu5/vkuX/4FHo/TvlXnOR8BAQEBAQEBAQEBAQEBwR5B+Ud1NIn6EDRHKbRy7PXv7ty5nw1kG+Q0GwICAgICAgICAgICAgKCXYJn5AkUHxGqdC9BW9q7NS0XlaalQYBWoyIgICAgICAgICAgICAg2Ce4MiO2fewZeXLj+K3QVgOKEZTb+moLT0BAQEBAQEBAQEBAQECwVdAvy9dO7+3Phf7enofRb8wL0SDgH1bLPAgICAgICAgICAgICAgIfiSItLnxdDRLr3Y2/1YEXZ/3rSZyz01X8yIgICAgICAgICAgICAg2CNYXREpSrK8OuZjj0ZrkVejKoPs4cv4CAgICAgICAgICAgICAg2C1Yp7nxZ2VcEcayYn2enj/+GvBb9Yl+eOgEBAQEBAQEBAQEBAQHBNkHuPn3Lvnu+bORQ5WxIn7+NRcaocqKPlICAgICAgICAgICAgIDgR4KyY9W4bC65C7fsy7/1OcT4ykDb5naCgICAgICAgICAgICAgGCPYOQ8Ee/5bbwfC/fVOG/5yLhzl1avLk3wEUlAQEBAQEBAQEBAQEBAsEeQk03x2o1TlJI7j+BDqGIu44uMOcuUam5PQEBAQEBAQEBAQEBAQLBDkCO/vq0fo9N4P165S3ss+76NJWd5zLnH8hgBAQEBAQEBAQEBAQEBwR5BuaKculuTspB9V7oimVv4e92vfXwsAgICAgICAgICAgICAoJdgvGOMv3WosTHazWHmibS4AX0bQ4lQZsNAQEBAQEBAQEBAQEBAcFWQb+xCMq7d77nY4ryap/vHiXUx8cytNyPgICAgICAgICAgICAgGCjIOe+R18ds29K9iX8/V4Ys/7DQmaMNjQCAgICAgICAgICAgICgv2COJAzxvmS5zHfc7UGrd94T+RehBqzZfpWjhEQEBAQEBAQEBAQEBAQ7Be01/O+kJtEnkc+FvrYl0NdDVn2lXf5VSsCAgICAgICAgICAgICgv2CHL7c/Wiv7AWZuSNLv7dfZcxTuuZ7r3f73JSAgICAgICAgICAgICAYJvg40d0X/X8ctm92HfN0klfMsao1pMjICAgICAgICAgICAgINgjKOfzPf0xTuRvBb7a8vjU5c7cNtcvjwQEBAQEBAQEBAQEBAQE2wQf9z4b329k+XbNXT78lofRg5YZ/kkQAQEBAQEBAQEBAQEBAcEOQWkSkdegVdDyLSJHsj6WiFxm2BIQEBAQEBAQEBAQEBAQEPxY0B5fGZvqnq+9m/kLYzqWJ/c6kZuOxRYCAgICAgICAgICAgICgt2CZ9ArX7a6J3zlxrYaVeD3el+b3KoICAgICAgICAgICAgICH4iKJbnt1fjdv4laNzie+QteQ59LNEvr0aXK0cjICAgICAgICAgICAgINgqeC5GshLvtVpSlGOtwdUEq3llfSyMRSsCAgICAgICAgICAgICgt8JyrYWasxBp1CjVnQZGf4xT9mXEzzmywkICAgICAgICAgICAgIfilY1ZWvaHk+fnvV+8bRxvJ6fNS6R63FFgICAgICAgICAgICAgKCPYIp3vqy6BSrvUqyuDv7rnlf9+WPx2ILAQEBAQEBAQEBAQEBAcFGQdkx5opkxddClRNjTFO63t/G3KVbsv4eo3QmICAgICAgICAgICAgINgqKHlyp0e+Ihile2zO36Y8uV/Ax+KOXvkiAgICAgICAgICAgICAoL9gqlnCbU4mnpm1ZX7ldmsfGWhtIrHNhYCAgICAgICAgICAgICgo2Ckmx1RWmXkdPdqwDrzX027diVf8urBAQEBAQEBAQEBAQEBARbBa97ntU7FWS7eyxuHOuJlLFk/WNx751TzZkJCAgICAgICAgICAgICPYKcqcINZ3P8abHUtGlNY3fYiLXIsZroXwQEBAQEBAQEBAQEBAQEGwVtNuveWE6OjeZ4l0NtLqjdM4zvBbfplQEBAQEBAQEBAQEBAQEBPsFJUV+HO837pHT5nsi45U/VqGyKpoW3z1fObWfMxMQEBAQEBAQEBAQEBAQ7BCsO020nHHkPOWej2MpGTO3q/LCvc5CQEBAQEBAQEBAQEBAQLBPcL2/jfna68vq9yhldT2gMpvS5ZEZ0YWAgICAgICAgICAgICAYLNgahydntUbx0t5eT0v0o/wHOr1mP82sCoCAgICAgICAgICAgICgt8J1j2j3ZX3xebWuEzkni2xebptfceqaW5AQEBAQEBAQEBAQEBAQLBRsNp751MRuVhKlyx4LDaHftr3cQSrLQQEBAQEBAQEBAQEBAQEmwVTnvJtjYyM/ZW9qa55VNH0btJSawYBAQEBAQEBAQEBAQEBwR5BiVwuy72uRair3Z2lV74hP34XXPNY+l8dCAgICAgICAgICAgICAi2CnK7EuVujVfJ2kKcmKpFLl1WjPUICAgICAgICAgICAgICAh+IMh1vaNMoJynB4iF6FLy5M4lY7l86pKLgICAgICAgICAgICAgGCXYHqXL9++bBn5t3jMoK5q7cuJ6DJNroyAgICAgICAgICAgICAgGCXIH7PTR75W77sfifqN2ZzSftolhaqBIrZXHMWAgICAgICAgICAgICAoLdglX3j8j1lnLFxFhHnsxlXsEoFgICAgICAgICAgICAgKCXwg643l0tHZ5YarVQrG0UY3cNIcvI7hrKwICAgICAgICAgICAgKCbYLvB/KNL0t5ZW9zmN7My2q5t5z4eNvXN30CAgICAgICAgICAgICgr9TENvGp/B9IUcef+pPAG1A99x+ihF3LIZGQEBAQEBAQEBAQEBAQLBDsKpyd0gL48uNH0K1q2L1ynfkLut7CQgICAgICAgICAgICAh2CEatqV1+xZ5ez/Pq6sardW557rwQnVsXAgICAgICAgICAgICAoJfCq68lMMX3xQqg/q+3Pl+b75z7jagRw66nkgkJSAgICAgICAgICAgICDYKMgZr7UqLgtB3Li2FNAY3yYXTa+vEyEgICAgICAgICAgICAgOCFolnhbn/KUwKVpPnHNwxjrfvlvCHdOlYuAgICAgICAgICAgICA4MeCWC3fPoYqeb4vlFDryb3OEhAQEBAQEBAQEBAQEBD8UrDuNN7n49peEa+kbZGnE21UYX58WSAgICAgICAgICAgICAg2CwoNTUpnfJrd38LL13ytR25mtIK3hoQEBAQEBAQEBAQEBAQEGwU/DOL4HwRnC+C80VwvgjOF8H5IjhfBOeL4HwRnC+C80VwvgjOF8H5IjhfBOeL4HwRnC+C80VwvgjOF8H5IjhfBOeL4HwRnC+C80VwvgjOF8H5IjhfBOeL4HwRnC+C80VwvgjOF8H5Ijhf/weCfwFwc5i3XoveiAAAAABJRU5ErkJggg==",
                IsDeleted = false
            },
            new Reservation
            {
                Id = 5,
                ReservationTime = new DateTime(2025, 10, 2, 20, 0, 50, 11),
                TotalPrice = 6.00m,
                OriginalPrice = 6.00m,
                DiscountPercentage = 0.00m,
                UserId = 2,
                ScreeningId = 17,
                PaymentId = null,
                PromotionId = null,
                NumberOfTickets = 2,
                PaymentType = "Cash",
                State = "UsedReservationState",
                QrcodeBase64 = "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",
                IsDeleted = false
            },
            new Reservation
            {
                Id = 6,
                ReservationTime = new DateTime(2025, 10, 2, 20, 1, 3, 506),
                TotalPrice = 8.00m,
                OriginalPrice = 8.00m,
                DiscountPercentage = 0.00m,
                UserId = 2,
                ScreeningId = 9,
                PaymentId = null,
                PromotionId = null,
                NumberOfTickets = 2,
                PaymentType = "Cash",
                State = "ApprovedReservationState",
                QrcodeBase64 = "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",
                IsDeleted = false
            },
            new Reservation
            {
                Id = 7,
                ReservationTime = new DateTime(2025, 10, 2, 20, 1, 15, 772),
                TotalPrice = 14.00m,
                OriginalPrice = 14.00m,
                DiscountPercentage = 0.00m,
                UserId = 2,
                ScreeningId = 18,
                PaymentId = null,
                PromotionId = null,
                NumberOfTickets = 2,
                PaymentType = "Cash",
                State = "ApprovedReservationState",
                QrcodeBase64 = "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",
                IsDeleted = false
            },
            new Reservation
            {
                Id = 8,
                ReservationTime = new DateTime(2025, 10, 2, 20, 1, 35, 562),
                TotalPrice = 12.00m,
                OriginalPrice = 12.00m,
                DiscountPercentage = 0.00m,
                UserId = 2,
                ScreeningId = 22,
                PaymentId = null,
                PromotionId = null,
                NumberOfTickets = 2,
                PaymentType = "Cash",
                State = "CancelledReservationState",
                QrcodeBase64 = "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",
                IsDeleted = false
            },
            new Reservation
            {
                Id = 9,
                ReservationTime = new DateTime(2025, 10, 2, 20, 1, 49, 240),
                TotalPrice = 14.00m,
                OriginalPrice = 14.00m,
                DiscountPercentage = 0.00m,
                UserId = 2,
                ScreeningId = 23,
                PaymentId = null,
                PromotionId = null,
                NumberOfTickets = 2,
                PaymentType = "Cash",
                State = "ApprovedReservationState",
                QrcodeBase64 = "iVBORw0KGgoAAAANSUhEUgAABgQAAAYEAQAAAAAK71yqAAALbklEQVR4nO3YQZLEtg0FUN5A97+lbtCpxOohCKDbrko4tFMPi6mWSAL/cacZr3943eN0gv+2CM4XwfkiOF8E54vgfBGcL4LzRXC+CM4XwfkiOF8E54vgfBGcL4LzRXC+CM4XwfkiOF8E54vgfBGcL4LzRXC+CM4XwfkiOF8E54vgfBGcL4LzRXC+CM4XwfkiOF8E54vgfBGcL4LzFQUj1/XHjvGfP+mxLMwG179/vTfP1ThobnnFzc+J2SX9StEICAgICAgICAgICAgICLYKri9znhGLNNGed6lBt68L/4qrXZb+kYCAgICAgICAgICAgIBgo+DJcTWPaWHOvn8yps0J9F6NadO7D4wuAQEBAQEBAQEBAQEBAQHBrwvinJmnm71YUooyNqWt0qfLa21AQEBAQEBAQEBAQEBAQPB3EczuX5DvxwRP+umLjO7sRUBAQEBAQEBAQEBAQEBwVNA/VkZaeN6l3NdPq3n2+nm8f/681ng16NdoBAQEBAQEBAQEBAQEBAR7BKME+Nv8qdEICAgICAgICAgICAgICLYKvtQdQQ/3ehamPu1Lm2eU+G6UfxDMprPf12gEBAQEBAQEBAQEBAQEBHsEd2wyM8Y81TIrplge07u/JLjXGMsMAgICAgICAgICAgICAoLfEExGF+8qGdPsRJvvulBp37M6B11x7sdVAgICAgICAgICAgICAoJ9gjtOjGnr7LSQosRftd+8gngZ6arSoHe+qCIgICAgICAgICAgICAg2CiYp7q9z+BlSwmwhC/DXuvZOi1eVc0df8WRBAQEBAQEBAQEBAQEBAQ7BF2T2emZmBgz99WkHT+trtJ5PqZ45diSqjAICAgICAgICAgICAgICHYJ7nI0thtxWIqcTsSM88SSOwUtqmVkugICAgICAgICAgICAgICgv2C58g72Wwcw7+a3N3ElOe19kvH6sh4YnlXioCAgICAgICAgICAgIBgj6DL2AWIGWOnECW9i6sjchOo/Kr31cwlICAgICAgICAgICAgINgmmClinmViUV2xe8qYks0/pVX32N3DNBMQEBAQEBAQEBAQEBAQ7BeMdeLSJIX6GD6O7Tq/1hMp6Hycqx+LgICAgICAgICAgICAgGC/YJQAqWcEvR9ng9hvCRV97xnzvvqmc+5yjICAgICAgICAgICAgIBgqyCer8PK4wyVruBa+12f2qcTd1mIqtqKgICAgICAgICAgICAgGCrII19ol7ruzns9bNlrHkqN85eTszN0dddxui3EBAQEBAQEBAQEBAQEBD8hmDEAKnJz9ExQalKgLRv3kP6z0EdFFfrZgICAgICAgICAgICAgKCfYL7T/Yuka+1e3cFs+lyIv4acfUjY0Z7zsYFAgICAgICAgICAgICAoIdgjh7jh1ldumZatmSJqYr6OKluV2X9V4JCAgICAgICAgICAgICHYIZp746/758yFU1F+lQXz8wOhP3P1ZAgICAgICAgICAgICAoJfEnQj4mf3GMvmWR2ohi8pZvur2bLcXFy9x1i7EBAQEBAQEBAQEBAQEBDsEHw59V6NybrZ73ely2KJyBq5v4wuPAEBAQEBAQEBAQEBAQHBbkHJM+tq8owysczppDVZupZOkIYTEBAQEBAQEBAQEBAQEGwVzB3xVGo8v8dH/JVGRGT1xS39x/uIm6/4rulHQEBAQEBAQEBAQEBAQLBN8Pya3efREX8lQaRdsd88llbj2bQ5IefIpTMBAQEBAQEBAQEBAQEBwWbBiCnmqTQnjpiP10+KD1FKq1G6xHtIq691yyu8IyAgICAgICAgICAgICDYIUgZ45yrmZhAH47F2fPE6+fYu8qxGXS5oKYLAQEBAQEBAQEBAQEBAcEewd18ZyfBYomb3wtzxBdzGjlPXOu1fIixNiAgICAgICAgICAgICAg2CN4Vz/xLlGi5RWRZXMy1y7R8hc2ExAQEBAQEBAQEBAQEBDsFqRT6UC0LNK0JdKu+C79I6E0S/806P6MuIWAgICAgICAgICAgICA4DcES9qpmp/iXxZqitS5v6C7tIpnaxYCAgICAgICAgICAgICgv2CeWCslWaXuuO+FG+C+ppN7zXePWpVFQEBAQEBAQEBAQEBAQHBZkG3N33BT1VHm6AuT+2cbq7cyIj9misgICAgICAgICAgICAgINgheJpc66k6LI14FrqxH1Wd71oHpRkfi4CAgICAgICAgICAgIBgjyAOe88uYyfoFaVpWHn3DhWv6o2M/T4wipmAgICAgICAgICAgICA4FcE8/wc8SXAkiKdLdw5e9lSkPdP09llrKDYioCAgICAgICAgICAgIBgj2DuGE27a+205I6qNPvbjUR4tZRpozlBQEBAQEBAQEBAQEBAQLBHkMbG8x/rKhNT5Ni5Y6Th813a/LEICAgICAgICAgICAgICLYK7rXTeyF+Yt9fUnTf7eXrf6xB6z8SumPxcr9+6RMQEBAQEBAQEBAQEBAQ/A8Ez6kPacu78TNnRHNc6JBLl7g6h49VcBXzmpmAgICAgICAgICAgICAYIcghq/xYtA77nvyLClivBq0qEbUl0HpguYVEBAQEBAQEBAQEBAQEBDsFyyR42P6br/LQvkyT1vqsdQ03WGqeEsEBAQEBAQEBAQEBAQEBLsFydI3/jYxxqv62ODb2Wd1Mad+MSsBAQEBAQEBAQEBAQEBwUbBaCr2fOdJ3Tt4BM3cVxPvWjeP5tis0oCAgICAgICAgICAgICAYKPg+pT2Q6cpiOGXfqlBv9DNrZdRZhAQEBAQEBAQEBAQEBAQ7BK8d8RkC2MuxF+jTCyPIwb4qOpW48K7CAgICAgICAgICAgICAj2C/rIc/YULH9msnIZHzrPYzHUvQ5KqrFuJiAgICAgICAgICAgICDYL5jd3026yF278q5G6bjlqmbkufm1zl1CEhAQEBAQEBAQEBAQEBDsEqTcfd1xTvlTo8Q8c7V+83czkrmEJyAgICAgICAgICAgICDYKuiiLI/Rdz8PJe1yrLuW0mp5VwRLvjiSgICAgICAgICAgICAgGCjoPseT6vpY7sP9U72/Kmhyj2kfXfOmBcijYCAgICAgICAgICAgIBgj+BpN9Zt6fwdY6YAKUrH6B7L8LvZnEDxkYCAgICAgICAgICAgIDgFwSTMS0paOn+Wjdfnxa6UPd6c6mW1RVOQEBAQEBAQEBAQEBAQLBDMBfHWl2yQrt+uowybJ2YG0TQXJ3VpSIgICAgICAgICAgICAg+BVBqRnv/T3e7euCxgbLZaSg8Uu/+2/CclUlAQEBAQEBAQEBAQEBAQHBVkHtHmvpNIP2qqVSxjhoTkv61GXJR0BAQEBAQEBAQEBAQECwVdBVyf1qfnWMZU6JNxnL9SVa6XKtgQgICAgICAgICAgICAgINgpGruVo/FUDzHepQRqb/nSCvsG13kOcS0BAQEBAQEBAQEBAQECwR9D1vNbcXYD64Z+2PLO77/ba/q+fICAgICAgICAgICAgICDYLRh/1NI4+t4ZU/duxGjqOTZr2RdXuwZXuWYCAgICAgICAgICAgICgt8UlACvJuP7V1RVabmWez37WuPd69w7+ggICAgICAgICAgICAgI/j6C1L1HfqS9G8Q8y2riRnNCEhAQEBAQEBAQEBAQEBDsFhTQPL9MjD1n1dnlHpY8M3wUdDPSlngZBAQEBAQEBAQEBAQEBAR7BKnSgW+C11rxXbf5blaXtJPWr84iICAgICAgICAgICAgINgj+GcWwfkiOF8E54vgfBGcL4LzRXC+CM4XwfkiOF8E54vgfBGcL4LzRXC+CM4XwfkiOF8E54vgfBGcL4LzRXC+CM4XwfkiOF8E54vgfBGcL4LzRXC+CM4XwfkiOF8E54vgfBGcL4LzRXC+/g8E/wJ/kQ/VxoIG1QAAAABJRU5ErkJggg==",
                IsDeleted = false
            },
            new Reservation
            {
                Id = 10,
                ReservationTime = new DateTime(2025, 10, 2, 20, 2, 22, 773),
                TotalPrice = 12.00m,
                OriginalPrice = 12.00m,
                DiscountPercentage = 0.00m,
                UserId = 2,
                ScreeningId = 12,
                PaymentId = null,
                PromotionId = null,
                NumberOfTickets = 2,
                PaymentType = "Cash",
                State = "ApprovedReservationState",
                QrcodeBase64 = "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",
                IsDeleted = false
            },
            new Reservation
            {
                Id = 11,
                ReservationTime = new DateTime(2025, 10, 2, 20, 38, 53, 363),
                TotalPrice = 15.00m,
                OriginalPrice = 15.00m,
                DiscountPercentage = 0.00m,
                UserId = 3,
                ScreeningId = 7,
                PaymentId = null,
                PromotionId = null,
                NumberOfTickets = 3,
                PaymentType = "Cash",
                State = "UsedReservationState",
                QrcodeBase64 = "iVBORw0KGgoAAAANSUhEUgAABgQAAAYEAQAAAAAK71yqAAALdElEQVR4nO3YXa4quxEG0J5Bz3+WzIBIN4Drj30SRd6+N1r1gKBtV33Lb831/IfX4zqd4H8tgvNFcL4IzhfB+SI4XwTni+B8EZwvgvNFcL4IzhfB+SI4XwTni+B8EZwvgvNFcL4IzhfB+SI4XwTni+B8EZwvgvNFcL4IzhfB+SI4XwTni+B8EZwvgvNFcL4IzhfB+SI4XwTni+B8RcFV6w7b/l1/fWvP0tlhRG26Pl6rd9sXf95/iEZAQEBAQEBAQEBAQEBAsEdwx8nxaBn7jAsvVUKWze2C7vZsGvlzNAICAgICAgICAgICAgKC/YIfIr9Xy+v5HGV1SQuL+4O5X8EUjYCAgICAgICAgICAgIDg1wVl4koRQc/Q7oqtvgjis/XzjqstFQEBAQEBAQEBAQEBAQHB30eQVkuKIo0NrvazcdextKXEICAgICAgICAgICAgICA4I2g/HzlPYsQoz7g5fnvWiTVFuYc/NWj9CAgICAgICAgICAgICAj2CEq95/wdPno0AgICAgICAgICAgICAoKtgp/rr4P/wQv4vO9dr78F0t8Hpf3652Ct/lAEBAQEBAQEBAQEBAQEBLsEjzjnFWA9K5FTxhJqej0vTdexNSOulmflIgkICAgICAgICAgICAgIdgviYmmSQq3NBVmGxaa93w9bpltaF3TXiyQgICAgICAgICAgICAg2CF4NUnxpoxNdbezc54vndfZlqDrByQBAQEBAQEBAQEBAQEBwQ5BjLdy35+FFGVNjCe6oHQux6fNcW6JnPoREBAQEBAQEBAQEBAQEGwVxMVHZlxD0GnElOwdKga4vvm6paUq90BAQEBAQEBAQEBAQEBAsEfwp07voGtfVJUT72PTPZR4cXi/viJo90VAQEBAQEBAQEBAQEBAsEcQd6RhU+OWJ1UJEPWl7nji693Eey1FQEBAQEBAQEBAQEBAQLBRsDo1WorXfEXw9Qq6+StorTbkGklAQEBAQEBAQEBAQEBAsEcwJYvPHp+Pwr3is3YP6e+DsmX1W6tRXzZP90VAQEBAQEBAQEBAQEBAsEcw7Xj1usOBaz0rH5HxHGjPdhkNWQb1nwQEBAQEBAQEBAQEBAQEvyRY7eLeR0v7w4h3xcgrY6nUoFzVdEGvj3alBAQEBAQEBAQEBAQEBAQbBc8cdK1eMVT0pdzf5lwzstxXGTRdxrNeJAEBAQEBAQEBAQEBAQHBDkHce8Uoa84aO3QKGWOXTivhf246N4iZCQgICAgICAgICAgICAj2CiZQmdiQ79nrWYkXz365m+KLoHXsfj5zSAICAgICAgICAgICAgKCXxDM7a7WeC1EVc/Yft65SxKUu4n52jUTEBAQEBAQEBAQEBAQEOwRPPOpR0u7qv18xi0rRXz2bF1ag+d8osW4CQgICAgICAgICAgICAi2C9LietkukWPPNHsa0V7oV6ipSwrfGI98NwQEBAQEBAQEBAQEBAQEvyRIB2K7Rx7WkXFiSrE2ty6rYrIUOV1VzkxAQEBAQEBAQEBAQEBAsENQ8kzJ1pwfe47x2qA7HorDy98CPxcBAQEBAQEBAQEBAQEBwUZBe8kvb9x33Bd9018A96fzqjsKIi39czClmi6DgICAgICAgICAgICAgGCf4PqW9jk07j9LsvYtXVBM+/65Iq/2Mfdi3J/JBAQEBAQEBAQEBAQEBAR7BG3HI357fTzjQgsw6dPm9uzOl1FmpCuNPgICAgICAgICAgICAgKC3xSUKnOeOfyVu1+fZ2lsy/jMgnUP6Zam68uZCQgICAgICAgICAgICAh2CGLGdCDmeTduoR55y5UDlLSTYEn78DiSgICAgICAgICAgICAgOBXBPFAqph7arcyXlmwajqbripaHle915jlWRsQEBAQEBAQEBAQEBAQEOwRrFN3/NYCXDHyNGKZG60EfcRj82rqEsMTEBAQEBAQEBAQEBAQEOwWxMgpbZnYqmzuraIgPWsJStOeJTIICAgICAgICAgICAgICHYJHvFoTHENr913OzE9W6Fig/J+/16NMYp02kdAQEBAQEBAQEBAQEBAsFWQIn+tYnn1TB9zl0l/t1tqlq8NCAgICAgICAgICAgICAg2ClbjeP7OC6nnvK/PbmPTltdq7zd3WfsICAgICAgICAgICAgICLYKrk/G+/OinsJPwyItCWKAt690jiNTxpagXDMBAQEBAQEBAQEBAQEBwX5BWSxRUoC4Oqn6t3K20FaCGD5VkRIQEBAQEBAQEBAQEBAQbBas7nccMQWdv/UAkTFZpit45qt6fGKkGQQEBAQEBAQEBAQEBAQEWwVl76t7eVtfyaY5Jfcj7otb7nla23fF4d9CEhAQEBAQEBAQEBAQEBBsE5Q55dsz12th7fuyucGv7EuqaH4OF7TCExAQEBAQEBAQEBAQEBDsFrQA/W29LPxsXse+Nmgnun7NeNYiICAgICAgICAgICAgINgjmI+mJnF2yt2u4P6YS4MOL/3ilme7h3gZBAQEBAQEBAQEBAQEBAS7BfP7eErWwj+iNHYvtbqks+WqmuqOV9DaExAQEBAQEBAQEBAQEBDsEcQ5Jcoj97yuDu81w+92bBq+tsRjczQCAgICAgICAgICAgICgh2C4SX6auFTlD+N6HmaIHWJjDc8zij7CAgICAgICAgICAgICAg2CkqAdb4NKycmy9d7WFfVr6Xte1e7GwICAgICAgICAgICAgKC/YLEWJ3it3cVVeMmUHm2GsQtJVkZdH3LQkBAQEBAQEBAQEBAQECwX5Be3l+depTVeL2tt2frbOK2oGvzmvv4bJ7ulYCAgICAgICAgICAgIBgo2DNLrlnWs8df97tbLmHcmlxSxKUZ8NZAgICAgICAgICAgICAoIdghjliini2MRYGcvmadjUYAVdx75e1Tc9AQEBAQEBAQEBAQEBAcEOQdvx+Jwvaa+WYtpSbiQGTSPj9SV9vKpS8RgBAQEBAQEBAQEBAQEBwQ7BZGm5ky/OuXOL/kIfz/40aLq0eC2lCAgICAgICAgICAgICAj2CFqe9GY+B33GjEW6ThR4C782l4wFns4SEBAQEBAQEBAQEBAQEGwVvHaUEWlOPD+3GycWX7uR9bfA3bZMx3JmAgICAgICAgICAgICAoIdgh/Sri0pXmv3/DTo8cqx8iwurBnTfV21HwEBAQEBAQEBAQEBAQHBRkFiTHNa5Pvz7fpseVxX65IWysh2h/1bkRIQEBAQEBAQEBAQEBAQ7BfESpGjr+xbZ0v4Oy6s3KVpHFSQ5R6u4Q4JCAgICAgICAgICAgICLYKHp/Z5eg0sTCu6yo//8suJfwUg4CAgICAgICAgICAgIDgVwRTvc6tl/zSpDPWs/WPQGvwjK2mzmVuuaD4XwMBAQEBAQEBAQEBAQEBwR7BVev+5EkfbcvqWbbcMfzyxbTTC/0Ev/OMeF8EBAQEBAQEBAQEBAQEBHsEd1wqs8ucGCVdQQx1x4WYez0rtDsOKqnKAgEBAQEBAQEBAQEBAQHBfsFq/DraXqyv+NHPFlCpIpj089v/qjvfNQEBAQEBAQEBAQEBAQHB7wmmsfl8Wl0L79XyLF7LI4YqjAYvdxh/EhAQEBAQEBAQEBAQEBD8nmAx1r6pStA1e01c3BR+OhsDFXO7JQICAgICAgICAgICAgKCbYIJlI+knu9kkZGGFV9TlUGPwfwc7nAlJSAgICAgICAgICAgICDYJSiV8rQAZWHiPlqXVfOlfQm6ApUTBAQEBAQEBAQEBAQEBAS7BP/MIjhfBOeL4HwRnC+C80VwvgjOF8H5IjhfBOeL4HwRnC+C80VwvgjOF8H5IjhfBOeL4HwRnC+C80VwvgjOF8H5IjhfBOeL4HwRnC+C80VwvgjOF8H5IjhfBOeL4HwRnC+C80VwvgjO1/+B4F+p0lYlEF9KMgAAAABJRU5ErkJggg==",
                IsDeleted = false
            },
            new Reservation
            {
                Id = 12,
                ReservationTime = new DateTime(2025, 10, 2, 20, 39, 6, 156),
                TotalPrice = 15.00m,
                OriginalPrice = 15.00m,
                DiscountPercentage = 0.00m,
                UserId = 3,
                ScreeningId = 8,
                PaymentId = null,
                PromotionId = null,
                NumberOfTickets = 3,
                PaymentType = "Cash",
                State = "ApprovedReservationState",
                QrcodeBase64 = "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",
                IsDeleted = false
            },
            new Reservation
            {
                Id = 13,
                ReservationTime = new DateTime(2025, 10, 2, 20, 39, 20, 407),
                TotalPrice = 18.00m,
                OriginalPrice = 18.00m,
                DiscountPercentage = 0.00m,
                UserId = 3,
                ScreeningId = 22,
                PaymentId = null,
                PromotionId = null,
                NumberOfTickets = 3,
                PaymentType = "Cash",
                State = "ApprovedReservationState",
                QrcodeBase64 = "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",
                IsDeleted = false
            },
            new Reservation
            {
                Id = 14,
                ReservationTime = new DateTime(2025, 10, 2, 20, 39, 34, 959),
                TotalPrice = 12.00m,
                OriginalPrice = 12.00m,
                DiscountPercentage = 0.00m,
                UserId = 3,
                ScreeningId = 10,
                PaymentId = null,
                PromotionId = null,
                NumberOfTickets = 2,
                PaymentType = "Cash",
                State = "ApprovedReservationState",
                QrcodeBase64 = "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",
                IsDeleted = false
            },
            new Reservation
            {
                Id = 15,
                ReservationTime = new DateTime(2025, 10, 2, 20, 39, 45, 456),
                TotalPrice = 8.00m,
                OriginalPrice = 8.00m,
                DiscountPercentage = 0.00m,
                UserId = 3,
                ScreeningId = 9,
                PaymentId = null,
                PromotionId = null,
                NumberOfTickets = 2,
                PaymentType = "Cash",
                State = "CancelledReservationState",
                QrcodeBase64 = "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",
                IsDeleted = false
            },
            new Reservation
            {
                Id = 16,
                ReservationTime = new DateTime(2025, 10, 2, 20, 39, 57, 511),
                TotalPrice = 30.00m,
                OriginalPrice = 30.00m,
                DiscountPercentage = 0.00m,
                UserId = 3,
                ScreeningId = 19,
                PaymentId = null,
                PromotionId = null,
                NumberOfTickets = 3,
                PaymentType = "Cash",
                State = "ApprovedReservationState",
                QrcodeBase64 = "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",
                IsDeleted = false
            },
            new Reservation
            {
                Id = 17,
                ReservationTime = new DateTime(2025, 10, 2, 20, 40, 8, 158),
                TotalPrice = 10.00m,
                OriginalPrice = 10.00m,
                DiscountPercentage = 0.00m,
                UserId = 3,
                ScreeningId = 4,
                PaymentId = null,
                PromotionId = null,
                NumberOfTickets = 2,
                PaymentType = "Cash",
                State = "ApprovedReservationState",
                QrcodeBase64 = "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",
                IsDeleted = false
            },
            new Reservation
            {
                Id = 18,
                ReservationTime = new DateTime(2025, 10, 2, 20, 41, 10, 63),
                TotalPrice = 32.00m,
                OriginalPrice = 32.00m,
                DiscountPercentage = 0.00m,
                UserId = 3,
                ScreeningId = 13,
                PaymentId = null,
                PromotionId = null,
                NumberOfTickets = 4,
                PaymentType = "Cash",
                State = "ApprovedReservationState",
                QrcodeBase64 = "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",
                IsDeleted = false
            }
        );

        // ReservationSeats
        modelBuilder.Entity<ReservationSeat>().HasData(
            new ReservationSeat { ReservationId = 1, SeatId = 1, ReservedAt = new DateTime(2024, 3, 14, 10, 0, 0) },
            new ReservationSeat { ReservationId = 1, SeatId = 2, ReservedAt = new DateTime(2024, 3, 14, 10, 0, 0) },
            new ReservationSeat { ReservationId = 2, SeatId = 10, ReservedAt = new DateTime(2025, 9, 8, 15, 45, 6, 721) },
            new ReservationSeat { ReservationId = 3, SeatId = 10, ReservedAt = new DateTime(2025, 10, 2, 18, 0, 11, 47) },
            new ReservationSeat { ReservationId = 3, SeatId = 11, ReservedAt = new DateTime(2025, 10, 2, 18, 0, 11, 52) },
            new ReservationSeat { ReservationId = 4, SeatId = 11, ReservedAt = new DateTime(2025, 10, 2, 18, 0, 33, 255) },
            new ReservationSeat { ReservationId = 4, SeatId = 12, ReservedAt = new DateTime(2025, 10, 2, 18, 0, 33, 255) },
            new ReservationSeat { ReservationId = 5, SeatId = 11, ReservedAt = new DateTime(2025, 10, 2, 18, 0, 50, 53) },
            new ReservationSeat { ReservationId = 5, SeatId = 12, ReservedAt = new DateTime(2025, 10, 2, 18, 0, 50, 53) },
            new ReservationSeat { ReservationId = 6, SeatId = 1, ReservedAt = new DateTime(2025, 10, 2, 18, 1, 3, 546) },
            new ReservationSeat { ReservationId = 6, SeatId = 2, ReservedAt = new DateTime(2025, 10, 2, 18, 1, 3, 546) },
            new ReservationSeat { ReservationId = 7, SeatId = 1, ReservedAt = new DateTime(2025, 10, 2, 18, 1, 15, 804) },
            new ReservationSeat { ReservationId = 7, SeatId = 2, ReservedAt = new DateTime(2025, 10, 2, 18, 1, 15, 805) },
            new ReservationSeat { ReservationId = 8, SeatId = 1, ReservedAt = new DateTime(2025, 10, 2, 18, 1, 35, 615) },
            new ReservationSeat { ReservationId = 8, SeatId = 2, ReservedAt = new DateTime(2025, 10, 2, 18, 1, 35, 615) },
            new ReservationSeat { ReservationId = 9, SeatId = 1, ReservedAt = new DateTime(2025, 10, 2, 18, 1, 49, 282) },
            new ReservationSeat { ReservationId = 9, SeatId = 2, ReservedAt = new DateTime(2025, 10, 2, 18, 1, 49, 282) },
            new ReservationSeat { ReservationId = 10, SeatId = 1, ReservedAt = new DateTime(2025, 10, 2, 18, 2, 22, 810) },
            new ReservationSeat { ReservationId = 10, SeatId = 2, ReservedAt = new DateTime(2025, 10, 2, 18, 2, 22, 813) },
            new ReservationSeat { ReservationId = 11, SeatId = 11, ReservedAt = new DateTime(2025, 10, 2, 18, 38, 54, 26) },
            new ReservationSeat { ReservationId = 11, SeatId = 12, ReservedAt = new DateTime(2025, 10, 2, 18, 38, 54, 27) },
            new ReservationSeat { ReservationId = 11, SeatId = 13, ReservedAt = new DateTime(2025, 10, 2, 18, 38, 54, 27) },
            new ReservationSeat { ReservationId = 12, SeatId = 11, ReservedAt = new DateTime(2025, 10, 2, 18, 39, 6, 760) },
            new ReservationSeat { ReservationId = 12, SeatId = 12, ReservedAt = new DateTime(2025, 10, 2, 18, 39, 6, 761) },
            new ReservationSeat { ReservationId = 12, SeatId = 13, ReservedAt = new DateTime(2025, 10, 2, 18, 39, 6, 761) },
            new ReservationSeat { ReservationId = 13, SeatId = 11, ReservedAt = new DateTime(2025, 10, 2, 18, 39, 21, 8) },
            new ReservationSeat { ReservationId = 13, SeatId = 12, ReservedAt = new DateTime(2025, 10, 2, 18, 39, 21, 9) },
            new ReservationSeat { ReservationId = 13, SeatId = 13, ReservedAt = new DateTime(2025, 10, 2, 18, 39, 21, 9) },
            new ReservationSeat { ReservationId = 14, SeatId = 28, ReservedAt = new DateTime(2025, 10, 2, 18, 39, 35, 564) },
            new ReservationSeat { ReservationId = 14, SeatId = 29, ReservedAt = new DateTime(2025, 10, 2, 18, 39, 35, 564) },
            new ReservationSeat { ReservationId = 15, SeatId = 28, ReservedAt = new DateTime(2025, 10, 2, 18, 39, 46, 62) },
            new ReservationSeat { ReservationId = 15, SeatId = 29, ReservedAt = new DateTime(2025, 10, 2, 18, 39, 46, 62) },
            new ReservationSeat { ReservationId = 16, SeatId = 19, ReservedAt = new DateTime(2025, 10, 2, 18, 39, 58, 124) },
            new ReservationSeat { ReservationId = 16, SeatId = 20, ReservedAt = new DateTime(2025, 10, 2, 18, 39, 58, 124) },
            new ReservationSeat { ReservationId = 16, SeatId = 21, ReservedAt = new DateTime(2025, 10, 2, 18, 39, 58, 124) },
            new ReservationSeat { ReservationId = 17, SeatId = 29, ReservedAt = new DateTime(2025, 10, 2, 18, 40, 8, 755) },
            new ReservationSeat { ReservationId = 17, SeatId = 30, ReservedAt = new DateTime(2025, 10, 2, 18, 40, 8, 755) },
            new ReservationSeat { ReservationId = 18, SeatId = 35, ReservedAt = new DateTime(2025, 10, 2, 18, 41, 10, 852) },
            new ReservationSeat { ReservationId = 18, SeatId = 36, ReservedAt = new DateTime(2025, 10, 2, 18, 41, 10, 854) },
            new ReservationSeat { ReservationId = 18, SeatId = 37, ReservedAt = new DateTime(2025, 10, 2, 18, 41, 10, 854) },
            new ReservationSeat { ReservationId = 18, SeatId = 38, ReservedAt = new DateTime(2025, 10, 2, 18, 41, 10, 854) }
        );

        // // Screenings
        // modelBuilder.Entity<Screening>().HasData(
        //     // Past screenings (for reviews)
        //     new Screening
        //     {
        //         Id = 1,
        //         StartTime = new DateTime(2025, 9, 8, 16, 0, 0),
        //         EndTime = new DateTime(2025, 9, 8, 18, 0, 0),
        //         BasePrice = 5.00m,
        //         Language = "English",
        //         HasSubtitles = false,
        //         IsDeleted = false,
        //         MovieId = 4,
        //         HallId = 3,
        //         ScreeningFormatId = 1
        //     },
        //     new Screening
        //     {
        //         Id = 2,
        //         StartTime = new DateTime(2025, 9, 8, 17, 0, 0),
        //         EndTime = new DateTime(2025, 9, 8, 18, 0, 0),
        //         BasePrice = 5.00m,
        //         Language = "English",
        //         HasSubtitles = false,
        //         IsDeleted = false,
        //         MovieId = 3,
        //         HallId = 3,
        //         ScreeningFormatId = 2
        //     },
        //     new Screening
        //     {
        //         Id = 3,
        //         StartTime = new DateTime(2025, 9, 8, 18, 20, 0),
        //         EndTime = new DateTime(2025, 9, 8, 20, 0, 0),
        //         BasePrice = 10.00m,
        //         Language = "English",
        //         HasSubtitles = false,
        //         IsDeleted = false,
        //         MovieId = 5,
        //         HallId = 3,
        //         ScreeningFormatId = 1
        //     },
        //     // Future screenings
        //     new Screening
        //     {
        //         Id = 4,
        //         StartTime = new DateTime(2025, 10, 8, 19, 0, 0),
        //         EndTime = new DateTime(2025, 9, 8, 21, 0, 0),
        //         BasePrice = 5.00m,
        //         Language = "English",
        //         HasSubtitles = false,
        //         IsDeleted = false,
        //         MovieId = 5,
        //         HallId = 5,
        //         ScreeningFormatId = 4
        //     },
        //     new Screening
        //     {
        //         Id = 5,
        //         StartTime = new DateTime(2025, 9, 30, 12, 0, 0),
        //         EndTime = new DateTime(2025, 9, 30, 14, 0, 0),
        //         BasePrice = 3.00m,
        //         Language = "English",
        //         HasSubtitles = true,
        //         IsDeleted = false,
        //         MovieId = 4,
        //         HallId = 2,
        //         ScreeningFormatId = 2
        //     },
        //     new Screening
        //     {
        //         Id = 6,
        //         StartTime = new DateTime(2025, 9, 29, 13, 0, 0),
        //         EndTime = new DateTime(2025, 9, 29, 15, 0, 0),
        //         BasePrice = 5.00m,
        //         Language = "English",
        //         HasSubtitles = false,
        //         IsDeleted = false,
        //         MovieId = 3,
        //         HallId = 4,
        //         ScreeningFormatId = 1
        //     }
        // );

        // var password = "stringst";
        // var salt = UserService.GenerateSalt();
        // var hash = UserService.GenerateHash(salt, password);

        // // Users
        // modelBuilder.Entity<User>().HasData(
        //     new User
        //     {
        //         Id = 1,
        //         FirstName = "Admin",
        //         LastName = "User",
        //         Username = "admin",
        //         Email = "admin@ecinema.com",
        //         PasswordHash = hash,
        //         PasswordSalt = salt,
        //         CreatedAt = new DateTime(2025, 1, 1),
        //         RoleId = 1,
        //         IsDeleted = false
        //     },
        //     new User
        //     {
        //         Id = 2,
        //         FirstName = "User",
        //         LastName = "One",
        //         Username = "user1",
        //         Email = "user1@ecinema.com",
        //         PasswordHash = hash,
        //         PasswordSalt = salt,
        //         CreatedAt = new DateTime(2025, 1, 1),
        //         RoleId = 2,
        //         IsDeleted = false
        //     },
        //     new User
        //     {
        //         Id = 3,
        //         FirstName = "User",
        //         LastName = "Two",
        //         Username = "user2",
        //         Email = "user2@ecinema.com",
        //         PasswordHash = hash,
        //         PasswordSalt = salt,
        //         CreatedAt = new DateTime(2025, 1, 1),
        //         RoleId = 2,
        //         IsDeleted = false
        //     },
        //     new User
        //     {
        //         Id = 4,
        //         FirstName = "Staff",
        //         LastName = "User",
        //         Username = "staff",
        //         Email = "staff@ecinema.com",
        //         PasswordHash = hash,
        //         PasswordSalt = salt,
        //         CreatedAt = new DateTime(2025, 1, 1),
        //         RoleId = 3,
        //         IsDeleted = false
        //     }
        // );
                // Screenings
        modelBuilder.Entity<Screening>().HasData(
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
            new Screening
            {
                Id = 4,
                StartTime = new DateTime(2025, 10, 8, 19, 0, 0),
                EndTime = new DateTime(2025, 10, 8, 21, 0, 0),
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
            },
            new Screening
            {
                Id = 7,
                StartTime = new DateTime(2025, 10, 5, 18, 0, 0),
                EndTime = new DateTime(2025, 10, 5, 20, 0, 0),
                BasePrice = 5.00m,
                Language = "English",
                HasSubtitles = false,
                IsDeleted = false,
                MovieId = 3,
                HallId = 3,
                ScreeningFormatId = 1
            },
            new Screening
            {
                Id = 8,
                StartTime = new DateTime(2025, 10, 6, 18, 0, 0),
                EndTime = new DateTime(2025, 10, 6, 20, 0, 0),
                BasePrice = 5.00m,
                Language = "English",
                HasSubtitles = false,
                IsDeleted = false,
                MovieId = 3,
                HallId = 4,
                ScreeningFormatId = 1
            },
            new Screening
            {
                Id = 9,
                StartTime = new DateTime(2025, 10, 7, 16, 0, 0),
                EndTime = new DateTime(2025, 10, 7, 18, 0, 0),
                BasePrice = 4.00m,
                Language = "English",
                HasSubtitles = false,
                IsDeleted = false,
                MovieId = 4,
                HallId = 2,
                ScreeningFormatId = 1
            },
            new Screening
            {
                Id = 10,
                StartTime = new DateTime(2025, 10, 6, 20, 0, 0),
                EndTime = new DateTime(2025, 10, 6, 22, 0, 0),
                BasePrice = 6.00m,
                Language = "English",
                HasSubtitles = false,
                IsDeleted = false,
                MovieId = 4,
                HallId = 2,
                ScreeningFormatId = 2
            },
            new Screening
            {
                Id = 11,
                StartTime = new DateTime(2025, 10, 8, 21, 0, 0),
                EndTime = new DateTime(2025, 10, 8, 23, 0, 0),
                BasePrice = 10.00m,
                Language = "English",
                HasSubtitles = false,
                IsDeleted = false,
                MovieId = 5,
                HallId = 5,
                ScreeningFormatId = 4
            },
            new Screening
            {
                Id = 12,
                StartTime = new DateTime(2025, 10, 9, 14, 0, 0),
                EndTime = new DateTime(2025, 10, 9, 16, 0, 0),
                BasePrice = 6.00m,
                Language = "English",
                HasSubtitles = false,
                IsDeleted = false,
                MovieId = 3,
                HallId = 4,
                ScreeningFormatId = 2
            },
            new Screening
            {
                Id = 13,
                StartTime = new DateTime(2025, 10, 10, 21, 0, 0),
                EndTime = new DateTime(2025, 10, 10, 23, 0, 0),
                BasePrice = 8.00m,
                Language = "English",
                HasSubtitles = false,
                IsDeleted = false,
                MovieId = 5,
                HallId = 4,
                ScreeningFormatId = 2
            },
            new Screening
            {
                Id = 14,
                StartTime = new DateTime(2025, 10, 5, 12, 0, 0),
                EndTime = new DateTime(2025, 10, 5, 14, 0, 0),
                BasePrice = 5.00m,
                Language = "English",
                HasSubtitles = false,
                IsDeleted = false,
                MovieId = 3,
                HallId = 4,
                ScreeningFormatId = 1
            },
            new Screening
            {
                Id = 15,
                StartTime = new DateTime(2025, 10, 6, 13, 0, 0),
                EndTime = new DateTime(2025, 10, 6, 15, 0, 0),
                BasePrice = 5.00m,
                Language = "English",
                HasSubtitles = false,
                IsDeleted = false,
                MovieId = 3,
                HallId = 3,
                ScreeningFormatId = 1
            },
            new Screening
            {
                Id = 16,
                StartTime = new DateTime(2025, 10, 9, 15, 0, 0),
                EndTime = new DateTime(2025, 10, 9, 17, 0, 0),
                BasePrice = 5.00m,
                Language = "English",
                HasSubtitles = false,
                IsDeleted = false,
                MovieId = 3,
                HallId = 3,
                ScreeningFormatId = 1
            },
            new Screening
            {
                Id = 17,
                StartTime = new DateTime(2025, 10, 6, 12, 0, 0),
                EndTime = new DateTime(2025, 10, 6, 14, 0, 0),
                BasePrice = 3.00m,
                Language = "English",
                HasSubtitles = false,
                IsDeleted = false,
                MovieId = 4,
                HallId = 3,
                ScreeningFormatId = 1
            },
            new Screening
            {
                Id = 18,
                StartTime = new DateTime(2025, 10, 10, 12, 0, 0),
                EndTime = new DateTime(2025, 10, 10, 14, 0, 0),
                BasePrice = 7.00m,
                Language = "English",
                HasSubtitles = false,
                IsDeleted = false,
                MovieId = 4,
                HallId = 4,
                ScreeningFormatId = 2
            },
            new Screening
            {
                Id = 19,
                StartTime = new DateTime(2025, 10, 10, 17, 0, 0),
                EndTime = new DateTime(2025, 10, 10, 19, 0, 0),
                BasePrice = 10.00m,
                Language = "English",
                HasSubtitles = false,
                IsDeleted = false,
                MovieId = 4,
                HallId = 5,
                ScreeningFormatId = 4
            },
            new Screening
            {
                Id = 20,
                StartTime = new DateTime(2025, 10, 10, 12, 0, 0),
                EndTime = new DateTime(2025, 10, 10, 14, 0, 0),
                BasePrice = 7.00m,
                Language = "English",
                HasSubtitles = false,
                IsDeleted = false,
                MovieId = 5,
                HallId = 3,
                ScreeningFormatId = 1
            },
            new Screening
            {
                Id = 21,
                StartTime = new DateTime(2025, 10, 10, 16, 0, 0),
                EndTime = new DateTime(2025, 10, 10, 18, 0, 0),
                BasePrice = 9.00m,
                Language = "English",
                HasSubtitles = false,
                IsDeleted = false,
                MovieId = 5,
                HallId = 3,
                ScreeningFormatId = 2
            },
            new Screening
            {
                Id = 22,
                StartTime = new DateTime(2025, 10, 10, 14, 0, 0),
                EndTime = new DateTime(2025, 10, 10, 16, 0, 0),
                BasePrice = 6.00m,
                Language = "English",
                HasSubtitles = false,
                IsDeleted = false,
                MovieId = 3,
                HallId = 4,
                ScreeningFormatId = 1
            },
            new Screening
            {
                Id = 23,
                StartTime = new DateTime(2025, 10, 11, 20, 0, 0),
                EndTime = new DateTime(2025, 10, 11, 22, 0, 0),
                BasePrice = 7.00m,
                Language = "English",
                HasSubtitles = false,
                IsDeleted = false,
                MovieId = 3,
                HallId = 3,
                ScreeningFormatId = 1
            }
        );
        modelBuilder.Entity<ScreeningSeat>().HasData(
            new ScreeningSeat { ScreeningId = 1, SeatId = 1, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 2, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 3, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 4, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 5, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 6, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 7, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 8, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 9, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 10, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 11, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 12, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 13, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 14, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 15, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 16, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 17, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 18, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 19, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 20, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 21, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 22, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 23, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 24, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 25, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 26, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 27, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 28, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 29, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 30, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 31, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 32, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 33, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 34, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 35, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 36, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 37, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 38, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 39, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 40, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 41, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 42, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 43, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 44, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 45, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 46, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 47, IsReserved = false },
            new ScreeningSeat { ScreeningId = 1, SeatId = 48, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 1, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 2, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 3, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 4, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 5, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 6, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 7, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 8, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 9, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 10, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 11, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 12, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 13, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 14, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 15, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 16, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 17, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 18, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 19, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 20, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 21, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 22, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 23, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 24, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 25, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 26, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 27, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 28, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 29, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 30, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 31, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 32, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 33, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 34, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 35, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 36, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 37, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 38, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 39, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 40, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 41, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 42, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 43, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 44, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 45, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 46, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 47, IsReserved = false },
            new ScreeningSeat { ScreeningId = 2, SeatId = 48, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 1, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 2, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 3, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 4, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 5, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 6, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 7, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 8, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 9, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 10, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 11, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 12, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 13, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 14, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 15, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 16, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 17, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 18, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 19, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 20, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 21, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 22, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 23, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 24, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 25, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 26, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 27, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 28, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 29, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 30, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 31, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 32, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 33, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 34, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 35, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 36, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 37, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 38, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 39, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 40, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 41, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 42, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 43, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 44, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 45, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 46, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 47, IsReserved = false },
            new ScreeningSeat { ScreeningId = 3, SeatId = 48, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 1, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 2, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 3, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 4, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 5, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 6, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 7, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 8, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 9, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 10, IsReserved = true },
            new ScreeningSeat { ScreeningId = 4, SeatId = 11, IsReserved = true },
            new ScreeningSeat { ScreeningId = 4, SeatId = 12, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 13, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 14, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 15, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 16, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 17, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 18, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 19, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 20, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 21, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 22, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 23, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 24, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 25, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 26, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 27, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 28, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 29, IsReserved = true },
            new ScreeningSeat { ScreeningId = 4, SeatId = 30, IsReserved = true },
            new ScreeningSeat { ScreeningId = 4, SeatId = 31, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 32, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 33, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 34, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 35, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 36, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 37, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 38, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 39, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 40, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 41, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 42, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 43, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 44, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 45, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 46, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 47, IsReserved = false },
            new ScreeningSeat { ScreeningId = 4, SeatId = 48, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 1, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 2, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 3, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 4, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 5, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 6, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 7, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 8, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 9, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 10, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 11, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 12, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 13, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 14, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 15, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 16, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 17, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 18, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 19, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 20, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 21, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 22, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 23, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 24, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 25, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 26, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 27, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 28, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 29, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 30, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 31, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 32, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 33, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 34, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 35, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 36, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 37, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 38, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 39, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 40, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 41, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 42, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 43, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 44, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 45, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 46, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 47, IsReserved = false },
            new ScreeningSeat { ScreeningId = 5, SeatId = 48, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 1, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 2, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 3, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 4, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 5, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 6, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 7, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 8, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 9, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 10, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 11, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 12, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 13, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 14, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 15, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 16, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 17, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 18, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 19, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 20, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 21, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 22, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 23, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 24, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 25, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 26, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 27, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 28, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 29, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 30, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 31, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 32, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 33, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 34, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 35, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 36, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 37, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 38, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 39, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 40, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 41, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 42, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 43, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 44, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 45, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 46, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 47, IsReserved = false },
            new ScreeningSeat { ScreeningId = 6, SeatId = 48, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 1, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 2, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 3, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 4, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 5, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 6, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 7, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 8, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 9, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 10, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 11, IsReserved = true },
            new ScreeningSeat { ScreeningId = 7, SeatId = 12, IsReserved = true },
            new ScreeningSeat { ScreeningId = 7, SeatId = 13, IsReserved = true },
            new ScreeningSeat { ScreeningId = 7, SeatId = 14, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 15, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 16, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 17, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 18, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 19, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 20, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 21, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 22, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 23, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 24, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 25, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 26, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 27, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 28, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 29, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 30, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 31, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 32, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 33, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 34, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 35, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 36, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 37, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 38, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 39, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 40, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 41, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 42, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 43, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 44, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 45, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 46, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 47, IsReserved = false },
            new ScreeningSeat { ScreeningId = 7, SeatId = 48, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 1, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 2, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 3, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 4, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 5, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 6, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 7, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 8, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 9, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 10, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 11, IsReserved = true },
            new ScreeningSeat { ScreeningId = 8, SeatId = 12, IsReserved = true },
            new ScreeningSeat { ScreeningId = 8, SeatId = 13, IsReserved = true },
            new ScreeningSeat { ScreeningId = 8, SeatId = 14, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 15, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 16, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 17, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 18, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 19, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 20, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 21, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 22, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 23, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 24, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 25, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 26, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 27, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 28, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 29, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 30, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 31, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 32, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 33, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 34, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 35, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 36, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 37, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 38, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 39, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 40, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 41, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 42, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 43, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 44, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 45, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 46, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 47, IsReserved = false },
            new ScreeningSeat { ScreeningId = 8, SeatId = 48, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 1, IsReserved = true },
            new ScreeningSeat { ScreeningId = 9, SeatId = 2, IsReserved = true },
            new ScreeningSeat { ScreeningId = 9, SeatId = 3, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 4, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 5, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 6, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 7, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 8, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 9, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 10, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 11, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 12, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 13, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 14, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 15, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 16, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 17, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 18, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 19, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 20, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 21, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 22, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 23, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 24, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 25, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 26, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 27, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 28, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 29, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 30, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 31, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 32, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 33, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 34, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 35, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 36, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 37, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 38, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 39, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 40, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 41, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 42, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 43, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 44, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 45, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 46, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 47, IsReserved = false },
            new ScreeningSeat { ScreeningId = 9, SeatId = 48, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 1, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 2, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 3, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 4, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 5, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 6, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 7, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 8, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 9, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 10, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 11, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 12, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 13, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 14, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 15, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 16, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 17, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 18, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 19, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 20, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 21, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 22, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 23, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 24, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 25, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 26, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 27, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 28, IsReserved = true },
            new ScreeningSeat { ScreeningId = 10, SeatId = 29, IsReserved = true },
            new ScreeningSeat { ScreeningId = 10, SeatId = 30, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 31, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 32, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 33, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 34, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 35, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 36, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 37, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 38, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 39, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 40, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 41, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 42, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 43, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 44, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 45, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 46, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 47, IsReserved = false },
            new ScreeningSeat { ScreeningId = 10, SeatId = 48, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 1, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 2, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 3, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 4, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 5, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 6, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 7, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 8, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 9, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 10, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 11, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 12, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 13, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 14, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 15, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 16, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 17, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 18, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 19, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 20, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 21, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 22, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 23, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 24, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 25, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 26, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 27, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 28, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 29, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 30, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 31, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 32, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 33, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 34, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 35, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 36, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 37, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 38, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 39, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 40, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 41, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 42, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 43, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 44, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 45, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 46, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 47, IsReserved = false },
            new ScreeningSeat { ScreeningId = 11, SeatId = 48, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 1, IsReserved = true },
            new ScreeningSeat { ScreeningId = 12, SeatId = 2, IsReserved = true },
            new ScreeningSeat { ScreeningId = 12, SeatId = 3, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 4, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 5, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 6, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 7, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 8, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 9, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 10, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 11, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 12, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 13, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 14, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 15, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 16, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 17, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 18, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 19, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 20, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 21, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 22, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 23, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 24, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 25, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 26, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 27, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 28, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 29, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 30, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 31, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 32, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 33, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 34, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 35, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 36, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 37, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 38, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 39, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 40, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 41, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 42, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 43, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 44, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 45, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 46, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 47, IsReserved = false },
            new ScreeningSeat { ScreeningId = 12, SeatId = 48, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 1, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 2, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 3, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 4, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 5, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 6, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 7, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 8, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 9, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 10, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 11, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 12, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 13, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 14, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 15, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 16, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 17, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 18, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 19, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 20, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 21, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 22, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 23, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 24, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 25, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 26, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 27, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 28, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 29, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 30, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 31, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 32, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 33, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 34, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 35, IsReserved = true },
            new ScreeningSeat { ScreeningId = 13, SeatId = 36, IsReserved = true },
            new ScreeningSeat { ScreeningId = 13, SeatId = 37, IsReserved = true },
            new ScreeningSeat { ScreeningId = 13, SeatId = 38, IsReserved = true },
            new ScreeningSeat { ScreeningId = 13, SeatId = 39, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 40, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 41, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 42, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 43, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 44, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 45, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 46, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 47, IsReserved = false },
            new ScreeningSeat { ScreeningId = 13, SeatId = 48, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 1, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 2, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 3, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 4, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 5, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 6, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 7, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 8, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 9, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 10, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 11, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 12, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 13, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 14, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 15, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 16, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 17, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 18, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 19, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 20, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 21, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 22, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 23, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 24, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 25, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 26, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 27, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 28, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 29, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 30, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 31, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 32, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 33, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 34, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 35, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 36, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 37, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 38, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 39, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 40, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 41, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 42, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 43, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 44, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 45, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 46, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 47, IsReserved = false },
            new ScreeningSeat { ScreeningId = 14, SeatId = 48, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 1, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 2, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 3, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 4, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 5, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 6, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 7, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 8, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 9, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 10, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 11, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 12, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 13, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 14, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 15, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 16, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 17, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 18, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 19, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 20, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 21, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 22, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 23, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 24, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 25, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 26, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 27, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 28, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 29, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 30, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 31, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 32, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 33, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 34, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 35, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 36, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 37, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 38, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 39, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 40, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 41, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 42, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 43, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 44, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 45, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 46, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 47, IsReserved = false },
            new ScreeningSeat { ScreeningId = 15, SeatId = 48, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 1, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 2, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 3, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 4, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 5, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 6, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 7, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 8, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 9, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 10, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 11, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 12, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 13, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 14, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 15, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 16, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 17, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 18, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 19, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 20, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 21, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 22, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 23, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 24, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 25, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 26, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 27, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 28, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 29, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 30, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 31, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 32, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 33, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 34, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 35, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 36, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 37, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 38, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 39, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 40, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 41, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 42, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 43, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 44, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 45, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 46, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 47, IsReserved = false },
            new ScreeningSeat { ScreeningId = 16, SeatId = 48, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 1, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 2, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 3, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 4, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 5, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 6, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 7, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 8, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 9, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 10, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 11, IsReserved = true },
            new ScreeningSeat { ScreeningId = 17, SeatId = 12, IsReserved = true },
            new ScreeningSeat { ScreeningId = 17, SeatId = 13, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 14, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 15, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 16, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 17, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 18, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 19, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 20, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 21, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 22, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 23, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 24, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 25, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 26, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 27, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 28, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 29, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 30, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 31, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 32, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 33, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 34, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 35, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 36, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 37, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 38, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 39, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 40, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 41, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 42, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 43, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 44, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 45, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 46, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 47, IsReserved = false },
            new ScreeningSeat { ScreeningId = 17, SeatId = 48, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 1, IsReserved = true },
            new ScreeningSeat { ScreeningId = 18, SeatId = 2, IsReserved = true },
            new ScreeningSeat { ScreeningId = 18, SeatId = 3, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 4, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 5, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 6, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 7, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 8, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 9, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 10, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 11, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 12, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 13, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 14, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 15, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 16, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 17, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 18, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 19, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 20, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 21, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 22, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 23, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 24, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 25, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 26, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 27, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 28, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 29, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 30, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 31, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 32, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 33, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 34, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 35, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 36, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 37, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 38, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 39, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 40, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 41, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 42, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 43, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 44, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 45, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 46, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 47, IsReserved = false },
            new ScreeningSeat { ScreeningId = 18, SeatId = 48, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 1, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 2, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 3, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 4, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 5, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 6, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 7, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 8, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 9, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 10, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 11, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 12, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 13, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 14, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 15, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 16, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 17, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 18, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 19, IsReserved = true },
            new ScreeningSeat { ScreeningId = 19, SeatId = 20, IsReserved = true },
            new ScreeningSeat { ScreeningId = 19, SeatId = 21, IsReserved = true },
            new ScreeningSeat { ScreeningId = 19, SeatId = 22, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 23, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 24, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 25, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 26, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 27, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 28, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 29, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 30, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 31, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 32, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 33, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 34, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 35, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 36, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 37, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 38, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 39, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 40, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 41, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 42, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 43, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 44, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 45, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 46, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 47, IsReserved = false },
            new ScreeningSeat { ScreeningId = 19, SeatId = 48, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 1, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 2, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 3, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 4, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 5, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 6, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 7, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 8, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 9, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 10, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 11, IsReserved = true },
            new ScreeningSeat { ScreeningId = 20, SeatId = 12, IsReserved = true },
            new ScreeningSeat { ScreeningId = 20, SeatId = 13, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 14, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 15, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 16, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 17, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 18, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 19, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 20, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 21, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 22, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 23, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 24, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 25, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 26, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 27, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 28, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 29, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 30, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 31, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 32, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 33, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 34, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 35, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 36, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 37, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 38, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 39, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 40, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 41, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 42, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 43, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 44, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 45, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 46, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 47, IsReserved = false },
            new ScreeningSeat { ScreeningId = 20, SeatId = 48, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 1, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 2, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 3, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 4, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 5, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 6, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 7, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 8, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 9, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 10, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 11, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 12, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 13, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 14, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 15, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 16, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 17, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 18, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 19, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 20, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 21, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 22, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 23, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 24, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 25, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 26, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 27, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 28, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 29, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 30, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 31, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 32, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 33, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 34, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 35, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 36, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 37, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 38, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 39, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 40, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 41, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 42, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 43, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 44, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 45, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 46, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 47, IsReserved = false },
            new ScreeningSeat { ScreeningId = 21, SeatId = 48, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 1, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 2, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 3, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 4, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 5, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 6, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 7, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 8, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 9, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 10, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 11, IsReserved = true },
            new ScreeningSeat { ScreeningId = 22, SeatId = 12, IsReserved = true },
            new ScreeningSeat { ScreeningId = 22, SeatId = 13, IsReserved = true },
            new ScreeningSeat { ScreeningId = 22, SeatId = 14, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 15, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 16, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 17, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 18, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 19, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 20, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 21, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 22, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 23, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 24, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 25, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 26, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 27, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 28, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 29, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 30, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 31, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 32, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 33, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 34, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 35, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 36, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 37, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 38, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 39, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 40, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 41, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 42, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 43, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 44, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 45, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 46, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 47, IsReserved = false },
            new ScreeningSeat { ScreeningId = 22, SeatId = 48, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 1, IsReserved = true },
            new ScreeningSeat { ScreeningId = 23, SeatId = 2, IsReserved = true },
            new ScreeningSeat { ScreeningId = 23, SeatId = 3, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 4, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 5, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 6, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 7, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 8, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 9, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 10, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 11, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 12, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 13, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 14, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 15, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 16, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 17, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 18, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 19, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 20, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 21, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 22, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 23, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 24, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 25, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 26, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 27, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 28, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 29, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 30, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 31, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 32, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 33, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 34, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 35, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 36, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 37, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 38, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 39, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 40, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 41, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 42, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 43, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 44, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 45, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 46, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 47, IsReserved = false },
            new ScreeningSeat { ScreeningId = 23, SeatId = 48, IsReserved = false }
        );
              

        var password = "stringst";
        var salt = UserService.GenerateSalt();
        var hash = UserService.GenerateHash(salt, password);

        // Users
        modelBuilder.Entity<User>().HasData(
            new User
            {
                Id = 1,
                FirstName = "Admin",
                LastName = "User",
                Username = "admin",
                Email = "admin@ecinema.com",
                PasswordHash = hash,
                PasswordSalt = salt,
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
                PasswordHash = hash,
                PasswordSalt = salt,
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
                PasswordHash = hash,
                PasswordSalt = salt,
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
                PasswordHash = hash,
                PasswordSalt = salt,
                CreatedAt = new DateTime(2025, 1, 1),
                RoleId = 3,
                IsDeleted = false
            }
        );
        }
    }
}