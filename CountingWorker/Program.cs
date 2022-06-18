using CountingWorker;
using CountingWorker.Infrastructure;

IHost host = Host.CreateDefaultBuilder(args)
    .ConfigureServices(services =>
    {
        services.AddHostedService<Worker>();
        services.AddSingleton<DataContext>();
        services.AddSingleton<VotesRepository>();
        services.AddSingleton<VotesQueue>();
    })
    .Build();

await host.RunAsync();