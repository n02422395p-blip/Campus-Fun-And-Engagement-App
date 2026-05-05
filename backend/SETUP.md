# 🚀 Quick Start Guide

## Prerequisites
- Node.js 14+ installed
- MongoDB installed locally OR MongoDB Atlas account for cloud
- npm or yarn package manager

## Setup Steps

### 1. Install Dependencies
```bash
cd backend
npm install
```

### 2. Configure Environment
```bash
# Copy the example environment file
cp .env.example .env

# Edit .env with your settings
# Important: Update these values:
# - MONGODB_URI: Your MongoDB connection string
# - JWT_SECRET: A strong random string
```

### 3. Start the Server

#### Option A: Development Mode (with auto-reload)
```bash
npm run dev
```

#### Option B: Production Mode
```bash
npm start
```

The server will start on `http://localhost:5000`

### 4. Verify Installation
Open your browser and visit:
```
http://localhost:5000/api/health
```

You should see:
```json
{
  "success": true,
  "message": "Backend is running",
  "timestamp": "2024-05-04T10:30:00Z"
}
```

---

## Using Docker (Optional)

### 1. Install Docker and Docker Compose

### 2. Start Services
```bash
docker-compose up -d
```

This will:
- Start MongoDB on port 27017
- Start the backend server on port 5000

### 3. View Logs
```bash
docker-compose logs -f backend
```

### 4. Stop Services
```bash
docker-compose down
```

---

## MongoDB Setup

### Local MongoDB

#### Windows
1. Download MongoDB Community from https://www.mongodb.com/try/download/community
2. Install and follow the installer
3. MongoDB will run on `mongodb://localhost:27017`

#### Mac (using Homebrew)
```bash
brew tap mongodb/brew
brew install mongodb-community
brew services start mongodb-community
```

#### Linux (Ubuntu/Debian)
```bash
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list
apt-get update
apt-get install -y mongodb-org
sudo systemctl start mongod
```

### Cloud MongoDB (MongoDB Atlas)

1. Go to https://www.mongodb.com/cloud/atlas
2. Create an account and login
3. Create a new cluster
4. Get your connection string
5. Update `MONGODB_URI` in `.env`:
```
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/nust-engagement?retryWrites=true&w=majority
```

---

## Testing the API

### Using Postman

1. Download Postman from https://www.postman.com/downloads/
2. Import the collection from `postman-collection.json` (create this file with your requests)

### Using cURL

#### 1. Register User
```bash
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "password": "password123",
    "registrationNumber": "NUST-TEST-001",
    "department": "Engineering"
  }'
```

#### 2. Login
```bash
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

#### 3. Get Users
```bash
curl -X GET http://localhost:5000/api/users?limit=10
```

---

## Project Structure

```
backend/
├── src/
│   ├── config/
│   │   └── database.js           # MongoDB connection
│   ├── controllers/
│   │   ├── authController.js     # Auth logic
│   │   ├── userController.js     # User management
│   │   ├── triviaController.js   # Trivia logic
│   │   ├── fitnessController.js  # Fitness tracking
│   │   └── leaderboardController.js # Leaderboard logic
│   ├── middleware/
│   │   ├── auth.js               # Authentication middleware
│   │   └── validation.js         # Input validation
│   ├── models/
│   │   ├── User.js               # User schema
│   │   ├── Trivia.js             # Trivia schema
│   │   ├── TriviaAttempt.js      # Trivia attempts
│   │   ├── FitnessActivity.js    # Fitness activities
│   │   └── Leaderboard.js        # Leaderboard schema
│   ├── routes/
│   │   ├── authRoutes.js         # Auth endpoints
│   │   ├── userRoutes.js         # User endpoints
│   │   ├── triviaRoutes.js       # Trivia endpoints
│   │   ├── fitnessRoutes.js      # Fitness endpoints
│   │   └── leaderboardRoutes.js  # Leaderboard endpoints
│   ├── utils/
│   │   ├── helpers.js            # Helper functions
│   │   └── sampleData.js         # Sample data
│   └── index.js                  # Main server file
├── .env.example                  # Environment variables template
├── .gitignore                    # Git ignore rules
├── docker-compose.yml            # Docker compose config
├── Dockerfile                    # Docker image config
├── package.json                  # Dependencies
├── README.md                     # Project README
├── SETUP.md                      # This file
└── API_DOCUMENTATION.md          # API documentation
```

---

## Troubleshooting

### MongoDB Connection Error
```
Error: Error connecting to MongoDB
```
**Solution:**
- Check MongoDB is running: `mongosh` (MongoDB Shell)
- Verify `MONGODB_URI` in `.env`
- Check network connectivity if using cloud MongoDB

### Port Already in Use
```
Error: listen EADDRINUSE: address already in use :::5000
```
**Solution:**
```bash
# Kill process on port 5000
lsof -ti:5000 | xargs kill -9
```

### JWT Error
```
Error: Not authorized to access this route
```
**Solution:**
- Include `Authorization: Bearer <token>` header
- Ensure token is not expired
- Check `JWT_SECRET` matches in `.env`

### Validation Error
```
Error: Validation failed
```
**Solution:**
- Check request body matches schema
- See API_DOCUMENTATION.md for required fields
- Validate email format, password length, etc.

---

## Environment Variables Reference

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| PORT | Server port | 5000 | No |
| NODE_ENV | Environment mode | development | No |
| MONGODB_URI | MongoDB connection string | localhost | Yes |
| JWT_SECRET | JWT signing secret | none | Yes |
| JWT_EXPIRE | JWT expiration time | 7d | No |

---

## Next Steps

1. ✅ Install dependencies
2. ✅ Configure MongoDB
3. ✅ Set up environment variables
4. ✅ Start the server
5. 📖 Read [API_DOCUMENTATION.md](API_DOCUMENTATION.md)
6. 🧪 Test endpoints with Postman or cURL
7. 🚀 Deploy to production

For detailed API information, see [API_DOCUMENTATION.md](API_DOCUMENTATION.md)
