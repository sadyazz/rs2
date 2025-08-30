using eCinema.Model.Messages;

namespace eCinema.Services.RabbitMQ
{
    public interface IRabbitMQService
    {
        Task SendEmail(Email email);
    }
}
