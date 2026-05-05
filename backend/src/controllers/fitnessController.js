const FitnessActivity = require('../models/FitnessActivity');
const User = require('../models/User');
const { calculateFitnessPoints } = require('../utils/helpers');
const { body } = require('express-validator');

// @desc    Log fitness activity
// @route   POST /api/fitness/activity
// @access  Private
exports.logActivity = async (req, res) => {
  try {
    const { activityType, duration, distance, caloriesBurned, intensity, notes, activityDate } = req.body;

    const pointsEarned = calculateFitnessPoints(duration, intensity);

    const activity = await FitnessActivity.create({
      userId: req.user.id,
      activityType,
      duration,
      distance,
      caloriesBurned,
      intensity,
      pointsEarned,
      notes,
      activityDate: activityDate || new Date(),
    });

    // Update user score
    const user = await User.findById(req.user.id);
    user.totalPoints += pointsEarned;
    user.fitnessScore += pointsEarned;
    await user.save();

    res.status(201).json({
      success: true,
      data: {
        activity,
        pointsEarned,
        userTotalPoints: user.totalPoints,
      },
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Get user fitness activities
// @route   GET /api/fitness/activities/:userId
// @access  Private
exports.getUserActivities = async (req, res) => {
  try {
    const { page = 1, limit = 20, startDate, endDate } = req.query;
    const skip = (page - 1) * limit;

    let query = { userId: req.params.userId };

    // Filter by date range if provided
    if (startDate || endDate) {
      query.activityDate = {};
      if (startDate) query.activityDate.$gte = new Date(startDate);
      if (endDate) query.activityDate.$lte = new Date(endDate);
    }

    const activities = await FitnessActivity.find(query)
      .sort({ activityDate: -1 })
      .limit(parseInt(limit))
      .skip(skip);

    const total = await FitnessActivity.countDocuments(query);

    res.status(200).json({
      success: true,
      total,
      count: activities.length,
      data: activities,
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

// @desc    Get fitness statistics
// @route   GET /api/fitness/stats/:userId
// @access  Private
exports.getFitnessStats = async (req, res) => {
  try {
    const activities = await FitnessActivity.find({ userId: req.params.userId });

    const stats = {
      totalActivities: activities.length,
      totalDuration: activities.reduce((sum, a) => sum + a.duration, 0),
      totalDistance: activities.reduce((sum, a) => sum + a.distance, 0),
      totalCalories: activities.reduce((sum, a) => sum + a.caloriesBurned, 0),
      totalPoints: activities.reduce((sum, a) => sum + a.pointsEarned, 0),
      averageIntensity: activities.length > 0 
        ? activities.reduce((sum, a) => sum + (['Low', 'Medium', 'High'].indexOf(a.intensity) + 1), 0) / activities.length
        : 0,
      activityBreakdown: {},
    };

    // Breakdown by activity type
    activities.forEach(activity => {
      if (!stats.activityBreakdown[activity.activityType]) {
        stats.activityBreakdown[activity.activityType] = {
          count: 0,
          duration: 0,
          points: 0,
        };
      }
      stats.activityBreakdown[activity.activityType].count += 1;
      stats.activityBreakdown[activity.activityType].duration += activity.duration;
      stats.activityBreakdown[activity.activityType].points += activity.pointsEarned;
    });

    res.status(200).json({
      success: true,
      data: stats,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Update fitness activity
// @route   PUT /api/fitness/activity/:id
// @access  Private
exports.updateActivity = async (req, res) => {
  try {
    let activity = await FitnessActivity.findById(req.params.id);

    if (!activity) {
      return res.status(404).json({ success: false, message: 'Activity not found' });
    }

    // Check authorization
    if (activity.userId.toString() !== req.user.id) {
      return res.status(403).json({ success: false, message: 'Not authorized to update this activity' });
    }

    const { duration, distance, caloriesBurned, intensity, notes } = req.body;

    // Calculate new points
    const oldPoints = activity.pointsEarned;
    const newPoints = calculateFitnessPoints(duration || activity.duration, intensity || activity.intensity);
    const pointsDifference = newPoints - oldPoints;

    // Update activity
    if (duration) activity.duration = duration;
    if (distance) activity.distance = distance;
    if (caloriesBurned) activity.caloriesBurned = caloriesBurned;
    if (intensity) activity.intensity = intensity;
    if (notes) activity.notes = notes;
    if (duration || intensity) activity.pointsEarned = newPoints;

    await activity.save();

    // Update user score
    const user = await User.findById(req.user.id);
    user.fitnessScore += pointsDifference;
    user.totalPoints += pointsDifference;
    await user.save();

    res.status(200).json({
      success: true,
      data: {
        activity,
        pointsChange: pointsDifference,
        userTotalPoints: user.totalPoints,
      },
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Delete fitness activity
// @route   DELETE /api/fitness/activity/:id
// @access  Private
exports.deleteActivity = async (req, res) => {
  try {
    const activity = await FitnessActivity.findById(req.params.id);

    if (!activity) {
      return res.status(404).json({ success: false, message: 'Activity not found' });
    }

    // Check authorization
    if (activity.userId.toString() !== req.user.id) {
      return res.status(403).json({ success: false, message: 'Not authorized to delete this activity' });
    }

    // Update user score
    const user = await User.findById(req.user.id);
    user.fitnessScore -= activity.pointsEarned;
    user.totalPoints -= activity.pointsEarned;
    await user.save();

    await FitnessActivity.findByIdAndDelete(req.params.id);

    res.status(200).json({
      success: true,
      message: 'Activity deleted successfully',
      userTotalPoints: user.totalPoints,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Validation rules
exports.logActivityValidationRules = () => {
  return [
    body('activityType').trim().notEmpty().withMessage('Activity type is required'),
    body('duration').isInt({ min: 1 }).withMessage('Duration must be at least 1 minute'),
    body('distance').optional().isFloat({ min: 0 }).withMessage('Distance must be a positive number'),
    body('caloriesBurned').optional().isInt({ min: 0 }).withMessage('Calories must be a positive number'),
    body('intensity').isIn(['Low', 'Medium', 'High']).withMessage('Intensity must be Low, Medium, or High'),
    body('notes').optional().trim().isLength({ max: 500 }).withMessage('Notes cannot exceed 500 characters'),
  ];
};
