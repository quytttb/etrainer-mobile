import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/providers/auth_providers.dart';
import '../../presentation/screens/auth/splash_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/journey/journey_screen.dart';
import '../../presentation/screens/journey/stage_detail_screen.dart';
import '../../presentation/screens/journey/daily_lesson_screen.dart';
import '../../presentation/screens/practice/practice_screen.dart';
import '../../presentation/screens/quiz/quiz_screen.dart';
import '../../presentation/screens/practice/result_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/profile/settings_screen.dart';
import '../../presentation/screens/shared/error_screen.dart';

// Route names constants
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String journey = '/journey';
  static const String stageDetail = '/journey/stage/:stageId';
  static const String dailyLesson = '/journey/stage/:stageId/day/:dayId';
  static const String practice = '/practice';
  static const String quiz = '/practice/quiz/:quizId';
  static const String quizResult = '/practice/result/:resultId';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String error = '/error';
}

// Router provider
final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isInitialized = authState.isInitialized;
      final isAuthenticated = authState.isAuthenticated;
      final isOnAuthPage =
          state.matchedLocation.startsWith('/login') ||
          state.matchedLocation.startsWith('/register');
      final isOnSplash = state.matchedLocation == AppRoutes.splash;

      // Still initializing
      if (!isInitialized) {
        return AppRoutes.splash;
      }

      // Not authenticated and not on auth page
      if (!isAuthenticated && !isOnAuthPage && !isOnSplash) {
        return AppRoutes.login;
      }

      // Authenticated and on auth page
      if (isAuthenticated && (isOnAuthPage || isOnSplash)) {
        return AppRoutes.home;
      }

      // No redirect needed
      return null;
    },
    errorBuilder: (context, state) =>
        ErrorScreen(error: state.error?.toString() ?? 'Unknown error occurred'),
    routes: [
      // Splash Screen
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Authentication Routes
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Main App Routes (require authentication)
      ShellRoute(
        builder: (context, state, child) {
          // Main shell with bottom navigation
          return MainShell(child: child);
        },
        routes: [
          // Home
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),

          // Journey Routes
          GoRoute(
            path: AppRoutes.journey,
            name: 'journey',
            builder: (context, state) => const JourneyScreen(),
            routes: [
              GoRoute(
                path: 'stage/:stageId',
                name: 'stageDetail',
                builder: (context, state) {
                  final stageId = state.pathParameters['stageId']!;
                  return StageDetailScreen(stageId: stageId);
                },
                routes: [
                  GoRoute(
                    path: 'day/:dayId',
                    name: 'dailyLesson',
                    builder: (context, state) {
                      final stageId = state.pathParameters['stageId']!;
                      final dayId = state.pathParameters['dayId']!;
                      return DailyLessonScreen(stageId: stageId, dayId: dayId);
                    },
                  ),
                ],
              ),
            ],
          ),

          // Practice Routes
          GoRoute(
            path: AppRoutes.practice,
            name: 'practice',
            builder: (context, state) => const PracticeScreen(),
            routes: [
              GoRoute(
                path: 'quiz/:quizId',
                name: 'quiz',
                builder: (context, state) {
                  final quizId = state.pathParameters['quizId']!;
                  return QuizScreen(quizId: quizId);
                },
              ),
              GoRoute(
                path: 'result/:resultId',
                name: 'quizResult',
                builder: (context, state) {
                  final resultId = state.pathParameters['resultId']!;
                  return ResultScreen(resultId: resultId);
                },
              ),
            ],
          ),

          // Profile Routes
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // Settings (separate from shell)
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),

      // Error Page
      GoRoute(
        path: AppRoutes.error,
        name: 'error',
        builder: (context, state) {
          final error = state.uri.queryParameters['error'] ?? 'Unknown error';
          return ErrorScreen(error: error);
        },
      ),
    ],
  );
});

// Main Shell with Bottom Navigation
class MainShell extends ConsumerWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(body: child, bottomNavigationBar: const BottomNavBar());
  }
}

