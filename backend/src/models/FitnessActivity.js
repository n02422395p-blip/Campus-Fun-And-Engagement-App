const mongoose = require('mongoose');

const fitnessActivitySchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    activityType: {
      type: String,
      enum: ['Running', 'Walking', 'Gym', 'Yoga', 'Sports', 'Cycling', 'Swimming', 'Other'],
      required: [true, 'Please specify activity type'],
    },
    duration: {
      type: Number,
      required: [true, 'Please provide duration in minutes'],
      min: 1,
    },
    distance: {
      type: Number,
      default: 0, // in kilometers
    },
    caloriesBurned: {
      type: Number,
      default: 0,
    },
    intensity: {
      type: String,
      enum: ['Low', 'Medium', 'High'],
      default: 'Medium',
    },
    pointsEarned: {
      type: Number,
      default: 0,
    },
    notes: {
      type: String,
      maxlength: [500, 'Notes cannot exceed 500 characters'],
    },
    activityDate: {
      type: Date,
      required: true,
    },
    createdAt: {
      type: Date,
      default: Date.now,
    },
    updatedAt: {
      type: Date,
      default: Date.now,
    },
  },
  { timestamps: true }
);

// Index for efficient queries
fitnessActivitySchema.index({ userId: 1, activityDate: -1 });

module.exports = mongoose.model('FitnessActivity', fitnessActivitySchema);
