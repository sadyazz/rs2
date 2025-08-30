using eCinema.Model.Messages;

namespace eCinema.Subscriber
{
    public class EmailDTO
    {
        public string EmailTo { get; set; }
        public string ReceiverName { get; set; }
        public string Subject { get; set; }
        public string Message { get; set; }
        public EmailType Type { get; set; }
    }
}