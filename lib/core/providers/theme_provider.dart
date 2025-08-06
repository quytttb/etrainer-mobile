import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_constants.dart';
import '../services/hive_service.dart';
import 'app_provider.dart';

// Theme Mode State Notifier
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final HiveService _hiveService;

  ThemeModeNotifier(this._hiveService) : super(ThemeMode.system) {
    _loadThemeMode();
  }

  void _loadThemeMode() {
    final isDarkMode = _hiveService.getSetting<bool>(
      AppConstants.isDarkModeKey,
      defaultValue: false,
    );
    
    if (isDarkMode == null) {
      state = ThemeMode.system;
    } else {
      state = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    
    bool? isDarkMode;
    switch (mode) {
      case ThemeMode.light:
        isDarkMode = false;
        break;
      case ThemeMode.dark:
        isDarkMode = true;
        break;
      case ThemeMode.system:
        isDarkMode = null;
        break;
    }
    
    if (isDarkMode != null) {
      await _hiveService.saveSetting(AppConstants.isDarkModeKey, isDarkMode);
    } else {
      await _hiveService.deleteSetting(AppConstants.isDarkModeKey);
    }
  }

  Future<void> toggleTheme() async {
    switch (state) {
      case ThemeMode.light:
        await setThemeMode(ThemeMode.dark);
        break;
      case ThemeMode.dark:
        await setThemeMode(ThemeMode.light);
        break;
      case ThemeMode.system:
        await setThemeMode(ThemeMode.light);
        break;
    }
  }
}

// Theme Mode Provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return ThemeModeNotifier(hiveService);
});

// Current theme brightness provider
final currentThemeBrightnessProvider = Provider<Brightness>((ref) {
  final themeMode = ref.watch(themeModeProvider);
  
  switch (themeMode) {
    case ThemeMode.light:
      return Brightness.light;
    case ThemeMode.dark:
      return Brightness.dark;
    case ThemeMode.system:
      // This would typically get the system brightness
      // For now, default to light
      return Brightness.light;
  }
});

// Is dark mode provider
final isDarkModeProvider = Provider<bool>((ref) {
  final brightness = ref.watch(currentThemeBrightnessProvider);
  return brightness == Brightness.dark;
});
