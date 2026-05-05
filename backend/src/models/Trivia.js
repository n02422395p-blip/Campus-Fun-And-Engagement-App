const mongoose = require('mongoose');

const triviaSchema = new mongoose.Schema(
  {
    question: {
      type: String,
      required: [true, 'Please provide a question'],
    },
    options: {
      type: [String],
      required: [true, 'Please provide options'],
      validate: {
        validator: function (v) {
          return v.length === 4;
        },
        message: 'Must provide exactly 4 options',
      },
    },
    correctAnswer: {
      type: Number,
      required: [true, 'Please specify correct answer index'],
      min: 0,
      max: 3,
    },
    category: {
      type: String,
      enum: ['General Knowledge', 'Science', 'History', 'Sports', 'Technology', 'Entertainment'],
      default: 'General Knowledge',
    },
    difficulty: {
      type: String,
      enum: ['Easy', 'Medium', 'Hard'],
      default: 'Medium',
    },
    points: {
      type: Number,
      default: 10,
    },
    explanation: {
      type: String,
      default: null,
    },
    isActive: {
      type: Boolean,
      default: true,
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

module.exports = mongoose.model('Trivia', triviaSchema);
