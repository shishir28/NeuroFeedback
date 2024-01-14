using System.Text;
using Azure.Messaging.EventHubs;
using Azure.Messaging.EventHubs.Producer;
using Newtonsoft.Json;

namespace NeurofeedbackApp.Commons.EventMessaging.EventHubs
{
    public class Producer
    {
        private EventHubProducerClient _producerClient;

        public void Init(string connectionString, string eventHubName)
        {
            if (string.IsNullOrWhiteSpace(connectionString)) throw new ArgumentNullException(nameof(connectionString));
            _producerClient = new EventHubProducerClient(connectionString, eventHubName);
        }

        public async Task PublishAsync<T>(T myEvent)
        {
            if (myEvent == null) throw new ArgumentNullException(nameof(myEvent));

            using var eventBatch = await _producerClient.CreateBatchAsync();
            // 1.Serialize the event
            var searialzedEvent = JsonConvert.SerializeObject(myEvent);

            // 2.Equals Get encoded bytes
            var eventData = new EventData(Encoding.UTF8.GetBytes(searialzedEvent));

            // 3.Push  it to batch
            eventBatch.TryAdd(eventData);

            // 4 Publish it to bus
            await _producerClient.SendAsync(eventBatch);

        }

        public async Task PublishAsync<T>(IEnumerable<T> myEvents)
        {
            if (myEvents == null) throw new ArgumentNullException(nameof(myEvents));

            using var eventBatch = await _producerClient.CreateBatchAsync();
            foreach (var myEvent in myEvents)
            {
                var searialzedEvent = JsonConvert.SerializeObject(myEvent);
                var eventData = new EventData(Encoding.UTF8.GetBytes(searialzedEvent));
                eventBatch.TryAdd(eventData);
            }
            await _producerClient.SendAsync(eventBatch);
        }
    }
}
