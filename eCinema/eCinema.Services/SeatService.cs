using eCinema.Model;
using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;
using eCinema.Services.Database;
using eCinema.Services;
using eCinema.Services.Database.Entities;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MapsterMapper;

namespace eCinema.Services
{
    public class SeatService : BaseCRUDService<SeatResponse, SeatSearchObject, Database.Entities.Seat, SeatInsertRequest, SeatUpdateRequest>, ISeatService
    {
        public SeatService(eCinemaDBContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
} 