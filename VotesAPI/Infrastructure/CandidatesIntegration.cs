using System.Net.Http;
using Microsoft.Extensions.Options;

namespace VotesAPI.Infrastructure;

public class CandidatesIntegration {

    private readonly IOptions<IntegrationsSettings> integrations;
    private readonly IHttpClientFactory httpClientFactory;

    public CandidatesIntegration(   IOptions<IntegrationsSettings> integrations,
                                    IHttpClientFactory httpClientFactory){
        this.httpClientFactory = httpClientFactory;
        this.integrations = integrations;
    }

    public async Task<bool> ValidateCandidate(int number){
        HttpClient client = httpClientFactory.CreateClient("HttpClient");
        var address = integrations.Value.CandidateAddress + number.ToString();
        HttpResponseMessage message = await client.GetAsync(address);
        return message.IsSuccessStatusCode;
    }

}