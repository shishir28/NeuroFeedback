using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using NeuroFeedbackApp.Function.MessageGateway.Services;
using System;
using System.Web.Http;

namespace NeuroFeedbackApp.Function.MessageGateway.Funcs
{
    public class MessageHandler
    {
        private readonly IMessageDataService _messageDataService;
        private readonly ILogger<MessageHandler> _log;
        public MessageHandler(IMessageDataService messageDataService, ILogger<MessageHandler> log)
        {
            _messageDataService = messageDataService;
            _log = log;
        }


        [FunctionName("MessageHandler")]
        public async Task<IActionResult> Run([HttpTrigger(AuthorizationLevel.Function, "post", Route = "readings")] HttpRequest req)
        {
            this._log.LogInformation("C# HTTP trigger function processed a request.");
            try
            {
                string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
                await _messageDataService.ProduceMessageToEventHub(requestBody);
                return new OkObjectResult($"Request saved");
            }
            catch (Exception ex)
            {
                _log.LogError(ex, $"PostMessage Exception raised: {ex.Message}");
                var customException = new Exception("Something went Wrong");
                return new ExceptionResult(customException, true);
            }
        }
    }
}
