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
            VoteMessage message = new VoteMessage();

            if (vote.NumberCandidate.HasValue
                && vote.NumberCandidate.Value != 0){
                Candidate candidate = await integration.FindCandidate(vote);

                if(candidate == null)
                    return NotFound();
                else
                    message.NameCandidate = candidate.Name;
            }

            message.CreatedAt = System.DateTime.Now;
            message.NumberCandidate = vote.NumberCandidate;
            queue.Send(message);
            return Ok();

        } catch(Exception)
        {
            return this.StatusCode(500);
        }
    }
}