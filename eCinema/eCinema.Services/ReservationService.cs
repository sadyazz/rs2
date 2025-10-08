using eCinema.Model.Requests;
using eCinema.Model.SearchObjects;
using eCinema.Model.Responses;
using eCinema.Services.Database;
using eCinema.Services.Database.Entities;
using eCinema.Services.ReservationStateMachine;
using Microsoft.EntityFrameworkCore;
using MapsterMapper;
using eCinema.Model;
using eCinema.Services.Auth;

namespace eCinema.Services
{
    public class ReservationService : BaseCRUDService<ReservationResponse, ReservationSearchObject, Reservation, ReservationUpsertRequest, ReservationUpsertRequest>, IReservationService
    {
        private readonly IServiceProvider _serviceProvider;
        private readonly PaymentService _paymentService;
        private readonly ICurrentUserService _currentUserService;

        public ReservationService(
            eCinemaDBContext context, 
            IMapper mapper, 
            IServiceProvider serviceProvider, 
            PaymentService paymentService,
            ICurrentUserService currentUserService) : base(context, mapper)
        {
            _serviceProvider = serviceProvider;
            _paymentService = paymentService;
            _currentUserService = currentUserService;
        }

        private BaseReservationState GetReservationState(string stateName)
        {
            var state = new BaseReservationState(_serviceProvider, _mapper, _context);
            return state.GetReservationState(stateName);
        }

        public override async Task<ReservationResponse> CreateAsync(ReservationUpsertRequest request)
        {

            try
            {
                var screening = await _context.Screenings
                    .FirstOrDefaultAsync(s => s.Id == request.ScreeningId);
                if (screening == null || screening.IsDeleted)
                    throw new UserException("Screening not found");

                if (screening.StartTime <= DateTime.UtcNow)
                    throw new UserException("Cannot make reservation for past screenings");

                var existingReservation = await _context.Reservations
                    .AnyAsync(r => r.UserId == request.UserId 
                        && r.ScreeningId == request.ScreeningId
                        && !r.IsDeleted
                        && r.State != nameof(CancelledReservationState)
                        && r.State != nameof(RejectedReservationState));
                if (existingReservation)
                    throw new UserException("You already have a reservation for this screening");

                await ValidateSeatsAvailability(request.ScreeningId, request.SeatIds);

                var reservation = new Reservation
                {
                    ReservationTime = request.ReservationTime,
                    TotalPrice = request.TotalPrice,
                    OriginalPrice = request.OriginalPrice,
                    DiscountPercentage = request.DiscountPercentage,
                    UserId = request.UserId,
                    ScreeningId = request.ScreeningId,
                    PaymentId = request.PaymentId,
                    PromotionId = request.PromotionId,
                    NumberOfTickets = request.SeatIds.Count,
                    PaymentType = request.PaymentType,
                    State = request.State,
                    IsDeleted = request.IsDeleted
                };

                _context.Reservations.Add(reservation);
                await _context.SaveChangesAsync();

                foreach (var seatId in request.SeatIds)
                {
                    var reservationSeat = new ReservationSeat
                    {
                        ReservationId = reservation.Id,
                        SeatId = seatId,
                        ReservedAt = DateTime.UtcNow
                    };
                    _context.ReservationSeats.Add(reservationSeat);
                }

                foreach (var seatId in request.SeatIds)
                {
                    var screeningSeat = await _context.ScreeningSeats
                        .FirstOrDefaultAsync(ss => ss.ScreeningId == request.ScreeningId && ss.SeatId == seatId);

                    if (screeningSeat != null)
                    {
                        screeningSeat.IsReserved = true;
                    }
                    else
                    {
                        var newScreeningSeat = new ScreeningSeat
                        {
                            ScreeningId = request.ScreeningId,
                            SeatId = seatId,
                            IsReserved = true
                        };
                        _context.ScreeningSeats.Add(newScreeningSeat);
                    }
                }

                if (request.PromotionId.HasValue)
                {
                    var hasUsedPromotion = await _context.UserPromotions
                        .AnyAsync(up => up.UserId == request.UserId && up.PromotionId == request.PromotionId.Value);

                    if (hasUsedPromotion)
                        throw new UserException("You have already used this promotion code");

                    var userPromotion = new UserPromotion
                    {
                        UserId = request.UserId,
                        PromotionId = request.PromotionId.Value,
                        UsedDate = DateTime.UtcNow
                    };
                    _context.UserPromotions.Add(userPromotion);
                }

                await _context.SaveChangesAsync();

                var qrCodeBase64 = await GenerateQRCode(reservation.Id);
                
                reservation.QrcodeBase64 = qrCodeBase64;
                await _context.SaveChangesAsync();

                var fullReservation = await GetByIdAsync(reservation.Id);
                return fullReservation ?? throw new Exception("Failed to create reservation");
            }
            catch
            {
                throw;
            }
        }

