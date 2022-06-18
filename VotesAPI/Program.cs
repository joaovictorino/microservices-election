using VotesAPI.Infrastructure;
using Polly;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

HttpClientHandler handler = new HttpClientHandler();
handler.ServerCertificateCustomValidationCallback = (message, cert, chain, sslPolicyErrors) =>
                                                {
                                                    return true;
                                                };

builder.Services.AddHttpClient("HttpClient")
                .AddPolicyHandler(Policy.HandleResult<HttpResponseMessage>(r => r.StatusCode == System.Net.HttpStatusCode.Forbidden).WaitAndRetryAsync(new[]
                                                {
                                                    TimeSpan.FromSeconds(1),
                                                    TimeSpan.FromSeconds(5),
                                                    TimeSpan.FromSeconds(10)
                                                }))
                .AddTransientHttpErrorPolicy(builder => builder.WaitAndRetryAsync(new[]
                                                {
                                                    TimeSpan.FromSeconds(1),
                                                    TimeSpan.FromSeconds(5),
                                                    TimeSpan.FromSeconds(10)
                                                }))
                .ConfigurePrimaryHttpMessageHandler(c => handler);

builder.Services.Configure<IntegrationsSettings>(builder.Configuration.GetSection("Integrations"));
builder.Services.AddScoped<CandidatesIntegration>();

string? azureEnv = Environment.GetEnvironmentVariable("ASPNETCORE_Azure");

if(!string.IsNullOrEmpty(azureEnv)
    && Convert.ToBoolean(azureEnv)){
    builder.Services.AddScoped<IVotesQueue, VotesQueueBus>();
}else{
    builder.Services.AddScoped<IVotesQueue, VotesQueue>();
}

var app = builder.Build();

//if (app.Environment.IsDevelopment())
//{
    app.UseSwagger();
    app.UseSwaggerUI();
//}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();