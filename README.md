
Full-stack project for the Software Development II course @ FIT. Includes a Flutter mobile app, a desktop admin app, and a .NET backend with RabbitMQ for messaging and Stripe for payments.

## Table of Contents
- [Project Overview](#project-overview)
- [Tech Stack](#tech-stack)
- [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Backend Setup](#backend-setup)
  - [Desktop App Setup](#desktop-app-setup)
  - [Mobile App Setup](#mobile-app-setup)
- [Credentials](#credentials)
- [Notes & Behaviors](#notes--behaviors)
- [Payments (Stripe Test)](#payments-stripe-test)
- [Messaging (RabbitMQ)](#messaging-rabbitmq)
- [Movie Recommendation System](#movie-recommendation-system)
- [UI Flows (Screenshots)](#ui-flows-screenshots)

## Project Overview
eCinema is a platform designed for users to browse movies, reserve tickets, and leave reviews. Staff and administrators use it to manage content and operations. It features authentication, role-based access, payments, messaging, and a movie recommendation system.

## Tech Stack
- Mobile: Flutter (Dart)
- Desktop: .NET (Windows)
- Backend: .NET, Docker, SQL Server, Entity Framework Core, RabbitMQ, Movie Recommender System
- Payments: Stripe (test mode)

## Features
### User Features (Mobile App)
- Browse and search for movies and screenings
- Reserve and purchase tickets for screenings
- Leave reviews for watched movies
- View past reservations
- Manage user profile
- Get random movie suggestions
- Get personalized movie recommendations on the home screen

### Staff Features (Mobile App)
- Scan QR codes to mark tickets as used

### Administrator Features (Desktop App)
- Full CRUD operations for movies, genres, halls, users, roles, and other entities
- Create and manage staff accounts
- Manage screenings and promotions
- View and download reports

### General UI Features
- Supports dark and light themes
- Includes localization for Bosnian and English

## Getting Started

### Prerequisites
- Docker and Docker Compose
- Android Emulator (or device) for the mobile app
- Windows environment for the desktop app

### Backend Setup
1. Ensure Docker and Docker Compose are installed.
2. Open a terminal in `rs2/eCinema`.
3. Start services (backend API, SQL Server database, and RabbitMQ): 
   - `docker-compose up --build`
4. Wait until the backend and dependencies are healthy. The database will be automatically migrated on startup.

### Desktop App Setup
1. Extract the archive: `fit-build-2025-09-28-desktop.zip`.
2. Open the `Release` folder.
3. Run `ecinema_desktop.exe`.
4. Log in with the admin credentials listed below.

### Mobile App Setup
1. Uninstall any existing eCinema app from your Android emulator/device.
2. Extract the archive: `fit-build-2025-10-08-mobile.zip`.
3. Locate the APK in `flutter-apk/`.
4. Drag the APK onto the emulator to install (or use `adb install <apk>`).
5. Log in with a test user (see Credentials).

## Credentials
### Administrator (Desktop)
- username: admin
- password: stringst

### Mobile App Users
- User 1
  - username: user1
  - password: stringst
- User 2
  - username: user2
  - password: stringst
- Staff
  - username: staff
  - password: stringst

## Notes & Behaviors
- Staff Registration
  - Staff users cannot self-register. An administrator creates staff accounts using the desktop app; the staff user then receives an email with login credentials.
- Navigation & Back Behavior
  - The global Back button is context-aware: primary screens (Dashboard, Movies, Screenings, etc.) use navigation, while detail/forms support step-back behavior.
- Reviews
  - Users can only review movies they have actually watched. A QR code tied to their reservation must be scanned to mark the ticket as used. After watching, the app shows a bottom sheet prompting a review only if the reservation is marked as used.
- Screenings List Default Filter
  - The “From” date filter defaults to the current date, showing screenings today and in the future. Past dates are excluded.

## Payments (Stripe Test)
For testing Stripe payments:
- Card number: 4242 4242 4242 4242
- Expiry date: any future date
- CVC: any 3 digits
- ZIP: any 5 digits

## Messaging (RabbitMQ)
RabbitMQ is used to send emails:
- During mobile user registration (welcome message).
- When an admin creates a new staff user (username + temporary password are emailed).

## Movie Recommendation System
The backend includes a movie recommendation system implemented using ML.NET, specifically within the `RecommenderService.cs`. This system provides personalized movie suggestions to users based on their interaction history.

Here's how it works:
- **For new users (no prior reviews):** The system recommends top-rated movies that are not marked as 'Coming Soon' or 'Deleted'.
- **For existing users (with reviews):** The system builds a profile based on movies the user has already reviewed. It then uses a content-based recommendation approach, calculating cosine similarity between the user's profile (based on text features like title, description, director, genres, and actors of rated movies) and candidate movies. Movies with higher similarity scores are recommended.

## UI Flows (Screenshots)
Below are some guided flows showcasing the UI

### Admin (Desktop)
<details>
<summary>Admin (Desktop) Screenshots</summary>

  ![Dashboard Overview](UI/screenshots/dashboard.png) ![Dashboard with Menu](UI/screenshots/dashboard-2.png) ![Reports Overview](UI/screenshots/reports-1.png) ![Ticket Sales and Revenue](UI/screenshots/reports-2.png) ![Screening Attendance](UI/screenshots/reports-3.png)

  ![Movies List](UI/screenshots/movies.png) ![Screenings List](UI/screenshots/screenings.png) ![Edit Screening Details](UI/screenshots/screening-details-1.png) ![Edit Screening Seat Layout](UI/screenshots/screening-details-2.png) ![Settings Page Top](UI/screenshots/settings-1.png) ![Settings Page Scrolled](UI/screenshots/settings-2.png)

</details>

### Staff (Mobile)
  <details>
  <summary>Scan Ticket Flow</summary>

  ![Initial Scan Screen](UI/screenshots/staff_1.png)
  ![Successful Scan](UI/screenshots/staff_valid.png)
  ![Ticket Already Used Error](UI/screenshots/staff_used.png)
  ![Invalid Ticket Error](UI/screenshots/staff_.png)
  </details>

### User (Mobile)
  <details>
  <summary>Reserve Screening Flow</summary>

  1.  **Home screen**
    
      ![Home screen](UI/screenshots/reservation-1.png)
  2.  **Select movie**
      
      ![Select movie](UI/screenshots/reservation-2.png)
  3.  **Select screening**
       
       ![Select screening (Top View)](UI/screenshots/reservation-3.1.png) ![Select screening (Scrolled View)](UI/screenshots/reservation-3.2.png)
   4.  **Seating selection and reservation details**
       
       ![Seating selection (Top View)](UI/screenshots/reservation-4.1.png) ![Seating selection (Scrolled View)](UI/screenshots/reservation-4.2.png)
   5.  **Payment**
       
       ![Payment (Top View)](UI/screenshots/reservation-5.1.png) ![Payment (Scrolled View)](UI/screenshots/reservation-5.2.png)
  6.  **Reservation Confirmation**
      
      ![Confirmation](UI/screenshots/reservation-6.png)
  </details>
  <details>
  <summary>Post-Viewing Review Flow</summary>

  ![Post-Viewing Review](UI/screenshots/review.png)
  </details>
  <details>
  <summary>Random Movie Suggestion Flow</summary>

  This flow demonstrates how users can get a random movie suggestion based on selected filters:
  
 ![Home Screen](UI/screenshots/reservation-1.png) ![Filter Options](UI/screenshots/random-1.png) ![Suggested Movie](UI/screenshots/random-2.png)
  </details>