        public async Task<ReservationResponse> ProcessStripePayment(string paymentIntentId, decimal amount, int screeningId, List<int> seatIds)
        {
            using var transaction = _context.Database.BeginTransaction();

            try
            {
                var userId = await _currentUserService.GetUserIdAsync() ?? throw new Exception("User not authenticated");
                
                var screening = await _context.Screenings
                    .FirstOrDefaultAsync(s => s.Id == screeningId);
                if (screening == null || screening.IsDeleted)
                    throw new UserException("Screening not found");

                if (screening.StartTime <= DateTime.UtcNow)
                    throw new UserException("Cannot make reservation for past screenings");

                var existingReservation = await _context.Reservations
                    .AnyAsync(r => r.UserId == userId 
                        && r.ScreeningId == screeningId
                        && !r.IsDeleted
                        && r.State != nameof(CancelledReservationState)
                        && r.State != nameof(RejectedReservationState));
                if (existingReservation)
                    throw new UserException("You already have a reservation for this screening");

                await ValidateSeatsAvailability(screeningId, seatIds);

                var payment = await _paymentService.ProcessStripePayment(paymentIntentId, amount);

                var request = new ReservationUpsertRequest
                {
                    ScreeningId = screeningId,
                    SeatIds = seatIds,
                    TotalPrice = amount,
                    PaymentType = "Stripe",
                    PaymentId = payment.Id,
                    ReservationTime = DateTime.UtcNow,
                    IsDeleted = false,
                    UserId = userId,
                    State = "ApprovedReservationState"
                };

                var reservation = await CreateAsync(request);
                
                if (reservation == null)
                    throw new Exception("Failed to create reservation");

                transaction.Commit();

                return reservation;
            }
            catch (Exception ex)
            {
                transaction.Rollback();
                throw new Exception($"Failed to process payment: {ex.Message}", ex);
            }
        }

        public override async Task<ReservationResponse> UpdateAsync(int id, ReservationUpsertRequest request)
        {
            using var transaction = _context.Database.BeginTransaction();

            try
            {
                var reservation = await _context.Reservations
                    .Include(r => r.ReservationSeats)
                    .FirstOrDefaultAsync(r => r.Id == id);

                if (reservation == null)
                    throw new UserException("Reservation not found");

                var currentState = GetReservationState(reservation.State);
                await currentState.UpdateAsync(id, request);

                reservation.ReservationTime = request.ReservationTime;
                reservation.TotalPrice = request.TotalPrice;
                reservation.OriginalPrice = request.OriginalPrice;
                reservation.DiscountPercentage = request.DiscountPercentage;
                reservation.UserId = request.UserId;
                reservation.ScreeningId = request.ScreeningId;
                reservation.PaymentId = request.PaymentId;
                reservation.PromotionId = request.PromotionId;
                reservation.NumberOfTickets = request.SeatIds.Count;
                reservation.PaymentType = request.PaymentType;
                reservation.IsDeleted = request.IsDeleted;

                _context.ReservationSeats.RemoveRange(reservation.ReservationSeats);
                await _context.SaveChangesAsync();

                foreach (var seatId in request.SeatIds)
                {
                    var reservationSeat = new ReservationSeat
                    {
                        ReservationId = reservation.Id,
                        SeatId = seatId,
                        ReservedAt = DateTime.UtcNow
                    };
                    _context.ReservationSeats.Add(reservationSeat);
                }

                await _context.SaveChangesAsync();
                transaction.Commit();

                var updatedReservation = await GetByIdAsync(reservation.Id);
                return updatedReservation ?? throw new Exception("Failed to update reservation");
            }
            catch
            {
                transaction.Rollback();
                throw;
            }
        }

