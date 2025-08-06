class AppConstants {
  // App Information
  static const String appName = 'ETrainer';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'English Learning App';
  
  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String isFirstLaunchKey = 'is_first_launch';
  static const String selectedLanguageKey = 'selected_language';
  static const String isDarkModeKey = 'is_dark_mode';
  static const String notificationEnabledKey = 'notification_enabled';
  static const String soundEnabledKey = 'sound_enabled';
  static const String autoPlayKey = 'auto_play';
  static const String studyReminderTimeKey = 'study_reminder_time';
  
  // Feature Flags
  static const bool enableGoogleSignIn = true;
  static const bool enablePushNotifications = true;
  static const bool enableOfflineMode = true;
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Cache Settings
  static const Duration cacheValidDuration = Duration(hours: 24);
  static const Duration imageCacheDuration = Duration(days: 7);
  
  // Quiz/Practice Settings
  static const int defaultQuizTimeLimit = 30; // minutes
  static const int maxQuestionsPerQuiz = 50;
  static const int minQuestionsPerQuiz = 5;
  static const int defaultQuestionsPerQuiz = 10;
  
  // Learning Settings
  static const int dailyStreakGoal = 7;
  static const int weeklyStudyGoal = 5; // days
  static const int minStudyTimePerDay = 10; // minutes
  static const int defaultStudyTimeGoal = 30; // minutes
  
  // Animation Durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;
  
  // Notification IDs
  static const int dailyReminderNotificationId = 1;
  static const int achievementNotificationId = 2;
  static const int journeyProgressNotificationId = 3;
  
  // External URLs
  static const String privacyPolicyUrl = 'https://etrainer.com/privacy';
  static const String termsOfServiceUrl = 'https://etrainer.com/terms';
  static const String supportEmailUrl = 'mailto:support@etrainer.com';
  static const String appStoreUrl = 'https://apps.apple.com/app/etrainer';
  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.etrainer.mobile';
  
  // Error Messages
  static const String networkErrorMessage = 'Please check your internet connection and try again.';
  static const String serverErrorMessage = 'Something went wrong. Please try again later.';
  static const String authErrorMessage = 'Please login again to continue.';
  static const String notFoundErrorMessage = 'The requested content was not found.';
  static const String unknownErrorMessage = 'An unexpected error occurred.';
  
  // Success Messages
  static const String loginSuccessMessage = 'Welcome back!';
  static const String registerSuccessMessage = 'Account created successfully!';
  static const String passwordResetSuccessMessage = 'Password reset link sent to your email.';
  static const String profileUpdateSuccessMessage = 'Profile updated successfully!';
}
