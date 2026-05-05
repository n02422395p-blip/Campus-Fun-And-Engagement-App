const mongoose = require('mongoose');

const leaderboardSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      unique: true,
    },
    rank: {
      type: Number,
      default: null,
    },
    totalPoints: {
      type: Number,
      default: 0,
    },
    triviaPoints: {
      type: Number,
      default: 0,
    },
    fitnessPoints: {
      type: Number,
      default: 0,
    },
    triviaQuestionsAnswered: {
      type: Number,
      default: 0,
    },
    triviaCorrectAnswers: {
      type: Number,
      default: 0,
    },
    accuracyPercentage: {
      type: Number,
      default: 0,
    },
    fitnessActivitiesLogged: {
      type: Number,
      default: 0,
    },
    totalFitnessMinutes: {
      type: Number,
      default: 0,
    },
    leaderboardPeriod: {
      type: String,
      enum: ['Global', 'Weekly', 'Monthly'],
      default: 'Global',
    },
    weekStart: {
      type: Date,
      default: null,
    },
    monthStart: {
      type: Date,
      default: null,
    },
    lastUpdated: {
      type: Date,
      default: Date.now,
    },
  },
  { timestamps: true }
);

// Index for efficient leaderboard queries
leaderboardSchema.index({ totalPoints: -1, rank: 1 });
leaderboardSchema.index({ leaderboardPeriod: 1, totalPoints: -1 });

module.exports = mongoose.model('Leaderboard', leaderboardSchema);
