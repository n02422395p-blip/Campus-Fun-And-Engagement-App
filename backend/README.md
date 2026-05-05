# NUST Fun & Engagement App - Backend

A Node.js/Express backend for the NUST Campus Fun & Engagement mobile application. This backend handles user authentication, trivia challenges, fitness tracking, leaderboard management, and push notifications.

## 🚀 Getting Started

### Prerequisites
- Node.js (v14+)
- MongoDB (local or cloud)
- npm or yarn

### Installation

1. Clone the repository and navigate to the backend folder:
```bash
cd backend
```

2. Install dependencies:
```bash
npm install
```

3. Create a `.env` file from `.env.example`:
```bash
cp .env.example .env
```

4. Update the `.env` file with your configuration:
   - Set `MONGODB_URI` to your MongoDB connection string
   - Set `JWT_SECRET` to a secure random string
   - Configure other services as needed

5. Start the development server:
```bash
npm run dev
```

The server will run on `http://localhost:5000`

## 📁 Project Structure

```
backend/
├── src/
│   ├── config/          # Configuration files
│   ├── controllers/      # Business logic controllers
│   ├── middleware/       # Express middleware
│   ├── models/           # MongoDB schemas
│   ├── routes/           # API routes
│   ├── utils/            # Utility functions
│   └── index.js          # Main server file
├── tests/                # Test files
├── .env.example          # Environment variables template
├── package.json          # Dependencies
└── README.md             # This file
```

## 🔌 API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `POST /api/auth/logout` - Logout user
- `POST /api/auth/refresh-token` - Refresh JWT token

### Users
- `GET /api/users/:id` - Get user profile
- `PUT /api/users/:id` - Update user profile
- `GET /api/users/leaderboard/top` - Get top users

### Trivia
- `GET /api/trivia/questions` - Get trivia questions
- `POST /api/trivia/answer` - Submit trivia answer
- `GET /api/trivia/history/:userId` - Get user trivia history

### Fitness
- `POST /api/fitness/activity` - Log fitness activity
- `GET /api/fitness/activities/:userId` - Get user activities
- `GET /api/fitness/stats/:userId` - Get fitness statistics

### Leaderboard
- `GET /api/leaderboard/global` - Get global leaderboard
- `GET /api/leaderboard/weekly` - Get weekly leaderboard
- `GET /api/leaderboard/monthly` - Get monthly leaderboard

## 🔐 Security Features

- JWT-based authentication
- Password hashing with bcrypt
- Input validation and sanitization
- CORS protection
- Rate limiting (to be implemented)
- Environment-based configuration

## 🗄️ Database Models

- **User** - User profiles and authentication
- **Trivia** - Trivia questions and answers
- **TriviaAttempt** - User trivia attempt history
- **FitnessActivity** - User fitness activities
- **Leaderboard** - Leaderboard entries

## 📝 Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| PORT | Server port | Yes |
| MONGODB_URI | MongoDB connection string | Yes |
| JWT_SECRET | Secret for JWT signing | Yes |
| NODE_ENV | Environment (development/production) | Yes |

## 🧪 Testing

Run tests with:
```bash
npm test
```

## 🚢 Deployment

For production deployment:
1. Set `NODE_ENV=production`
2. Use a production MongoDB instance
3. Generate a strong `JWT_SECRET`
4. Configure HTTPS
5. Set up environment variables on your hosting platform

## 📞 Support

For issues or questions, please create an issue in the repository.
