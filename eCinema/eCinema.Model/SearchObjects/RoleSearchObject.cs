using System;
using System.Collections.Generic;
using System.Text;

namespace eCinema.Model.SearchObjects
{
    public class RoleSearchObject : BaseSearchObject
    {
        public string? Name { get; set; }
        public bool? IsActive { get; set; }
    }
} 