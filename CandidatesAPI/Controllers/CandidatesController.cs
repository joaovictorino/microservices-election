using Microsoft.AspNetCore.Mvc;
using CandidatesAPI.Models;

namespace CandidatesAPI.Controllers;

[ApiController]
[Route("api/candidates")]
public class CandidatesController : ControllerBase
{
    private readonly ILogger<CandidatesController> _logger;

    public CandidatesController(ILogger<CandidatesController> logger)
    {
        _logger = logger;
    }

    [HttpGet]
    public IEnumerable<Candidate> Get()
    {
        return new List<Candidate>();
    }

    [HttpPost]
    public ActionResult Create()
    {
        return Ok();
    }
}
