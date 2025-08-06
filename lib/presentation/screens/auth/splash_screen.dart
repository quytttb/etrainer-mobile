import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/constants/theme_constants.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _navigateToNextScreen();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.7, curve: Curves.elasticOut),
      ),
    );

    _animationController.forward();
  }

  Future<void> _navigateToNextScreen() async {
    // Wait for splash animation to complete
    await Future.delayed(const Duration(milliseconds: 3000));

    if (!mounted) return;

    final isAuthenticated = ref.read(isAuthenticatedProvider);
    final isFirstLaunch = ref.read(isFirstLaunchProvider);

    if (isFirstLaunch) {
      // Show onboarding
      _navigateToOnboarding();
    } else if (isAuthenticated) {
      // Navigate to home
      _navigateToHome();
    } else {
      // Navigate to login
      _navigateToLogin();
    }
  }

  void _navigateToOnboarding() {
    context.go('/login');
  }

  void _navigateToHome() {
    context.go('/home');
  }

  void _navigateToLogin() {
    context.go('/login');
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstants.primaryColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: ThemeConstants.primaryGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Animation
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: ThemeConstants.white,
                          borderRadius: BorderRadius.circular(
                            ThemeConstants.borderRadiusLarge,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: ThemeConstants.black.withValues(
                                alpha: 0.2,
                              ),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.school,
                          size: 60,
                          color: ThemeConstants.primaryColor,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: ThemeConstants.spacingLarge),

              // App Name
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: const Text(
                      'ETrainer',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: ThemeConstants.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: ThemeConstants.spacingSmall),

              // Tagline
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: const Text(
                      'Master English with Confidence',
                      style: TextStyle(
                        fontSize: 16,
                        color: ThemeConstants.white,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.5,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: ThemeConstants.spacingXXLarge),

              // Loading Indicator
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          ThemeConstants.white,
                        ),
                        strokeWidth: 3,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: ThemeConstants.spacingMedium),

              // Loading Text
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: const Text(
                      'Preparing your learning journey...',
                      style: TextStyle(
                        fontSize: 14,
                        color: ThemeConstants.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
