using System;

namespace eCinema.Model.Responses
{
    public class HallResponse
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public int Capacity { get; set; }
        public string? ScreenType { get; set; }
        public string? SoundSystem { get; set; }
        public string Location { get; set; } = string.Empty;
        public bool IsActive { get; set; }
        public bool IsDeleted { get; set; }
    }
} 