# 👶 Children Tracking in Nursery Using Face Recognition

A Flutter mobile application that allows parents to monitor their children inside the nursery through cameras, using face detection technology.

---

## 📱 About the Project

This project was developed as a graduation project at **Taibah University** – College of Computer Science and Engineering.

Many parents worry about leaving their children in nurseries. This application provides a solution by enabling parents to:
- Monitor their children remotely through cameras
- Receive real-time updates about their child's status
- Communicate quickly with nursery staff in emergencies

---

## ✨ Features

- 🔐 Parent registration & login (Firebase Authentication)
- 👶 Add and manage child profiles with photos
- 📷 Real-time face detection using Google ML Kit
- 🎥 Live camera monitoring
- 💬 Communication between parents and nursery admin
- 🔑 Password reset via email
- 🌐 Supports Arabic & English

---

## 🛠️ Technologies Used

| Technology | Purpose |
|---|---|
| Flutter / Dart | Mobile app development |
| Firebase Authentication | User login & registration |
| Cloud Firestore | Database |
| Firebase Storage | Store child images |
| Google ML Kit Face Detection | Face detection algorithm |
| Android Studio | Android emulator |

---

## 🧠 Face Detection Algorithm

The app uses **Google ML Kit Face Detection**, which is based on the **Viola-Jones algorithm** — the same algorithm specified in the project requirements. ML Kit provides an optimized, Flutter-ready implementation of this algorithm with:

- Viola-Jones Haar Cascade for face detection
- Face landmark detection (eyes, nose, mouth)
- Real-time processing via device camera

---

## 📂 Project Structure

```
lib/
├── main.dart
├── auth.dart
├── camera_view.dart
├── face_detector_page.dart
├── home_page.dart
├── screens/
│   ├── login_screen.dart
│   ├── signup1_screen.dart
│   ├── signup2_screen.dart
│   ├── forgot_pass_screen.dart
│   ├── parent_screen.dart
│   ├── parentsProfile_screen.dart
│   ├── admin_screen.dart
│   ├── SendRequest_screen.dart
│   ├── Database.dart
│   ├── Read_Data.dart
│   └── model.dart
└── util/
    ├── face_detector_painter.dart
    ├── coordinates_painter.dart
    └── screen_mode.dart
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK
- Android Studio (for emulator)
- Firebase project configured

### Installation

```bash
git clone https://github.com/itseham1/children-tracking-nursery.git
cd children-tracking-nursery
flutter pub get
flutter run
```

---

## 👥 Team Members

| Name | Student ID |
|---|---|
| Afnan Nasser Al Hujaili | 3755535 |
| Amjad Fawzi Al Amri | 4050286 |
| Ebtihal Saad Al Hajili | 3756797 |
| Seham Sultan Matouq | 4050089 |

**Supervised by:** Dr. Ibtehal Talal Nafea

**Taibah University** – College of Computer Science and Engineering (Girls Section)
Academic Year 1443/1444 (2022/2023)

---

## 📸 Screenshots

_Coming soon_

---

## 📄 License

This project was developed for academic purposes at Taibah University.
