using System;

namespace eCinema.Model.Responses
{
    public class ActorResponse
    {
        public int Id { get; set; }
        public string FirstName { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public DateTime? DateOfBirth { get; set; }
        public string? Biography { get; set; }
        public byte[]? Image { get; set; }
        public bool IsDeleted { get; set; }
    }
} 