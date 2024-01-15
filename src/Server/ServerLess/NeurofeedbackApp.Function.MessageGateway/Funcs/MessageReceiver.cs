using System;
using System.Threading.Tasks;
using Azure.Messaging.EventHubs;
using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;

namespace NeurofeedbackApp.Function.MessageGateway.Funcs
{
    // temporary place holder class 
    public class MessageReceiver
    {
        [FunctionName("MessageReceiver")]
        public async Task Run([EventHubTrigger("EventHubName", Connection = "ConsumerConnectionStrings")] EventData[] events, ILogger log)
        {
            try
            {
                foreach (var message in events)
                {
                    log.LogInformation($"C# Event Hub trigger function processed a message: {message.EventBody}");
                }
            }
            catch (Exception ex)
            {
                log.LogError(ex, "Error In MessageReceiver");
            }
        }
    }
}
