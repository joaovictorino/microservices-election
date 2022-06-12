using VotesAPI.Infrastructure;
using Polly;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddDbContext<DataContext>();
builder.Services.AddScoped<VotesRepository>();

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

var app = builder.Build();

//if (app.Environment.IsDevelopment())
//{
    app.UseSwagger();
    app.UseSwaggerUI();
//}

using(var scope = app.Services.CreateScope()){
    var db = scope.ServiceProvider.GetRequiredService<DataContext>();
    db.Database.Migrate();
}


app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();