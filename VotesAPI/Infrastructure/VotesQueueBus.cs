using RabbitMQ.Client;
using VotesAPI.Models;
using System.Text;
using System.Text.Json;
using Azure.Messaging.ServiceBus;

namespace VotesAPI.Infrastructure;

public class VotesQueueBus : IVotesQueue {
    private readonly IConfiguration configuration;

    public VotesQueueBus(IConfiguration configuration){
        this.configuration = configuration;
    }

    public async void Send(VoteMessage vote){
        var client = new ServiceBusClient(this.configuration.GetValue<string>("RabbitMQ"));
        ServiceBusMessage message = new ServiceBusMessage(JsonSerializer.Serialize<VoteMessage>(vote));
        var sender = client.CreateSender("votesmq");
        await sender.SendMessageAsync(message);
    }
}