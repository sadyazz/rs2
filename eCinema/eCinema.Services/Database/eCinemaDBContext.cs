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
        }
    }
}