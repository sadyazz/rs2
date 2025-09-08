using System.Text;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using eCinema.Model.Messages;
using Newtonsoft.Json;
using eCinema.Subscriber;
using DotNetEnv;

Env.Load();

Console.WriteLine("Sleeping to wait for RabbitMQ...");
Task.Delay(15000).Wait();

var hostname = Environment.GetEnvironmentVariable("_rabbitMqHost") ?? "rabbitmq";
var username = Environment.GetEnvironmentVariable("_rabbitMqUser") ?? "guest";
var password = Environment.GetEnvironmentVariable("_rabbitMqPassword") ?? "guest";
var port = int.Parse(Environment.GetEnvironmentVariable("_rabbitMqPort") ?? "5672");

Console.WriteLine($"Connecting to RabbitMQ at {hostname}:{port}...");

IConnection connection = null;
int maxRetries = 10;
int retryCount = 0;

while (connection == null && retryCount < maxRetries)
{
    try
    {
        ConnectionFactory factory = new ConnectionFactory() 
        { 
            HostName = hostname, 
            Port = port,
            UserName = username,
            Password = password,
            RequestedConnectionTimeout = TimeSpan.FromSeconds(30),
            RequestedHeartbeat = TimeSpan.FromSeconds(60)
        };
        
        connection = factory.CreateConnection();
        Console.WriteLine("Successfully connected to RabbitMQ!");
    }
    catch (Exception ex)
    {
        retryCount++;
        Console.WriteLine($"Failed to connect to RabbitMQ (attempt {retryCount}/{maxRetries}): {ex.Message}");
        
        if (retryCount < maxRetries)
        {
            Console.WriteLine($"Retrying in 5 seconds...");
            Task.Delay(5000).Wait();
        }
        else
        {
            Console.WriteLine("Max retries reached. Exiting...");
            Environment.Exit(1);
        }
    }
}
IModel channel = connection.CreateModel();

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
