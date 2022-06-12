using CountingApp.Infrastructure;
using Microsoft.Extensions.Configuration;
using System.Text;
using System.Text.Json;
using CountingApp.Models;

IConfiguration configuration = new ConfigurationBuilder()
    .AddJsonFile("appsettings.json")
    .AddEnvironmentVariables()
    .Build();

VotesQueue queue = new VotesQueue(configuration);
queue.Receive();

DataContext context = new DataContext(configuration);
VotesRepository repo = new VotesRepository(context);

queue.Consumer.Received += async (model, ea) => {
    var body = ea.Body.ToArray();
    var message = Encoding.UTF8.GetString(body);
    Vote? vote = JsonSerializer.Deserialize<Vote>(message);
    await repo.CreateAsync(vote);
};