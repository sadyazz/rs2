using eCinema.Model.Messages;
using RabbitMQ.Client;
using eCinema.Subscriber;
using System.Text;
using Newtonsoft.Json;

namespace eCinema.Services.RabbitMQ
{
    public class RabbitMQService : IRabbitMQService
    {
        public Task SendEmail(Model.Messages.Email email)
        {
            var hostname = Environment.GetEnvironmentVariable("_rabbitMqHost") ?? "localhost";
            var username = Environment.GetEnvironmentVariable("_rabbitMqUser") ?? "guest";
            var password = Environment.GetEnvironmentVariable("_rabbitMqPassword") ?? "guest";
            var port = int.Parse(Environment.GetEnvironmentVariable("_rabbitMqPort") ?? "5672");

            var factory = new ConnectionFactory 
            { 
                HostName = hostname, 
                UserName = username, 
                Password = password, 
                Port = port 
            };

            using var connection = factory.CreateConnection();
            using var channel = connection.CreateModel();

            channel.QueueDeclare(
                queue: "mail_sending",
                durable: false,
                exclusive: false,
                autoDelete: false,
                arguments: null
            );

                var jsonMessage = JsonConvert.SerializeObject(email);
                Console.WriteLine($"Sending message: {jsonMessage}");
                var body = Encoding.UTF8.GetBytes(jsonMessage);

            channel.BasicPublish(
                exchange: string.Empty,
                routingKey: "mail_sending",
                basicProperties: null,
                body: body
            );

            return Task.CompletedTask;
        }
    }
}