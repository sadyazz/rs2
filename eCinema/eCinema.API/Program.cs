using eCinema.Services;
using eCinema.Services.Database;
using Microsoft.EntityFrameworkCore;
using Mapster;
using MapsterMapper;
using Microsoft.AspNetCore.Authentication;
using eCinema.API.Filters;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection") 
    ?? throw new InvalidOperationException("Connection string 'DefaultConnection' not found.");
builder.Services.AddeCinemaDbContext(connectionString);

builder.Services.AddAuthentication("BasicAuthentication")
    .AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);

builder.Services.AddControllers(); 
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.AddSecurityDefinition("BasicAuthentication", new OpenApiSecurityScheme
    {
        Name = "Authorization",
        Type = SecuritySchemeType.Http,
        Scheme = "basic",
        In = ParameterLocation.Header,
        Description = "Basic Authorization header using the Bearer scheme."
    });
    c.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme { Reference = new OpenApiReference { Type = ReferenceType.SecurityScheme, Id = "BasicAuthentication" } },
            new string[] { }
        }
    });
});

builder.Services.AddTransient<ISeatService, SeatService>();
builder.Services.AddTransient<ISeatTypeService, SeatTypeService>();
builder.Services.AddTransient<IRoleService, RoleService>();
builder.Services.AddTransient<IActorService, ActorService>();
builder.Services.AddTransient<IGenreService, GenreService>();
builder.Services.AddTransient<IHallService, HallService>();
builder.Services.AddTransient<IScreeningService, ScreeningService>();
builder.Services.AddTransient<IScreeningFormatService, ScreeningFormatService>();
builder.Services.AddTransient<IMovieService, MovieService>();
builder.Services.AddTransient<INewsArticleService, NewsArticleService>();
builder.Services.AddTransient<IPaymentService, PaymentService>();
builder.Services.AddTransient<IPromotionService, PromotionService>();
builder.Services.AddTransient<IUserService, UserService>();
builder.Services.AddTransient<IReservationService, ReservationService>();

builder.Services.AddMapster();


var app = builder.Build();

using (var scope = app.Services.CreateScope())
{
    var services = scope.ServiceProvider;
    var dbContext = services.GetRequiredService<eCinemaDBContext>();
    dbContext.Database.EnsureCreated();
}

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();
app.Run();