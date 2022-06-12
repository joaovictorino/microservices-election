using RabbitMQ.Client;
using VotesAPI.Models;
using System.Text;
using System.Text.Json;

namespace VotesAPI.Infrastructure;

public class VotesQueue{
    private readonly IConfiguration configuration;

    public VotesQueue(IConfiguration configuration){
        this.configuration = configuration;
    }

    public void Send(Vote vote){
        var factory = new ConnectionFactory() { HostName = configuration.GetValue<string>("RabbitMQ") };
        using(var connection = factory.CreateConnection())
        using(var channel = connection.CreateModel()){
            channel.QueueDeclare("votes", false, false, false, null);
            String voteJson = JsonSerializer.Serialize<Vote>(vote);
            var message = Encoding.UTF8.GetBytes(voteJson);
            channel.BasicPublish("", "votes", null, message);
        }
    }
}