# 🎉 NUST Fun & Engagement App

 ## 📖 Description

The **NUST Fun & Engagement App** is a mobile application developed using Flutter, designed to enhance student interaction and participation through engaging and interactive features. The app provides a centralized platform where users can take part in activities such as trivia challenges and leaderboard competitions.

The goal of this project is to promote student engagement, encourage healthy competition, and provide a fun digital environment within the university community.

**Status**: ✅ All features fully connected to backend APIs!

## 🚀 Features

* 🧠 **Trivia Challenges** - Connected to backend
* 🏆 **Leaderboard System** - Real-time rankings
* 👤 **User Profile Management** - Create and edit profiles
* 🔔 **Notifications** (Planned)

## 🛠️ Technologies Used

* **Flutter** – Frontend mobile development framework
* **Dart** – Programming language
* **Provider** – State management
* **HTTP** – API communication
* **JSON Server** – Backend REST API
* **Git & GitHub** – Version control

## 📂 Project Structure

```
nust_fun_engagement/
<<<<<<< Updated upstream
├── lib/
│   ├── main.dart
│   ├── models/
│   │   ├── trivia_model.dart
│   │   ├── leaderboard_model.dart
│   │   └── user_model.dart
│   ├── screens/
│   │   ├── trivia/
│   │   │   └── trivia_screen.dart
│   │   ├── leaderboard/
│   │   │   └── leaderboard_screen.dart
│   │   └── profile/
│   │       └── profile_screen.dart
│   ├── services/
│   │   └── api_service.dart
│   ├── providers/
│   │   ├── trivia_provider.dart
│   │   ├── leaderboard_provider.dart
│   │   └── profile_provider.dart
│   └── widgets/
│
├── backend/
│   └── db.json
│
├── pubspec.yaml
├── BACKEND_INTEGRATION.md
└── README.md
```
=======
 ├── lib/
 │    ├── main.dart
 │    ├── models/
 │    ├── screens/
 │    │    ├── auth/
 │    │    ├── trivia/
 │    │    ├── fitness/
 │    │    ├── leaderboard/
 │    │    └── profile/
 │    ├── services/
 │    ├── widgets/
 │    └── providers/
 │
 ├── backend/
 │    └── db.json



## 🏁 Getting Started

### Prerequisites

- Flutter SDK installed
- Node.js installed (for JSON Server)
- VS Code or preferred IDE

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/nust-fun-engagement.git
   cd nust-fun-engagement
   ```

2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. Start the backend server:
   ```bash
   cd backend
   npx json-server --watch db.json --port 3000
   ```

4. Run the Flutter app:
   ```bash
   flutter run -d chrome
   ```

### Usage

- Register a new account or login with existing credentials
- Navigate through trivia, fitness, leaderboard, and profile sections
- Earn points by completing challenges and quizzes
- View your ranking on the leaderboard

## 👥 Team Responsibilities

- **Delight**: Project Manager, Leaderboard & Profile UI
- **Tapiwanashe & Gamuchirai**: UI/UX Designers
- **Nothando**: Frontend (Auth & Navigation)
- **Tabani**: Frontend (Trivia)
- **Tanaka**: Frontend (Fitness)
- **Laura**: Profile UI Support
- **Tanatswa**: Backend (Authentication)
- **Rakim**: Backend (Database & API)
- **Emmanuel**: Integration

## 📅 Project Timeline

- **Week 1**: Setup & UI/UX Design
- **Week 2**: Backend Setup & Authentication
- **Week 3-4**: Core Feature Development
- **Week 5**: Integration & Testing
- **Week 6**: Final Polish & Demo
 │
 ├── pubspec.yaml
 └── README.md



>>>>>>> Stashed changes

## ⚙️ Setup Instructions

### Prerequisites
- Flutter SDK (3.0+)
- Dart SDK
- Node.js (for JSON Server)
- Git

### 1. Clone the Repository

```bash
git clone https://github.com/n02422395p-blip/Campus-Fun-And-Engagement-App
cd Campus-Fun-And-Engagement-App
```

### 2. Install Flutter Dependencies

```bash
cd nust_fun_engagement
flutter pub get
```

### 3. Install and Run Backend

```bash
# Install JSON Server globally (if not already)
npm install -g json-server

