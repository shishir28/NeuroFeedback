using Microsoft.Azure.Functions.Extensions.DependencyInjection;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using NeuroFeedbackApp.Function.MessageGateway.Services;

[assembly: FunctionsStartup(typeof(NeuroFeedbackApp.Function.MessageGateway.Startup))]
namespace NeuroFeedbackApp.Function.MessageGateway
{
    public class Startup : FunctionsStartup
    {
        public override void Configure(IFunctionsHostBuilder builder)
        {
            var config = new ConfigurationBuilder()
              .AddJsonFile("local.settings.json", optional: true, reloadOnChange: true)
              .AddEnvironmentVariables()
              .Build();

            //var storageAccounConnectionString = Environment.GetEnvironmentVariable("StorageConnectionString");

            //var storageAccountContext = new StorageAccountContext(storageAccounConnectionString);
            builder.Services.AddTransient<IMessageDataService, MessageDataService>();
            builder.Services.AddSingleton<ILoggerFactory, LoggerFactory>();
            //builder.Services.AddLogging(x => x.AddProvider(this.GetLoggingProvider()));
        }
       
    }
}
