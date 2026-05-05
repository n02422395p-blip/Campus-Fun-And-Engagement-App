const express = require('express');
const {
  logActivity,
  getUserActivities,
  getFitnessStats,
  updateActivity,
  deleteActivity,
  logActivityValidationRules,
} = require('../controllers/fitnessController');
const { protect } = require('../middleware/auth');
const { handleValidationErrors } = require('../middleware/validation');

const router = express.Router();

// Private routes only
router.post('/activity', protect, logActivityValidationRules(), handleValidationErrors, logActivity);
router.get('/activities/:userId', protect, getUserActivities);
router.get('/stats/:userId', protect, getFitnessStats);
router.put('/activity/:id', protect, logActivityValidationRules(), handleValidationErrors, updateActivity);
router.delete('/activity/:id', protect, deleteActivity);

module.exports = router;
