**ParkNow: Smart Parking System**

ParkNow is a complete solution for managing parking lots with smart, automated controls powered by Arduino components and a modern web interface. The system integrates hardware such as cameras and gates with real-time data to offer a seamless parking experience for users and administrators.

**Table of Contents**

1.  Features
2.  Hardware Components
3.  Technology Stack
4.  Installation
5.  Frontend Overview
6.  Backend Overview
7.  Environment Variables
8.  Routes and Components
9.  Subscription Plans

**Features**

- **Automated Parking Management**: The system automates gate operations, parking slot allocation, and violations using smart hardware components.
- **Multi-lot Support**: Support for multiple cities, each with areas, slots, and gates.
- **Real-time Notifications**: Updates via WebSockets for slot occupancy, user reservations, and parking lot status.
- **Smart Car Recognition**: Cameras attached to gates and slots capture car registration numbers for validation.
- **Reservation System**: Users can reserve spots for up to 24 hours or park without reservations for 6 hours.
- **Admin Dashboard**: Manage parking lots, monitor parking logs, track system faults, and send notifications.
- **User Dashboard**: Book reservations, manage cars, and update account settings.
- **Subscription Tiers**: Multiple subscription plans with integration to Stripe for payment handling and automated renewals.

**Hardware Components**

The smart parking lot is controlled by Arduino components, with the following functionality:

- **Gates and Slots**: Each parking lot area has gates that only open if slots are available. Slots are monitored, and violations are logged if a reserved slot is misused.
- **Cameras**: Cameras capture registration plates at both gates and slots. The system uses Optical Character Recognition (OCR) to convert images to text, matching them with the database for parking validation.
- **Gate Operations**: If a parking lot is full, the gate will not open. When a car enters without a reservation, the system assigns the slot that has been available the longest.

**Hardware Integration**:

- The system updates slot occupancy in real-time, triggering gate operations and notifications based on the availability of slots.
- Data from the Arduino components is fed into the web interface, giving users and admins live insights into the parking lot status.

**Technology Stack**

- **Frontend**:

- React with hooks (useState, useEffect)
- NextUI for UI components
- Axios for API requests
- Socket.io for real-time updates
- Stripe for payment processing
- Framer Motion for animations

- **Backend**:

- Node.js with Express.js
- PostgreSQL with Prisma ORM
- JWT for authentication
- WebSockets (Socket.io) for real-time interactions
- Arduino for hardware control

**Installation**

1.  **Clone the repository**:\
    bash\
    Copy code

    git clone https://github.com/your-repo/park-now.git

2.  cd park-now
3.

4.  **Install dependencies**:\
    bash\
    Copy code

    npm install

5.

6.  **Set up environment variables**:\
    Add the required environment variables in .env files for both the frontend and backend. Refer to Environment Variables for details.
7.  **Run the development servers**:\
    bash\
    Copy code

    # Run backend

8.  npm run dev-backend

9.  # Run frontend
10. npm run dev-frontend
11.

**Frontend Overview**

**Key Components:**

- **HeroSection**: The welcome page displaying user-specific actions.
- **UserDashboard**: Contains sub-sections for booking parking spots, managing cars, and updating account settings.
- **AdminDashboard**: Used by admins to manage parking lots, monitor income and occupancy, and view logs.
- **Subscriptions**: Allows users to choose subscription plans and make payments using Stripe.
- **Notifications**: Real-time notifications via WebSockets.

**Frontend Routing:**

- **Public Routes**:

- /: Landing page
- /login: User login page
- /signup: User registration page
- /subscriptions: View subscription plans

- **User Routes** (Protected):

- /UserDashboard: Manage reservations, cars, and account settings

- **Admin Routes** (Protected):

- /AdminDashboard: Admin functionalities like managing lots, notifications, and system monitoring

**Backend Overview**

The backend is built with Node.js and Express, and connects to a PostgreSQL database via Prisma. It provides APIs for authentication, parking management, notifications, and payment handling. Key backend features:

- **Authentication**: JWT-based authentication, Google OAuth, and secure password handling with bcrypt.
- **WebSockets**: Real-time updates on parking slot availability and notifications.
- **Hardware Integration**: Manages Arduino-triggered operations for gates and slots, updating slot occupancy.
- **Cron Jobs**: Scheduled jobs check for expired subscriptions daily and clean up outdated reservations.

**API Endpoints:**

- **Auth API**:

- POST /api/users/signup: Register a new user
- POST /api/users/login: Log in a user
- GET /api/users/details: Fetch user details

- **Parking API**:

- GET /api/parkinglots: Fetch available parking lots
- POST /api/parking/reservation: Reserve a parking spot
- DELETE /api/parking/reservation: Cancel a reservation

- **Admin API**:

- POST /api/admin/parkinglot: Add a new parking lot
- PUT /api/admin/parkinglot/:id: Update parking lot details
- DELETE /api/admin/parkinglot/:id: Remove a parking lot

**Environment Variables**

**Frontend** (.env):

makefile

Copy code

VITE_API_URL=http://localhost:3001/api

VITE_GOOGLE_CLIENT_ID=<Google_Client_ID>

VITE_STRIPE_TEST_PUBLISHABLE_KEY=<Stripe_Publishable_Key>

**Backend** (.env):

makefile

Copy code

DB_USER=postgres

DB_HOST=localhost

DB_DATABASE=ParkingLot_DB

DB_PASSWORD=<your_password>

DB_PORT=5432

JWT_SECRET=<your_jwt_secret>

STRIPE_SECRET_KEY=<your_stripe_secret_key>

**Routes and Components**

**User Routes:**

- /UserDashboard: Main user dashboard for reservations and account management
- /UserDashboard/Cars: Manage user cars
- /UserDashboard/AccountSettings: Update user account details

**Admin Routes:**

- /AdminDashboard: Admin overview page
- /AdminDashboard/ParkingLots: Manage parking lots, areas, gates, and slots
- /AdminDashboard/Notifications: Send notifications to users

**Subscription Plans**

The system offers three subscription tiers with Stripe for secure payments:

- **Single Plan**: $50/year, allows 1 car and 2 active reservations.
- **Family Plan**: $100/year, allows 2 cars and 6 active reservations.
- **Enterprise Plan**: $500/year, allows 15 cars, 10 active reservations, premium booking features, and 24/7 support.

**Subscription Features**:

- Upgrade or cancel subscriptions at any time.
- Automatic renewal after one year.
- Stripe integration for secure payments and subscriptions management.
