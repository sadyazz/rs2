namespace eCinema.Model.Responses
{
    public class PaymentIntentCreateResponse
    {
        public string ClientSecret { get; set; } = string.Empty;
        public string Id { get; set; } = string.Empty;
    }
}