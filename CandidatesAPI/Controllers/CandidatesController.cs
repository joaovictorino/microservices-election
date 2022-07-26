using MongoDB.Driver;
using Microsoft.AspNetCore.Mvc;
using CandidatesAPI.Models;
using CandidatesAPI.Infrastructure;

namespace CandidatesAPI.Controllers;

[ApiController]
[Route("api/candidates")]
public class CandidatesController : ControllerBase
{
    private readonly ILogger<CandidatesController> logger;
    private readonly CandidatesRepository repository;

    public CandidatesController(CandidatesRepository repository, ILogger<CandidatesController> logger)
    {
        this.repository = repository;
        this.logger = logger;
    }

    [HttpGet]
    public async Task<List<Candidate>> Get() => 
        await repository.GetAllAsync();

    [HttpGet("{number}")]
    public async Task<ActionResult<Candidate>> Get(int number)
    {
        var candidate = await repository.GetAsync(number);

        if (candidate is null)
            return NotFound();

        return Ok(candidate);
    }

    [HttpPost]
    public async Task<ActionResult> Create(Candidate candidate)
    {
        try
        {
            await repository.CreateAsync(candidate);
        }
        catch(MongoWriteException)
        {
            return Conflict();
        }

        return Ok();
    }
}
