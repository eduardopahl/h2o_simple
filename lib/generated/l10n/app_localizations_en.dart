// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'H2OSync';

  @override
  String get welcomeTitle => 'Welcome to H2OSync!';

  @override
  String get letsPersonalize => 'Let\'s customize your experience!';

  @override
  String get helpYouStayHydrated =>
      'To help you maintain healthy hydration, let\'s configure:';

  @override
  String get personalizedGoal => 'Personalized goal';

  @override
  String get basedOnWeightAge => 'Based on your weight, age and activity level';

  @override
  String get smartReminders => 'Smart reminders';

  @override
  String get notificationsToKeepHydrated =>
      'Notifications to keep you hydrated';

  @override
  String get tracking => 'Tracking';

  @override
  String get monitorDailyProgress => 'Monitor your daily progress';

  @override
  String get personalData => 'Personal Data';

  @override
  String get toCalculateIdealGoal => 'To calculate your ideal hydration goal';

  @override
  String get weightKg => 'Weight (kg)';

  @override
  String get kg => 'kg';

  @override
  String get age => 'Age';

  @override
  String get years => 'years';

  @override
  String get gender => 'Gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get activityLevel => 'Activity level';

  @override
  String get sedentary => 'Sedentary';

  @override
  String get light => 'Light (1-3x/week)';

  @override
  String get moderate => 'Moderate (3-5x/week)';

  @override
  String get intense => 'Intense (6-7x/week)';

  @override
  String get extreme => 'Extreme (2x/day)';

  @override
  String get hydrationGoal => 'Hydration goal';

  @override
  String get personalizedGoalRecommended => 'Personalized goal (recommended)';

  @override
  String perDay(String amount) {
    return '${amount}ml per day';
  }

  @override
  String get setGoalManually => 'Set goal manually';

  @override
  String get goalMl => 'Goal (ml)';

  @override
  String get ml => 'ml';

  @override
  String get recommendedRange => 'Recommended: 1500ml - 3000ml';

  @override
  String get hydrationReminders => 'Hydration reminders';

  @override
  String get receiveSmartReminders =>
      'Receive smart reminders to drink water throughout the day';

  @override
  String get customizeSchedule =>
      'You can customize schedules and intervals in settings.';

  @override
  String get notNow => 'Not now';

  @override
  String get allowNotifications => 'Allow Notifications';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get finish => 'Finish';

  @override
  String get settings => 'Settings';

  @override
  String get dailyGoal => 'Daily Goal';

  @override
  String get volumeUnit => 'Volume Unit';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get enabled => 'Enabled';

  @override
  String get disabled => 'Disabled';

  @override
  String get notifications => 'Notifications';

  @override
  String get about => 'About';

  @override
  String get aboutH2OSimple => 'About H2OSync';

  @override
  String get version => 'Version';

  @override
  String get data => 'Data';

  @override
  String get resetData => 'Reset Data';

  @override
  String get deleteAllSavedData => 'Delete all saved data';

  @override
  String get selectUnit => 'Select Unit';

  @override
  String get milliliters => 'Milliliters';

  @override
  String get fluidOunces => 'Fluid Ounces';

  @override
  String get symbol => 'Symbol';

  @override
  String get cancel => 'Cancel';

  @override
  String unitChangedTo(String unit) {
    return 'Unit changed to $unit';
  }

  @override
  String get changeDailyGoal => 'Change Daily Goal';

  @override
  String get recommendedDaily => 'Recommended: 2000ml - 2500ml per day';

  @override
  String get save => 'Save';

  @override
  String goalChangedTo(int amount) {
    return 'Goal changed to ${amount}ml';
  }

  @override
  String get confirmResetData => 'Confirm Reset Data';

  @override
  String get resetWarningMessage =>
      'Are you sure you want to reset all data? This action cannot be undone.';

  @override
  String get reset => 'Reset';

  @override
  String get dataResetSuccessfully => 'Data reset successfully';

  @override
  String get customAmount => 'Custom Amount';

  @override
  String get enterValidAmount => 'Enter a valid amount';

  @override
  String get enterValueBetween => 'Enter a value between 1 and 9999 ml';

  @override
  String get add => 'Add';

  @override
  String get congratulations => '🎉 Congratulations!';

  @override
  String get goalAchievedMessage =>
      'You reached your daily hydration goal!\\n\\nYour body thanks you! 💧';

  @override
  String get continueText => 'Continue';

  @override
  String get prepositionOf => 'of';

  @override
  String remaining(int amount) {
    return 'Remaining ${amount}ml';
  }

  @override
  String get extra => 'extra';

  @override
  String get custom => 'Custom';

  @override
  String get lbs => 'lbs';

  @override
  String get flOz => 'fl oz';

  @override
  String get history => 'History';

  @override
  String get daily => 'Daily';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get intervalBetweenNotifications => 'Interval between notifications:';

  @override
  String get everyHour => 'Every hour';

  @override
  String everyXHours(int hours) {
    return 'Every $hours hours';
  }

  @override
  String get startTime => 'Start time:';

  @override
  String get endTime => 'End time:';

  @override
  String get sendTestNotification => 'Send Test Notification';

  @override
  String get close => 'Close';

  @override
  String get averagePerRecord => 'Average per record:';

  @override
  String get h2oSimpleDescription =>
      'App to track your daily water consumption and maintain healthy hydration.';

  @override
  String get developedWithFlutter => 'Developed with Flutter 💙';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get languageChanged => 'Language changed successfully';

  @override
  String get resetDataConfirmation =>
      'Are you sure you want to reset all data? This action cannot be undone.';

  @override
  String get loading => 'Loading H2OSync...';

  @override
  String get waterReminders => 'Water reminders';

  @override
  String get notificationPermissionDenied => 'Notification permission denied';

  @override
  String get aboutApp => 'About the App';

  @override
  String get appInfo => 'Information and credits';

  @override
  String get resetAllData => 'Reset All Data';

  @override
  String get appVersion => 'H2OSync v1.0.0';

  @override
  String get lightActivity => 'Light (1-3x/week)';

  @override
  String get moderateActivity => 'Moderate (3-5x/week)';

  @override
  String get intenseActivity => 'Intense (6-7x/week)';

  @override
  String get extremeActivity => 'Extreme (2x/day)';

  @override
  String get customGoalRecommended => 'Custom goal (recommended)';

  @override
  String mlPerDay(int amount) {
    return '${amount}ml per day';
  }

  @override
  String get tryAgain => 'Try again';

  @override
  String errorLoadingData(String error) {
    return 'Error loading data: $error';
  }

  @override
  String get welcomeToH2O => 'Welcome to H2OSync!';

  @override
  String get noRecordsThisDay => 'No records on this day';

  @override
  String get dataResetSuccess => 'Data reset successfully';

  @override
  String get invalidAmount => 'Please enter a valid amount';

  @override
  String get amountTooSmall => 'Amount must be greater than 0ml';

  @override
  String get notificationsEnabled => 'Notifications enabled successfully';

  @override
  String get notificationsNotAvailable =>
      'Notifications are not available on this device';

  @override
  String get errorEnablingNotifications => 'Error enabling notifications';

  @override
  String setupCompleteWithGoal(int goal) {
    return '✅ Setup complete! Goal: ${goal}ml/day';
  }

  @override
  String setupCompleteManual(int goal) {
    return '⚙️ Setup complete! Goal: ${goal}ml/day';
  }

  @override
  String errorSavingSettings(String error) {
    return 'Error saving settings: $error';
  }

  @override
  String confirmDelete(String itemName) {
    return 'Do you really want to delete $itemName?';
  }

  @override
  String get errorLoadingHydrationData => 'Error loading hydration data';

  @override
  String get errorAddingWaterIntake => 'Error adding water intake';

  @override
  String get errorRemovingWaterIntake => 'Error removing water intake';

  @override
  String get errorCheckingNotifications => 'Error checking notifications';

  @override
  String get confirmDeletion => 'Confirm deletion';

  @override
  String get delete => 'Delete';

  @override
  String get confirmReset => 'Confirm reset';

  @override
  String get resetConfirmMessage =>
      'This action will permanently delete all data. Do you want to continue?';

  @override
  String get today => 'Today';

  @override
  String get day => 'Day';

  @override
  String get week => 'Week';

  @override
  String get month => 'Month';

  @override
  String get goalAchieved => '🎉 Goal achieved!';

  @override
  String get goalCompleted => '🎉 Goal Achieved!';

  @override
  String goalCompletedMessage(int amount) {
    return 'Congratulations! You reached your daily goal. Keep up the excellent hydration!';
  }

  @override
  String get weeklyAchievement => '🗓️ Weekly Success!';

  @override
  String weeklyAchievementMessage(int days) {
    return 'Amazing! You completed your hydration goal $days days this week. You\'re building a healthy habit!';
  }

  @override
  String get streakMilestone => '🔥 Streak Milestone!';

  @override
  String streakMilestoneMessage(int days) {
    return 'Incredible! You\'ve maintained your hydration streak for $days consecutive days. You\'re a hydration champion!';
  }

  @override
  String get adLabel => 'Ad';

  @override
  String get smartHydrationBottle => 'Smart Hydration Bottle';

  @override
  String get hydrationSupplements => 'Hydration+ Supplements';

  @override
  String get premiumFitWaterApp => 'FitWater Premium App';

  @override
  String get hydrationProducts => 'Hydration Products';

  @override
  String get monitorAutomatically => 'Monitor automatically without effort';

  @override
  String get naturalElectrolytes => 'Natural electrolytes for all day';

  @override
  String get advancedFeaturesNoAds => 'Advanced features without ads';

  @override
  String get improveDailyHydration => 'Improve your daily hydration';

  @override
  String get totalConsumed => 'Total consumed:';

  @override
  String get todayHydration => 'Today\'s hydration';

  @override
  String ofTarget(int target) {
    return 'of ${target}ml';
  }

  @override
  String get confirm => 'Confirm';

  @override
  String get amountMl => 'Amount (ml)';

  @override
  String get customizeNotificationSettings =>
      'You can customize the times and intervals in the settings.';

  @override
  String get welcomeToH2OSimple => 'Welcome to H2OSync!';

  @override
  String get letsCustomizeExperience => 'Let\'s customize your experience!';

  @override
  String get helpMaintainHealthyHydration =>
      'To help you maintain healthy hydration, we\'ll set up:';

  @override
  String get basedOnWeightAgeActivity =>
      'Based on your weight, age and activity level';

  @override
  String get intelligentReminders => 'Intelligent reminders';

  @override
  String get ageYears => 'Age';

  @override
  String get receiveIntelligentReminders =>
      'Receive intelligent reminders to drink water throughout the day';

  @override
  String get goalMlLabel => 'Goal (ml)';

  @override
  String get recommendedDailyGoal => 'Recommended: 2000ml - 2500ml per day';

  @override
  String get adultRecommendation =>
      'The recommended goal for adults is 2-3 liters per day.';

  @override
  String get confirmDeleteWaterRecord =>
      'Do you really want to delete this water intake record?';

  @override
  String get testNotificationTitle => 'H2OSync - Test';

  @override
  String get testNotificationBody =>
      '💧 This is a test notification! Your notifications are working.';

  @override
  String get everyHourInterval => 'Every hour';

  @override
  String everyXHoursInterval(int hours) {
    return 'Every $hours hours';
  }

  @override
  String fromToSchedule(String startTime, String endTime) {
    return 'From $startTime to $endTime';
  }

  @override
  String get yesterday => 'Yesterday';

  @override
  String get monShort => 'Mon';

  @override
  String get tueShort => 'Tue';

  @override
  String get wedShort => 'Wed';

  @override
  String get thuShort => 'Thu';

  @override
  String get friShort => 'Fri';

  @override
  String get satShort => 'Sat';

  @override
  String get sunShort => 'Sun';

  @override
  String get dailyConsumption => 'Daily Consumption';

  @override
  String get weeklyConsumption => 'Weekly Consumption';

  @override
  String get monthlyConsumption => 'Monthly Consumption';

  @override
  String get weekLabel => 'Week';

  @override
  String get daysLabel => 'Days';

  @override
  String get mlUnit => 'ml';

  @override
  String extraAmount(int amount) {
    return '+${amount}ml extra';
  }

  @override
  String get removeAds => 'Remove Ads';

  @override
  String get premiumFeatures => 'Premium Features';

  @override
  String get removeAdsDescription => 'Remove all ads for a smoother experience';

  @override
  String get purchaseRemoveAds => 'Purchase - Remove Ads';

  @override
  String get removeAdsForever => 'Remove all ads permanently for just:';

  @override
  String get buyNow => 'Buy Now';

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String get purchaseSuccess => 'Purchase successful! Ads have been removed.';

  @override
  String get purchaseError => 'Error processing purchase. Please try again.';

  @override
  String get restoreSuccess => 'Purchases restored successfully!';

  @override
  String get restoreError => 'No purchases found to restore.';

  @override
  String get purchaseNotAvailable => 'Purchases not available at the moment.';

  @override
  String get premiumUser => 'Premium User';

  @override
  String get thanksForSupport => 'Thank you for your support! 💙';

  @override
  String get independentDeveloper => 'Independent Developer';

  @override
  String get supportMessage =>
      'Your purchase helps me a lot to continue developing and improving the app! 🙏\n\nAs an independent developer, every support makes a difference to keep H2OSync always updated.';

  @override
  String get oneTimePayment => 'One-time payment';

  @override
  String get purchaseThankYou =>
      'Thank you for your support! Ads removed successfully! 🎉';

  @override
  String get processingPurchase => 'Processing purchase...';

  @override
  String get dataResetError => 'Error resetting data. Please try again.';
}
