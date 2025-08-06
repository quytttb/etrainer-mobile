import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

import '../../data/models/user_model.dart';
import '../../core/services/auth_service.dart';
import '../../core/providers/providers.dart';

// Auth State
class AuthState extends Equatable {
  final UserModel? user;
  final bool isLoading;
  final bool isAuthenticated;
  final String? error;
  final bool isInitialized;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.isAuthenticated = false,
    this.error,
    this.isInitialized = false,
  });

  const AuthState.initial()
      : user = null,
        isLoading = false,
        isAuthenticated = false,
        error = null,
        isInitialized = false;

  const AuthState.loading()
      : user = null,
        isLoading = true,
        isAuthenticated = false,
        error = null,
        isInitialized = false;

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    bool? isAuthenticated,
    String? error,
    bool? isInitialized,
    bool clearError = false,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      error: clearError ? null : (error ?? this.error),
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  @override
  List<Object?> get props => [
        user,
        isLoading,
        isAuthenticated,
        error,
        isInitialized,
      ];
}

// Auth State Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final Logger _logger = Logger();

  AuthNotifier(this._authService) : super(const AuthState.initial()) {
    _initializeAuth();
  }

  /// Initialize authentication state
  Future<void> _initializeAuth() async {
    try {
      _logger.i('Initializing authentication state');
      
      final currentUser = _authService.getCurrentUser();
      
      if (currentUser != null) {
        // Check if token is still valid
        final isTokenValid = await _authService.ensureTokenValid();
        
        if (isTokenValid) {
          state = state.copyWith(
            user: currentUser,
            isAuthenticated: true,
            isInitialized: true,
            clearError: true,
          );
          _logger.i('User authenticated: ${currentUser.email}');
        } else {
          // Token invalid, logout user
          await logout();
          state = state.copyWith(
            isInitialized: true,
            clearError: true,
          );
          _logger.w('Token invalid, user logged out');
        }
      } else {
        state = state.copyWith(
          isInitialized: true,
          clearError: true,
        );
        _logger.i('No authenticated user found');
      }
    } catch (e) {
      _logger.e('Auth initialization error: $e');
      state = state.copyWith(
        error: 'Authentication initialization failed',
        isInitialized: true,
      );
    }
  }

  /// Login with email and password
  Future<void> loginWithEmail(String email, String password) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, clearError: true);
    
    try {
      _logger.i('Attempting email login for: $email');
      
      final user = await _authService.loginWithEmail(email, password);
      
      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
        clearError: true,
      );
      
      _logger.i('Email login successful');
    } catch (e) {
      _logger.e('Email login failed: $e');
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Register with email and password
  Future<void> registerWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, clearError: true);
    
    try {
      _logger.i('Attempting email registration for: $email');
      
      final user = await _authService.registerWithEmail(
        email: email,
        password: password,
        fullName: fullName,
      );
      
      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
        clearError: true,
      );
      
      _logger.i('Email registration successful');
    } catch (e) {
      _logger.e('Email registration failed: $e');
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Login with Google
  Future<void> loginWithGoogle() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, clearError: true);
    
    try {
      _logger.i('Attempting Google login');
      
      final user = await _authService.loginWithGoogle();
      
      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
        clearError: true,
      );
      
      _logger.i('Google login successful');
    } catch (e) {
      _logger.e('Google login failed: $e');
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      _logger.i('Attempting logout');
      
      await _authService.logout();
      
      state = const AuthState(
        isAuthenticated: false,
        isInitialized: true,
      );
      
      _logger.i('Logout successful');
    } catch (e) {
      _logger.e('Logout failed: $e');
      // Even if logout fails, clear local state
      state = state.copyWith(
        user: null,
        isAuthenticated: false,
        error: 'Logout failed, but local session cleared',
      );
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Update user profile
  Future<void> updateUser(UserModel updatedUser) async {
    try {
      state = state.copyWith(user: updatedUser);
      _logger.i('User profile updated');
    } catch (e) {
      _logger.e('Failed to update user: $e');
      state = state.copyWith(error: 'Failed to update profile');
    }
  }
}

// Form State for Login/Register screens
class AuthFormState extends Equatable {
  final String email;
  final String password;
  final String fullName;
  final String confirmPassword;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool isFormValid;

  const AuthFormState({
    this.email = '',
    this.password = '',
    this.fullName = '',
    this.confirmPassword = '',
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.isFormValid = false,
  });

  AuthFormState copyWith({
    String? email,
    String? password,
    String? fullName,
    String? confirmPassword,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    bool? isFormValid,
  }) {
    return AuthFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword: obscureConfirmPassword ?? this.obscureConfirmPassword,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        fullName,
        confirmPassword,
        obscurePassword,
        obscureConfirmPassword,
        isFormValid,
      ];
}

class AuthFormNotifier extends StateNotifier<AuthFormState> {
  AuthFormNotifier() : super(const AuthFormState());

  void setEmail(String email) {
    state = state.copyWith(email: email);
    _validateForm();
  }

  void setPassword(String password) {
    state = state.copyWith(password: password);
    _validateForm();
  }

  void setFullName(String fullName) {
    state = state.copyWith(fullName: fullName);
    _validateForm();
  }

  void setConfirmPassword(String confirmPassword) {
    state = state.copyWith(confirmPassword: confirmPassword);
    _validateForm();
  }

  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword);
  }

  void clearForm() {
    state = const AuthFormState();
  }

  void _validateForm() {
    final isEmailValid = _isValidEmail(state.email);
    final isPasswordValid = state.password.length >= 6;
    final isFormValid = isEmailValid && isPasswordValid;
    
    state = state.copyWith(isFormValid: isFormValid);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool isValidForLogin() {
    return _isValidEmail(state.email) && state.password.length >= 6;
  }

  bool isValidForRegister() {
    return _isValidEmail(state.email) &&
           state.password.length >= 6 &&
           state.fullName.trim().length >= 2 &&
           state.password == state.confirmPassword;
  }
}

// Providers
final authServiceProvider = Provider<AuthService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  final hiveService = ref.read(hiveServiceProvider);
  return AuthService(apiService, hiveService);
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.read(authServiceProvider);
  return AuthNotifier(authService);
});

final authFormProvider = StateNotifierProvider<AuthFormNotifier, AuthFormState>((ref) {
  return AuthFormNotifier();
});

// Helper providers
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isAuthenticated;
});

final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authStateProvider).user;
});

final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authStateProvider).error;
});

final authLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isLoading;
});

final authInitializedProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isInitialized;
});
