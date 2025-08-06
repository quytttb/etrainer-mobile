import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:timezone/timezone.dart' as tz;
import '../constants/app_constants.dart';

class NotificationService {
  static NotificationService? _instance;
  static NotificationService get instance => _instance ??= NotificationService._();
  
  NotificationService._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      // Initialize local notifications
      await _initializeLocalNotifications();
      
      // Initialize Firebase messaging
      await _initializeFirebaseMessaging();
      
      _isInitialized = true;
      debugPrint('✅ Notification service initialized');
    } catch (e) {
      debugPrint('❌ Notification service initialization failed: $e');
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channels for Android
    await _createNotificationChannels();
  }

  Future<void> _createNotificationChannels() async {
    const channelConfigs = [
      AndroidNotificationChannel(
        'daily_reminder',
        'Daily Reminders',
        description: 'Daily study reminders',
        importance: Importance.high,
        playSound: true,
      ),
      AndroidNotificationChannel(
        'achievements',
        'Achievements',
        description: 'Achievement notifications',
        importance: Importance.high,
        playSound: true,
      ),
      AndroidNotificationChannel(
        'journey_progress',
        'Journey Progress',
        description: 'Journey milestone notifications',
        importance: Importance.defaultImportance,
        playSound: false,
      ),
    ];

    for (final channel in channelConfigs) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  Future<void> _initializeFirebaseMessaging() async {
    // Request permissions
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('✅ Firebase messaging permission granted');
      
      // Get FCM token
      final token = await _firebaseMessaging.getToken();
      debugPrint('📱 FCM Token: $token');
      
      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      
      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      
      // Handle notification taps when app is in background
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
      
      // Check for initial message (when app is opened from terminated state)
      final initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationTap(initialMessage);
      }
    } else {
      debugPrint('❌ Firebase messaging permission denied');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('📨 Foreground message received: ${message.messageId}');
    
    // Show local notification for foreground messages
    _showLocalNotification(
      title: message.notification?.title ?? 'ETrainer',
      body: message.notification?.body ?? '',
      payload: message.data.toString(),
    );
  }

  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('🔔 Notification tapped: ${message.messageId}');
    
    // Handle navigation based on message data
    final data = message.data;
    if (data.isNotEmpty) {
      _navigateBasedOnData(data);
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('🔔 Local notification tapped: ${response.id}');
    
    if (response.payload != null) {
      // Handle local notification tap
      _navigateBasedOnPayload(response.payload!);
    }
  }

  void _navigateBasedOnData(Map<String, dynamic> data) {
    final type = data['type'] as String?;
    // final targetId = data['targetId'] as String?; // TODO: Use this when implementing navigation
    
    switch (type) {
      case 'journey_progress':
        // Navigate to journey screen
        break;
      case 'achievement':
        // Navigate to achievements screen
        break;
      case 'daily_reminder':
        // Navigate to practice screen
        break;
      default:
        // Navigate to home
        break;
    }
  }

  void _navigateBasedOnPayload(String payload) {
    // Parse payload and navigate accordingly
    debugPrint('Navigating based on payload: $payload');
  }

  // Public methods for showing notifications
  Future<void> showDailyReminder({
    String title = 'Time to study!',
    String body = 'Don\'t forget your daily English lesson.',
  }) async {
    await _showLocalNotification(
      id: AppConstants.dailyReminderNotificationId,
      title: title,
      body: body,
      channelId: 'daily_reminder',
    );
  }

  Future<void> showAchievementNotification({
    required String title,
    required String body,
  }) async {
    await _showLocalNotification(
      id: AppConstants.achievementNotificationId,
      title: title,
      body: body,
      channelId: 'achievements',
    );
  }

  Future<void> showJourneyProgressNotification({
    required String title,
    required String body,
  }) async {
    await _showLocalNotification(
      id: AppConstants.journeyProgressNotificationId,
      title: title,
      body: body,
      channelId: 'journey_progress',
    );
  }

  Future<void> _showLocalNotification({
    required String title,
    required String body,
    int? id,
    String channelId = 'default',
    String? payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelId,
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id ?? DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // Schedule daily reminder
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    String title = 'Time to study!',
    String body = 'Don\'t forget your daily English lesson.',
  }) async {
    await _localNotifications.zonedSchedule(
      AppConstants.dailyReminderNotificationId,
      title,
      body,
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder',
          'Daily Reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    
    return scheduledDate;
  }

  // Cancel notifications
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  // Get FCM token
  Future<String?> getFCMToken() async {
    return await _firebaseMessaging.getToken();
  }

  // Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  // Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  void dispose() {
    // Clean up resources if needed
  }
}

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('📨 Background message received: ${message.messageId}');
  
  // Handle background message
  // Note: You can't update UI here, only perform background tasks
}
