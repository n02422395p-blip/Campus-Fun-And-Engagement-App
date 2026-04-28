# 🎉 NUST Fun & Engagement App

 ## 📖 Description

The **NUST Fun & Engagement App** is a mobile application developed using Flutter, designed to enhance student interaction and participation through engaging and interactive features. The app provides a centralized platform where users can take part in activities such as trivia challenges, fitness tracking, and leaderboard competitions.

The goal of this project is to promote student engagement, encourage healthy competition, and provide a fun digital environment within the university community.



## 🚀 Features

* 🔐 User Authentication (Register & Login)
* 🧠 Trivia Challenges
* 🏃 Fitness Activity Tracking
* 🏆 Leaderboard System
* 👤 User Profile Management
* 🔔 Notifications (Planned)
* 🌐 Integration with a JSON-based backend



## 🛠️ Technologies Used

* **Flutter** – Frontend mobile development framework
* **Dart** – Programming language
* **JSON Server** – Fake backend for API simulation
* **Git & GitHub** – Version control and collaboration



## 📂 Project Structure


nust_fun_engagement/
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
 │
 ├── pubspec.yaml
 └── README.md




## ⚙️ Setup Instructions

### 1. Clone the Repository


git clone https://github.com/n02422395p-blip/Campus-Fun-And-Engagement-App


### 2. Navigate to the Project Directory


cd nust_fun_engagement


### 3. Install Dependencies


flutter pub get


### 4. Run the Fake Backend

Make sure you have Node.js installed, then run:


json-server --watch backend/db.json --port 3000


### 5. Run the Application


flutter run




## 🌐 API Endpoints

The application uses a fake REST API powered by JSON Server.

* `GET /users` – Retrieve all users
* `POST /users` – Create a new user
* `GET /scores` – Retrieve leaderboard scores
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


