import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/hive_service.dart';
import '../services/connectivity_service.dart';
import '../services/notification_service.dart';

// Core Services Providers
final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService.instance;
});

final apiServiceProvider = Provider<ApiService>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return ApiService(hiveService);
});

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService.instance;
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService.instance;
});

// Connectivity Stream Provider
final connectivityProvider = StreamProvider<bool>((ref) {
  final connectivityService = ref.watch(connectivityServiceProvider);
  return connectivityService.connectivityStream;
});

// Current connectivity state
final isConnectedProvider = Provider<bool>((ref) {
  final connectivityAsyncValue = ref.watch(connectivityProvider);
  return connectivityAsyncValue.when(
    data: (isConnected) => isConnected,
    loading: () => true, // Assume connected while loading
    error: (_, __) => false,
  );
});

// App initialization provider
final appInitializationProvider = FutureProvider<void>((ref) async {
  final hiveService = ref.watch(hiveServiceProvider);
  final connectivityService = ref.watch(connectivityServiceProvider);
  final notificationService = ref.watch(notificationServiceProvider);

  // Initialize all services
  await Future.wait([
    hiveService.init(),
    connectivityService.init(),
    notificationService.init(),
  ]);
});

// Auth token provider
final authTokenProvider = Provider<String?>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return hiveService.getAuthToken();
});

// Is authenticated provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  final token = ref.watch(authTokenProvider);
  return token != null && token.isNotEmpty;
});

// First launch provider
final isFirstLaunchProvider = Provider<bool>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return hiveService.isFirstLaunch();
});

// Theme mode provider
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.system;
});
