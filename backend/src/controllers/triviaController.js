const Trivia = require('../models/Trivia');
const TriviaAttempt = require('../models/TriviaAttempt');
const User = require('../models/User');
const { calculatePoints, calculateAccuracy } = require('../utils/helpers');
const { body } = require('express-validator');

// @desc    Get all trivia questions
// @route   GET /api/trivia/questions
// @access  Public
exports.getTrivia = async (req, res) => {
  try {
    const { category, difficulty, page = 1, limit = 10 } = req.query;

    let query = { isActive: true };
    if (category) query.category = category;
    if (difficulty) query.difficulty = difficulty;

    const skip = (page - 1) * limit;

    const triviaQuestions = await Trivia.find(query)
      .limit(parseInt(limit))
      .skip(skip)
      .select('-correctAnswer'); // Don't send correct answer to client

    const total = await Trivia.countDocuments(query);

    res.status(200).json({
      success: true,
      total,
      count: triviaQuestions.length,
      data: triviaQuestions,
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

// @desc    Submit trivia answer
// @route   POST /api/trivia/answer
// @access  Private
exports.submitTrivia = async (req, res) => {
  try {
    const { triviaId, selectedAnswer, timeSpent } = req.body;

    const trivia = await Trivia.findById(triviaId);
    if (!trivia) {
      return res.status(404).json({ success: false, message: 'Trivia question not found' });
    }

    const isCorrect = selectedAnswer === trivia.correctAnswer;
    const pointsEarned = isCorrect ? calculatePoints(trivia.difficulty) : 0;

    // Create trivia attempt record
    const attempt = await TriviaAttempt.create({
      userId: req.user.id,
      triviaId,
      selectedAnswer,
      isCorrect,
      pointsEarned,
      timeSpent,
    });

    // Update user score
    const user = await User.findById(req.user.id);
    user.totalPoints += pointsEarned;
    user.triviaScore += pointsEarned;
    await user.save();

    res.status(201).json({
      success: true,
      data: {
        attempt,
        isCorrect,
        pointsEarned,
        explanation: trivia.explanation,
        correctAnswer: trivia.options[trivia.correctAnswer],
        userTotalPoints: user.totalPoints,
      },
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Get user trivia history
// @route   GET /api/trivia/history/:userId
// @access  Private
exports.getTriviaHistory = async (req, res) => {
  try {
    const { page = 1, limit = 20 } = req.query;
    const skip = (page - 1) * limit;

    const attempts = await TriviaAttempt.find({ userId: req.params.userId })
      .populate('triviaId', 'question options category difficulty points')
      .sort({ attemptedAt: -1 })
      .limit(parseInt(limit))
      .skip(skip);

    const total = await TriviaAttempt.countDocuments({ userId: req.params.userId });

    const correctAnswers = attempts.filter(a => a.isCorrect).length;

    res.status(200).json({
      success: true,
      total,
      count: attempts.length,
      accuracy: calculateAccuracy(correctAnswers, attempts.length),
      data: attempts,
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

// @desc    Get trivia categories
// @route   GET /api/trivia/categories
// @access  Public
exports.getCategories = async (req, res) => {
  try {
    const categories = await Trivia.distinct('category');

    res.status(200).json({
      success: true,
      data: categories,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// @desc    Create trivia (Admin only)
// @route   POST /api/trivia
// @access  Private (Admin)
exports.createTrivia = async (req, res) => {
  try {
    const trivia = await Trivia.create(req.body);

    res.status(201).json({
      success: true,
      data: trivia,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Validation rules
exports.submitTriviaValidationRules = () => {
  return [
    body('triviaId').notEmpty().withMessage('Trivia ID is required'),
    body('selectedAnswer').isInt({ min: 0, max: 3 }).withMessage('Selected answer must be between 0 and 3'),
    body('timeSpent').optional().isInt({ min: 0 }).withMessage('Time spent must be a positive number'),
  ];
};

exports.createTriviaValidationRules = () => {
  return [
    body('question').trim().notEmpty().withMessage('Question is required'),
    body('options').isArray({ min: 4, max: 4 }).withMessage('Must provide exactly 4 options'),
    body('correctAnswer').isInt({ min: 0, max: 3 }).withMessage('Correct answer index must be between 0 and 3'),
    body('category').trim().notEmpty().withMessage('Category is required'),
    body('difficulty').isIn(['Easy', 'Medium', 'Hard']).withMessage('Difficulty must be Easy, Medium, or Hard'),
    body('points').optional().isInt({ min: 1 }).withMessage('Points must be a positive number'),
  ];
};
