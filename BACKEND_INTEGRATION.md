# Backend Integration Guide

This document describes how all frontend features are connected to the backend APIs.

## Overview

The NUST Fun & Engagement App uses a Flutter frontend with a JSON Server-based REST API backend. All features (Trivia, Leaderboard, Profile) fetch and store data through HTTP calls to the backend.

## Architecture

### API Service (`lib/services/api_service.dart`)

The `ApiService` class is the central point for all backend communication. It provides static methods for:

- **Trivia Management**: Fetch questions, submit answers
- **Leaderboard**: Retrieve rankings, update scores
- **User Profiles**: Get/update user data, create users

All API calls use the `http` package and communicate with the backend at `http://localhost:3000`.

### Data Models

Three main models handle data serialization:

1. **TriviaQuestion** & **UserScore** (`lib/models/trivia_model.dart`)
   - `TriviaQuestion`: Quiz questions with multiple choice options
   - `UserScore`: Records of user's answers and points

2. **LeaderboardEntry** (`lib/models/leaderboard_model.dart`)
   - Represents user rankings with scores and accuracy metrics

3. **User** (`lib/models/user_model.dart`)
   - Student profile information including name, email, department, bio

### State Management (Providers)

Three providers manage the app state and API interactions:

1. **TriviaProvider** (`lib/providers/trivia_provider.dart`)
   - Manages trivia questions and user scores
   - Submits answers to backend via `ApiService.submitTriviaAnswer()`
   - Fetches user's score history via `ApiService.getUserScores()`

2. **LeaderboardProvider** (`lib/providers/leaderboard_provider.dart`)
   - Fetches and maintains leaderboard rankings
   - Updates entries via `ApiService.updateLeaderboardEntry()`
   - Provides ranking utilities

3. **ProfileProvider** (`lib/providers/profile_provider.dart`)
   - Manages user profile data
   - Fetches profile via `ApiService.getUserById()`
   - Updates profile via `ApiService.updateUserProfile()`

## Feature Integration Details

### 1. Trivia Feature

**Flow:**
1. User navigates to Trivia screen
2. `TriviaScreen` loads and calls `TriviaProvider.fetchTriviaQuestions()`
3. Provider calls `ApiService.getTriviaQuestions()` → Backend `/trivia` endpoint
4. Questions displayed from `provider.questions` list
5. User selects answer and taps submit
6. `TriviaProvider.submitAnswer()` calls `ApiService.submitTriviaAnswer()`
7. Answer submitted to backend `/userScores` endpoint
8. Score updated in UI

**Backend Endpoints Used:**
- `GET /trivia` - Fetch all trivia questions
- `POST /userScores` - Submit user's answer

### 2. Leaderboard Feature

**Flow:**
1. User navigates to Leaderboard screen
2. `LeaderboardScreen` loads and calls `LeaderboardProvider.fetchLeaderboard()`
3. Provider calls `ApiService.getLeaderboard()` → Backend `/leaderboard` endpoint
4. Rankings sorted by score and displayed
5. User can refresh to update rankings
6. Current user's entry highlighted in blue

**Backend Endpoints Used:**
- `GET /leaderboard` - Fetch all leaderboard entries
- `PATCH /leaderboard/{id}` - Update leaderboard entry (score, accuracy)

**Features:**
- Auto-ranking based on score
- Accuracy percentage calculation
- Pull-to-refresh functionality
- Current user highlighting

### 3. Profile Feature

**Flow:**
1. User navigates to Profile screen
2. `ProfileScreen` loads and calls `ProfileProvider.fetchUserProfile(userId)`
3. Provider calls `ApiService.getUserById(userId)` → Backend `/users/{id}` endpoint
4. User data displayed (read-only view)
5. User taps edit button
6. Edit mode displays text fields for name and bio
7. User saves changes
8. `ProfileProvider.updateUserProfile()` calls `ApiService.updateUserProfile()`
9. Changes sent to backend PATCH `/users/{id}` endpoint
10. UI updates with new data

**Backend Endpoints Used:**
- `GET /users` - Fetch all users
- `GET /users/{id}` - Fetch specific user profile
- `POST /users` - Create new user
- `PATCH /users/{id}` - Update user profile

## Backend Setup

### Database (`backend/db.json`)

Contains four main collections:

```json
{
  "users": [...],           // Student profiles
  "trivia": [...],          // Quiz questions
  "leaderboard": [...],     // Score rankings
  "userScores": [...]       // Individual answer records
}
```

### Running the Backend

```bash
# Install JSON Server globally (if not already)
npm install -g json-server

# From project root
json-server --watch backend/db.json --port 3000
```

Backend will be accessible at `http://localhost:3000`

## Running the Frontend

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run
```

## API Endpoints Reference

| Feature | Method | Endpoint | Purpose |
|---------|--------|----------|---------|
| Trivia | GET | `/trivia` | Fetch all questions |
| Trivia | POST | `/userScores` | Submit user answer |
| Trivia | GET | `/userScores?userId={id}` | Get user's score history |
| Leaderboard | GET | `/leaderboard` | Fetch rankings |
| Leaderboard | PATCH | `/leaderboard/{id}` | Update score entry |
| Profile | GET | `/users` | Fetch all users |
| Profile | GET | `/users/{id}` | Fetch user profile |
| Profile | POST | `/users` | Create new user |
| Profile | PATCH | `/users/{id}` | Update user profile |

## Error Handling

All API calls include error handling:
- Network errors are caught and displayed to user
- Providers maintain error state accessible to UI
- Retry buttons available in error states
- User-friendly error messages shown in SnackBars

## Data Flow Diagram

```
User Action
    ↓
Screen Widget
    ↓
Provider (State Management)
    ↓
ApiService (HTTP Calls)
    ↓
Backend (JSON Server)
    ↓
Database (db.json)
```

## Testing the Integration

1. **Start Backend**: `json-server --watch backend/db.json --port 3000`
2. **Start App**: `flutter run`
3. **Test Trivia**: Take a quiz, verify answers in backend
4. **Test Leaderboard**: Check scores appear in leaderboard
5. **Test Profile**: View and edit profile, verify changes persist

## Notes

- User ID defaults to 1 in the main app (can be made dynamic with authentication)
- All timestamps use ISO8601 format
- Points are awarded as 100 per correct answer
- Accuracy percentage calculated from correct answers / total questions
- Backend runs on `localhost:3000` (can be configured in `ApiService.baseUrl`)
