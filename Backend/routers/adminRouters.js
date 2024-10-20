const express = require('express');
const router = express.Router();
const { getParkingLotCities } = require('../controllers/parkingController');
const {
  addParkingLot,
  updateParkingLot,
  areasByCityID,
  addArea,
  updateArea,
  removeArea,
  addSlotsToArea,
  updateSubscriptionController,
  addSubscriptionController,
  removeSubscriptionController,
  removeParkingLot,
  mostActiveUsersController,
  viewSlotsByCriteriaController,
  updateIndividualSlot,
  deleteSlotByIDController,
  viewUsersByCriteria,
  updateCityPicture,
  getUserDetails,
  userCountController,
  incomeByTimeFrame,
  getParkingLotsFaultsController,
  getRecentSubscriptionsController,
  calculateAverageParkingTimeAllUsersController,
  getRecentParkingLogsController,
  addIndividualSlot,
  editArea,
  addGateToCity,
  getGatesByCityController,
  deleteGate,
  editGate,
  createNotification,
  createParkingLotNotification
} = require('../controllers/adminController');
const { getSubscriptionTiers } = require('../controllers/userController');
const { cancelReservationController, setExitTimeController } = require('../controllers/parkingController');
const { OAuth2Client } = require('google-auth-library');
const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID, process.env.GOOGLE_CLIENT_SECRET, process.env.REDIRECT_URI);
const { apiKeyAuth } = require('../middlewares/apiKeyAuth');
const passport = require('passport');
const { checkAdminRole } = require('../middlewares/isAdmin');
const { toggleSubscriptionStatusById, getUserCounts } = require('../models/adminModel');
const { authenticateJWT } = require('../middlewares/authenticateJWT');

router.use(authenticateJWT);
router.use(checkAdminRole);

router.post('/parking/gates/add', addGateToCity);
router.get('/parking/gates/:idCities', getGatesByCityController);
router.delete('/parking/gates/:idGates', deleteGate);
router.put('/parking/gates/:idGates', editGate);

router.post('/notifications', createNotification);
router.post('/notifications/cities/:cityId', createParkingLotNotification);

router.post('/parking/slots/add-individual', addIndividualSlot);
router.get('/parking/recent-parking-logs', getRecentParkingLogsController);
router.get('/parking/average-parking-time', calculateAverageParkingTimeAllUsersController);
router.get('/income-by-dates', incomeByTimeFrame);
router.post('/parking/add-parking-lot', addParkingLot);
router.put('/parking/update-parking-lot/:idCities', updateParkingLot);
router.delete('/parking/parkinglot/:idCities', removeParkingLot);
router.get('/parking/all-parking-lots', getParkingLotCities);
router.patch('/parking/picture/:idCities', updateCityPicture);
router.get('/users/counts', userCountController);
router.post('/parking/areas', addArea);
router.put('/parking/areas/:idAreas', editArea);
router.delete('/parking/areas/:idAreas', removeArea);
router.get('/parking/areas/:idCities', areasByCityID);
router.get('/parking/faulty/:cityId', getParkingLotsFaultsController);
router.delete('/parking/slots/:idSlots', deleteSlotByIDController);
router.get('/users/recent/', getRecentSubscriptionsController);
router.get('/parking/slots', viewSlotsByCriteriaController);
router.patch('/parking/slots/update/:idSlots', updateIndividualSlot);
router.post('/parking/slots/add', addSlotsToArea);
router.post('/subscriptions', addSubscriptionController);
router.patch('/subscriptions/:idSubscriptionPlans', updateSubscriptionController);
router.delete('/subscriptions/:idSubscriptionPlans', removeSubscriptionController);
router.get('/subscriptions', getSubscriptionTiers);

router.get('/users/mostactive', mostActiveUsersController);
//status || fname || lname || subscriptionTier || email || violations || role
//http://localhost:3001/api/admin/users/criteria?role=user&subscriptionTier=Single%20Plan  example
router.get('/users/criteria', viewUsersByCriteria);
router.patch('/users/subscriptions/:subscriptionId', toggleSubscriptionStatusById);

// router.delete('/parking/reservation', apiKeyAuth, cancelReservationController);
// router.post('/parking/log/exittime/:idCars', apiKeyAuth, setExitTimeController);

module.exports = router;