        protected override ReservationResponse MapToResponse(Reservation entity)
        {
            if (entity == null)
                throw new ArgumentNullException(nameof(entity));

            var response = new ReservationResponse
            {
                Id = entity.Id,
                ReservationTime = entity.ReservationTime,
                TotalPrice = entity.TotalPrice,
                OriginalPrice = entity.OriginalPrice ?? entity.TotalPrice,
                DiscountPercentage = entity.DiscountPercentage,
                IsDeleted = entity.IsDeleted,
                UserId = entity.UserId,
                UserName = entity.User?.Username ?? "",
                ScreeningId = entity.ScreeningId,
                MovieTitle = entity.Screening?.Movie?.Title ?? "",
                ScreeningStartTime = entity.Screening?.StartTime ?? DateTime.MinValue,
                SeatIds = entity.ReservationSeats?.Select(rs => rs.SeatId).ToList() ?? new List<int>(),
                SeatNames = entity.ReservationSeats?.Select(rs => rs.Seat?.Name ?? $"Seat {rs.SeatId}").ToList() ?? new List<string>(),
                NumberOfTickets = entity.NumberOfTickets ?? 0,
                PromotionId = entity.PromotionId,
                PromotionName = entity.Promotion?.Code,
                PaymentId = entity.PaymentId,
                State = entity.State ?? "",
                MovieImage = entity.Screening?.Movie?.Image,
                HallName = entity.Screening?.Hall?.Name ?? "",
                QrcodeBase64 = entity.QrcodeBase64
            };
            return response;
        }

        public override async Task<ReservationResponse> GetByIdAsync(int id)
        {
            var reservation = await _context.Reservations
                .Include(r => r.ReservationSeats)
                    .ThenInclude(rs => rs.Seat)
                .Include(r => r.User)
                .Include(r => r.Screening)
                    .ThenInclude(s => s.Movie)
                .Include(r => r.Screening)
                    .ThenInclude(s => s.Hall)
                .Include(r => r.Payment)
                .Include(r => r.Promotion)
                .FirstOrDefaultAsync(r => r.Id == id);
                
            if (reservation == null)
                throw new KeyNotFoundException($"Reservation with ID {id} not found");

            return new ReservationResponse
            {
                Id = reservation.Id,
                ReservationTime = reservation.ReservationTime,
                TotalPrice = reservation.TotalPrice,
                OriginalPrice = reservation.OriginalPrice ?? reservation.TotalPrice,
                DiscountPercentage = reservation.DiscountPercentage,
                IsDeleted = reservation.IsDeleted,
                UserId = reservation.UserId,
                UserName = reservation.User?.Username ?? "",
                ScreeningId = reservation.ScreeningId,
                MovieTitle = reservation.Screening?.Movie?.Title ?? "",
                ScreeningStartTime = reservation.Screening?.StartTime ?? DateTime.MinValue,
                SeatIds = reservation.ReservationSeats.Select(rs => rs.SeatId).ToList(),
                SeatNames = reservation.ReservationSeats.Select(rs => rs.Seat?.Name ?? $"Seat {rs.SeatId}").ToList(),
                NumberOfTickets = reservation.NumberOfTickets ?? 0,
                PromotionId = reservation.PromotionId,
                PromotionName = reservation.Promotion?.Code,
                PaymentId = reservation.PaymentId,
                State = reservation.State ?? "",
                MovieImage = reservation.Screening?.Movie?.Image,
                HallName = reservation.Screening?.Hall?.Name ?? "",
                QrcodeBase64 = reservation.QrcodeBase64,
            };
        }

        public async Task<List<Seat>> GetAvailableSeatsForScreening(int screeningId)
        {
            var reservedSeatIds = await _context.ReservationSeats
                .Where(rs => rs.Reservation.ScreeningId == screeningId && !rs.Reservation.IsDeleted)
                .Select(rs => rs.SeatId)
                .ToListAsync();

            var availableSeats = await _context.Seats
                .Where(s => !reservedSeatIds.Contains(s.Id))
                .ToListAsync();

            return availableSeats;
        }

