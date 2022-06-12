using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using Microsoft.Extensions.Configuration;

namespace CountingApp.Infrastructure;

public class VotesQueue{
    private readonly IConfiguration configuration;
    private EventingBasicConsumer consumer;

    public EventingBasicConsumer Consumer{
        get{ 
            return consumer;
        }
    }

    public VotesQueue(IConfiguration configuration){
        this.configuration = configuration;
    }

    public void Receive(){
        var factory = new ConnectionFactory() { HostName = configuration.GetValue<string>("RabbitMQ") };
        using(var connection = factory.CreateConnection())
        using(var channel = connection.CreateModel()){
            channel.QueueDeclare("votes", false, false, false, null);
            this.consumer = new EventingBasicConsumer(channel);
            channel.BasicConsume("votes", true, consumer);
        }
    }
}