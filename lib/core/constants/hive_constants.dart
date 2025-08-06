class HiveConstants {
  // Box Names
  static const String userBox = 'user_box';
  static const String journeyBox = 'journey_box';
  static const String practiceBox = 'practice_box';
  static const String contentBox = 'content_box';
  static const String settingsBox = 'settings_box';
  static const String cacheBox = 'cache_box';
  static const String favoritesBox = 'favorites_box';
  static const String achievementsBox = 'achievements_box';
  
  // Type IDs for Hive Models (must be unique)
  static const int userModelTypeId = 0;
  static const int journeyModelTypeId = 1;
  static const int stageModelTypeId = 2;
  static const int dayModelTypeId = 3;
  static const int questionModelTypeId = 4;
  static const int practiceModelTypeId = 5;
  static const int examModelTypeId = 6;
  static const int vocabularyModelTypeId = 7;
  static const int grammarModelTypeId = 8;
  static const int lessonModelTypeId = 9;
  static const int progressModelTypeId = 10;
  static const int achievementModelTypeId = 11;
  static const int statisticsModelTypeId = 12;
  static const int notificationModelTypeId = 13;
  static const int settingsModelTypeId = 14;
  static const int cacheEntryModelTypeId = 15;
  static const int answerOptionModelTypeId = 16;
  
  // User Box Keys
  static const String currentUserKey = 'current_user';
  static const String userTokenKey = 'user_token';
  static const String userRefreshTokenKey = 'user_refresh_token';
  static const String userSettingsKey = 'user_settings';
  
  // Settings Box Keys (for auth tokens)
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  
  // Journey Box Keys
  static const String currentJourneyKey = 'current_journey';
  static const String journeyProgressKey = 'journey_progress';
  static const String completedStagesKey = 'completed_stages';
  static const String currentStageKey = 'current_stage';
  static const String currentDayKey = 'current_day';
  
  // Practice Box Keys
  static const String practiceHistoryKey = 'practice_history';
  static const String practiceResultsKey = 'practice_results';
  static const String practiceStatsKey = 'practice_stats';
  static const String favoriteQuestionsKey = 'favorite_questions';
  
  // Content Box Keys
  static const String vocabularyTopicsKey = 'vocabulary_topics';
  static const String grammarRulesKey = 'grammar_rules';
  static const String lessonsKey = 'lessons';
  static const String contentCacheKey = 'content_cache';
  
  // Settings Box Keys
  static const String themeSettingsKey = 'theme_settings';
  static const String notificationSettingsKey = 'notification_settings';
  static const String languageSettingsKey = 'language_settings';
  static const String studySettingsKey = 'study_settings';
  static const String appSettingsKey = 'app_settings';
  
  // Cache Box Keys
  static const String apiCacheKey = 'api_cache';
  static const String imageCacheKey = 'image_cache';
  static const String lastSyncKey = 'last_sync';
  static const String offlineDataKey = 'offline_data';
  
  // Favorites Box Keys
  static const String favoriteVocabularyKey = 'favorite_vocabulary';
  static const String favoriteGrammarKey = 'favorite_grammar';
  static const String favoriteLessonsKey = 'favorite_lessons';
  
  // Achievements Box Keys
  static const String unlockedAchievementsKey = 'unlocked_achievements';
  static const String achievementProgressKey = 'achievement_progress';
  static const String streakDataKey = 'streak_data';
  static const String statisticsDataKey = 'statistics_data';
  
  // Cache Expiration
  static const Duration defaultCacheExpiration = Duration(hours: 24);
  static const Duration shortCacheExpiration = Duration(hours: 1);
  static const Duration longCacheExpiration = Duration(days: 7);
  
  // Storage Limits
  static const int maxCacheEntries = 1000;
  static const int maxPracticeHistory = 500;
  static const int maxFavoriteItems = 200;
}
