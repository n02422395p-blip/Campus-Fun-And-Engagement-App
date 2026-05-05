const Leaderboard = require('../models/Leaderboard');
const User = require('../models/User');
const TriviaAttempt = require('../models/TriviaAttempt');
const FitnessActivity = require('../models/FitnessActivity');

// @desc    Get global leaderboard
// @route   GET /api/leaderboard/global
// @access  Public
exports.getGlobalLeaderboard = async (req, res) => {
  try {
    const { page = 1, limit = 20 } = req.query;
    const skip = (page - 1) * limit;

    const users = await User.find({ isActive: true })
      .sort({ totalPoints: -1 })
      .limit(parseInt(limit))
      .skip(skip)
      .select('name registrationNumber department totalPoints triviaScore fitnessScore profileImage');

    const total = await User.countDocuments({ isActive: true });

    // Add rank to each user
    const leaderboard = users.map((user, index) => ({
      rank: skip + index + 1,
      ...user.toObject(),
    }));

    res.status(200).json({
      success: true,
      total,
      count: leaderboard.length,
      data: leaderboard,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        pages: Math.ceil(total / limit),
      },
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Get weekly leaderboard
// @route   GET /api/leaderboard/weekly
// @access  Public
exports.getWeeklyLeaderboard = async (req, res) => {
  try {
    const { page = 1, limit = 20 } = req.query;
    const skip = (page - 1) * limit;

    // Calculate week start (Monday of current week)
    const today = new Date();
    const dayOfWeek = today.getDay();
    const daysToMonday = dayOfWeek === 0 ? 6 : dayOfWeek - 1;
    const weekStart = new Date(today);
    weekStart.setDate(today.getDate() - daysToMonday);
    weekStart.setHours(0, 0, 0, 0);

    // Get trivia points earned this week
    const triviaAttempts = await TriviaAttempt.find({
      attemptedAt: { $gte: weekStart },
      isCorrect: true,
    }).select('userId pointsEarned');

    const fitnessActivities = await FitnessActivity.find({
      createdAt: { $gte: weekStart },
    }).select('userId pointsEarned');

    // Aggregate points by user
    const userPoints = {};

    triviaAttempts.forEach(attempt => {
      const userId = attempt.userId.toString();
      userPoints[userId] = (userPoints[userId] || 0) + attempt.pointsEarned;
    });

    fitnessActivities.forEach(activity => {
      const userId = activity.userId.toString();
      userPoints[userId] = (userPoints[userId] || 0) + activity.pointsEarned;
    });

    // Convert to array and sort
    const leaderboardData = Object.entries(userPoints)
      .map(([userId, points]) => ({
        userId,
        weeklyPoints: points,
      }))
      .sort((a, b) => b.weeklyPoints - a.weeklyPoints);

    // Get user details
    const userIds = leaderboardData.slice(skip, skip + parseInt(limit)).map(d => d.userId);
    const userDetails = await User.find({ _id: { $in: userIds }, isActive: true }).select('name registrationNumber department profileImage');

    const leaderboard = leaderboardData.slice(skip, skip + parseInt(limit)).map((item, index) => {
      const user = userDetails.find(u => u._id.toString() === item.userId);
      return {
        rank: skip + index + 1,
        ...user.toObject(),
        weeklyPoints: item.weeklyPoints,
      };
    });

    res.status(200).json({
      success: true,
      total: leaderboardData.length,
      count: leaderboard.length,
      weekStart: weekStart.toISOString().split('T')[0],
      data: leaderboard,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        pages: Math.ceil(leaderboardData.length / limit),
      },
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Get monthly leaderboard
// @route   GET /api/leaderboard/monthly
// @access  Public
exports.getMonthlyLeaderboard = async (req, res) => {
  try {
    const { page = 1, limit = 20 } = req.query;
    const skip = (page - 1) * limit;

    // Calculate month start
    const today = new Date();
    const monthStart = new Date(today.getFullYear(), today.getMonth(), 1);

    // Get trivia points earned this month
    const triviaAttempts = await TriviaAttempt.find({
      attemptedAt: { $gte: monthStart },
      isCorrect: true,
    }).select('userId pointsEarned');

    const fitnessActivities = await FitnessActivity.find({
      createdAt: { $gte: monthStart },
    }).select('userId pointsEarned');

    // Aggregate points by user
    const userPoints = {};

    triviaAttempts.forEach(attempt => {
      const userId = attempt.userId.toString();
      userPoints[userId] = (userPoints[userId] || 0) + attempt.pointsEarned;
    });

    fitnessActivities.forEach(activity => {
      const userId = activity.userId.toString();
      userPoints[userId] = (userPoints[userId] || 0) + activity.pointsEarned;
    });

    // Convert to array and sort
    const leaderboardData = Object.entries(userPoints)
      .map(([userId, points]) => ({
        userId,
        monthlyPoints: points,
      }))
      .sort((a, b) => b.monthlyPoints - a.monthlyPoints);

    // Get user details
    const userIds = leaderboardData.slice(skip, skip + parseInt(limit)).map(d => d.userId);
    const userDetails = await User.find({ _id: { $in: userIds }, isActive: true }).select('name registrationNumber department profileImage');

    const leaderboard = leaderboardData.slice(skip, skip + parseInt(limit)).map((item, index) => {
      const user = userDetails.find(u => u._id.toString() === item.userId);
      return {
        rank: skip + index + 1,
        ...user.toObject(),
        monthlyPoints: item.monthlyPoints,
      };
    });

    res.status(200).json({
      success: true,
      total: leaderboardData.length,
      count: leaderboard.length,
      monthStart: monthStart.toISOString().split('T')[0],
      data: leaderboard,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        pages: Math.ceil(leaderboardData.length / limit),
      },
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Get user rank
// @route   GET /api/leaderboard/rank/:userId
// @access  Public
exports.getUserRank = async (req, res) => {
  try {
    const user = await User.findById(req.params.userId);
    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }

    // Count how many users have more points
    const betterRank = await User.countDocuments({
      totalPoints: { $gt: user.totalPoints },
      isActive: true,
    });

    res.status(200).json({
      success: true,
      data: {
        userId: user._id,
        name: user.name,
        rank: betterRank + 1,
        totalPoints: user.totalPoints,
        triviaScore: user.triviaScore,
        fitnessScore: user.fitnessScore,
      },
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
