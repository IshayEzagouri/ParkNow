const {
  deleteUserById,
  updateUserById,
  getSubscriptions,
  createUser,
  createCars,
  updateCarsModel
} = require('../models/userModel');
const { sanitizeObject } = require('../utils/xssUtils');
const prisma = require('../prisma/prismaClient');
const jwt = require('jsonwebtoken');
const passport = require('../utils/passport-config'); // Import from the correct path

const bcrypt = require('bcrypt');
const saltRounds = 10;

//hashing should move to controller
//--------------------------------------------------------------------------------------------------------------------------------//

//TODO: some controllers will need a subscription status check (important!)
const getActiveUsers = (req, res) => {
  res.status(200).json({ message: 'Users retrieved successfully' });
};
const updateUser = async (req, res) => {
  const id = parseInt(req.params.id); // Convert id to integer if it's a string
  const idFromToken = req.user.idUsers;

  if (id !== idFromToken) {
    return res.status(403).json({ message: 'You are not authorized to update this account' });
  }

  const { currentPassword, newPassword, confirmNewPassword, ...data } = req.body;

  try {
    // Sanitize the input data
    const sanitizedData = sanitizeObject(data, ['FirstName', 'LastName', 'Phone', 'Email']);

    // Handle password update
    let passwordUpdate = {};
    if (currentPassword && newPassword && confirmNewPassword) {
      // Fetch the current user data to compare
      const currentUser = await prisma.users.findUnique({
        where: { idUsers: id },
        select: { Password: true }
      });

      if (!currentUser) {
        return res.status(404).json({ message: 'User not found' });
      }

      const isPasswordValid = await bcrypt.compare(currentPassword, currentUser.Password);

      if (!isPasswordValid) {
        return res.status(401).json({ message: 'Invalid current password' });
      }

      // Validate new password
      if (newPassword !== confirmNewPassword) {
        return res.status(400).json({ message: 'New passwords do not match' });
      }

      // Hash new password
      const hashedPassword = await bcrypt.hash(newPassword, saltRounds);
      passwordUpdate.Password = hashedPassword;
    }

    // Combine sanitized data and password update
    const combinedData = { ...sanitizedData, ...passwordUpdate };

    // Update the user using the model function
    const result = await updateUserById(id, combinedData);

    if (result.success) {
      return res.status(200).json({ message: result.message, user: result.user });
    } else {
      return res.status(404).json({ message: result.message });
    }
  } catch (error) {
    console.error('Error updating user:', error.message);
    return res.status(500).json({ message: 'Internal server error' });
  }
};

const deleteUser = async (req, res) => {
  try {
    const id = req.params.id;
    const idFromToken = req.user.idUsers;

    console.log('type of id params: ' + typeof id);
    console.log('type of req.user.id: ' + typeof idFromToken);
    console.log('req.params.id: ' + id);
    console.log('req.user.id: ' + idFromToken);
    if (id !== idFromToken.toString())
      return res.status(403).json({ message: 'You are not authorized to delete this account' });

    const result = await deleteUserById(id); // Make sure to await the result
    if (result.success) {
      return res.status(200).json({ message: 'User deleted successfully' });
    }
    return res.status(404).json({ message: result.message });
  } catch (err) {
    console.error('Unexpected error:', err);
    res.status(500).json({ message: 'An unexpected error occurred' });
  }
};

const stringFields = ['FirstName', 'LastName', 'Email', 'Phone', 'SubscriptionPlanID', 'StartDate', 'EndDate'];
const addUserController = async (req, res) => {
  const userData = req.body; // Adjust based on how user data is sent

  try {
    // Sanitize the input data
    const sanitizedUserData = sanitizeObject(userData, [
      'persId',
      'FirstName',
      'LastName',
      'Email',
      'Phone',
      'Password'
    ]);

    // Create user
    const user = await createUser(sanitizedUserData);

    // Generate JWT token
    const token = jwt.sign({ id: user.idUsers }, process.env.JWT_SECRET, { expiresIn: '72h' });

    // Respond with success and user ID along with JWT token
    res.status(201).json({
      message: 'User created successfully. Proceed to payment to select a subscription.',
      userId: user.idUsers,
      token
    });
  } catch (error) {
    if (error.name === 'ZodError') {
      return res.status(400).json({
        message: `Validation error: ${error.errors.map((e) => e.message).join(', ')}`
      });
    }
    console.error('Error:', error.message);
    return res.status(500).json({ message: 'Internal Server Error' });
  }
};

