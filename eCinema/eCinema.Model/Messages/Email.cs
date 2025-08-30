namespace eCinema.Model.Messages
{
    public class Email
    {
        public string To { get; set; }
        public string Subject { get; set; }
        public string Body { get; set; }
        public EmailType Type { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
    }
}
