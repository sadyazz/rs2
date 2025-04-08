using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using eCinema.Services.Database.Entities;
using System;
using System.Linq;

namespace eCinema.Services.Database
{
    public static class DatabaseConfiguration
    {
        public static IServiceCollection AddeCinemaDbContext(this IServiceCollection services, string connectionString)
        {
            services.AddDbContext<eCinemaDBContext>(options =>
                options.UseSqlServer(connectionString));

            return services;
        }
        
        public static void SeedDatabase(eCinemaDBContext context)
        {
            // Only seed the database if there are no users
            // if (!context.Users.Any())
            // {
            //     // Create admin role if it doesn't exist
            //     var adminRole = context.Roles.FirstOrDefault(r => r.Name == "Admin");
            //     if (adminRole == null)
            //     {
            //         adminRole = new Role
            //         {
            //             Name = "Admin",
            //             Description = "Administrator with full access to all features"
            //         };
            //         context.Roles.Add(adminRole);
            //         context.SaveChanges();
            //     }
                
            //     // Create user role if it doesn't exist
            //     var userRole = context.Roles.FirstOrDefault(r => r.Name == "User");
            //     if (userRole == null)
            //     {
            //         userRole = new Role
            //         {
            //             Name = "User",
            //             Description = "Regular user with basic access"
            //         };
            //         context.Roles.Add(userRole);
            //         context.SaveChanges();
            //     }
                
            //     // Create admin user with Admin role
            //     var adminUser = new User
            //     {
            //         FirstName = "Admin",
            //         LastName = "User",
            //         Username = "admin",
            //         Email = "admin@ecinema.com",
            //         PasswordHash = HashPassword("admin123", "adminsalt"),
            //         PasswordSalt = "adminsalt",
            //         Active = true,
            //         CreatedAt = DateTime.UtcNow,
            //         RoleId = adminRole.Id
            //     };
            //     context.Users.Add(adminUser);
                
            //     // Create a regular user with User role
            //     var regularUser = new User
            //     {
            //         FirstName = "Regular",
            //         LastName = "User",
            //         Username = "user",
            //         Email = "user@ecinema.com",
            //         PasswordHash = HashPassword("user123", "usersalt"),
            //         PasswordSalt = "usersalt",
            //         Active = true,
            //         CreatedAt = DateTime.UtcNow,
            //         RoleId = userRole.Id
            //     };
            //     context.Users.Add(regularUser);
                
            //     context.SaveChanges();
            // }
        }
        
        private static string HashPassword(string password, string salt)
        {
            // In a real application, use a proper password hashing algorithm like BCrypt
            // This is just a simple example and is NOT secure for production use
            return Convert.ToBase64String(
                System.Security.Cryptography.SHA256.Create()
                    .ComputeHash(System.Text.Encoding.UTF8.GetBytes(password + salt))
            );
        }
    }
} 