// Bottom Navigation Bar với Animations
class BottomNavBar extends ConsumerStatefulWidget {
  const BottomNavBar({super.key});

  @override
  ConsumerState<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends ConsumerState<BottomNavBar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<AnimationController> _iconAnimationControllers;
  late List<Animation<double>> _iconAnimations;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Create animation controllers for each icon
    _iconAnimationControllers = List.generate(
      4,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ),
    );

    // Create animations for each icon
    _iconAnimations = _iconAnimationControllers.map((controller) {
      return Tween<double>(
        begin: 1.0,
        end: 1.3,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.elasticOut));
    }).toList();

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var controller in _iconAnimationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _animateIcon(int index) {
    _iconAnimationControllers[index].forward().then((_) {
      _iconAnimationControllers[index].reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    int getCurrentIndex() {
      if (location.startsWith('/home')) return 0;
      if (location.startsWith('/journey')) return 1;
      if (location.startsWith('/practice')) return 2;
      if (location.startsWith('/profile')) return 3;
      return 0;
    }

    final currentIndex = getCurrentIndex();

    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
          .animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeOutCubic,
            ),
          ),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            _animateIcon(index);

            switch (index) {
              case 0:
                context.go(AppRoutes.home);
                break;
              case 1:
                context.go(AppRoutes.journey);
                break;
              case 2:
                context.go(AppRoutes.practice);
                break;
              case 3:
                context.go(AppRoutes.profile);
                break;
            }
          },
          destinations: [
            _buildAnimatedDestination(
              0,
              Icons.home_outlined,
              Icons.home,
              'Trang chủ',
              currentIndex,
            ),
            _buildAnimatedDestination(
              1,
              Icons.map_outlined,
              Icons.map,
              'Hành trình',
              currentIndex,
            ),
            _buildAnimatedDestination(
              2,
              Icons.quiz_outlined,
              Icons.quiz,
              'Luyện tập',
              currentIndex,
            ),
            _buildAnimatedDestination(
              3,
              Icons.person_outlined,
              Icons.person,
              'Hồ sơ',
              currentIndex,
            ),
          ],
        ),
      ),
    );
  }

  NavigationDestination _buildAnimatedDestination(
    int index,
    IconData outlinedIcon,
    IconData filledIcon,
    String label,
    int currentIndex,
  ) {
    final isSelected = index == currentIndex;

    return NavigationDestination(
      icon: AnimatedBuilder(
        animation: _iconAnimations[index],
        builder: (context, child) {
          return Transform.scale(
            scale: _iconAnimations[index].value,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? filledIcon : outlinedIcon,
                key: ValueKey(isSelected),
              ),
            ),
          );
        },
      ),
      selectedIcon: AnimatedBuilder(
        animation: _iconAnimations[index],
        builder: (context, child) {
          return Transform.scale(
            scale: _iconAnimations[index].value,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(filledIcon),
            ),
          );
        },
      ),
      label: label,
    );
  }
}

// Helper extension for navigation
extension GoRouterExtension on BuildContext {
  void goToLogin() => go(AppRoutes.login);
  void goToRegister() => go(AppRoutes.register);
  void goToHome() => go(AppRoutes.home);
  void goToJourney() => go(AppRoutes.journey);
  void goToPractice() => go(AppRoutes.practice);
  void goToProfile() => go(AppRoutes.profile);
  void goToSettings() => go(AppRoutes.settings);

  void goToStageDetail(String stageId) {
    go('/journey/stage/$stageId');
  }

  void goToDailyLesson(String stageId, String dayId) {
    go('/journey/stage/$stageId/day/$dayId');
  }

  void goToQuiz(String quizId, {String type = 'vocabulary'}) {
    go('/practice/quiz/$quizId?type=$type');
  }

  void goToQuizResult(String resultId) {
    go('/practice/result/$resultId');
  }

  void goToError(String error) {
    go('/error?error=${Uri.encodeComponent(error)}');
  }
}
