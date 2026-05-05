const express = require('express');
const { register, login, logout, getMe, registerValidationRules, loginValidationRules } = require('../controllers/authController');
const { protect } = require('../middleware/auth');
const { handleValidationErrors } = require('../middleware/validation');

const router = express.Router();

// Public routes
router.post('/register', registerValidationRules(), handleValidationErrors, register);
router.post('/login', loginValidationRules(), handleValidationErrors, login);

// Private routes
router.post('/logout', protect, logout);
router.get('/me', protect, getMe);

module.exports = router;
