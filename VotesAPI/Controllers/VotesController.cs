using Microsoft.AspNetCore.Mvc;

namespace VotesAPI.Controllers;

[ApiController]
[Route("api/votes")]
public class VotesController : ControllerBase
{
    private readonly ILogger<VotesController> _logger;

    public VotesController(ILogger<VotesController> logger)
    {
        _logger = logger;
    }

    [HttpPost]
    public ActionResult Create()
    {
        return Ok();
    }
}
