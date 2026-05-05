const express = require('express');
const {
  getUserProfile,
  updateUserProfile,
  getAllUsers,
  getTopUsers,
  getUserStats,
  updateProfileValidationRules,
} = require('../controllers/userController');
const { protect } = require('../middleware/auth');
const { handleValidationErrors } = require('../middleware/validation');

const router = express.Router();

// Public routes
router.get('/', getAllUsers);
router.get('/top/:limit', getTopUsers);

// Private routes
router.get('/:id', protect, getUserProfile);
router.get('/:id/stats', protect, getUserStats);
router.put('/:id', protect, updateProfileValidationRules(), handleValidationErrors, updateUserProfile);

module.exports = router;
