const jwt = require('jsonwebtoken');

const generateToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRE || '7d',
  });
};

const calculatePoints = (difficulty) => {
  const pointsMap = {
    Easy: 10,
    Medium: 20,
    Hard: 50,
  };
  return pointsMap[difficulty] || 20;
};

const calculateFitnessPoints = (duration, intensity) => {
  const basePoints = {
    Low: 5,
    Medium: 10,
    High: 15,
  };
  const pointsPerMinute = basePoints[intensity] || 10;
  return Math.floor((duration / 30) * pointsPerMinute);
};

const calculateAccuracy = (correct, total) => {
  if (total === 0) return 0;
  return ((correct / total) * 100).toFixed(2);
};

module.exports = {
  generateToken,
  calculatePoints,
  calculateFitnessPoints,
  calculateAccuracy,
};
