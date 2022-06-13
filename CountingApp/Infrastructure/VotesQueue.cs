using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using Microsoft.Extensions.Configuration;
using System.Text;
using System.Text.Json;
using CountingApp.Models;

namespace CountingApp.Infrastructure;

public class VotesQueue{
    private readonly IConfiguration configuration;

    //private VotesRepository repo;
    
    public VotesQueue(IConfiguration configuration){
        this.configuration = configuration;
    }

    public void Receive(){
        var factory = new ConnectionFactory() { HostName = configuration.GetValue<string>("RabbitMQ") };
        using(var connection = factory.CreateConnection())
        using(var channel = connection.CreateModel()){
            channel.QueueDeclare("votes", false, false, false, null);
            var consumer = new EventingBasicConsumer(channel);
            consumer.Received += (model, ea) => {
                var body = ea.Body.ToArray();
                var message = Encoding.UTF8.GetString(body);
                Console.WriteLine(message);
                //Vote? vote = JsonSerializer.Deserialize<Vote>(message);
                //repo.Create(vote);
            };
            channel.BasicConsume("votes", true, consumer);
        }
    }
}