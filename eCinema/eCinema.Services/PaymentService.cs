using eCinema.Model;
using eCinema.Model.Requests;
using eCinema.Model.Responses;
using eCinema.Model.SearchObjects;
using eCinema.Services.Database;
using eCinema.Services.Database.Entities;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MapsterMapper;

namespace eCinema.Services
{
    public class PaymentService : BaseCRUDService<PaymentResponse, PaymentSearchObject, Payment, PaymentUpsertRequest, PaymentUpsertRequest>, IPaymentService
    {
        private readonly eCinemaDBContext _context;
        public PaymentService(eCinemaDBContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
        }

        protected override IQueryable<Payment> ApplyFilter(IQueryable<Payment> query, PaymentSearchObject search)
        {
            query = base.ApplyFilter(query, search);
            
            if (search.MinAmount.HasValue)
            {
                query = query.Where(x => x.Amount >= search.MinAmount.Value);
            }

            if (search.MaxAmount.HasValue)
            {
                query = query.Where(x => x.Amount <= search.MaxAmount.Value);
            }

            if (search.FromPaymentDate.HasValue)
            {
                query = query.Where(x => x.PaymentDate >= search.FromPaymentDate.Value);
            }

            if (search.ToPaymentDate.HasValue)
            {
                query = query.Where(x => x.PaymentDate <= search.ToPaymentDate.Value);
            }

            if (!string.IsNullOrWhiteSpace(search.PaymentMethod))
            {
                query = query.Where(x => x.PaymentMethod == search.PaymentMethod);
            }

            if (!string.IsNullOrWhiteSpace(search.Status))
            {
                query = query.Where(x => x.Status == search.Status);
            }

            if (search.ReservationId.HasValue)
            {
                query = query.Where(x => x.ReservationId == search.ReservationId.Value);
            }

            return query;
        }
    }
} 