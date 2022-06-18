using Microsoft.Extensions.Options;
using System.Text.Json;
using VotesAPI.Models;

namespace VotesAPI.Infrastructure;

public class CandidatesIntegration {

    private readonly IOptions<IntegrationsSettings> integrations;
    private readonly IHttpClientFactory httpClientFactory;

    public CandidatesIntegration(   IOptions<IntegrationsSettings> integrations,
                                    IHttpClientFactory httpClientFactory){
        this.httpClientFactory = httpClientFactory;
        this.integrations = integrations;
    }

    public async Task<Candidate> FindCandidate(Vote vote){
        HttpClient client = httpClientFactory.CreateClient("HttpClient");
        var address = integrations.Value.CandidateAddress + vote.NumberCandidate.Value.ToString();
        HttpResponseMessage message = await client.GetAsync(address);

        if (message.StatusCode == System.Net.HttpStatusCode.OK) {
            string jsonMessage = await message.Content.ReadAsStringAsync();
            return JsonSerializer.Deserialize<Candidate>(jsonMessage);
        } else if(message.StatusCode == System.Net.HttpStatusCode.NotFound) {
            return null;
        } else {
            throw new Exception();
        }
    }
}