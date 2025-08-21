using eCinema.Model.Requests;
using eCinema.Model.SearchObjects;
using eCinema.Model.Responses;
using eCinema.Services.Database;
using eCinema.Services.Database.Entities;
using Microsoft.EntityFrameworkCore;
using MapsterMapper;
using System.Collections.Generic;

namespace eCinema.Services
{
    public class ReservationService : BaseCRUDService<ReservationResponse, ReservationSearchObject, Reservation, ReservationUpsertRequest, ReservationUpsertRequest>, IReservationService
    {
        public ReservationService(eCinemaDBContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override async Task<ReservationResponse> CreateAsync(ReservationUpsertRequest request)
        {
            using var transaction = _context.Database.BeginTransaction();

            try
            {
                await ValidateSeatsAvailability(request.ScreeningId, request.SeatIds);

                var reservation = new Reservation
                {
                    ReservationTime = request.ReservationTime,
                    TotalPrice = request.TotalPrice,
                    OriginalPrice = request.OriginalPrice,
                    DiscountPercentage = request.DiscountPercentage,
                    Status = request.Status,
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

                await _context.SaveChangesAsync();

                var qrCodeBase64 = await GenerateQRCode(reservation.Id);
                
                reservation.QrcodeBase64 = qrCodeBase64;
                await _context.SaveChangesAsync();

                transaction.Commit();

                var fullReservation = await GetByIdAsync(reservation.Id);
                return fullReservation;
            }
            catch
            {
                transaction.Rollback();
                throw;
            }
        }

        public override async Task<ReservationResponse> UpdateAsync(int id, ReservationUpsertRequest request)
        {
            var reservation = await _context.Reservations
                .Include(r => r.ReservationSeats)
                .FirstOrDefaultAsync(r => r.Id == id);

            if (reservation == null)
                throw new Exception("Reservation not found");

            reservation.ReservationTime = request.ReservationTime;
            reservation.TotalPrice = request.TotalPrice;
            reservation.OriginalPrice = request.OriginalPrice;
            reservation.DiscountPercentage = request.DiscountPercentage;
            reservation.Status = request.Status;
            reservation.UserId = request.UserId;
            reservation.ScreeningId = request.ScreeningId;
            reservation.PaymentId = request.PaymentId;
            reservation.PromotionId = request.PromotionId;
            reservation.NumberOfTickets = request.SeatIds.Count;
            reservation.PaymentType = request.PaymentType;
            reservation.State = request.State;
            reservation.IsDeleted = request.IsDeleted;

            _context.ReservationSeats.RemoveRange(reservation.ReservationSeats);

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
            return MapToResponse(reservation);
        }

        protected override ReservationResponse MapToResponse(Reservation entity)
        {
            if (entity == null)
                return null;

            var response = new ReservationResponse
            {
                Id = entity.Id,
                ReservationTime = entity.ReservationTime,
                TotalPrice = entity.TotalPrice,
                OriginalPrice = entity.OriginalPrice ?? entity.TotalPrice,
                DiscountPercentage = entity.DiscountPercentage,
                Status = entity.Status,
                IsDeleted = entity.IsDeleted,
                UserId = entity.UserId,
                UserName = entity.User?.Username ?? "",
                ScreeningId = entity.ScreeningId,
                MovieTitle = entity.Screening?.Movie?.Title ?? "",
                ScreeningStartTime = entity.Screening?.StartTime ?? DateTime.MinValue,
                SeatIds = entity.ReservationSeats?.Select(rs => rs.SeatId).ToList() ?? new List<int>(),
                NumberOfTickets = entity.NumberOfTickets ?? 0,
                PromotionId = entity.PromotionId,
                PromotionName = entity.Promotion?.Code,
                PaymentId = entity.PaymentId,
                PaymentStatus = entity.Payment?.Status,
                ReservationState = entity.State ?? "",
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
                
            return MapToResponse(reservation);
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
                    query = query.Where(r => r.Screening.StartTime > now);
                }
                else
                {
                    query = query.Where(r => r.Screening.StartTime <= now);
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
                    Status = r.Status,
                    IsDeleted = r.IsDeleted,
                    UserId = r.UserId,
                    UserName = r.User.Username,
                    ScreeningId = r.ScreeningId,
                    MovieTitle = r.Screening.Movie.Title,
                    ScreeningStartTime = r.Screening.StartTime,
                    SeatIds = r.ReservationSeats.Select(rs => rs.SeatId).ToList(),
                    NumberOfTickets = r.NumberOfTickets ?? 0,
                    PromotionId = r.PromotionId,
                    PromotionName = r.Promotion != null ? r.Promotion.Code : null,
                    PaymentId = r.PaymentId,
                    PaymentStatus = r.Payment != null ? r.Payment.Status : null,
                    ReservationState = r.State,
                    MovieImage = r.Screening.Movie.Image,
                    HallName = r.Screening.Hall.Name,
                    QrcodeBase64 = r.QrcodeBase64,
                })
                .ToList();

            return reservations;
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