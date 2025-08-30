using System.Text;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using eCinema.Model.Messages;
using Newtonsoft.Json;
using eCinema.Subscriber;
using DotNetEnv;

Env.Load(".env");

Console.WriteLine("Sleeping to wait for RabbitMQ...");
Task.Delay(10000).Wait();

Console.WriteLine("Connecting to RabbitMQ...");

var hostname = Environment.GetEnvironmentVariable("_rabbitMqHost") ?? "localhost";
var username = Environment.GetEnvironmentVariable("_rabbitMqUser") ?? "guest";
var password = Environment.GetEnvironmentVariable("_rabbitMqPassword") ?? "guest";
var port = int.Parse(Environment.GetEnvironmentVariable("_rabbitMqPort") ?? "5672");

var factory = new ConnectionFactory 
{ 
    HostName = hostname, 
    UserName = username, 
    Password = password, 
    Port = port,
    RequestedHeartbeat = TimeSpan.FromSeconds(60),
    AutomaticRecoveryEnabled = true
};

int retryCount = 0;
const int maxRetries = 5;
IConnection connection = null;
IModel channel = null;

while (retryCount < maxRetries)
{
    try
    {
        connection = factory.CreateConnection();
        channel = connection.CreateModel();
        Console.WriteLine("Successfully connected to RabbitMQ");
        break;
    }
    catch (Exception ex)
    {
        retryCount++;
        if (retryCount == maxRetries)
        {
            Console.WriteLine($"Failed to connect to RabbitMQ after {maxRetries} attempts. Error: {ex.Message}");
            throw;
        }
        Console.WriteLine($"Failed to connect to RabbitMQ. Attempt {retryCount} of {maxRetries}. Retrying in 5 seconds...");
        Thread.Sleep(5000);
    }
}

channel.QueueDeclare(
    queue: "mail_sending",
    durable: false,
    exclusive: false,
    autoDelete: false,
    arguments: null
);

Console.WriteLine("Waiting for messages...");

var consumer = new EventingBasicConsumer(channel);
consumer.Received += (model, ea) =>
{
    var body = ea.Body.ToArray();
    var message = Encoding.UTF8.GetString(body);
    var email = JsonConvert.DeserializeObject<Email>(message);
    
    var emailDto = new EmailDTO
    {
        EmailTo = email.To,
        Subject = email.Subject,
        Message = email.Body,
        ReceiverName = $"{email.FirstName} {email.LastName}",
        Type = email.Type
    };
    
    if (emailDto != null)
    {
        MailSender.SendEmail(emailDto);
    }
};

channel.BasicConsume(
    queue: "mail_sending",
    autoAck: true,
    consumer: consumer);

Thread.Sleep(Timeout.Infinite);
