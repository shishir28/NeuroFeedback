using NeurofeedbackApp.Commons.EventMessaging.EventHubs;
using NeurofeedbackApp.Commons.Models;
using Newtonsoft.Json;
using System;
using System.Threading.Tasks;

namespace NeuroFeedbackApp.Function.MessageGateway.Services
{
    public interface IMessageDataService
    {
        Task ProduceMessageToEventHub(string messageBody);
    }

    public class MessageDataService : IMessageDataService
    {
        private readonly Producer _eventProducer;
        public MessageDataService()
        {
            _eventProducer = new Producer();
            var connectionString = Environment.GetEnvironmentVariable("PublisherConnectionStrings");
            var eventHubName = Environment.GetEnvironmentVariable("EventHubName");
            _eventProducer.Init(connectionString, eventHubName);
        }

        public async Task ProduceMessageToEventHub(string messageBody)
        {
            var recording = JsonConvert.DeserializeObject<EEGRecording>(messageBody);
            await _eventProducer.PublishAsync<EEGRecording>(recording);
        }
    }
}