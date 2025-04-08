using eCinema.Model;
using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;
using eCinema.Services;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace eCinema.API.Controllers
{
    public class SeatController : BaseCRUDController<SeatResponse, SeatSearchObject, SeatInsertRequest, SeatUpdateRequest>
    {

        public SeatController(ISeatService service) : base(service)
        {
        }
    }
} 