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



Group 9

1. Rakim Chadehumbe N02425811N
2. ⁠ Tapiwanashe Dumbarimwe (N02418943X)
3. ⁠ Nothando L Moyo (N02421539A)
4. ⁠Laurah T Chimuka (N02422178Q)
5. ⁠Delight Matiure (N02422395P)
6. ⁠Gamuchirai Mafuta (N02422353F)
7. ⁠Tanatswa Nhambu (N02420739F)
8. Courage Dadirai (N02422699K)
9. ⁠Tabani Sibanda (N02422735V)
10. ⁠Tanaka Pasipanodya (N02420526P)
