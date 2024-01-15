using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace NeurofeedbackApp.Commons.Models
{
    public enum EEGFrequency
    {
        All,
        Theta,
        Alpha,
        Beta,
        Gamma
    }

    public record EEGReading(
     [property: JsonProperty("channel")] string Channel,
        [property: JsonProperty("value")] double Value
);

    public struct EEGChannel : IEquatable<EEGChannel>, IEquatable<string>
    {
        public string RawValue { get; }

        // In-built channel in Muse
        public static EEGChannel Af7 { get; } = new EEGChannel("AF7");
        public static EEGChannel Af8 { get; } = new EEGChannel("AF8");
        public static EEGChannel Fpz { get; } = new EEGChannel("FPZ");
        public static EEGChannel T9 { get; } = new EEGChannel("T9");
        public static EEGChannel T10 { get; } = new EEGChannel("T10");

        // Additional possible channels for external sensors
        public static EEGChannel Cz { get; } = new EEGChannel("CZ");
        public static EEGChannel Fz { get; } = new EEGChannel("FZ");
        public static EEGChannel F3 { get; } = new EEGChannel("F3");
        public static EEGChannel F4 { get; } = new EEGChannel("F4");
        public static EEGChannel O1 { get; } = new EEGChannel("O1");

        private EEGChannel(string rawValue)
        {
            RawValue = rawValue;
        }

        public bool Equals(EEGChannel other)
        {
            return RawValue == other.RawValue;
        }

        public bool Equals(string other)
        {
            return RawValue == other;
        }

        public override bool Equals(object obj)
        {
            return obj is EEGChannel channel && Equals(channel);
        }

        public override int GetHashCode()
        {
            return RawValue.GetHashCode();
        }

        public static bool operator ==(EEGChannel left, EEGChannel right)
        {
            return left.Equals(right);
        }

        public static bool operator !=(EEGChannel left, EEGChannel right)
        {
            return !(left == right);
        }
    }

    // Could not use record to string to EEGFrequency 
    // come back to it later
    public class EEGFrequencyReadings
    {
        [JsonProperty("readings")]
        public List<EEGReading> Readings { get; set; }

        [JsonProperty("frequency")]
        [JsonConverter(typeof(StringEnumConverter))]
        public EEGFrequency EEGFrequency { get; set; }
    }

    public record EEGRecording(
        [property: JsonProperty("sessionId")] string SessionId,
        [property: JsonProperty("data")] IReadOnlyList<EEGFrequencyReadings> Data,
        [property: JsonProperty("userId")] string UserId,
        [property: JsonProperty("baseTime")] double BaseTime
);

}
