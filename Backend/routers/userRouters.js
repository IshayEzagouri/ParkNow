// example user login
// "Email": "john.doe@example.com",
// "Password": "password123"

const express = require('express');
const { loginLimiter, generalLimiter } = require('../middlewares/rateLimit');

const Stripe = require('stripe');
const stripe = Stripe(process.env.STRIPE_SECRET_KEY);

const router = express.Router();
const {
  updateUser,
  deleteUser,
  getSubscriptionTiers,
  addUserController,
  login,
  addCarsController,
  updateCar,
  deleteCarById,
  getUserDetails,
  logout,
  fetchCheckoutSessionURL,
  getUserSubscription,
  getUserCars,
  getUpcomingReservations,
  markNotificationsAsRead,
  fetchUnreadNotificationsCount,
  fetchUserNotifications,
  markSingleNotificationRead,
  updateUserPassword
} = require('../controllers/userController');
const {
  getParkingLotCities,
  // reserveParkingController,
  bookSlotController,
  findAvailableSlotController,
  cancelReservationController,
  getParkingHistory,
  calculateTotalParkingTimeByUser,
  calculateAverageParkingTimeByUser,
  countSlotsByCityID
} = require('../controllers/parkingController');
const { googleCallback } = require('../controllers/authController');
const { OAuth2Client } = require('google-auth-library');
const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID, process.env.GOOGLE_CLIENT_SECRET, process.env.REDIRECT_URI);
const passport = require('passport');
const { createStripeSession, cancelSubscription } = require('../controllers/stripeCheckoutController');
const { handleCheckoutSessionCompleted } = require('../controllers/stripeWebHookController');
const { authenticateJWT } = require('../middlewares/authenticateJWT');

router.use(generalLimiter);

router.get('/checkout-session/:sessionId', fetchCheckoutSessionURL);

router.get(
  '/details',
  (req, res, next) => {
    console.log(`Incoming request to ${req.url}`);
    next();
  },

  authenticateJWT,
  getUserDetails
);

router.get('/sessions/:sessionId', async (req, res) => {
  try {
    const session = await stripe.checkout.sessions.retrieve(req.params.sessionId);
    res.json(session);
  } catch (error) {
    console.error('Error retrieving session:', error);
    res.status(500).json({ error: 'Unable to retrieve session' });
  }
});

router.get('/notifications/unread', authenticateJWT, fetchUnreadNotificationsCount);
router.post('/notifications/clear', authenticateJWT, markNotificationsAsRead);
router.get('/notifications', authenticateJWT, fetchUserNotifications);
router.post('/notifications/:notificationId', authenticateJWT, markSingleNotificationRead);
router.get('/parking/reservations', authenticateJWT, getUpcomingReservations);
router.post('/cancel-subscription', authenticateJWT, cancelSubscription);
router.get('/parkinglots', getParkingLotCities);
router.get('/user-subscription', authenticateJWT, getUserSubscription);
//im aware the the router below doesn'tfully follow restful conventions by not usind :id. however i chose this approach in order to edit bulk items
router.put('/cars/:idCars', authenticateJWT, updateCar);
router.get('/subscriptions', getSubscriptionTiers);
router.post('/signup', addUserController);
router.post('/login', loginLimiter, login);
router.post('/logout', authenticateJWT, logout);
router.get('/parking/slots-count/:cityId', authenticateJWT, countSlotsByCityID);
router.put('/update-user-info', authenticateJWT, updateUser);
router.put('/change-pass', authenticateJWT, updateUserPassword);
router.post('/cars/add', authenticateJWT, addCarsController);
router.delete('/cars/:idCars', authenticateJWT, deleteCarById);
router.get('/cars', authenticateJWT, getUserCars);
router.get('/parking/total-time', authenticateJWT, calculateTotalParkingTimeByUser);
router.get('/parking/average-duration', authenticateJWT, calculateAverageParkingTimeByUser);
router.post('/parking/reservation', authenticateJWT, bookSlotController);
//here also i decided to not use /:id in order to be able to keep the same controller and model to work with both admin and user
//important- idReservation in the req.body
//if anyone is signed in- we will know who it is and make sure that he can't delete a reservation that isnt his
//on the other hand no one can access the admin route without the api key
router.delete('/parking/reservation', authenticateJWT, cancelReservationController);
//use params
router.get('/parking/find-best-slot', authenticateJWT, findAvailableSlotController);
router.get('/parking/history', authenticateJWT, getParkingHistory);
router.delete('/:id', authenticateJWT, deleteUser);

///TODO****** add a middleware to check if subscription is active
router.get('/google/callback', googleCallback);
router.get(
  '/google',
  passport.authenticate('google', {
    scope: ['profile', 'email']
  })
);
router.post('/webhook', handleCheckoutSessionCompleted);
router.post('/create-checkout-session', authenticateJWT, createStripeSession);

router.get('/webhook', (req, res) => {
  res.send('hello from ngrok');
});

module.exports = router;
