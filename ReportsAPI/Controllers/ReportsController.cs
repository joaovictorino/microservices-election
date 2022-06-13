using Microsoft.AspNetCore.Mvc;
using ReportsAPI.Models;
using ReportsAPI.Infrastructure;

namespace ReportsAPI.Controllers;

[ApiController]
[Route("reports")]
public class ReportsController : ControllerBase
{

    private readonly VotesRepository repository;
    private readonly ILogger<ReportsController> logger;

    public ReportsController(VotesRepository repository, ILogger<ReportsController> logger)
    {
        this.repository = repository;
        this.logger = logger;
    }

    [HttpGet()]
    public IEnumerable<Vote> Get()
    {
        return this.repository.GetAll();
    }
}
