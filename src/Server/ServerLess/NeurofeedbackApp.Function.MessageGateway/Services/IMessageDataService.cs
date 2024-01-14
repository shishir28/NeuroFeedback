using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NeuroFeedbackApp.Function.MessageGateway.Services
{
    public interface IMessageDataService
    {
        Task<string> SaveRawData(string partnerName, dynamic messageBody);
    }

    public class MessageDataService : IMessageDataService
    {
        public Task<string> SaveRawData(string partnerName, dynamic messageBody)
        {
            throw new NotImplementedException();
        }
    }
}
