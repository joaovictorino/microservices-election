using Microsoft.AspNetCore.Mvc;
using VotesAPI.Infrastructure;
using VotesAPI.Models;

namespace VotesAPI.Controllers;

[ApiController]
[Route("api/votes")]
public class VotesController : ControllerBase
{
    private readonly VotesRepository repository;
    private readonly CandidatesIntegration integration;
    private readonly ILogger<VotesController> logger;

    public VotesController( VotesRepository repository, 
                            CandidatesIntegration integration,
                            ILogger<VotesController> logger)
    {
        this.repository = repository;
        this.integration = integration;
        this.logger = logger;
    }

    [HttpPost]
    public async Task<ActionResult> Create(Vote vote)
    {
        if (vote.NumberCandidate.HasValue
            && vote.NumberCandidate.Value != 0){
            if(!await integration.ValidateCandidate(vote.NumberCandidate.Value)){
                return NotFound();
            }
        }
        await repository.CreateAsync(vote);
        return Ok();
    }
}
