const express = require('express');
const {
  getGlobalLeaderboard,
  getWeeklyLeaderboard,
  getMonthlyLeaderboard,
  getUserRank,
} = require('../controllers/leaderboardController');
const { protect } = require('../middleware/auth');

const router = express.Router();

// Public routes
router.get('/global', getGlobalLeaderboard);
router.get('/weekly', getWeeklyLeaderboard);
router.get('/monthly', getMonthlyLeaderboard);

// Private routes
router.get('/rank/:userId', protect, getUserRank);

module.exports = router;
