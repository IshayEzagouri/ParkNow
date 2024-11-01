# ParkNow

ParkNow is a complete solution for managing parking lots with smart, automated controls powered by Arduino components and a modern web interface. The system integrates hardware such as cameras and gates with real-time data to offer a seamless parking experience for users and administrators.## Table of Contents

1. [Features](#features)
2. [Hardware Components](#hardware-components)
3. [Technology Stack](#technology-stack)
4. [Installation](#installation)
5. [Frontend Overview](#frontend-overview)
6. [Backend Overview](#backend-overview)
7. [Environment Variables](#environment-variables)
8. [Routes and Components](#routes-and-components)
9. [Subscription Plans](#subscription-plans)
10. [Test Account for Demonstration](#Test-Account-for-Demonstration)

## Features

- **Multi-City Parking Management**: Manage parking lots across different cities.
- **Hardware Integration**: Arduino-based system managing slots, gates, cameras.
- **Smart Reservation System**: Reserve slots up to 24 hours or park for up to 6 hours without a reservation.
- **Violation Detection**: Detects parking violations when trying to park in reserved spots.
- **Occupancy Updates**: Real-time updates on parking lot occupancy using cameras and gates.
- **License Plate Recognition**: Cameras capture car registration numbers and match them with the database.
- **Web-based Admin Dashboard**: Admins can manage parking lots, monitor faults, track income, and more.
- **Subscription-based System**: Different subscription tiers for users.
- **Notifications**: Real-time notifications via socket.io for admins and users.

## Hardware Components

- **Arduino**: Controls gates and monitors parking slots.
- **Cameras**: Installed at each gate and slot for license plate recognition.
- **Gates**: Open or close based on reservation and parking availability.
- **Slots**: Monitored to track availability.
- **Sensors**: Used to detect car entry and exit, updating slot occupancy in real time.

## Technology Stack

- **Frontend**: React.js, NextUI, Socket.io
- **Backend**: Node.js, Express, Prisma ORM
- **Database**: PostgreSQL
- **Authentication**: Passport.js (Local and Google OAuth), JWT with HTTP cookies, bcrypt for password hashing
- **Security**: XSS protection (xss npm), SQL injection protection (Prisma), Zod for validation, CORS, Rate limiting against brute force attacks
- **Payment**: Stripe for handling subscriptions and payments
- **Real-time Updates**: Socket.io for notifications and parking lot occupancy updates

## Installation

### Prerequisites

- Node.js
- PostgreSQL
- Arduino hardware setup
- Stripe account for payments

### Backend

1. Clone the repository.

   git clone

   ```bash
   cd ParkNow/backend

   ```

2. Install dependencies

   ```bash
   npm install

   ```

3. Set up PostgreSQL database and update .env file with database credentials.

4. Run SetupTrigger.js

   ```bash
   node Path_TO/db-postgres/setupTrigger.js

   ```

5. Run migrations.

   ```bash
   npx prisma migrate dev

   ```

6. Start the backend server.
   ```bash
   npm run dev
   ```

### Backend

1. Navigate to the frontend directory.

   ```bash
   cd ../frontend

   ```

2.Install dependencies.

    npm install

3. Update the .env file with your environment variables (see below).

4.Start the frontend server.

    npm run dev

## Frontend Overview

The frontend is built with React.js and NextUI for the design system, with the following main features:

- Booking System: Users can reserve parking slots in their chosen city.
- User Dashboard: Users can manage their cars and account details.
- Stripe Integration: For payment and subscription management.
- Socket.io Notifications: Users get real-time updates about parking availability and violations.
- Google and Local Login: Secure login with Google OAuth or via email/password.

## Key Routes and Components

- /login: User authentication with Google or email/password.
- /signup: User registration.
- /UserDashboard: Manage reservations, cars, and account settings.
- /AdminDashboard: Admin controls for managing parking lots,
- monitoring faults, sending notifications, and viewing analytics.

## Backend Overview

The backend is built with **Node.js** and **Express**, using **Prisma ORM** for database interactions, and **Socket.io** for real-time communication.

- **Authentication**: Passport.js with JWT and Google OAuth.
- **Subscription Management**: Stripe integration for handling user payments and subscription plans.
- **Real-time Occupancy Tracking**: Updates on parking lot occupancy are sent via Socket.io.
- **Notifications**: Admins can send notifications to users or broadcast updates.

## Environment Variables

You need to set the following environment variables:

### Frontend

    VITE_API_URL=http://localhost:3001/api
    VITE_GOOGLE_CLIENT_ID=YOUR_GOOGLE_CLIENT_ID
    VITE_STRIPE_PUBLISHABLE_KEY=YOUR_STRIPE_PUBLISHABLE_KEY
    VITE_CALLBACK_URL=http://localhost:3001/api/users/google/callback

### Backend

    DB_USER=postgres
    DB_HOST=localhost
    DB_DATABASE=ParkingLot_DB
    DB_PASSWORD=yourpassword
    DB_PORT=5432
    PORT=3001
    STRIPE_SECRET_KEY=YOUR_STRIPE_SECRET_KEY
    JWT_SECRET=your_jwt_secret
    GOOGLE_CLIENT_ID=YOUR_GOOGLE_CLIENT_ID
    GOOGLE_CLIENT_SECRET=YOUR_GOOGLE_CLIENT_SECRET

## Subscription Plans

We offer three subscription tiers for users:

- **Single**: $50/year, 1 car allowed, 2 active reservations
- **Family**: $100/year, 2 cars allowed, 6 active reservations
- **Enterprise**: $500/year, 15 cars allowed, 10 active reservations, 24/7 support, enterprise-level access

## Admin Dashboard

The admin dashboard provides an overview of parking lot data and allows for CRUD operations on parking lots, gates, and slots. It includes features like:

- **Occupancy Monitoring**: Real-time updates on slot occupancy.
- **Fault Monitoring**: View and track hardware faults.
- **Notifications**: Send notifications to users and monitor recent logs.
- **Income Reports**: View total income from subscription plans.
- **User Management**: Manage users, view recent sign-ups and parking activity.

## Users Dashboard

sers have access to three main sections:

- **Book**: Reserve a parking spot in any available city.
- **Cars**: Manage their cars (add, edit, delete).
- **Account Settings**: Update personal details, change password, manage subscription.

**Note**: The system also utilizes **cron jobs** to manage periodic tasks such as:

- Checking for expired subscriptions.
- Deleting old reservations.

## Test Account for Demonstration

For testing purposes, a user account with both user and admin privileges is available:

-**Email**: ishay7@gmail.com -**Password**: asdasd
