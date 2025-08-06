import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import '../constants/hive_constants.dart';
import '../constants/app_constants.dart';
import '../../data/models/user_model.dart';
import '../../data/models/journey_model.dart';
import '../../data/models/question_model.dart';

class HiveService {
  static HiveService? _instance;
  static HiveService get instance => _instance ??= HiveService._();
  
  HiveService._();

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      await Hive.initFlutter();
      
      // Register all adapters
      await _registerAdapters();
      
      // Open all boxes
      await _openBoxes();
      
      _isInitialized = true;
      debugPrint('✅ Hive initialized successfully');
    } catch (e) {
      debugPrint('❌ Hive initialization failed: $e');
      rethrow;
    }
  }

  Future<void> _registerAdapters() async {
    // Register model adapters
    if (!Hive.isAdapterRegistered(HiveConstants.userModelTypeId)) {
      Hive.registerAdapter(UserModelAdapter());
    }
    
    if (!Hive.isAdapterRegistered(HiveConstants.journeyModelTypeId)) {
      Hive.registerAdapter(JourneyModelAdapter());
    }
    
    if (!Hive.isAdapterRegistered(HiveConstants.stageModelTypeId)) {
      Hive.registerAdapter(StageModelAdapter());
    }
    
    if (!Hive.isAdapterRegistered(HiveConstants.dayModelTypeId)) {
      Hive.registerAdapter(DayModelAdapter());
    }
    
    if (!Hive.isAdapterRegistered(HiveConstants.questionModelTypeId)) {
      Hive.registerAdapter(QuestionModelAdapter());
    }
    
    if (!Hive.isAdapterRegistered(HiveConstants.questionModelTypeId + 1)) {
      Hive.registerAdapter(AnswerOptionModelAdapter());
    }
  }

  Future<void> _openBoxes() async {
    final boxNames = [
      HiveConstants.userBox,
      HiveConstants.journeyBox,
      HiveConstants.practiceBox,
      HiveConstants.contentBox,
      HiveConstants.settingsBox,
      HiveConstants.cacheBox,
      HiveConstants.favoritesBox,
      HiveConstants.achievementsBox,
    ];

    for (final boxName in boxNames) {
      if (!Hive.isBoxOpen(boxName)) {
        await Hive.openBox(boxName);
      }
    }
  }

  // Generic box operations
  Box<T> getBox<T>(String boxName) {
    if (!Hive.isBoxOpen(boxName)) {
      throw Exception('Box $boxName is not open');
    }
    return Hive.box<T>(boxName);
  }

  Box getGeneralBox(String boxName) {
    if (!Hive.isBoxOpen(boxName)) {
      throw Exception('Box $boxName is not open');
    }
    return Hive.box(boxName);
  }

  // Auth-related methods
  Future<void> saveAuthTokens(String accessToken, String refreshToken) async {
    final settingsBox = getGeneralBox(HiveConstants.settingsBox);
    await settingsBox.put(AppConstants.authTokenKey, accessToken);
    await settingsBox.put(AppConstants.refreshTokenKey, refreshToken);
  }

  String? getAuthToken() {
    final settingsBox = getGeneralBox(HiveConstants.settingsBox);
    return settingsBox.get(AppConstants.authTokenKey);
  }

  String? getRefreshToken() {
    final settingsBox = getGeneralBox(HiveConstants.settingsBox);
    return settingsBox.get(AppConstants.refreshTokenKey);
  }

  Future<void> clearAuthData() async {
    final settingsBox = getGeneralBox(HiveConstants.settingsBox);
    await settingsBox.delete(AppConstants.authTokenKey);
    await settingsBox.delete(AppConstants.refreshTokenKey);
    
    // Clear user data
    final userBox = getBox<UserModel>(HiveConstants.userBox);
    await userBox.clear();
  }

  // User-related methods
  Future<void> saveUser(UserModel user) async {
    final userBox = getBox<UserModel>(HiveConstants.userBox);
    await userBox.put(HiveConstants.currentUserKey, user);
  }

  UserModel? getCurrentUser() {
    final userBox = getBox<UserModel>(HiveConstants.userBox);
    return userBox.get(HiveConstants.currentUserKey);
  }

  Future<void> updateUser(UserModel user) async {
    await saveUser(user);
  }

  // Journey-related methods
  Future<void> saveJourney(JourneyModel journey) async {
    final journeyBox = getBox<JourneyModel>(HiveConstants.journeyBox);
    await journeyBox.put(HiveConstants.currentJourneyKey, journey);
  }

  JourneyModel? getCurrentJourney() {
    final journeyBox = getBox<JourneyModel>(HiveConstants.journeyBox);
    return journeyBox.get(HiveConstants.currentJourneyKey);
  }

  Future<void> updateJourneyProgress(int stageIndex, int dayIndex) async {
    final journey = getCurrentJourney();
    if (journey != null) {
      // Update lastAccessedAt to track progress
      final updatedJourney = journey.copyWith(
        lastAccessedAt: DateTime.now(),
        completedStages: stageIndex,
      );
      await saveJourney(updatedJourney);
    }
  }

  // Settings-related methods
  Future<void> saveSetting(String key, dynamic value) async {
    final settingsBox = getGeneralBox(HiveConstants.settingsBox);
    await settingsBox.put(key, value);
  }

  T? getSetting<T>(String key, {T? defaultValue}) {
    final settingsBox = getGeneralBox(HiveConstants.settingsBox);
    return settingsBox.get(key, defaultValue: defaultValue) as T?;
  }

  Future<void> deleteSetting(String key) async {
    final settingsBox = getGeneralBox(HiveConstants.settingsBox);
    await settingsBox.delete(key);
  }

  // Cache-related methods
  Future<void> saveToCache(String key, dynamic data, {Duration? expiration}) async {
    final cacheBox = getGeneralBox(HiveConstants.cacheBox);
    final cacheEntry = {
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'expiration': expiration?.inMilliseconds,
    };
    await cacheBox.put(key, cacheEntry);
  }

  T? getFromCache<T>(String key) {
    final cacheBox = getGeneralBox(HiveConstants.cacheBox);
    final cacheEntry = cacheBox.get(key);
    
    if (cacheEntry == null) return null;
    
    final timestamp = cacheEntry['timestamp'] as int?;
    final expiration = cacheEntry['expiration'] as int?;
    
    if (expiration != null && timestamp != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - timestamp > expiration) {
        // Cache expired, remove it
        cacheBox.delete(key);
        return null;
      }
    }
    
    return cacheEntry['data'] as T?;
  }

  Future<void> clearCache() async {
    final cacheBox = getGeneralBox(HiveConstants.cacheBox);
    await cacheBox.clear();
  }

  // Favorites-related methods
  Future<void> addToFavorites(String type, String itemId) async {
    final favoritesBox = getGeneralBox(HiveConstants.favoritesBox);
    final favorites = List<String>.from(favoritesBox.get(type, defaultValue: <String>[]));
    
    if (!favorites.contains(itemId)) {
      favorites.add(itemId);
      await favoritesBox.put(type, favorites);
    }
  }

  Future<void> removeFromFavorites(String type, String itemId) async {
    final favoritesBox = getGeneralBox(HiveConstants.favoritesBox);
    final favorites = List<String>.from(favoritesBox.get(type, defaultValue: <String>[]));
    
    favorites.remove(itemId);
    await favoritesBox.put(type, favorites);
  }

  List<String> getFavorites(String type) {
    final favoritesBox = getGeneralBox(HiveConstants.favoritesBox);
    return List<String>.from(favoritesBox.get(type, defaultValue: <String>[]));
  }

  bool isFavorite(String type, String itemId) {
    final favorites = getFavorites(type);
    return favorites.contains(itemId);
  }

  // Practice history methods
  Future<void> savePracticeResult(Map<String, dynamic> result) async {
    final practiceBox = getGeneralBox(HiveConstants.practiceBox);
    final history = List<Map<String, dynamic>>.from(
      practiceBox.get(HiveConstants.practiceHistoryKey, defaultValue: <Map<String, dynamic>>[]),
    );
    
    history.insert(0, result); // Add to beginning
    
    // Keep only recent entries
    if (history.length > HiveConstants.maxPracticeHistory) {
      history.removeRange(HiveConstants.maxPracticeHistory, history.length);
    }
    
    await practiceBox.put(HiveConstants.practiceHistoryKey, history);
  }

  List<Map<String, dynamic>> getPracticeHistory() {
    final practiceBox = getGeneralBox(HiveConstants.practiceBox);
    return List<Map<String, dynamic>>.from(
      practiceBox.get(HiveConstants.practiceHistoryKey, defaultValue: <Map<String, dynamic>>[]),
    );
  }

  // Statistics methods
  Future<void> updateStatistics(Map<String, dynamic> stats) async {
    final achievementsBox = getGeneralBox(HiveConstants.achievementsBox);
    final currentStats = Map<String, dynamic>.from(
      achievementsBox.get(HiveConstants.statisticsDataKey, defaultValue: <String, dynamic>{}),
    );
    
    currentStats.addAll(stats);
    await achievementsBox.put(HiveConstants.statisticsDataKey, currentStats);
  }

  Map<String, dynamic> getStatistics() {
    final achievementsBox = getGeneralBox(HiveConstants.achievementsBox);
    return Map<String, dynamic>.from(
      achievementsBox.get(HiveConstants.statisticsDataKey, defaultValue: <String, dynamic>{}),
    );
  }

  // App state methods
  bool isFirstLaunch() {
    final settingsBox = getGeneralBox(HiveConstants.settingsBox);
    return settingsBox.get(AppConstants.isFirstLaunchKey, defaultValue: true);
  }

  Future<void> setFirstLaunchCompleted() async {
    final settingsBox = getGeneralBox(HiveConstants.settingsBox);
    await settingsBox.put(AppConstants.isFirstLaunchKey, false);
  }

  // Cleanup methods
  Future<void> clearAllData() async {
    final boxes = [
      HiveConstants.userBox,
      HiveConstants.journeyBox,
      HiveConstants.practiceBox,
      HiveConstants.contentBox,
      HiveConstants.settingsBox,
      HiveConstants.cacheBox,
      HiveConstants.favoritesBox,
      HiveConstants.achievementsBox,
    ];

    for (final boxName in boxes) {
      if (Hive.isBoxOpen(boxName)) {
        await Hive.box(boxName).clear();
      }
    }
  }

  Future<void> compactBoxes() async {
    final boxes = [
      HiveConstants.userBox,
      HiveConstants.journeyBox,
      HiveConstants.practiceBox,
      HiveConstants.contentBox,
      HiveConstants.settingsBox,
      HiveConstants.cacheBox,
      HiveConstants.favoritesBox,
      HiveConstants.achievementsBox,
    ];

    for (final boxName in boxes) {
      if (Hive.isBoxOpen(boxName)) {
        await Hive.box(boxName).compact();
      }
    }
  }

  Future<void> dispose() async {
    await Hive.close();
    _isInitialized = false;
  }
}
