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



Console.ReadLine();