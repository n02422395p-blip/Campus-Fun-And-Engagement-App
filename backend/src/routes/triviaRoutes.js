const express = require('express');
const {
  getTrivia,
  submitTrivia,
  getTriviaHistory,
  getCategories,
  createTrivia,
  submitTriviaValidationRules,
  createTriviaValidationRules,
} = require('../controllers/triviaController');
const { protect } = require('../middleware/auth');
const { handleValidationErrors } = require('../middleware/validation');

const router = express.Router();

// Public routes
router.get('/questions', getTrivia);
router.get('/categories', getCategories);

// Private routes
router.post('/answer', protect, submitTriviaValidationRules(), handleValidationErrors, submitTrivia);
router.get('/history/:userId', protect, getTriviaHistory);

// Admin routes (to be implemented with role-based access)
router.post('/', protect, createTriviaValidationRules(), handleValidationErrors, createTrivia);

module.exports = router;
