using System;

namespace eCinema.Model.SearchObjects
{
    public class HallSearchObject : BaseSearchObject
    {
        public string? Name { get; set; }
        public string? Location { get; set; }
        public string? ScreenType { get; set; }
        public string? SoundSystem { get; set; }
        public int? MinCapacity { get; set; }
        public int? MaxCapacity { get; set; }
        public bool IncludeDeleted { get; set; } = false;
    }
} 