        public List<ReservationResponse> GetReservationsByUserId(int userId, bool? isFuture = null)
        {
            var query = _context.Reservations
                .Include(r => r.ReservationSeats)
                    .ThenInclude(rs => rs.Seat)
                .Include(r => r.Screening)
                    .ThenInclude(s => s.Movie)
                .Include(r => r.User)
                .Include(r => r.Payment)
                .Include(r => r.Promotion)
                .Where(r => r.UserId == userId && !r.IsDeleted);

            if (isFuture.HasValue)
            {
                var now = DateTime.UtcNow;
                if (isFuture.Value)
                {
                    query = query.Where(r => 
                        r.Screening.StartTime > now && 
                        r.State != nameof(UsedReservationState) &&
                        r.State != nameof(ExpiredReservationState) &&
                        r.State != nameof(RejectedReservationState));
                }
                else
                {
                    query = query.Where(r => 
                        r.Screening.StartTime <= now ||
                        r.State == nameof(UsedReservationState) ||
                        r.State == nameof(ExpiredReservationState) ||
                        r.State == nameof(RejectedReservationState));
                }
            }

            var reservations = query
                .Select(r => new ReservationResponse
                {
                    Id = r.Id,
                    ReservationTime = r.ReservationTime,
                    TotalPrice = r.TotalPrice,
                    OriginalPrice = r.OriginalPrice ?? r.TotalPrice,
                    DiscountPercentage = r.DiscountPercentage,
                    IsDeleted = r.IsDeleted,
                    UserId = r.UserId,
                    UserName = r.User.Username ?? "",
                    ScreeningId = r.ScreeningId,
                    MovieTitle = r.Screening.Movie.Title ?? "",
                    ScreeningStartTime = r.Screening.StartTime,
                    SeatIds = r.ReservationSeats.Select(rs => rs.SeatId).ToList(),
                    SeatNames = r.ReservationSeats.Select(rs => rs.Seat.Name ?? $"Seat {rs.SeatId}").ToList(),
                    NumberOfTickets = r.NumberOfTickets ?? 0,
                    PromotionId = r.PromotionId,
                    PromotionName = r.Promotion != null ? r.Promotion.Code : null,
                    PaymentId = r.PaymentId,
                    State = r.State ?? "",
                    MovieImage = r.Screening.Movie.Image,
                    HallName = r.Screening.Hall.Name ?? "",
                    QrcodeBase64 = r.QrcodeBase64,
                })
                .ToList();

            return reservations;
        }

        protected override IQueryable<Reservation> ApplyFilter(IQueryable<Reservation> query, ReservationSearchObject search)
        {
            query = base.ApplyFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search.State))
            {
                query = query.Where(x => x.State == search.State);
            }

            if (search.UserId.HasValue)
            {
                query = query.Where(x => x.UserId == search.UserId.Value);
            }

            if (search.ScreeningId.HasValue)
            {
                query = query.Where(x => x.ScreeningId == search.ScreeningId.Value);
            }

            if (search.SeatId.HasValue)
            {
                query = query.Where(x => x.ReservationSeats.Any(rs => rs.SeatId == search.SeatId.Value));
            }

            if (search.PromotionId.HasValue)
            {
                query = query.Where(x => x.PromotionId == search.PromotionId.Value);
            }

            if (search.FromReservationTime.HasValue)
            {
                query = query.Where(x => x.ReservationTime >= search.FromReservationTime.Value);
            }

            if (search.ToReservationTime.HasValue)
            {
                query = query.Where(x => x.ReservationTime <= search.ToReservationTime.Value);
            }

            if (search.MinTotalPrice.HasValue)
            {
                query = query.Where(x => x.TotalPrice >= search.MinTotalPrice.Value);
            }

            if (search.MaxTotalPrice.HasValue)
            {
                query = query.Where(x => x.TotalPrice <= search.MaxTotalPrice.Value);
            }

