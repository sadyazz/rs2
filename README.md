
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
- Backend: .NET, Docker, SQL Server, EF Core, RabbitMQ
- Recommender: ML.NET (content-based, cosine similarity)
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

<div align="center">
  <img src="UI/screenshots/dashboard.png" alt="Dashboard Overview" width="400px"> <img src="UI/screenshots/dashboard-2.png" alt="Dashboard with Menu" width="400px"> <img src="UI/screenshots/reports-1.png" alt="Reports Overview" width="400px"> <img src="UI/screenshots/reports-2.png" alt="Ticket Sales and Revenue" width="400px"> <img src="UI/screenshots/reports-3.png" alt="Screening Attendance" width="400px">

  <img src="UI/screenshots/movies.png" alt="Movies List" width="400px"> <img src="UI/screenshots/screenings.png" alt="Screenings List" width="400px"> <img src="UI/screenshots/screening-details-1.png" alt="Edit Screening Details" width="400px"> <img src="UI/screenshots/screening-details-2.png" alt="Edit Screening Seat Layout" width="400px"> <img src="UI/screenshots/settings-1.png" alt="Settings Page Top" width="400px"> <img src="UI/screenshots/settings-2.png" alt="Settings Page Scrolled" width="400px">

</div>
</details>

### Staff (Mobile)
  <details>
  <summary>Scan Ticket Flow</summary>

<p align="center">
  <img src="UI/screenshots/staff_1.png" alt="Initial Scan Screen" width="200px">
  <img src="UI/screenshots/staff_valid.png" alt="Successful Scan" width="200px">
  <img src="UI/screenshots/staff_used.png" alt="Ticket Already Used Error" width="200px">
  <img src="UI/screenshots/staff_.png" alt="Invalid Ticket Error" width="200px">
  </p>
  </details>

### User (Mobile)
  <details>
  <summary>Reserve Screening Flow</summary>

  <table border="0" align="center">
    <tr>
      <td align="center">
        Home screen<br>
        <img src="UI/screenshots/reservation-1.png" alt="Home screen" width="200px">
      </td>
      <td align="center">
        Select movie<br>
        <img src="UI/screenshots/reservation-2.png" alt="Select movie" width="200px">
      </td>
      <td align="center">
        Select screening<br>
        <img src="UI/screenshots/reservation-3.1.png" alt="Select screening (Top View)" width="200px">
      </td>
      <td align="center">
        Select screening<br>
        <img src="UI/screenshots/reservation-3.2.png" alt="Select screening (Scrolled View)" width="200px">
      </td>
    </tr>
    <tr>
      <td align="center">
        Seating selection<br>
        <img src="UI/screenshots/reservation-4.1.png" alt="Seating selection (Top View)" width="200px">
      </td>
      <td align="center">
        Seating selection<br>
        <img src="UI/screenshots/reservation-4.2.png" alt="Seating selection (Scrolled View)" width="200px">
      </td>
      <td align="center">
        Payment<br>
        <img src="UI/screenshots/reservation-5.1.png" alt="Payment (Top View)" width="200px">
      </td>
      <td align="center">
        Payment<br>
        <img src="UI/screenshots/reservation-5.2.png" alt="Payment (Scrolled View)" width="200px">
      </td>
    </tr>
    <tr>
      <td align="center" colspan="4">
        Reservation Confirmation<br>
        <img src="UI/screenshots/reservation-6.png" alt="Confirmation" width="200px">
      </td>
    </tr>
  </table>

  </details>
  <details>
  <summary>Post-Viewing Review Flow</summary>

<div align="center">
  <img src="UI/screenshots/review.png" alt="Post-Viewing Review" width="200px">
  </div>
  </details>
  <details>
  <summary>Random Movie Suggestion Flow</summary>

  This flow demonstrates how users can get a random movie suggestion based on selected filters:
  
  <div align="center">
  <img src="UI/screenshots/reservation-1.png" alt="Home Screen" width="200px"> <img src="UI/screenshots/random-1.png" alt="Filter Options" width="200px"> <img src="UI/screenshots/random-2.png" alt="Suggested Movie" width="200px">
  </div>
  </details>