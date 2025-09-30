# H2O Simple 💧

A simple Flutter app to track your daily water intake.

## 📱 About the App

H2O Simple is a hydration tracking app that helps you keep your water levels on track. With a clean and intuitive interface, you can easily log your water intake and monitor your progress over time.

### ✨ Features

- 📊 **Daily Tracking**: Log and visualize your water intake
- 📈 **Complete History**: View your progress over days
- 🎯 **Customizable Goals**: Set your daily hydration target
- 📱 **Material 3 Interface**: Modern and responsive design
- 🌊 **Smooth Animations**: Fluid and pleasant visual experience

## 🏗️ Architecture

The project follows **Clean Architecture** principles with:

- **Domain Layer**: Entities, use cases, and repository contracts
- **Data Layer**: Repository implementations and data sources
- **Presentation Layer**: UI, widgets, and state management with Riverpod

### 📁 Project Structure

```
lib/
├── core/
│   └── extensions/        # Utility extensions
├── data/
│   ├── models/           # Data models
│   └── repositories/     # Repository implementations
├── domain/
│   ├── entities/         # Business entities
│   ├── repositories/     # Repository contracts
│   └── use_cases/        # Use cases
└── presentation/
    ├── pages/            # Application pages
    ├── providers/        # State management (Riverpod)
    ├── theme/            # Theme and colors
    └── widgets/          # Reusable components
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. Clone the repository:
```bash
git clone https://github.com/eduardopahl/h2o_simple.git
cd h2o_simple
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 🛠️ Main Dependencies

- **flutter_riverpod**: Reactive state management
- **shared_preferences**: Local data persistence
- **sensors_plus**: Device motion detection

## 📦 Build

### Android APK
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 Contributing

1. Fork the project
2. Create a feature branch (`git checkout -b feature/new-feature`)
3. Commit your changes (`git commit -m 'Add new feature'`)
4. Push to the branch (`git push origin feature/new-feature`)
5. Open a Pull Request

## 📝 License

This project is under the MIT license. See the [LICENSE](LICENSE) file for more details.

## 👨‍💻 Author

**Eduardo Pahl**
- GitHub: [@eduardopahl](https://github.com/eduardopahl)
