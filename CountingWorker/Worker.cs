using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using Microsoft.Extensions.Configuration;
using System.Text;
using System.Text.Json;
using CountingWorker.Models;
using CountingWorker.Infrastructure;

namespace CountingWorker;

public class Worker : BackgroundService
{
    private readonly ILogger<Worker> logger;
    private readonly VotesRepository repository;
    private readonly VotesQueue queue;

    public Worker(VotesQueue queue, VotesRepository repository, ILogger<Worker> logger)
    {
        this.queue = queue;
        this.repository = repository;
        this.logger = logger;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        queue.CreateConnection();

        while (!stoppingToken.IsCancellationRequested)
        {
            queue.Receive();
            await Task.Delay(1000, stoppingToken);
        }
    }
}