const addCarsController = async (req, res) => {
  // Extract user ID from JWT token

  const idUsers = req.user.idUsers; // Ensure this matches how the user ID is stored in req.user

  const { cars } = req.body;

  try {
    // Sanitize input data
    console.log('sanitizing cars');
    const sanitizedCars = cars.map((car) => sanitizeObject(car, ['make', 'model']));

    // Fetch user's subscription plan
    console.log('fetching user subscription');
    const userSubscription = await prisma.userSubscriptions.findFirst({
      where: { UserID: idUsers, Status: 'active' },
      select: { SubscriptionPlanID: true }
    });

    if (!userSubscription) {
      return res.status(400).json({ message: 'User does not have an active subscription' });
    }

    const { SubscriptionPlanID } = userSubscription;

    // Add cars to the database
    console.log('triggering create cars model');
    await createCars(idUsers, sanitizedCars, SubscriptionPlanID);

    // Respond with success
    res.status(201).json({
      message: 'Cars added successfully.'
    });
  } catch (error) {
    console.error('Error:', error.message);
    return res.status(500).json({ message: 'Internal Server Error' });
  }
};

const login = (req, res, next) => {
  passport.authenticate('local', (err, user, info) => {
    if (err) return next(err);
    if (!user) return res.status(401).json({ message: info.message });

    // Generate JWT token
    //TODO store the token in the frontend
    const token = jwt.sign({ id: user.idUsers }, process.env.JWT_SECRET, { expiresIn: '72h' });

    // Send response with token
    res.status(200).json({ token });
  })(req, res, next); // Pass req, res, and next to the middleware
};

//TODO
const extendSubscription = (req, res) => {};

async function getSubscriptionTiers(req, res) {
  try {
    const subscriptions = await getSubscriptions();
    res.json(subscriptions);
  } catch (err) {
    console.error('Error in getSubscriptionTiers:', err.message);
    res.status(500).json({ error: 'Internal Server Error' });
  }
}

const updateCars = async (req, res) => {
  console.log('Received PATCH request for /api/users/cars');
  console.log('User:', req.user); // Log authenticated user
  console.log('Request Body:', req.body); // Log request body
  // Extract user ID from JWT token
  console.log('extracting user from JWT token');
  const idUsers = req.user.idUsers; // Ensure this matches how the user ID is stored in req.user

  const { cars } = req.body;

  try {
    console.log('start of try block in updateCars conntroller');

    // Sanitize input data
    console.log('sanitizing');
    const sanitizedCars = cars.map((car) => sanitizeObject(car, ['RegistrationID', 'Model']));

    // Update cars in the database
    console.log('calling updateCarsModel');
    await updateCarsModel(idUsers, sanitizedCars);

    // Respond with success

    res.status(200).json({
      message: 'Cars updated successfully.'
    });
  } catch (err) {
    console.error('Error updating cars:', err.message);
    res.status(500).json({ message: 'Internal Server Error' });
  }
};

const getUserCarsController = async (req, res) => {
  const userId = req.user.idUsers; // Extract user ID from the JWT token

  try {
    const result = await getCarsByUserId(userId);

    if (result.success) {
      return res.status(200).json(result.cars);
    } else {
      return res.status(404).json({ message: result.message });
    }
  } catch (error) {
    console.error('Error in getUserCarsController:', error.message);
    return res.status(500).json({ message: 'Internal Server Error' });
  }
};
//update subscription plans

module.exports = {
  updateUser,
  deleteUser,
  getSubscriptionTiers,
  addUserController,
  login,
  addCarsController,
  updateCars
};