using eCinema.Model.Requests;
using eCinema.Model.SearchObjects;
using eCinema.Model.Responses;
using eCinema.Services.Database.Entities;

namespace eCinema.Services
{
    public interface IReservationService : ICRUDService<ReservationResponse, ReservationSearchObject, ReservationUpsertRequest, ReservationUpsertRequest>
    {
        Task<List<Seat>> GetAvailableSeatsForScreening(int screeningId);
        List<ReservationResponse> GetReservationsByUserId(int userId, bool? isFuture = null);
        Task<string> GenerateQRCode(int reservationId);
        Task<ReservationResponse> VerifyReservation(int reservationId);
        Task<ReservationResponse> CancelReservation(int reservationId);
        Task<ReservationResponse> ProcessStripePayment(string paymentIntentId, decimal amount, int screeningId, List<int> seatIds);
    }
} 