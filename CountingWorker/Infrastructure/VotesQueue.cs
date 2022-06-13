using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using Microsoft.Extensions.Configuration;
using System.Text;
using System.Text.Json;
using CountingWorker.Models;

namespace CountingWorker.Infrastructure;

public class VotesQueue{
    private readonly IConfiguration configuration;

    private VotesRepository repository;
    private IModel channel;
    private EventingBasicConsumer consumer;
    
    public VotesQueue(VotesRepository repository, IConfiguration configuration){
        this.repository = repository;
        this.configuration = configuration;
    }

    public void CreateConnection(){
        var factory = new ConnectionFactory() { HostName = configuration.GetValue<string>("RabbitMQ") };
        var connection = factory.CreateConnection();
        this.channel = connection.CreateModel();
        this.channel.QueueDeclare("votes", false, false, false, null);
        this.consumer = new EventingBasicConsumer(this.channel);
        this.consumer.Received += (model, ea) => {
            var body = ea.Body.ToArray();
            var message = Encoding.UTF8.GetString(body);
            Vote? vote = JsonSerializer.Deserialize<Vote>(message);
            repository.Create(vote);
        };
    }

    public void Receive(){
        this.channel.BasicConsume("votes", true, consumer);        
    }
}