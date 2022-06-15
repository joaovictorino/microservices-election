using System;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Azure.WebJobs.Extensions.Sql;
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
                                [Sql("dbo.Votes", ConnectionStringSetting="SqlConnectionString")] ICollector<Vote> voteAsync)
        {
            Vote vote = JsonSerializer.Deserialize<Vote>(myQueueItem);
            voteAsync.Add(vote);
            
            log.LogInformation($"C# ServiceBus queue trigger function processed message: {myQueueItem}");
        }
    }
}
