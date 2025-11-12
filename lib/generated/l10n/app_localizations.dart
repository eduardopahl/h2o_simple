import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'H2OSync'**
  String get appTitle;

  /// Welcome dialog title
  ///
  /// In en, this message translates to:
  /// **'Welcome to H2OSync!'**
  String get welcomeTitle;

  /// Welcome dialog subtitle
  ///
  /// In en, this message translates to:
  /// **'Let\'s customize your experience!'**
  String get letsPersonalize;

  /// Welcome dialog description
  ///
  /// In en, this message translates to:
  /// **'To help you maintain healthy hydration, let\'s configure:'**
  String get helpYouStayHydrated;

  /// Personalized goal feature title
  ///
  /// In en, this message translates to:
  /// **'Personalized goal'**
  String get personalizedGoal;

  /// Feature item description
  ///
  /// In en, this message translates to:
  /// **'Based on your weight, age and activity level'**
  String get basedOnWeightAge;

  /// Feature item title
  ///
  /// In en, this message translates to:
  /// **'Smart reminders'**
  String get smartReminders;

  /// Reminders feature description
  ///
  /// In en, this message translates to:
  /// **'Notifications to keep you hydrated'**
  String get notificationsToKeepHydrated;

  /// Tracking feature title
  ///
  /// In en, this message translates to:
  /// **'Tracking'**
  String get tracking;

  /// Tracking feature description
  ///
  /// In en, this message translates to:
  /// **'Monitor your daily progress'**
  String get monitorDailyProgress;

  /// Personal data section title
  ///
  /// In en, this message translates to:
  /// **'Personal Data'**
  String get personalData;

  /// Personal data page subtitle
  ///
  /// In en, this message translates to:
  /// **'To calculate your ideal hydration goal'**
  String get toCalculateIdealGoal;

  /// Weight input label
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weightKg;

  /// Kilogram unit abbreviation
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kg;

  /// Age input label
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// Years suffix
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get years;

  /// Gender label
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// Male gender option
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// Female gender option
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// Activity level section title
  ///
  /// In en, this message translates to:
  /// **'Activity level'**
  String get activityLevel;

  /// Sedentary activity level
  ///
  /// In en, this message translates to:
  /// **'Sedentary'**
  String get sedentary;

  /// Light activity level
  ///
  /// In en, this message translates to:
  /// **'Light (1-3x/week)'**
  String get light;

  /// Moderate activity level
  ///
  /// In en, this message translates to:
  /// **'Moderate (3-5x/week)'**
  String get moderate;

  /// Intense activity level
  ///
  /// In en, this message translates to:
  /// **'Intense (6-7x/week)'**
  String get intense;

  /// Extreme activity level
  ///
  /// In en, this message translates to:
  /// **'Extreme (2x/day)'**
  String get extreme;

  /// Hydration goal page title
  ///
  /// In en, this message translates to:
  /// **'Hydration goal'**
  String get hydrationGoal;

  /// Personalized goal option
  ///
  /// In en, this message translates to:
  /// **'Personalized goal (recommended)'**
  String get personalizedGoalRecommended;

  /// Daily amount format
  ///
  /// In en, this message translates to:
  /// **'{amount}ml per day'**
  String perDay(String amount);

  /// Manual goal radio option
  ///
  /// In en, this message translates to:
  /// **'Set goal manually'**
  String get setGoalManually;

  /// Manual goal input label
  ///
  /// In en, this message translates to:
  /// **'Goal (ml)'**
  String get goalMl;

  /// Milliliter unit abbreviation
  ///
  /// In en, this message translates to:
  /// **'ml'**
  String get ml;

  /// Recommended goal range helper text
  ///
  /// In en, this message translates to:
  /// **'Recommended: 1500ml - 3000ml'**
  String get recommendedRange;

  /// Notification toggle title
  ///
  /// In en, this message translates to:
  /// **'Hydration reminders'**
  String get hydrationReminders;

  /// Notification settings description
  ///
  /// In en, this message translates to:
  /// **'Receive smart reminders to drink water throughout the day'**
  String get receiveSmartReminders;

  /// Notification settings note
  ///
  /// In en, this message translates to:
  /// **'You can customize schedules and intervals in settings.'**
  String get customizeSchedule;

  /// Not now button
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// Allow notifications button
  ///
  /// In en, this message translates to:
  /// **'Allow Notifications'**
  String get allowNotifications;

  /// Back button text
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Next button text
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Finish button text
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// Settings tab title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Daily goal settings item
  ///
  /// In en, this message translates to:
  /// **'Daily Goal'**
  String get dailyGoal;

  /// Volume unit settings item
  ///
  /// In en, this message translates to:
  /// **'Volume Unit'**
  String get volumeUnit;

  /// Dark mode settings item
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Enabled status
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// Disabled status
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// Notifications title
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// About section title
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// About dialog title
  ///
  /// In en, this message translates to:
  /// **'About H2OSync'**
  String get aboutH2OSimple;

  /// Version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Data section title
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// Reset data dialog title
  ///
  /// In en, this message translates to:
  /// **'Reset Data'**
  String get resetData;

  /// Reset data description
  ///
  /// In en, this message translates to:
  /// **'Delete all saved data'**
  String get deleteAllSavedData;

  /// Unit selection dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Unit'**
  String get selectUnit;

  /// Milliliters unit name
  ///
  /// In en, this message translates to:
  /// **'Milliliters'**
  String get milliliters;

  /// Fluid ounces unit name
  ///
  /// In en, this message translates to:
  /// **'Fluid Ounces'**
  String get fluidOunces;

  /// Unit symbol label
  ///
  /// In en, this message translates to:
  /// **'Symbol'**
  String get symbol;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Unit change success message
  ///
  /// In en, this message translates to:
  /// **'Unit changed to {unit}'**
  String unitChangedTo(String unit);

  /// Change daily goal dialog title
  ///
  /// In en, this message translates to:
  /// **'Change Daily Goal'**
  String get changeDailyGoal;

  /// Daily goal recommendation helper text
  ///
  /// In en, this message translates to:
  /// **'Recommended: 2000ml - 2500ml per day'**
  String get recommendedDaily;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Goal change success message
  ///
  /// In en, this message translates to:
  /// **'Goal changed to {amount}ml'**
  String goalChangedTo(int amount);

  /// Reset confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Confirm Reset Data'**
  String get confirmResetData;

  /// Reset warning message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset all data? This action cannot be undone.'**
  String get resetWarningMessage;

  /// Reset button text
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Reset success message
  ///
  /// In en, this message translates to:
  /// **'Data reset successfully'**
  String get dataResetSuccessfully;

  /// Custom amount dialog title
  ///
  /// In en, this message translates to:
  /// **'Custom Amount'**
  String get customAmount;

  /// Invalid amount error
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get enterValidAmount;

  /// Value range error
  ///
  /// In en, this message translates to:
  /// **'Enter a value between 1 and 9999 ml'**
  String get enterValueBetween;

  /// Add button text
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Goal achieved dialog title
  ///
  /// In en, this message translates to:
  /// **'🎉 Congratulations!'**
  String get congratulations;

  /// Goal achieved message
  ///
  /// In en, this message translates to:
  /// **'You reached your daily hydration goal!\\n\\nYour body thanks you! 💧'**
  String get goalAchievedMessage;

  /// Continue button text
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// Of preposition for progress
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get prepositionOf;

  /// Remaining amount
  ///
  /// In en, this message translates to:
  /// **'Remaining {amount}ml'**
  String remaining(int amount);

  /// Extra text for over-goal
  ///
  /// In en, this message translates to:
  /// **'extra'**
  String get extra;

  /// Custom option for buttons
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// Pounds unit abbreviation
  ///
  /// In en, this message translates to:
  /// **'lbs'**
  String get lbs;

  /// Fluid ounces unit abbreviation
  ///
  /// In en, this message translates to:
  /// **'fl oz'**
  String get flOz;

  /// History tab label
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// Daily tab title
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// Notification settings dialog title
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// Notification interval label
  ///
  /// In en, this message translates to:
  /// **'Interval between notifications:'**
  String get intervalBetweenNotifications;

  /// Every hour option
  ///
  /// In en, this message translates to:
  /// **'Every hour'**
  String get everyHour;

  /// Every X hours option
  ///
  /// In en, this message translates to:
  /// **'Every {hours} hours'**
  String everyXHours(int hours);

  /// Start time label
  ///
  /// In en, this message translates to:
  /// **'Start time:'**
  String get startTime;

  /// End time label
  ///
  /// In en, this message translates to:
  /// **'End time:'**
  String get endTime;

  /// Test notification button
  ///
  /// In en, this message translates to:
  /// **'Send Test Notification'**
  String get sendTestNotification;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Average per record label
  ///
  /// In en, this message translates to:
  /// **'Average per record:'**
  String get averagePerRecord;

  /// App description in about dialog
  ///
  /// In en, this message translates to:
  /// **'App to track your daily water consumption and maintain healthy hydration.'**
  String get h2oSimpleDescription;

  /// Development info in about dialog
  ///
  /// In en, this message translates to:
  /// **'Developed with Flutter 💙'**
  String get developedWithFlutter;

  /// Language selection dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Language change success message
  ///
  /// In en, this message translates to:
  /// **'Language changed successfully'**
  String get languageChanged;

  /// Reset data confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset all data? This action cannot be undone.'**
  String get resetDataConfirmation;

  /// Loading screen text
  ///
  /// In en, this message translates to:
  /// **'Loading H2OSync...'**
  String get loading;

  /// Water reminder description
  ///
  /// In en, this message translates to:
  /// **'Water reminders'**
  String get waterReminders;

  /// Notification permission denied message
  ///
  /// In en, this message translates to:
  /// **'Notification permission denied'**
  String get notificationPermissionDenied;

  /// About app section title
  ///
  /// In en, this message translates to:
  /// **'About the App'**
  String get aboutApp;

  /// App info description
  ///
  /// In en, this message translates to:
  /// **'Information and credits'**
  String get appInfo;

  /// Reset data button title
  ///
  /// In en, this message translates to:
  /// **'Reset All Data'**
  String get resetAllData;

  /// App version in about dialog
  ///
  /// In en, this message translates to:
  /// **'H2OSync v1.0.0'**
  String get appVersion;

  /// Light activity level
  ///
  /// In en, this message translates to:
  /// **'Light (1-3x/week)'**
  String get lightActivity;

  /// Moderate activity level
  ///
  /// In en, this message translates to:
  /// **'Moderate (3-5x/week)'**
  String get moderateActivity;

  /// Intense activity level
  ///
  /// In en, this message translates to:
  /// **'Intense (6-7x/week)'**
  String get intenseActivity;

  /// Extreme activity level
  ///
  /// In en, this message translates to:
  /// **'Extreme (2x/day)'**
  String get extremeActivity;

  /// Custom goal radio option
  ///
  /// In en, this message translates to:
  /// **'Custom goal (recommended)'**
  String get customGoalRecommended;

  /// ML per day format
  ///
  /// In en, this message translates to:
  /// **'{amount}ml per day'**
  String mlPerDay(int amount);

  /// Try again button
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// Error loading data message
  ///
  /// In en, this message translates to:
  /// **'Error loading data: {error}'**
  String errorLoadingData(String error);

  /// Welcome dialog title
  ///
  /// In en, this message translates to:
  /// **'Welcome to H2OSync!'**
  String get welcomeToH2O;

  /// No records message
  ///
  /// In en, this message translates to:
  /// **'No records on this day'**
  String get noRecordsThisDay;

  /// Data reset success message
  ///
  /// In en, this message translates to:
  /// **'Data reset successfully'**
  String get dataResetSuccess;

  /// Invalid amount error message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get invalidAmount;

  /// Amount too small error message
  ///
  /// In en, this message translates to:
  /// **'Amount must be greater than 0ml'**
  String get amountTooSmall;

  /// Notifications enabled success message
  ///
  /// In en, this message translates to:
  /// **'Notifications enabled successfully'**
  String get notificationsEnabled;

  /// Notifications not available message
  ///
  /// In en, this message translates to:
  /// **'Notifications are not available on this device'**
  String get notificationsNotAvailable;

  /// Error enabling notifications message
  ///
  /// In en, this message translates to:
  /// **'Error enabling notifications'**
  String get errorEnablingNotifications;

  /// Setup complete message with goal
  ///
  /// In en, this message translates to:
  /// **'✅ Setup complete! Goal: {goal}ml/day'**
  String setupCompleteWithGoal(int goal);

  /// Setup complete message manual
  ///
  /// In en, this message translates to:
  /// **'⚙️ Setup complete! Goal: {goal}ml/day'**
  String setupCompleteManual(int goal);

  /// Error saving settings message
  ///
  /// In en, this message translates to:
  /// **'Error saving settings: {error}'**
  String errorSavingSettings(String error);

  /// Confirm delete message
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delete {itemName}?'**
  String confirmDelete(String itemName);

  /// Error loading hydration data
  ///
  /// In en, this message translates to:
  /// **'Error loading hydration data'**
  String get errorLoadingHydrationData;

  /// Error adding water intake
  ///
  /// In en, this message translates to:
  /// **'Error adding water intake'**
  String get errorAddingWaterIntake;

  /// Error removing water intake
  ///
  /// In en, this message translates to:
  /// **'Error removing water intake'**
  String get errorRemovingWaterIntake;

  /// Error checking notifications
  ///
  /// In en, this message translates to:
  /// **'Error checking notifications'**
  String get errorCheckingNotifications;

  /// Confirm deletion dialog title
  ///
  /// In en, this message translates to:
  /// **'Confirm deletion'**
  String get confirmDeletion;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Confirm reset dialog title
  ///
  /// In en, this message translates to:
  /// **'Confirm reset'**
  String get confirmReset;

  /// Reset confirmation message
  ///
  /// In en, this message translates to:
  /// **'This action will permanently delete all data. Do you want to continue?'**
  String get resetConfirmMessage;

  /// Today tab label
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Day period option
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// Week period option
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// Month period option
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// Goal achieved message
  ///
  /// In en, this message translates to:
  /// **'🎉 Goal achieved!'**
  String get goalAchieved;

  /// Goal completed celebration title
  ///
  /// In en, this message translates to:
  /// **'🎉 Goal Achieved!'**
  String get goalCompleted;

  /// Goal completed celebration message
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You reached your daily goal. Keep up the excellent hydration!'**
  String goalCompletedMessage(int amount);

  /// Weekly achievement title
  ///
  /// In en, this message translates to:
  /// **'🗓️ Weekly Success!'**
  String get weeklyAchievement;

  /// Weekly achievement message
  ///
  /// In en, this message translates to:
  /// **'Amazing! You completed your hydration goal {days} days this week. You\'re building a healthy habit!'**
  String weeklyAchievementMessage(int days);

  /// Streak milestone title
  ///
  /// In en, this message translates to:
  /// **'🔥 Streak Milestone!'**
  String get streakMilestone;

  /// Streak milestone message
  ///
  /// In en, this message translates to:
  /// **'Incredible! You\'ve maintained your hydration streak for {days} consecutive days. You\'re a hydration champion!'**
  String streakMilestoneMessage(int days);

  /// Advertisement label
  ///
  /// In en, this message translates to:
  /// **'Ad'**
  String get adLabel;

  /// Ad title for smart bottle
  ///
  /// In en, this message translates to:
  /// **'Smart Hydration Bottle'**
  String get smartHydrationBottle;

  /// Ad title for supplements
  ///
  /// In en, this message translates to:
  /// **'Hydration+ Supplements'**
  String get hydrationSupplements;

  /// Ad title for premium app
  ///
  /// In en, this message translates to:
  /// **'FitWater Premium App'**
  String get premiumFitWaterApp;

  /// Generic ad title for hydration products
  ///
  /// In en, this message translates to:
  /// **'Hydration Products'**
  String get hydrationProducts;

  /// Ad subtitle for smart bottle
  ///
  /// In en, this message translates to:
  /// **'Monitor automatically without effort'**
  String get monitorAutomatically;

  /// Ad subtitle for supplements
  ///
  /// In en, this message translates to:
  /// **'Natural electrolytes for all day'**
  String get naturalElectrolytes;

  /// Ad subtitle for premium app
  ///
  /// In en, this message translates to:
  /// **'Advanced features without ads'**
  String get advancedFeaturesNoAds;

  /// Generic ad subtitle
  ///
  /// In en, this message translates to:
  /// **'Improve your daily hydration'**
  String get improveDailyHydration;

  /// Total consumed label
  ///
  /// In en, this message translates to:
  /// **'Total consumed:'**
  String get totalConsumed;

  /// Today's hydration title
  ///
  /// In en, this message translates to:
  /// **'Today\'s hydration'**
  String get todayHydration;

  /// Of target amount
  ///
  /// In en, this message translates to:
  /// **'of {target}ml'**
  String ofTarget(int target);

  /// Confirm button text
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Amount input field label
  ///
  /// In en, this message translates to:
  /// **'Amount (ml)'**
  String get amountMl;

  /// Notification customization info text
  ///
  /// In en, this message translates to:
  /// **'You can customize the times and intervals in the settings.'**
  String get customizeNotificationSettings;

  /// Welcome title in setup dialog
  ///
  /// In en, this message translates to:
  /// **'Welcome to H2OSync!'**
  String get welcomeToH2OSimple;

  /// Setup dialog customization title
  ///
  /// In en, this message translates to:
  /// **'Let\'s customize your experience!'**
  String get letsCustomizeExperience;

  /// Setup dialog description
  ///
  /// In en, this message translates to:
  /// **'To help you maintain healthy hydration, we\'ll set up:'**
  String get helpMaintainHealthyHydration;

  /// Personalized goal description
  ///
  /// In en, this message translates to:
  /// **'Based on your weight, age and activity level'**
  String get basedOnWeightAgeActivity;

  /// Reminders feature title
  ///
  /// In en, this message translates to:
  /// **'Intelligent reminders'**
  String get intelligentReminders;

  /// Age input label
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get ageYears;

  /// Notification toggle description
  ///
  /// In en, this message translates to:
  /// **'Receive intelligent reminders to drink water throughout the day'**
  String get receiveIntelligentReminders;

  /// Goal input field label
  ///
  /// In en, this message translates to:
  /// **'Goal (ml)'**
  String get goalMlLabel;

  /// Recommended daily goal helper text
  ///
  /// In en, this message translates to:
  /// **'Recommended: 2000ml - 2500ml per day'**
  String get recommendedDailyGoal;

  /// Adult recommendation info text
  ///
  /// In en, this message translates to:
  /// **'The recommended goal for adults is 2-3 liters per day.'**
  String get adultRecommendation;

  /// Water intake deletion confirmation message
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delete this water intake record?'**
  String get confirmDeleteWaterRecord;

  /// Test notification title
  ///
  /// In en, this message translates to:
  /// **'H2OSync - Test'**
  String get testNotificationTitle;

  /// Test notification body message
  ///
  /// In en, this message translates to:
  /// **'💧 This is a test notification! Your notifications are working.'**
  String get testNotificationBody;

  /// Every hour interval description
  ///
  /// In en, this message translates to:
  /// **'Every hour'**
  String get everyHourInterval;

  /// Every X hours interval description
  ///
  /// In en, this message translates to:
  /// **'Every {hours} hours'**
  String everyXHoursInterval(int hours);

  /// Schedule time range description
  ///
  /// In en, this message translates to:
  /// **'From {startTime} to {endTime}'**
  String fromToSchedule(String startTime, String endTime);

  /// Yesterday date label
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// Monday short label
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get monShort;

  /// Tuesday short label
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tueShort;

  /// Wednesday short label
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wedShort;

  /// Thursday short label
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thuShort;

  /// Friday short label
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get friShort;

  /// Saturday short label
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get satShort;

  /// Sunday short label
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sunShort;

  /// Title for daily consumption chart
  ///
  /// In en, this message translates to:
  /// **'Daily Consumption'**
  String get dailyConsumption;

  /// Title for weekly consumption chart
  ///
  /// In en, this message translates to:
  /// **'Weekly Consumption'**
  String get weeklyConsumption;

  /// Title for monthly consumption chart
  ///
  /// In en, this message translates to:
  /// **'Monthly Consumption'**
  String get monthlyConsumption;

  /// Week label for charts
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get weekLabel;

  /// Days label for charts
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get daysLabel;

  /// Milliliters unit abbreviation
  ///
  /// In en, this message translates to:
  /// **'ml'**
  String get mlUnit;

  /// Extra amount consumed beyond goal
  ///
  /// In en, this message translates to:
  /// **'+{amount}ml extra'**
  String extraAmount(int amount);

  /// Option to remove ads
  ///
  /// In en, this message translates to:
  /// **'Remove Ads'**
  String get removeAds;

  /// Premium features section
  ///
  /// In en, this message translates to:
  /// **'Premium Features'**
  String get premiumFeatures;

  /// Remove ads description
  ///
  /// In en, this message translates to:
  /// **'Remove all ads for a smoother experience'**
  String get removeAdsDescription;

  /// Purchase dialog title
  ///
  /// In en, this message translates to:
  /// **'Purchase - Remove Ads'**
  String get purchaseRemoveAds;

  /// Remove ads purchase description
  ///
  /// In en, this message translates to:
  /// **'Remove all ads permanently for just:'**
  String get removeAdsForever;

  /// Buy button
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buyNow;

  /// Restore purchases button
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get restorePurchases;

  /// Purchase success message
  ///
  /// In en, this message translates to:
  /// **'Purchase successful! Ads have been removed.'**
  String get purchaseSuccess;

  /// Purchase error message
  ///
  /// In en, this message translates to:
  /// **'Error processing purchase. Please try again.'**
  String get purchaseError;

  /// Restore success message
  ///
  /// In en, this message translates to:
  /// **'Purchases restored successfully!'**
  String get restoreSuccess;

  /// Message when no purchases to restore
  ///
  /// In en, this message translates to:
  /// **'No purchases found to restore.'**
  String get restoreError;

  /// Message when purchases are not available
  ///
  /// In en, this message translates to:
  /// **'Purchases not available at the moment.'**
  String get purchaseNotAvailable;

  /// Premium user status
  ///
  /// In en, this message translates to:
  /// **'Premium User'**
  String get premiumUser;

  /// Thank you message for premium users
  ///
  /// In en, this message translates to:
  /// **'Thank you for your support! 💙'**
  String get thanksForSupport;

  /// Label for independent developer
  ///
  /// In en, this message translates to:
  /// **'Independent Developer'**
  String get independentDeveloper;

  /// Support message for purchases
  ///
  /// In en, this message translates to:
  /// **'Your purchase helps me a lot to continue developing and improving the app! 🙏\n\nAs an independent developer, every support makes a difference to keep H2OSync always updated.'**
  String get supportMessage;

  /// Label for one-time payment
  ///
  /// In en, this message translates to:
  /// **'One-time payment'**
  String get oneTimePayment;

  /// Thank you message after successful purchase
  ///
  /// In en, this message translates to:
  /// **'Thank you for your support! Ads removed successfully! 🎉'**
  String get purchaseThankYou;

  /// Message shown while processing the purchase
  ///
  /// In en, this message translates to:
  /// **'Processing purchase...'**
  String get processingPurchase;

  /// Error message when resetting data fails
  ///
  /// In en, this message translates to:
  /// **'Error resetting data. Please try again.'**
  String get dataResetError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
