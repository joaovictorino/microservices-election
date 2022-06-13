using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using Microsoft.Extensions.Configuration;
using System.Text;
using System.Text.Json;
using CountingApp.Models;
using CountingApp.Infrastructure;

IConfiguration configuration = new ConfigurationBuilder()
    .AddJsonFile("appsettings.json")
    .AddEnvironmentVariables()
    .Build();

//DataContext context = new DataContext(configuration);
//VotesRepository repo = new VotesRepository(context);

var factory = new ConnectionFactory() { HostName = configuration.GetValue<string>("RabbitMQ") };
using(var connection = factory.CreateConnection())
using(var channel = connection.CreateModel()){
    channel.QueueDeclare("votes", false, false, false, null);
    var consumer = new EventingBasicConsumer(channel);
    consumer.Received += (model, ea) => {
        var body = ea.Body.ToArray();
        var message = Encoding.UTF8.GetString(body);
        Console.WriteLine(message);
    };
    channel.BasicConsume("votes", true, consumer);
}

Console.ReadLine();