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
    public class SeatTypeController : BaseCRUDController<SeatTypeResponse, SeatTypeSearchObject, SeatTypeUpsertRequest, SeatTypeUpsertRequest>
    {

        public SeatTypeController(ISeatTypeService seatTypeService) : base(seatTypeService)
        {
        }

    }
} 