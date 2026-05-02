# H2OSync

A Flutter hydration tracking app built as an architecture reference — demonstrating how I structure production-grade mobile applications with Clean Architecture, Riverpod 3, and a clear separation of concerns across all layers.

![Flutter](https://img.shields.io/badge/Flutter-3.41-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.11-0175C2?logo=dart)
![Architecture](https://img.shields.io/badge/Architecture-Clean-green)
![State](https://img.shields.io/badge/State-Riverpod%203-purple)
![Platforms](https://img.shields.io/badge/Platforms-iOS%20%7C%20Android-lightgrey)

---

## Purpose

This project exists primarily as a portfolio piece. The app itself is straightforward — log water intake, track progress, get reminders. The goal was to implement it using the same patterns I apply in production: proper layer boundaries, dependency inversion, testable business logic, and a state management strategy that scales.

---

## Architecture

The project follows **Clean Architecture** with strict dependency rules: inner layers know nothing about outer layers, and all cross-boundary communication happens through interfaces.

```
┌─────────────────────────────────────┐
│         Presentation Layer          │  Riverpod providers, widgets, pages
│   (Riverpod, Notifiers, Widgets)    │
├─────────────────────────────────────┤
│           Domain Layer              │  Business rules — no Flutter imports
│   (Entities, Use Cases, Repos)      │
├─────────────────────────────────────┤
│            Data Layer               │  Repository implementations, models
│   (SharedPreferences, Services)     │
└─────────────────────────────────────┘
         Dependencies flow inward ↑
```

### Layer Responsibilities

**Domain** is the core. It contains entities (`WaterIntake`, `UserProfile`, `DailyGoal`), repository contracts (abstract classes), and use cases that encode business rules. Zero Flutter imports — this layer is pure Dart and can be tested without any framework.

**Data** implements the repository contracts defined by domain. All persistence (SharedPreferences) lives here. Data models handle serialization; entities handle behavior. The separation means swapping a storage backend requires touching only this layer.

**Presentation** contains everything UI-related: Riverpod providers that bridge domain logic and UI state, widget trees, and controllers for complex UI interactions. Providers depend on domain interfaces injected at the `ProviderScope` level.

### State Management — Riverpod 3

Providers use Riverpod 3's `AsyncNotifier`/`Notifier` pattern throughout. Each notifier is responsible for a single slice of state:

- `DailyWaterIntakeNotifier` — today's intake list + event emission
- `HistoryWaterIntakeNotifier` — history tab state, date/week/month loading
- `DailyGoalNotifier` — daily goal with lazy sync to user profile
- `UserProfileNotifier` — persisted user settings
- `ThemeNotifier` / `LanguageNotifier` — app preferences with async loading

Provider dependency graph is wired through `repository_providers.dart` and `use_case_providers.dart`, making the injection chain explicit and testable.

### Cross-Provider Synchronization

A non-trivial challenge: deleting an item from the history tab needs to update the daily tab, but only if the deleted item belongs to today. `HistoryWaterIntakeNotifier.removeWaterIntake` handles this by checking the item's timestamp before calling `ref.invalidate(dailyWaterIntakeProvider)` — selective invalidation rather than broadcasting a global refresh.

### Domain Events

Business logic communicates with the UI through a domain event system (`WaterIntakeEvent`) rather than callbacks or direct BuildContext access. When the daily goal is reached, `DailyWaterIntakeNotifier` emits a `goalAchieved` event into an in-memory event queue. The UI layer polls this queue and reacts (celebration animation, ad trigger) without the notifier needing to know anything about the UI.

This keeps business logic free of presentation concerns and makes the flow testable in isolation.

### Use Case Validation

`AddWaterIntakeUseCase` enforces domain rules synchronously before touching the repository:
- Amount must be positive and ≤ 2000ml per entry
- Timestamp cannot be in the future
- Returns the created `WaterIntake` entity on success

Validation lives in the use case, not in the widget or the repository.

---

## Technical Highlights

**Physics-based water animation** — The water container widget subscribes to `accelerometerEventStream()` from `sensors_plus` and translates device tilt into a fluid wave offset, creating a physical feel without any game engine.

**Smart notification scheduling** — Notifications are scheduled 7 days ahead on device (not server-push), respecting user-defined start/end hours and interval. The scheduler skips slots where the daily goal has already been reached, integrating with the hydration data layer.

**AdMob + IAP integration** — `GoogleAdService` is injected through a `PurchaseService` abstraction. Premium users bypass all ad paths entirely. The ad lifecycle (load → show → dispose → reload) is managed inside the service, so UI components only call `canShowAd()` and `showCelebrationAd()`.

**Internationalization** — Full i18n using Flutter's `gen-l10n` tool with ARB files. Language detection falls back to system locale, with manual override persisted via `SharedPreferences`. Adding a new language requires only a new ARB file — no code changes.

---

## Project Structure

```
lib/
├── core/
│   ├── config/           # AdMob and app config
│   ├── events/           # Domain event definitions
│   ├── extensions/       # List and DateTime utilities
│   └── services/         # Notification, purchase, first-launch services
├── data/
│   ├── models/           # Serialization models
│   ├── repositories/     # SharedPreferences-backed implementations
│   └── services/         # GoogleAdService
├── domain/
│   ├── entities/         # WaterIntake, UserProfile, DailyGoal, ThemeSettings
│   ├── repositories/     # Abstract contracts
│   ├── services/         # Abstract service contracts
│   └── use_cases/        # AddWaterIntake, CalculateHydrationStats
├── generated/l10n/       # Auto-generated localization classes
├── l10n/                 # ARB translation files (en, pt)
└── presentation/
    ├── controllers/      # CelebrationAdManager, WaterIntakeController
    ├── dialogs/          # First-launch setup, settings dialogs
    ├── pages/            # Daily, History, Settings tabs
    ├── providers/        # Riverpod notifiers and derived providers
    ├── theme/            # Material 3 light/dark themes
    └── widgets/          # PhysicsWaterContainer, WaterChart, reusable components
```

---

## Getting Started

**Prerequisites:** Flutter ≥ 3.7 · Dart ≥ 3.7 · Android Studio or VS Code

```bash
git clone https://github.com/eduardopahl/h2o_simple.git
cd h2o_simple
flutter pub get
flutter gen-l10n
flutter run
```

### Local Configuration

Two files are gitignored and must be created before building:

**`key.properties`** — Android signing (see [`key.properties.example`](key.properties.example))
```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=your_key_alias
storeFile=path/to/your-keystore.jks
```

**`admob.properties`** — AdMob IDs (see [`admob.properties.example`](admob.properties.example))
```properties
android_app_id=ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX
android_banner_id=ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX
android_interstitial_id=ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX
ios_app_id=ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX
ios_banner_id=ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX
ios_interstitial_id=ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX
is_testing=true
```

Set `is_testing=true` during development to use Google's public test IDs.

### Build

```bash
flutter build apk --release    # Android
flutter build ios --release    # iOS
```

---

## Dependencies

| Package | Version | Role |
|---|---|---|
| `flutter_riverpod` | ^3.3.1 | State management — `Notifier`/`AsyncNotifier` pattern |
| `shared_preferences` | ^2.5.5 | Local persistence for all domain data |
| `fl_chart` | ^1.2.0 | Daily, weekly, and monthly intake charts |
| `sensors_plus` | ^7.0.0 | Accelerometer stream for physics animation |
| `flutter_local_notifications` | ^21.0.0 | Scheduled hydration reminders |
| `timezone` | ^0.11.0 | Timezone-aware notification scheduling |
| `permission_handler` | ^12.0.1 | Notification and alarm permissions |
| `google_mobile_ads` | ^8.0.0 | Banner and interstitial ads |
| `in_app_purchase` | ^3.1.13 | Premium tier via StoreKit / Play Billing |
| `intl` | ^0.20.2 | Date formatting and i18n support |

---

## Author

**Eduardo Pahl** · Flutter Engineer  
[github.com/eduardopahl](https://github.com/eduardopahl)
