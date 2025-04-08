using eCinema.Model;
using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace eCinema.Services;

public interface ISeatTypeService : ICRUDService<SeatTypeResponse, SeatTypeSearchObject, SeatTypeUpsertRequest, SeatTypeUpsertRequest>
{
   
} 