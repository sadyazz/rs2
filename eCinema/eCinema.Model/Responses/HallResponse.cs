using System;

namespace eCinema.Model.Responses
{
    public class HallResponse
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public int Capacity { get; set; } = 48;
        public bool IsDeleted { get; set; }
    }
} 