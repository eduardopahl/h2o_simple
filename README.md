# H2OSync 💧

A simple Flutter app to track your daily water intake with full internationalization support.

## 📱 About the App

H2OSync is a hydration tracking app that helps you keep your water levels on track. With a clean and intuitive interface, you can easily log your water intake and monitor your progress over time. The app supports multiple languages and automatically adapts to your device's language settings.

### ✨ Features

- 💧 **Daily Tracking**: Log and visualize your water intake
- 📈 **Complete History**: View your progress over days, weeks, and months
- 🎯 **Customizable Goals**: Set your daily hydration target based on personal data
- 🔔 **Smart Notifications**: Intelligent reminders to stay hydrated
- 🌍 **Multi-language Support**: Full internationalization (English/Portuguese)
- 📱 **Material 3 Interface**: Modern and responsive design
- 🌊 **Smooth Animations**: Fluid and pleasant visual experience
- 📊 **Interactive Charts**: Visual progress tracking with detailed analytics
- 💳 **In-App Purchases**: Premium features via in-app purchase

## 🏗️ Architecture

The project follows **Clean Architecture** principles with:

- **Domain Layer**: Entities, use cases, and repository contracts
- **Data Layer**: Repository implementations and data sources
- **Presentation Layer**: UI, widgets, and state management with Riverpod

### 🌍 Internationalization (i18n)

The app features complete internationalization support using Flutter's official l10n system:

- **ARB Files**: Translation resources in `lib/l10n/` directory
- **Supported Languages**: English (en) and Portuguese (pt)
- **Auto-generated Classes**: Type-safe translation access
- **120+ Translated Strings**: Complete UI coverage
- **Automatic Language Detection**: Follows device settings with English fallback

### 📁 Project Structure

```
lib/
├── core/
│   ├── config/           # App configuration
│   ├── enums/            # Shared enumerations
│   ├── events/           # Domain events
│   ├── extensions/       # Utility extensions
│   └── services/         # Core services
├── data/
│   ├── models/           # Data models
│   ├── repositories/     # Repository implementations
│   └── services/         # Data layer services
├── domain/
│   ├── entities/         # Business entities
│   ├── repositories/     # Repository contracts
│   ├── services/         # Domain service contracts
│   └── use_cases/        # Use cases
├── generated/l10n/       # Auto-generated localization files
├── l10n/                 # Translation resource files (ARB)
│   ├── app_en.arb       # English translations
│   └── app_pt.arb       # Portuguese translations
└── presentation/
    ├── controllers/      # Business logic controllers
    ├── dialogs/          # Modal dialogs
    ├── pages/            # Application pages
    ├── providers/        # State management (Riverpod)
    ├── theme/            # Theme and colors
    └── widgets/          # Reusable components
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.7.0)
- Dart SDK (>=3.7.0)
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

3. Generate localization files:
```bash
flutter gen-l10n
```

4. Run the app:
```bash
flutter run
```

## 🛠️ Main Dependencies

- **flutter_riverpod**: Reactive state management
- **shared_preferences**: Local data persistence
- **sensors_plus**: Device motion detection
- **flutter_localizations**: Internationalization support
- **fl_chart**: Interactive charts and data visualization
- **flutter_local_notifications**: Smart hydration reminders
- **timezone**: Timezone handling for notifications
- **google_mobile_ads**: AdMob ads integration
- **in_app_purchase**: In-app purchase support
- **permission_handler**: Runtime permissions management

## 📦 Build

### Android APK
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## ⚙️ Local Configuration

These files are **gitignored** — you must create them locally before building.

### Android Signing (`key.properties`)

Create `key.properties` at the project root:

```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=your_key_alias
storeFile=path/to/your-keystore.jks
```

See [key.properties.example](key.properties.example) for reference.

### AdMob (`admob.properties`)

Create `admob.properties` at the project root:

```properties
android_app_id=ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX
android_banner_id=ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX
android_interstitial_id=ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX
ios_app_id=ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX
ios_banner_id=ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX
ios_interstitial_id=ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX
is_testing=true
```

See [admob.properties.example](admob.properties.example) for reference. Set `is_testing=true` during development to use Google's public test ad IDs.

## 🤝 Contributing

### Adding New Features

1. Fork the project
2. Create a feature branch (`git checkout -b feature/new-feature`)
3. Commit your changes (`git commit -m 'Add new feature'`)
4. Push to the branch (`git push origin feature/new-feature`)
5. Open a Pull Request

### Adding New Languages

1. Create new ARB file in `lib/l10n/` (e.g., `app_es.arb` for Spanish)
2. Copy structure from `app_en.arb` and translate all strings
3. Add new locale to `supportedLocales` in `main.dart`
4. Run `flutter gen-l10n` to generate localization classes
5. Test the new language thoroughly

## 👨‍💻 Author

**Eduardo Pahl**
- GitHub: [@eduardopahl](https://github.com/eduardopahl)