            if (search.HasPayment.HasValue)
            {
                query = query.Where(x => (x.PaymentId != null) == search.HasPayment.Value);
            }

            return query;
        }

        private async Task ValidateSeatsAvailability(int screeningId, List<int> seatIds)
        {
            var unavailableSeats = await _context.ScreeningSeats
                .Where(ss => ss.ScreeningId == screeningId && seatIds.Contains(ss.SeatId) && ss.IsReserved == true)
                .Select(ss => ss.SeatId)
                .ToListAsync();

            if (unavailableSeats.Any())
            {
                throw new InvalidOperationException($"The following seats are already reserved: {string.Join(", ", unavailableSeats)}");
            }
        }

        public async Task<ReservationResponse> VerifyReservation(int reservationId)
        {
            var reservation = await _context.Reservations
                .Include(r => r.User)
                .Include(r => r.Screening)
                    .ThenInclude(s => s.Movie)
                .Include(r => r.Screening)
                    .ThenInclude(s => s.Hall)
                .Include(r => r.ReservationSeats)
                    .ThenInclude(rs => rs.Seat)
                .Include(r => r.Payment)
                .Include(r => r.Promotion)
                .FirstOrDefaultAsync(r => r.Id == reservationId);

            if (reservation == null)
                throw new Exception("This ticket does not exist in our system.");

            if (reservation.State == nameof(UsedReservationState))
                throw new Exception("This ticket has already been used for entry.");

            if (reservation.State == nameof(CancelledReservationState))
                throw new Exception("This ticket has been cancelled and cannot be used.");
                
            if (reservation.State != nameof(ApprovedReservationState))
                throw new Exception("This ticket is not valid for entry.");

            var screening = reservation.Screening;
            if (screening == null)
                throw new Exception("The screening associated with this ticket no longer exists.");

            var now = DateTime.UtcNow;
            var screeningTime = screening.StartTime;
            
            Console.WriteLine($"=== time debug info ===");
            Console.WriteLine($"current time (utc): {now}");
            Console.WriteLine($"screening time (utc): {screeningTime}");
            Console.WriteLine($"Time until screening: {screeningTime - now}");
            Console.WriteLine($"max allowed time (2h): {now.AddHours(2)}");
            Console.WriteLine($"min allowed time (-3h): {now.AddHours(-3)}");
            Console.WriteLine($"is too early? {screeningTime > now.AddHours(2)}");
            Console.WriteLine($"is too late? {screeningTime < now.AddHours(-3)}");
            Console.WriteLine($"=====================");

            if (screeningTime < now.AddHours(-3))
            {
                Console.WriteLine($"Screening ended more than 3 hours ago");
                throw new Exception("This screening has already ended.");
            }

            if (screeningTime > now.AddHours(3))
            {
                Console.WriteLine($"Screening starts in more than 3 hours");
                throw new Exception("It's too early for entry. Please come back closer to the screening time.");
            }

            var currentState = GetReservationState(reservation.State);
            var response = await currentState.MarkAsUsedAsync(reservationId);
            
            if (response == null)
                throw new Exception("Failed to process the ticket. Please try again.");
                
            await _context.SaveChangesAsync();
                
            return MapToResponse(reservation);
        }

        public async Task<ReservationResponse> CancelReservation(int reservationId)
        {
            var reservation = await _context.Reservations
                .Include(r => r.User)
                .Include(r => r.Screening)
                    .ThenInclude(s => s.Movie)
                .Include(r => r.Screening)
                    .ThenInclude(s => s.Hall)
                .Include(r => r.ReservationSeats)
                    .ThenInclude(rs => rs.Seat)
                .Include(r => r.Payment)
                .Include(r => r.Promotion)
                .FirstOrDefaultAsync(r => r.Id == reservationId);

            if (reservation == null)
                throw new Exception("Reservation not found");

            if (reservation.State == nameof(UsedReservationState))
                throw new Exception("Cannot cancel a used ticket");

            if (reservation.State == nameof(CancelledReservationState))
                throw new Exception("This reservation is already cancelled");

            if (reservation.State != nameof(ApprovedReservationState))
                throw new Exception("Only approved reservations can be cancelled");

            var screening = reservation.Screening;
            if (screening == null)
                throw new Exception("Screening not found");

            var now = DateTime.UtcNow;
            var screeningTime = screening.StartTime;

            if (screeningTime < now.AddHours(1))
                throw new Exception("Cannot cancel reservation less than 1 hour before screening");

            var currentState = GetReservationState(reservation.State);
            var response = await currentState.CancelAsync(reservationId);
            
            if (response == null)
                throw new Exception("Failed to cancel reservation");
                
            await _context.SaveChangesAsync();

            var screeningSeats = await _context.ScreeningSeats
                .Where(ss => ss.ScreeningId == reservation.ScreeningId && 
                       reservation.ReservationSeats.Select(rs => rs.SeatId).Contains(ss.SeatId))
                .ToListAsync();

            foreach (var seat in screeningSeats)
            {
                seat.IsReserved = false;
            }

            await _context.SaveChangesAsync();
                
            return MapToResponse(reservation);
        }

        public async Task<(decimal totalPrice, decimal? discountPercentage)> CalculatePriceWithPromotion(decimal originalPrice, string? promotionCode)
        {
            if (string.IsNullOrEmpty(promotionCode))
                return (originalPrice, null);

            var promotion = await _context.Promotions
                .FirstOrDefaultAsync(p => p.Code == promotionCode 
                    && !p.IsDeleted 
                    && p.StartDate <= DateTime.UtcNow 
                    && p.EndDate >= DateTime.UtcNow);

            if (promotion == null)
                return (originalPrice, null);

            var discountAmount = originalPrice * (promotion.DiscountPercentage / 100m);
            var finalPrice = originalPrice - discountAmount;

            return (finalPrice, promotion.DiscountPercentage);
        }

        public async Task<bool> HasUserWatchedMovie(int movieId)
        {
            var userId = await _currentUserService.GetUserIdAsync();
            if (!userId.HasValue)
                return false;

            return await _context.Reservations
                .Include(r => r.Screening)
                .AnyAsync(r => 
                    r.UserId == userId.Value &&
                    r.Screening.MovieId == movieId &&
                    r.State == nameof(UsedReservationState));
        }

        public async Task<string> GenerateQRCode(int reservationId)
        {
            var reservation = await _context.Reservations
                .Include(r => r.User)
                .Include(r => r.Screening)
                    .ThenInclude(s => s.Movie)
                .Include(r => r.Screening)
                    .ThenInclude(s => s.Hall)
                .Include(r => r.ReservationSeats)
                    .ThenInclude(rs => rs.Seat)
                .FirstOrDefaultAsync(r => r.Id == reservationId);

            if (reservation == null)
            {
                throw new Exception("Reservation not found");
            }

            var qrCodeContent = $"Reservation ID: {reservation.Id}\n" +
                                $"User: {reservation.User?.Username} ({reservation.User?.FirstName} {reservation.User?.LastName})\n" +
                                $"Movie: {reservation.Screening?.Movie?.Title}\n" +
                                $"Date: {reservation.Screening?.StartTime:dd-MM-yyyy HH:mm}\n" +
                                $"Hall: {reservation.Screening?.Hall?.Name}\n" +
                                $"Ticket Price: {reservation.Screening?.BasePrice}\n" +
                                $"Reservation Date: {reservation.ReservationTime:dd-MM-yyyy HH:mm}\n" +
                                $"Seats: {string.Join(", ", reservation.ReservationSeats.Select(s => s.Seat.Name ?? $"Seat {s.Seat.Id}"))}\n" +
                                $"Total Price: {reservation.TotalPrice}\n" +
                                $"Payment Type: {reservation.PaymentType}\n";

            using var qrGenerator = new QRCoder.QRCodeGenerator();
            var qrCodeData = qrGenerator.CreateQrCode(qrCodeContent, QRCoder.QRCodeGenerator.ECCLevel.Q);
            var qrCode = new QRCoder.PngByteQRCode(qrCodeData);
            var qrCodeImage = qrCode.GetGraphic(20);

            return Convert.ToBase64String(qrCodeImage);
        }
    }
}