# From the project root directory
json-server --watch backend/db.json --port 3000
```

The backend will be available at `http://localhost:3000`

### 4. Run the Application

In a new terminal:

```bash
# From nust_fun_engagement directory
flutter run
```

## 📡 Backend Integration

All features are fully integrated with the backend:

### **Trivia Feature** 🧠
- Fetches quiz questions from backend
- Submits user answers and scores
- Tracks user's score history
- Calculates points per correct answer (100 pts)

### **Leaderboard Feature** 🏆
- Retrieves all user rankings
- Displays scores sorted by performance
- Shows accuracy percentages
- Allows real-time ranking updates
- Pull-to-refresh functionality

### **Profile Feature** 👤
- Loads user profile information
- Allows editing of name and bio
- Persists changes to backend
- Displays student details (ID, department, joined date)

For detailed technical documentation, see [BACKEND_INTEGRATION.md](BACKEND_INTEGRATION.md)

## 🌐 API Endpoints

### Trivia
- `GET /trivia` – Retrieve all trivia questions
- `GET /trivia/:id` – Get specific question
- `POST /userScores` – Submit user's answer
- `GET /userScores?userId=:id` – Get user's score history

### Leaderboard
- `GET /leaderboard` – Retrieve all leaderboard entries
- `PATCH /leaderboard/:id` – Update leaderboard entry

### Users/Profile
- `GET /users` – Retrieve all users
- `GET /users/:id` – Retrieve specific user
- `POST /users` – Create new user
- `PATCH /users/:id` – Update user profile

## 🎮 How to Use

### Trivia
1. Navigate to the "Trivia" tab
2. Answer multiple-choice questions
3. Get instant feedback and points
4. Complete the quiz to see your score

### Leaderboard
1. Navigate to the "Leaderboard" tab
2. View your rank and score
3. Compare with other students
4. Pull down to refresh rankings

### Profile
1. Navigate to the "Profile" tab
2. View your student information
3. Tap the edit icon to update your profile
4. Save changes to persist to backend

## 🚀 Running in Different Modes

### Development Mode
```bash
flutter run -v
```

### Release Mode
```bash
flutter run --release
```

## 🔧 Configuration

To change the backend URL, edit `lib/services/api_service.dart`:
```dart
static const String baseUrl = 'http://localhost:3000';
```

## 📊 Database Schema

The backend uses `db.json` with the following structure:
- `users` - Student profiles
- `trivia` - Quiz questions
- `leaderboard` - User rankings
- `userScores` - Individual answer records

## 🐛 Troubleshooting

### Backend not connecting?
- Ensure JSON Server is running on port 3000
- Check that `http://localhost:3000` is accessible
- Verify `backend/db.json` exists and is valid JSON

### App crashes on startup?
- Run `flutter pub get` to install dependencies
- Check that all imports are correct
- Verify Dart version compatibility

### Data not updating?
- Refresh the screen (pull-to-refresh on leaderboard)
- Check network connection
- Verify backend is running

## 📝 Development Notes

- The app uses Provider for state management
- All API calls are centralized in `ApiService`
- User ID defaults to 1 (can be made dynamic with authentication)
- Backend uses ISO8601 timestamps

## 🤝 Contributing

1. Create a new branch for your feature
2. Commit your changes
3. Push to GitHub
4. Create a Pull Request

## 📄 License

This project is part of NUST student engagement initiative.

## 👥 Team

- Frontend: Flutter with Dart
- Backend: JSON Server
- Project: Campus Fun & Engagement App
* `POST /scores` – Add new score



## 👥 Team Members

* Delight Matiure
* Courage Dadirai
* Tapiwanashe Dumbarimwe
* Nothando Moyo
* Gamuchirai Mafuta
* Tabani Sibanda
* Laurah Chimuka
* Tanatswa Nhambu
* Rakim Chadehumbe
* Tanaka Pasipanodya



## 📌 Future Improvements

* Integration with a real backend (Firebase / Node.js)
* Push notifications for updates and reminders
* Enhanced UI/UX animations
* Real-time leaderboard updates
* Social sharing features




## 📄 License

This project is for educational purposes only.


## 🙌 Acknowledgements

Special thanks to our lecturers and peers for guidance and support throughout the development of this project.


