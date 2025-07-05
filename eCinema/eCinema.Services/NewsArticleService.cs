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
    public class NewsArticleService : BaseCRUDService<NewsArticleResponse, NewsArticleSearchObject, NewsArticle, NewsArticleUpsertRequest, NewsArticleUpsertRequest>, INewsArticleService
    {
        private readonly eCinemaDBContext _context;
        public NewsArticleService(eCinemaDBContext context, IMapper mapper) : base(context, mapper)
        {
            _context = context;
        }

        protected override IQueryable<NewsArticle> ApplyFilter(IQueryable<NewsArticle> query, NewsArticleSearchObject search)
        {
            query = base.ApplyFilter(query, search);
            
            if (!string.IsNullOrWhiteSpace(search.Title))
            {
                query = query.Where(x => x.Title.Contains(search.Title));
            }

            if (!string.IsNullOrWhiteSpace(search.Content))
            {
                query = query.Where(x => x.Content.Contains(search.Content));
            }

            if (search.FromPublishDate.HasValue)
            {
                query = query.Where(x => x.PublishDate >= search.FromPublishDate.Value);
            }

            if (search.ToPublishDate.HasValue)
            {
                query = query.Where(x => x.PublishDate <= search.ToPublishDate.Value);
            }

            if (search.AuthorId.HasValue)
            {
                query = query.Where(x => x.AuthorId == search.AuthorId.Value);
            }

            return query;
        }
    }
} 