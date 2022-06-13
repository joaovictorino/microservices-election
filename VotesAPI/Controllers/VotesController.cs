using Microsoft.AspNetCore.Mvc;
using VotesAPI.Infrastructure;
using VotesAPI.Models;

namespace VotesAPI.Controllers;

[ApiController]
[Route("api/votes")]
public class VotesController : ControllerBase
{
    private readonly CandidatesIntegration integration;
    private readonly VotesQueue queue;
    private readonly ILogger<VotesController> logger;

    public VotesController( VotesQueue queue,
                            CandidatesIntegration integration,
                            ILogger<VotesController> logger)
    {
        this.queue = queue;
        this.integration = integration;
        this.logger = logger;
    }

    [HttpPost]
    public async Task<ActionResult> Create(Vote vote)
    {
        try {

            if (vote.NumberCandidate.HasValue
                && vote.NumberCandidate.Value != 0){
                if(!await integration.ValidateCandidate(vote)){
                    return NotFound();
                }
            }

            vote.CreatedAt = System.DateTime.Now;
            queue.Send(vote);
            return Ok();

        } catch(Exception)
        {
            return this.StatusCode(500);
        }
    }
}