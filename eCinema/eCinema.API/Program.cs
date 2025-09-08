using eCinema.Services;
using eCinema.Services.Database;
using eCinema.Services.Auth;
using eCinema.Services.RabbitMQ;
using Microsoft.EntityFrameworkCore;
using Mapster;
using MapsterMapper;
using Microsoft.AspNetCore.Authentication;
using eCinema.API.Filters;
using Microsoft.OpenApi.Models;
using eCinema.Services.ReservationStateMachine;
using DotNetEnv;
using eCinema.Services.Recommender;

Env.Load(@"../.env");

var builder = WebApplication.CreateBuilder(args);

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection") 
    ?? throw new InvalidOperationException("Connection string 'DefaultConnection' not found.");
builder.Services.AddeCinemaDbContext(connectionString);

builder.Services.AddHttpContextAccessor();
builder.Services.AddScoped<ICurrentUserService, CurrentUserService>();

//TEMP
//builder.Services.AddCors(options =>
//{
//    options.AddPolicy("AllowAll", policy =>
//    {
//        policy.AllowAnyOrigin()
//              .AllowAnyMethod()
//              .AllowAnyHeader();
//    });
//});

builder.Services.AddAuthentication("BasicAuthentication")
    .AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);

builder.Services.AddControllers(x=> 
    {
        x.Filters.Add<ExceptionFilter>();
    }); 
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
builder.Services.AddTransient<IRoleService, RoleService>();
builder.Services.AddTransient<IActorService, ActorService>();
builder.Services.AddTransient<IGenreService, GenreService>();
builder.Services.AddTransient<IHallService, HallService>();
builder.Services.AddTransient<IScreeningService, ScreeningService>();
builder.Services.AddTransient<IScreeningFormatService, ScreeningFormatService>();
builder.Services.AddTransient<IMovieService, MovieService>();
builder.Services.AddTransient<INewsArticleService, NewsArticleService>();
var stripeSecretKey = Environment.GetEnvironmentVariable("STRIPE_SECRET_KEY");

builder.Services.AddTransient(sp => new PaymentService(
    stripeSecretKey ?? throw new InvalidOperationException("STRIPE_SECRET_KEY not found in environment variables."),
    sp.GetRequiredService<eCinemaDBContext>()
));
builder.Services.AddTransient<IPromotionService, PromotionService>();
builder.Services.AddTransient<IUserService, UserService>();
builder.Services.AddTransient<IReservationService, ReservationService>();
builder.Services.AddTransient<IReviewService, ReviewService>();
builder.Services.AddTransient<IDashboardService, DashboardService>();
builder.Services.AddTransient<IUserMovieListService, UserMovieListService>();
builder.Services.AddScoped<IRabbitMQService, RabbitMQService>();
builder.Services.AddScoped<IRecommenderService, RecommenderService>();

builder.Services.AddTransient<BaseReservationState>();
builder.Services.AddTransient<InitialReservationState>();
builder.Services.AddTransient<PendingReservationState>();
builder.Services.AddTransient<ApprovedReservationState>();
builder.Services.AddTransient<RejectedReservationState>();
builder.Services.AddTransient<CancelledReservationState>();
builder.Services.AddTransient<ExpiredReservationState>();
builder.Services.AddMapster();


var app = builder.Build();

using (var scope = app.Services.CreateScope())
{
    var datacontext = scope.ServiceProvider.GetRequiredService<eCinemaDBContext>();
    datacontext.Database.Migrate();
}

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
//TEMP
//app.UseCors("AllowAll");
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();
app.Run();