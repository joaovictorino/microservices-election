using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;
using CountingFunction.Models;
using System.Text.Json;

namespace CountingFunction
{
    public static class CountingTrigger
    {
        [FunctionName("CountingTrigger")]
        public static void Run( [ServiceBusTrigger("votesmq", Connection = "ServiceBusConnection")]string myQueueItem, 
                                ILogger log,
                                [Sql("dbo.Votes", ConnectionStringSetting="SqlConnectionString")] ICollector<Vote> votesCollector)
        {
            Vote vote = JsonSerializer.Deserialize<Vote>(myQueueItem);
            votesCollector.Add(vote);
            log.LogInformation($"C# ServiceBus queue trigger function processed message: {myQueueItem}");
        }
    }
}
