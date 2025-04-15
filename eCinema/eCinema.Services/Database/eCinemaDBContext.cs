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
        public DbSet<UserRole> UserRoles { get; set; }
        // public DbSet<Hall> Halls { get; set; } = null!;
        public DbSet<Seat> Seats { get; set; } = null!;
        public DbSet<SeatType> SeatTypes { get; set; } = null!;
        // public DbSet<Movie> Movies { get; set; } = null!;
        // public DbSet<Actor> Actors { get; set; } = null!;
        // public DbSet<MovieActor> MovieActors { get; set; } = null!;
        // public DbSet<Genre> Genres { get; set; } = null!;
        // public DbSet<MovieGenre> MovieGenres { get; set; } = null!;
        // public DbSet<Screening> Screenings { get; set; } = null!;
        // public DbSet<ScreeningFormat> ScreeningFormats { get; set; } = null!;
        // public DbSet<Reservation> Reservations { get; set; } = null!;
        // public DbSet<Payment> Payments { get; set; } = null!;
        // public DbSet<Review> Reviews { get; set; } = null!;
        // public DbSet<Promotion> Promotions { get; set; } = null!;
        // public DbSet<NewsArticle> NewsArticles { get; set; } = null!;

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Configure User entity
            modelBuilder.Entity<User>()
                .HasIndex(u => u.Username)
                .IsUnique();

            modelBuilder.Entity<User>()
                .HasIndex(u => u.Email)
                .IsUnique();

            // Configure Role entity
            modelBuilder.Entity<Role>()
                .HasIndex(r => r.Name)
                .IsUnique();

            modelBuilder.Entity<Role>()
                .Property(r => r.IsActive)
                .HasDefaultValue(true);

            // Configure UserRole relationships
            modelBuilder.Entity<UserRole>()
                .HasOne(ur => ur.User)
                .WithMany(u => u.UserRoles)
                .HasForeignKey(ur => ur.UserId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<UserRole>()
                .HasOne(ur => ur.Role)
                .WithMany(r => r.UserRoles)
                .HasForeignKey(ur => ur.RoleId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<UserRole>()
                .HasIndex(ur => new { ur.UserId, ur.RoleId })
                .IsUnique();

            // Configure Hall and Seat relationship
            // modelBuilder.Entity<Seat>()
            //     .HasOne(s => s.Hall)
            //     .WithMany(h => h.Seats)
            //     .HasForeignKey(s => s.HallId)
            //     .OnDelete(DeleteBehavior.Cascade);

            // Configure SeatType and Seat relationship
            // modelBuilder.Entity<Seat>()
            //     .HasOne(s => s.SeatType)
            //     .WithMany(st => st.Seats)
            //     .HasForeignKey(s => s.SeatTypeId)
            //     .OnDelete(DeleteBehavior.SetNull);

            // Configure Movie and Screening relationship
            // modelBuilder.Entity<Screening>()
            //     .HasOne(s => s.Movie)
            //     .WithMany(m => m.Screenings)
            //     .HasForeignKey(s => s.MovieId)
            //     .OnDelete(DeleteBehavior.Cascade);

            // // Configure Hall and Screening relationship
            // modelBuilder.Entity<Screening>()
            //     .HasOne(s => s.Hall)
            //     .WithMany(h => h.Screenings)
            //     .HasForeignKey(s => s.HallId)
            //     .OnDelete(DeleteBehavior.Cascade);

            // // Configure ScreeningFormat and Screening relationship
            // modelBuilder.Entity<Screening>()
            //     .HasOne(s => s.Format)
            //     .WithMany(sf => sf.Screenings)
            //     .HasForeignKey(s => s.ScreeningFormatId)
            //     .OnDelete(DeleteBehavior.SetNull);

            // // Configure User and Reservation relationship
            // modelBuilder.Entity<Reservation>()
            //     .HasOne(r => r.User)
            //     .WithMany(u => u.Reservations)
            //     .HasForeignKey(r => r.UserId)
            //     .OnDelete(DeleteBehavior.Cascade);

            // // Configure Screening and Reservation relationship
            // modelBuilder.Entity<Reservation>()
            //     .HasOne(r => r.Screening)
            //     .WithMany(s => s.Reservations)
            //     .HasForeignKey(r => r.ScreeningId)
            //     .OnDelete(DeleteBehavior.Cascade);

            // // Configure Seat and Reservation relationship
            // modelBuilder.Entity<Reservation>()
            //     .HasOne(r => r.Seat)
            //     .WithMany(s => s.Reservations)
            //     .HasForeignKey(r => r.SeatId)
            //     .OnDelete(DeleteBehavior.Cascade);

            // // Configure Promotion and Reservation relationship
            // modelBuilder.Entity<Reservation>()
            //     .HasOne(r => r.Promotion)
            //     .WithMany(p => p.Reservations)
            //     .HasForeignKey(r => r.PromotionId)
            //     .OnDelete(DeleteBehavior.SetNull);

            // // Configure Reservation and Payment relationship
            // modelBuilder.Entity<Payment>()
            //     .HasOne(p => p.Reservation)
            //     .WithOne(r => r.Payment)
            //     .HasForeignKey<Payment>(p => p.ReservationId)
            //     .OnDelete(DeleteBehavior.Cascade);
                
            // // Configure User and Review relationship
            // modelBuilder.Entity<Review>()
            //     .HasOne(r => r.User)
            //     .WithMany(u => u.Reviews)
            //     .HasForeignKey(r => r.UserId)
            //     .OnDelete(DeleteBehavior.Cascade);
                
            // // Configure Movie and Review relationship
            // modelBuilder.Entity<Review>()
            //     .HasOne(r => r.Movie)
            //     .WithMany(m => m.Reviews)
            //     .HasForeignKey(r => r.MovieId)
            //     .OnDelete(DeleteBehavior.Cascade);
                
            // // Configure unique constraint to prevent multiple reviews from the same user for the same movie
            // modelBuilder.Entity<Review>()
            //     .HasIndex(r => new { r.UserId, r.MovieId })
            //     .IsUnique();
                
            // // Configure Promotion code to be unique
            // modelBuilder.Entity<Promotion>()
            //     .HasIndex(p => p.Code)
            //     .IsUnique()
            //     .HasFilter("[Code] IS NOT NULL");
                
            // // Configure User and NewsArticle relationship
            // modelBuilder.Entity<NewsArticle>()
            //     .HasOne(na => na.Author)
            //     .WithMany(u => u.NewsArticles)
            //     .HasForeignKey(na => na.AuthorId)
            //     .OnDelete(DeleteBehavior.SetNull);
                
            // // Configure Movie and Actor relationship (many-to-many)
            // modelBuilder.Entity<MovieActor>()
            //     .HasOne(ma => ma.Movie)
            //     .WithMany(m => m.MovieActors)
            //     .HasForeignKey(ma => ma.MovieId)
            //     .OnDelete(DeleteBehavior.Cascade);
                
            // modelBuilder.Entity<MovieActor>()
            //     .HasOne(ma => ma.Actor)
            //     .WithMany(a => a.MovieActors)
            //     .HasForeignKey(ma => ma.ActorId)
            //     .OnDelete(DeleteBehavior.Cascade);
                
            // // Configure Movie and Genre relationship (many-to-many)
            // modelBuilder.Entity<MovieGenre>()
            //     .HasOne(mg => mg.Movie)
            //     .WithMany(m => m.MovieGenres)
            //     .HasForeignKey(mg => mg.MovieId)
            //     .OnDelete(DeleteBehavior.Cascade);
                
            // modelBuilder.Entity<MovieGenre>()
            //     .HasOne(mg => mg.Genre)
            //     .WithMany(g => g.MovieGenres)
            //     .HasForeignKey(mg => mg.GenreId)
            //     .OnDelete(DeleteBehavior.Cascade);
                
            // // Configure unique constraints for names
            // modelBuilder.Entity<Genre>()
            //     .HasIndex(g => g.Name)
            //     .IsUnique();
                
        
                
            // modelBuilder.Entity<ScreeningFormat>()
            //     .HasIndex(sf => sf.Name)
            //     .IsUnique();

            // modelBuilder.Entity<MovieActor>()
            //     .HasKey(ma => new { ma.MovieId, ma.ActorId });

            // modelBuilder.Entity<MovieGenre>()
            //     .HasKey(mg => new { mg.MovieId, mg.GenreId });
        }
    }
} 