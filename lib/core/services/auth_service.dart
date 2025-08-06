import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

import '../constants/api_constants.dart';
import '../constants/hive_constants.dart';
import '../../data/models/user_model.dart';
import 'api_service.dart';
import 'hive_service.dart';

class AuthService {
  final ApiService _apiService;
  final HiveService _hiveService;
  final GoogleSignIn _googleSignIn;
  final Logger _logger = Logger();

  AuthService(this._apiService, this._hiveService)
      : _googleSignIn = GoogleSignIn(
          scopes: ['email', 'profile'],
        );

  /// Get current authenticated user from local storage
  UserModel? getCurrentUser() {
    try {
      final userBox = _hiveService.getBox<UserModel>(HiveConstants.userBox);
      return userBox.get(HiveConstants.currentUserKey);
    } catch (e) {
      _logger.e('Error getting current user: $e');
      return null;
    }
  }

  /// Check if user is authenticated
  bool get isAuthenticated => getCurrentUser() != null;

  /// Get auth token from local storage
  String? getAuthToken() {
    try {
      final settingsBox = _hiveService.getBox(HiveConstants.settingsBox);
      return settingsBox.get(HiveConstants.authTokenKey);
    } catch (e) {
      _logger.e('Error getting auth token: $e');
      return null;
    }
  }

  /// Login with email and password
  Future<UserModel> loginWithEmail(String email, String password) async {
    try {
      _logger.i('Attempting login with email: $email');

      final response = await _apiService.post(
        ApiConstants.loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final user = UserModel.fromJson(data['user']);
        final token = data['token'];

        // Save user and token to local storage
        await _saveUserData(user, token);
        
        _logger.i('Login successful for user: ${user.email}');
        return user;
      } else {
        throw Exception('Login failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      _logger.e('Login API error: ${e.message}');
      if (e.response?.statusCode == 401) {
        throw Exception('Invalid email or password');
      } else if (e.response?.statusCode == 422) {
        throw Exception('Invalid email format');
      } else {
        throw Exception('Network error. Please try again.');
      }
    } catch (e) {
      _logger.e('Login error: $e');
      throw Exception('Login failed. Please try again.');
    }
  }

  /// Register with email and password
  Future<UserModel> registerWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      _logger.i('Attempting registration with email: $email');

      final response = await _apiService.post(
        ApiConstants.registerEndpoint,
        data: {
          'email': email,
          'password': password,
          'fullName': fullName,
        },
      );

      if (response.statusCode == 201) {
        final data = response.data;
        final user = UserModel.fromJson(data['user']);
        final token = data['token'];

        // Save user and token to local storage
        await _saveUserData(user, token);
        
        _logger.i('Registration successful for user: ${user.email}');
        return user;
      } else {
        throw Exception('Registration failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      _logger.e('Registration API error: ${e.message}');
      if (e.response?.statusCode == 409) {
        throw Exception('Email already exists');
      } else if (e.response?.statusCode == 422) {
        throw Exception('Invalid input data');
      } else {
        throw Exception('Network error. Please try again.');
      }
    } catch (e) {
      _logger.e('Registration error: $e');
      throw Exception('Registration failed. Please try again.');
    }
  }

  /// Login with Google
  Future<UserModel> loginWithGoogle() async {
    try {
      _logger.i('Attempting Google Sign-In');

      // Sign out first to ensure fresh authentication
      await _googleSignIn.signOut();
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw Exception('Google sign-in was cancelled');
      }

      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw Exception('Failed to get Google authentication tokens');
      }

      // Send tokens to backend for verification
      final response = await _apiService.post(
        ApiConstants.googleLoginEndpoint,
        data: {
          'accessToken': googleAuth.accessToken,
          'idToken': googleAuth.idToken,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final user = UserModel.fromJson(data['user']);
        final token = data['token'];

        // Save user and token to local storage
        await _saveUserData(user, token);
        
        _logger.i('Google Sign-In successful for user: ${user.email}');
        return user;
      } else {
        throw Exception('Google login failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      _logger.e('Google login API error: ${e.message}');
      throw Exception('Google login failed. Please try again.');
    } catch (e) {
      _logger.e('Google Sign-In error: $e');
      rethrow;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      _logger.i('Attempting logout');

      // Call logout API if token exists
      final token = getAuthToken();
      if (token != null) {
        try {
          await _apiService.post(ApiConstants.logoutEndpoint);
        } catch (e) {
          _logger.w('Logout API call failed, continuing with local logout: $e');
        }
      }

      // Clear local data
      await _clearUserData();
      
      // Sign out from Google
      try {
        await _googleSignIn.signOut();
      } catch (e) {
        _logger.w('Google sign out failed: $e');
      }

      _logger.i('Logout successful');
    } catch (e) {
      _logger.e('Logout error: $e');
      // Still clear local data even if API fails
      await _clearUserData();
      rethrow;
    }
  }

  /// Refresh auth token
  Future<void> refreshToken() async {
    try {
      final refreshToken = _hiveService.getBox(HiveConstants.settingsBox)
          .get(HiveConstants.refreshTokenKey);
      
      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }

      final response = await _apiService.post(
        ApiConstants.refreshTokenEndpoint,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final newToken = response.data['token'];
        final newRefreshToken = response.data['refreshToken'];

        // Update tokens in local storage
        final settingsBox = _hiveService.getBox(HiveConstants.settingsBox);
        await settingsBox.put(HiveConstants.authTokenKey, newToken);
        await settingsBox.put(HiveConstants.refreshTokenKey, newRefreshToken);

        _logger.i('Token refreshed successfully');
      } else {
        throw Exception('Token refresh failed');
      }
    } catch (e) {
      _logger.e('Token refresh error: $e');
      // If refresh fails, logout user
      await logout();
      rethrow;
    }
  }

  /// Check if token is expired and refresh if needed
  Future<bool> ensureTokenValid() async {
    try {
      // Make a test API call to check token validity
      final response = await _apiService.get(ApiConstants.profileEndpoint);
      return response.statusCode == 200;
    } catch (e) {
      // Token might be expired, try to refresh
      try {
        await refreshToken();
        return true;
      } catch (refreshError) {
        _logger.e('Token validation and refresh failed: $refreshError');
        return false;
      }
    }
  }

  /// Save user data and token to local storage
  Future<void> _saveUserData(UserModel user, String token) async {
    try {
      // Save user
      final userBox = _hiveService.getBox<UserModel>(HiveConstants.userBox);
      await userBox.put(HiveConstants.currentUserKey, user);

      // Save token
      final settingsBox = _hiveService.getBox(HiveConstants.settingsBox);
      await settingsBox.put(HiveConstants.authTokenKey, token);

      _logger.d('User data saved to local storage');
    } catch (e) {
      _logger.e('Error saving user data: $e');
      rethrow;
    }
  }

  /// Clear all user data from local storage
  Future<void> _clearUserData() async {
    try {
      // Clear user data
      final userBox = _hiveService.getBox<UserModel>(HiveConstants.userBox);
      await userBox.clear();

      // Clear auth tokens
      final settingsBox = _hiveService.getBox(HiveConstants.settingsBox);
      await settingsBox.delete(HiveConstants.authTokenKey);
      await settingsBox.delete(HiveConstants.refreshTokenKey);

      _logger.d('User data cleared from local storage');
    } catch (e) {
      _logger.e('Error clearing user data: $e');
      rethrow;
    }
  }
}
