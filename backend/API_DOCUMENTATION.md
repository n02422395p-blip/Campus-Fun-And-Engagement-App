# 🚀 API Documentation - NUST Fun & Engagement Backend

## Base URL
```
http://localhost:5000/api
```

## Authentication
Most endpoints require a JWT token passed in the Authorization header:
```
Authorization: Bearer <token>
```

---

## 🔐 Authentication Endpoints

### 1. Register User
**POST** `/auth/register`

Register a new user account.

**Request Body:**
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "registrationNumber": "NUST-001",
  "department": "Engineering"
}
```

**Response (201):**
```json
{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "507f1f77bcf86cd799439011",
    "name": "John Doe",
    "email": "john@example.com",
    "registrationNumber": "NUST-001",
    "department": "Engineering"
  }
}
```

---

### 2. Login User
**POST** `/auth/login`

Login with email and password.

**Request Body:**
```json
{
  "email": "john@example.com",
  "password": "password123"
}
```

**Response (200):**
```json
{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "507f1f77bcf86cd799439011",
    "name": "John Doe",
    "email": "john@example.com",
    "registrationNumber": "NUST-001",
    "totalPoints": 250,
    "lastLogin": "2024-05-04T10:30:00Z"
  }
}
```

---

### 3. Get Current User
**GET** `/auth/me`

Requires authentication.

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": "507f1f77bcf86cd799439011",
    "name": "John Doe",
    "email": "john@example.com",
    "totalPoints": 250,
    "triviaScore": 100,
    "fitnessScore": 150,
    "createdAt": "2024-01-15T00:00:00Z"
  }
}
```

---

## 👤 User Endpoints

### 1. Get All Users
**GET** `/users?page=1&limit=20&sortBy=totalPoints`

Get list of all active users.

**Query Parameters:**
- `page` (default: 1) - Page number
- `limit` (default: 20) - Items per page
- `sortBy` (default: totalPoints) - Sort field

**Response (200):**
```json
{
  "success": true,
  "total": 150,
  "count": 20,
  "data": [
    {
      "id": "507f1f77bcf86cd799439011",
      "name": "John Doe",
      "registrationNumber": "NUST-001",
      "department": "Engineering",
      "totalPoints": 250,
      "triviaScore": 100,
      "fitnessScore": 150
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "pages": 8
  }
}
```

---

### 2. Get User Profile
**GET** `/users/:id`

