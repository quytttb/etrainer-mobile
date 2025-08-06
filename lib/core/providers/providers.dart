import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../services/hive_service.dart';

// Hive Service Provider
final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService.instance;
});

// API Service Provider
final apiServiceProvider = Provider<ApiService>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return ApiService(hiveService);
});
