# 🎯 E-Trainer Mobile

> **Interactive Flutter learning platform with Vietnamese interface and modern Material 3 design**

[![Flutter](https://img.shields.io/badge/Flutter-3.32.7-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.5.0-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Build Status](https://img.shields.io/badge/Build-Passing-brightgreen.svg)](#)

## 📱 About E-Trainer

E-Trainer is a comprehensive mobile learning platform built with Flutter, featuring an interactive journey-based learning system, Vietnamese interface, and modern Material 3 design. The app provides an engaging educational experience with animations, quizzes, and progress tracking.

## ✨ Features

### 🔐 **Authentication System**
- Google Sign-in integration
- Secure user authentication
- Profile management

### 🗺️ **Journey-Based Learning**
- Interactive learning stages
- Progress tracking system
- Daily lesson recommendations
- Stage completion rewards

### 🧠 **Interactive Quizzes**
- Timer-based quiz system
- Real-time feedback
- Multiple choice questions
- Animated transitions
- Performance analytics

### 🎨 **Modern UI/UX**
- Material 3 design system
- Vietnamese interface
- Dark/Light theme support
- Smooth animations and transitions
- Responsive design

### 📊 **Practice Mode**
- Shimmer loading effects
- Comprehensive question bank
- Immediate result feedback
- Progress visualization

### 🔧 **Technical Features**
- Offline support with Hive database
- State management with Riverpod
- Modern navigation with go_router
- Firebase integration
- Performance optimized (0 analysis issues)

## 🛠️ Tech Stack

| Technology | Purpose |
|------------|---------|
| **Flutter 3.32.7** | Cross-platform mobile framework |
| **Dart 3.5.0** | Programming language |
| **Riverpod 2.5.1** | State management |
| **go_router 13.2.5** | Navigation and routing |
| **Hive 2.2.3** | Local database for offline support |
| **Firebase** | Authentication and backend services |
| **Material 3** | Modern design system |

## 📦 Dependencies

```yaml
dependencies:
  flutter_riverpod: ^2.5.1
  go_router: ^13.2.5
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  google_sign_in: ^6.1.6
  connectivity_plus: ^5.0.2
  flutter_local_notifications: ^16.3.2
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.32.7 or higher)
- Dart SDK (3.5.0 or higher)
- Android Studio / VS Code
- Android SDK for Android development
- Xcode for iOS development (macOS only)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/quytttb/etrainer-mobile.git
   cd etrainer-mobile
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Configure Firebase** (Optional)
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Update `firebase_options.dart` with your configuration

5. **Run the app**
   ```bash
   # Debug mode
   flutter run
   
   # Release mode
   flutter run --release
   ```

## 📱 Build & Deploy

### Android APK
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release
```

### iOS App
```bash
# iOS build
flutter build ios --release
```

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/          # App constants and themes
│   ├── providers/          # Global state providers
│   ├── routing/            # Navigation and routing
│   ├── services/           # Core services (API, Auth, etc.)
│   └── themes/             # Material 3 theme configuration
├── data/
│   └── models/             # Data models and Hive entities
├── presentation/
│   ├── providers/          # Screen-specific providers
│   ├── screens/            # UI screens
│   └── widgets/            # Reusable UI components
└── main.dart               # App entry point
```

## 🎯 Key Features Implemented

- ✅ **Complete Authentication Flow** - Google Sign-in with Firebase
- ✅ **Journey-Based Learning System** - Interactive stages and progress tracking
- ✅ **Quiz System** - Timer-based quizzes with animations
- ✅ **Practice Mode** - Comprehensive question practice
- ✅ **Vietnamese Interface** - Full localization support
- ✅ **Material 3 Design** - Modern UI with dark/light themes
- ✅ **Offline Support** - Hive database for local storage
- ✅ **Performance Optimized** - Zero analysis issues, production-ready
- ✅ **Advanced Animations** - Smooth transitions and loading states

## 🔧 Configuration

### Theme Customization
Edit `lib/core/themes/app_theme.dart` to customize colors and styling.

### Add New Screens
1. Create screen in `lib/presentation/screens/`
2. Add route in `lib/core/routing/app_router.dart`
3. Update navigation logic

### Database Models
1. Create model in `lib/data/models/`
2. Add Hive annotations
3. Run `flutter packages pub run build_runner build`

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Developer

**Quý Trần** - [@quytttb](https://github.com/quytttb)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design team for the design system
- Riverpod for excellent state management
- Firebase for backend services

---

**⭐ If you found this project helpful, please consider giving it a star!**