Requires authentication.

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": "507f1f77bcf86cd799439011",
    "name": "John Doe",
    "email": "john@example.com",
    "bio": "I love trivia and fitness!",
    "totalPoints": 250,
    "registrationNumber": "NUST-001",
    "department": "Engineering"
  }
}
```

---

### 3. Update User Profile
**PUT** `/users/:id`

Requires authentication. Must be the user's own profile.

**Request Body:**
```json
{
  "name": "John Doe",
  "bio": "Updated bio",
  "department": "Science"
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": "507f1f77bcf86cd799439011",
    "name": "John Doe",
    "bio": "Updated bio",
    "department": "Science"
  }
}
```

---

### 4. Get User Statistics
**GET** `/users/:id/stats`

Requires authentication.

**Response (200):**
```json
{
  "success": true,
  "data": {
    "user": {
      "name": "John Doe",
      "totalPoints": 250,
      "triviaScore": 100,
      "fitnessScore": 150
    },
    "trivia": {
      "totalAttempts": 25,
      "correctAnswers": 18,
      "accuracy": "72.00"
    },
    "fitness": {
      "activitiesLogged": 10,
      "totalDuration": 450,
      "totalCalories": 4500
    }
  }
}
```

---

### 5. Get Top Users
**GET** `/users/top/:limit`

Get top N users by points.

**Response (200):**
```json
{
  "success": true,
  "count": 10,
  "data": [
    {
      "id": "507f1f77bcf86cd799439011",
      "name": "John Doe",
      "registrationNumber": "NUST-001",
      "totalPoints": 500
    }
  ]
}
```

---

## 🧠 Trivia Endpoints

### 1. Get Trivia Questions
**GET** `/trivia/questions?category=Science&difficulty=Medium&page=1&limit=10`

Get trivia questions.

**Query Parameters:**
- `category` - Filter by category
- `difficulty` - Easy, Medium, Hard
- `page` - Page number
- `limit` - Items per page

**Response (200):**
```json
{
  "success": true,
  "total": 100,
  "count": 10,
  "data": [
    {
      "id": "507f1f77bcf86cd799439012",
      "question": "What is the capital of France?",
      "options": ["Paris", "London", "Berlin", "Madrid"],
      "category": "General Knowledge",
      "difficulty": "Easy",
      "points": 10
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "pages": 10
  }
}
```

---

### 2. Submit Trivia Answer
**POST** `/trivia/answer`

Requires authentication.

**Request Body:**
```json
{
  "triviaId": "507f1f77bcf86cd799439012",
  "selectedAnswer": 0,
  "timeSpent": 45
}
```

**Response (201):**
```json
{
  "success": true,
  "data": {
    "attempt": {
      "id": "507f1f77bcf86cd799439013",
      "userId": "507f1f77bcf86cd799439011",
      "isCorrect": true,
      "pointsEarned": 10,
      "timeSpent": 45
    },
    "isCorrect": true,
    "pointsEarned": 10,
    "explanation": "Paris is indeed the capital of France.",
    "correctAnswer": "Paris",
    "userTotalPoints": 260
  }
}
```

---

### 3. Get Trivia History
**GET** `/trivia/history/:userId?page=1&limit=20`

Requires authentication.

**Response (200):**
```json
{
  "success": true,
  "total": 25,
  "count": 20,
  "accuracy": "72.00",
  "data": [
    {
      "id": "507f1f77bcf86cd799439013",
      "triviaId": {
        "question": "What is the capital of France?",
        "options": ["Paris", "London", "Berlin", "Madrid"],
        "category": "General Knowledge",
        "difficulty": "Easy"
      },
      "selectedAnswer": 0,
      "isCorrect": true,
      "pointsEarned": 10,
      "attemptedAt": "2024-05-04T10:30:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "pages": 2
  }
}
```

---

### 4. Get Categories
**GET** `/trivia/categories`

Get all available trivia categories.

**Response (200):**
```json
{
  "success": true,
  "data": ["General Knowledge", "Science", "History", "Sports", "Technology", "Entertainment"]
}
```

---

## 🏃 Fitness Endpoints

### 1. Log Fitness Activity
**POST** `/fitness/activity`

Requires authentication.

**Request Body:**
```json
{
  "activityType": "Running",
  "duration": 30,
  "distance": 5.5,
  "caloriesBurned": 350,
  "intensity": "High",
  "notes": "Morning run in the park",
  "activityDate": "2024-05-04T06:00:00Z"
}
```

**Response (201):**
```json
{
  "success": true,
  "data": {
    "activity": {
      "id": "507f1f77bcf86cd799439014",
      "userId": "507f1f77bcf86cd799439011",
      "activityType": "Running",
      "duration": 30,
      "distance": 5.5,
      "caloriesBurned": 350,
      "intensity": "High",
      "pointsEarned": 15,
      "activityDate": "2024-05-04T06:00:00Z"
    },
    "pointsEarned": 15,
    "userTotalPoints": 275
  }
}
```

---

### 2. Get User Activities
**GET** `/fitness/activities/:userId?page=1&limit=20&startDate=2024-01-01&endDate=2024-05-04`

Requires authentication.

**Query Parameters:**
- `page` - Page number
- `limit` - Items per page
- `startDate` - Filter from date
- `endDate` - Filter to date

**Response (200):**
```json
{
  "success": true,
  "total": 15,
  "count": 10,
  "data": [
    {
      "id": "507f1f77bcf86cd799439014",
      "activityType": "Running",
      "duration": 30,
      "distance": 5.5,
      "caloriesBurned": 350,
      "intensity": "High",
      "pointsEarned": 15,
      "activityDate": "2024-05-04T06:00:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "pages": 1
  }
}
```

---

### 3. Get Fitness Statistics
**GET** `/fitness/stats/:userId`

Requires authentication.

**Response (200):**
```json
{
  "success": true,
  "data": {
    "totalActivities": 15,
    "totalDuration": 450,
    "totalDistance": 75.5,
    "totalCalories": 4500,
    "totalPoints": 150,
    "averageIntensity": 2.1,
    "activityBreakdown": {
      "Running": {
        "count": 8,
        "duration": 240,
        "points": 80
      },
      "Gym": {
        "count": 5,
        "duration": 150,
        "points": 50
      },
      "Yoga": {
        "count": 2,
        "duration": 60,
        "points": 20
      }
    }
  }
}
```

---

### 4. Update Fitness Activity
**PUT** `/fitness/activity/:id`

Requires authentication. Must be the user's own activity.

**Request Body:**
```json
{
  "duration": 45,
  "caloriesBurned": 450,
  "intensity": "High"
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "activity": {
      "id": "507f1f77bcf86cd799439014",
      "duration": 45,
      "caloriesBurned": 450,
      "pointsEarned": 22
    },
    "pointsChange": 7,
    "userTotalPoints": 282
  }
}
```

---

### 5. Delete Fitness Activity
**DELETE** `/fitness/activity/:id`

Requires authentication.

**Response (200):**
```json
{
  "success": true,
  "message": "Activity deleted successfully",
  "userTotalPoints": 260
}
```

---

## 🏆 Leaderboard Endpoints

### 1. Get Global Leaderboard
**GET** `/leaderboard/global?page=1&limit=20`

Get global leaderboard.

**Response (200):**
```json
{
  "success": true,
  "total": 150,
  "count": 20,
  "data": [
    {
      "rank": 1,
      "id": "507f1f77bcf86cd799439011",
      "name": "John Doe",
      "registrationNumber": "NUST-001",
      "department": "Engineering",
      "totalPoints": 500,
      "triviaScore": 200,
      "fitnessScore": 300
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "pages": 8
  }
}
```

---

### 2. Get Weekly Leaderboard
**GET** `/leaderboard/weekly?page=1&limit=20`

Get leaderboard for current week.

**Response (200):**
```json
{
  "success": true,
  "total": 150,
  "count": 20,
  "weekStart": "2024-04-29",
  "data": [
    {
      "rank": 1,
      "id": "507f1f77bcf86cd799439011",
      "name": "John Doe",
      "weeklyPoints": 150
    }
  ]
}
```

---

### 3. Get Monthly Leaderboard
**GET** `/leaderboard/monthly?page=1&limit=20`

Get leaderboard for current month.

**Response (200):**
```json
{
  "success": true,
  "total": 150,
  "count": 20,
  "monthStart": "2024-05-01",
  "data": [
    {
      "rank": 1,
      "id": "507f1f77bcf86cd799439011",
      "name": "John Doe",
      "monthlyPoints": 450
    }
  ]
}
```

---

### 4. Get User Rank
**GET** `/leaderboard/rank/:userId`

Requires authentication.

**Response (200):**
```json
{
  "success": true,
  "data": {
    "userId": "507f1f77bcf86cd799439011",
    "name": "John Doe",
    "rank": 5,
    "totalPoints": 400,
    "triviaScore": 150,
    "fitnessScore": 250
  }
}
```

---

## 🏥 Health Check

### Health Status
**GET** `/health`

Check if the backend is running.

**Response (200):**
```json
{
  "success": true,
  "message": "Backend is running",
  "timestamp": "2024-05-04T10:30:00Z"
}
```

---

## Error Handling

All endpoints return standardized error responses:

```json
{
  "success": false,
  "message": "Error description",
  "errors": [
    {
      "field": "email",
      "message": "Please provide a valid email"
    }
  ]
}
```

### Common Status Codes
- `200` - Success
- `201` - Resource created
- `400` - Bad request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not found
- `500` - Server error
