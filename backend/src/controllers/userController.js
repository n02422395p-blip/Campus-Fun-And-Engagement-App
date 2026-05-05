const User = require('../models/User');
const { body } = require('express-validator');

// @desc    Get user profile
// @route   GET /api/users/:id
// @access  Private
exports.getUserProfile = async (req, res) => {
  try {
    const user = await User.findById(req.params.id);

    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }

    res.status(200).json({
      success: true,
      data: user,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Update user profile
// @route   PUT /api/users/:id
// @access  Private
exports.updateUserProfile = async (req, res) => {
  try {
    // Check if user is updating their own profile
    if (req.user.id !== req.params.id) {
      return res.status(403).json({ success: false, message: 'Not authorized to update this user' });
    }

    const { name, bio, profileImage, department } = req.body;

    let user = await User.findById(req.params.id);
    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }

    // Update fields
    if (name) user.name = name;
    if (bio) user.bio = bio;
    if (profileImage) user.profileImage = profileImage;
    if (department) user.department = department;

    await user.save();

    res.status(200).json({
      success: true,
      data: user,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Get all users (for leaderboard)
// @route   GET /api/users
// @access  Public
exports.getAllUsers = async (req, res) => {
  try {
    const { page = 1, limit = 20, sortBy = 'totalPoints' } = req.query;

    const skip = (page - 1) * limit;
    const sort = sortBy === 'totalPoints' ? { totalPoints: -1 } : { createdAt: -1 };

    const users = await User.find({ isActive: true })
      .sort(sort)
      .limit(parseInt(limit))
      .skip(skip)
      .select('name registrationNumber department totalPoints triviaScore fitnessScore profileImage');

    const total = await User.countDocuments({ isActive: true });

    res.status(200).json({
      success: true,
      total,
      count: users.length,
      data: users,
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

// @desc    Get top users
// @route   GET /api/users/top/:limit
// @access  Public
exports.getTopUsers = async (req, res) => {
  try {
    const limit = parseInt(req.params.limit) || 10;

    const users = await User.find({ isActive: true })
      .sort({ totalPoints: -1 })
      .limit(limit)
      .select('name registrationNumber department totalPoints triviaScore fitnessScore profileImage');

    res.status(200).json({
      success: true,
      count: users.length,
      data: users,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Get user stats
// @route   GET /api/users/:id/stats
// @access  Private
exports.getUserStats = async (req, res) => {
  try {
    const TriviaAttempt = require('../models/TriviaAttempt');
    const FitnessActivity = require('../models/FitnessActivity');

    const user = await User.findById(req.params.id);
    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }

    const triviaAttempts = await TriviaAttempt.find({ userId: req.params.id });
    const fitnessActivities = await FitnessActivity.find({ userId: req.params.id });

    const correctAnswers = triviaAttempts.filter(a => a.isCorrect).length;
    const totalDuration = fitnessActivities.reduce((sum, a) => sum + a.duration, 0);
    const totalCalories = fitnessActivities.reduce((sum, a) => sum + a.caloriesBurned, 0);

    res.status(200).json({
      success: true,
      data: {
        user: {
          name: user.name,
          totalPoints: user.totalPoints,
          triviaScore: user.triviaScore,
          fitnessScore: user.fitnessScore,
        },
        trivia: {
          totalAttempts: triviaAttempts.length,
          correctAnswers,
          accuracy: triviaAttempts.length > 0 ? ((correctAnswers / triviaAttempts.length) * 100).toFixed(2) : 0,
        },
        fitness: {
          activitiesLogged: fitnessActivities.length,
          totalDuration,
          totalCalories,
        },
      },
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Validation rules
exports.updateProfileValidationRules = () => {
  return [
    body('name').optional().trim().isLength({ min: 2 }).withMessage('Name must be at least 2 characters'),
    body('bio').optional().trim().isLength({ max: 500 }).withMessage('Bio cannot exceed 500 characters'),
    body('department').optional().trim(),
  ];
};
