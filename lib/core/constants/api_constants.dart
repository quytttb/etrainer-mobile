class ApiConstants {
  // Base URLs
  static const String baseUrl = 'https://etrainer-backend.vercel.app/api';
  static const String imageBaseUrl = 'https://etrainer-backend.vercel.app';
  
  // Authentication endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String googleLoginEndpoint = '/auth/google';
  static const String forgotPasswordEndpoint = '/auth/forgot-password';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String logoutEndpoint = '/auth/logout';
  static const String profileEndpoint = '/auth/profile';
  
  // Legacy support (keeping old constants for backward compatibility)
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String profile = '/auth/profile';
  
  // Journey endpoints
  static const String journeys = '/journeys';
  static const String journeyCurrent = '/journeys/current';
  static const String journeyProgress = '/journeys/progress';
  static const String stageComplete = '/journeys/stages/complete';
  static const String dayComplete = '/journeys/days/complete';
  
  // Content endpoints
  static const String vocabularyTopics = '/content/vocabulary/topics';
  static const String vocabularyByTopic = '/content/vocabulary/topic';
  static const String grammarRules = '/content/grammar/rules';
  static const String grammarByRule = '/content/grammar/rule';
  static const String lessons = '/content/lessons';
  static const String lessonDetail = '/content/lessons';
  
  // Practice endpoints
  static const String practiceQuestions = '/practice/questions';
  static const String practiceSubmit = '/practice/submit';
  static const String practiceHistory = '/practice/history';
  static const String practiceFavorites = '/practice/favorites';
  
  // Exam endpoints
  static const String exams = '/exams';
  static const String examDetail = '/exams';
  static const String examSubmit = '/exams/submit';
  static const String examResults = '/exams/results';
  
  // Statistics endpoints
  static const String userStats = '/stats/user';
  static const String progressStats = '/stats/progress';
  static const String achievements = '/stats/achievements';
  
  // Timeout configurations
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  
  // API Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
