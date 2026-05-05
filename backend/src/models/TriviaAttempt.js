const mongoose = require('mongoose');

const triviaAttemptSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    triviaId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Trivia',
      required: true,
    },
    selectedAnswer: {
      type: Number,
      required: true,
      min: 0,
      max: 3,
    },
    isCorrect: {
      type: Boolean,
      required: true,
    },
    pointsEarned: {
      type: Number,
      default: 0,
    },
    timeSpent: {
      type: Number,
      default: 0, // in seconds
    },
    attemptedAt: {
      type: Date,
      default: Date.now,
    },
  },
  { timestamps: true }
);

// Compound index to prevent duplicate attempts
triviaAttemptSchema.index({ userId: 1, triviaId: 1, createdAt: 1 });

module.exports = mongoose.model('TriviaAttempt', triviaAttemptSchema);
