import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/animated_loading_widget.dart';

// Mock data providers for practice features
final practiceStatsProvider = StateProvider<Map<String, dynamic>>(
  (ref) => {
    'totalQuizzes': 24,
    'completedToday': 3,
    'averageScore': 87,
    'bestStreak': 12,
    'timeSpent': 45, // minutes today
  },
);

final availableQuizzesProvider = StateProvider<List<Map<String, dynamic>>>(
  (ref) => [
    {
      'id': 'math_basic',
      'title': 'Toán học cơ bản',
      'description': 'Ôn tập các phép tính cơ bản',
      'questionCount': 10,
      'difficulty': 'Dễ',
      'duration': 10, // minutes
      'icon': Icons.calculate,
      'color': Colors.blue,
      'completed': true,
      'score': 9,
    },
    {
      'id': 'physics_basic',
      'title': 'Vật lý cơ bản',
      'description': 'Khái niệm vật lý phổ thông',
      'questionCount': 15,
      'difficulty': 'Trung bình',
      'duration': 15,
      'icon': Icons.science,
      'color': Colors.green,
      'completed': false,
    },
    {
      'id': 'chemistry_advanced',
      'title': 'Hóa học nâng cao',
      'description': 'Phản ứng hóa học phức tạp',
      'questionCount': 20,
      'difficulty': 'Khó',
      'duration': 25,
      'icon': Icons.biotech,
      'color': Colors.red,
      'completed': false,
    },
    {
      'id': 'biology_ecology',
      'title': 'Sinh thái học',
      'description': 'Hệ sinh thái và môi trường',
      'questionCount': 12,
      'difficulty': 'Trung bình',
      'duration': 12,
      'icon': Icons.eco,
      'color': Colors.green,
      'completed': true,
      'score': 8,
    },
    {
      'id': 'english_grammar',
      'title': 'Ngữ pháp tiếng Anh',
      'description': 'Cấu trúc câu và từ vựng',
      'questionCount': 18,
      'difficulty': 'Trung bình',
      'duration': 20,
      'icon': Icons.language,
      'color': Colors.purple,
      'completed': false,
    },
    {
      'id': 'history_vietnam',
      'title': 'Lịch sử Việt Nam',
      'description': 'Các mốc lịch sử quan trọng',
      'questionCount': 16,
      'difficulty': 'Dễ',
      'duration': 18,
      'icon': Icons.history,
      'color': Colors.amber,
      'completed': true,
      'score': 10,
    },
  ],
);

class PracticeScreen extends ConsumerStatefulWidget {
  const PracticeScreen({super.key});

  @override
  ConsumerState<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends ConsumerState<PracticeScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainAnimationController;
  late AnimationController _statsAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _statsScaleAnimation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _mainAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _statsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _mainAnimationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _statsScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _statsAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _initializeScreen();
  }

  void _initializeScreen() async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      _mainAnimationController.forward();
      await Future.delayed(const Duration(milliseconds: 200));
      _statsAnimationController.forward();
    }
  }

  @override
  void dispose() {
    _mainAnimationController.dispose();
    _statsAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final practiceStats = ref.watch(practiceStatsProvider);
    final availableQuizzes = ref.watch(availableQuizzesProvider);

    if (_isLoading) {
      return _buildLoadingScreen(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: FadeTransition(
          opacity: _fadeAnimation,
          child: const Text('Luyện tập'),
        ),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        elevation: 0,
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Statistics Card
                  ScaleTransition(
                    scale: _statsScaleAnimation,
                    child: _buildStatsCard(context, practiceStats),
                  ),

                  const SizedBox(height: 24),

                  // Daily Challenge
                  _buildDailyChallengeCard(context, practiceStats),

                  const SizedBox(height: 24),

                  // Quiz Categories Header
                  _buildQuizCategoriesHeader(context),

                  const SizedBox(height: 16),

                  // Quiz Grid
                  _buildQuizGrid(context, availableQuizzes),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Luyện tập'),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerLoading(
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ShimmerLoading(
                child: Container(
                  width: 150,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ...List.generate(
                4,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ShimmerLoading(
                    child: Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard(
    BuildContext context,
    Map<String, dynamic> practiceStats,
  ) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thống kê hôm nay',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Quiz đã làm',
                    '${practiceStats['completedToday']}',
                    Icons.quiz,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Thời gian',
                    '${practiceStats['timeSpent']}p',
                    Icons.timer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Điểm TB',
                    '${practiceStats['averageScore']}%',
                    Icons.trending_up,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Streak tốt nhất',
                    '${practiceStats['bestStreak']}',
                    Icons.local_fire_department,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyChallengeCard(
    BuildContext context,
    Map<String, dynamic> practiceStats,
  ) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      Colors.amber.withValues(alpha: 0.1),
                      Colors.orange.withValues(alpha: 0.1),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 800),
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      builder: (context, double scaleValue, child) {
                        return Transform.scale(
                          scale: scaleValue,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.emoji_events,
                              color: Colors.amber,
                              size: 32,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Thử thách hàng ngày',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Hoàn thành 5 quiz để nhận thưởng!',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 1000),
                      tween: Tween<double>(
                        begin: 0.0,
                        end: practiceStats['completedToday'] / 5.0,
                      ),
                      builder: (context, double progress, child) {
                        return Column(
                          children: [
                            Text(
                              '${practiceStats['completedToday']}/5',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber[700],
                                  ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: 60,
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.grey[300],
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.amber,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuizCategoriesHeader(BuildContext context) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 500),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Row(
              children: [
                Text(
                  'Danh mục Quiz',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // Show all categories
                  },
                  child: const Text('Xem tất cả'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuizGrid(
    BuildContext context,
    List<Map<String, dynamic>> availableQuizzes,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: availableQuizzes.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder(
          duration: Duration(milliseconds: 400 + (index * 100)),
          tween: Tween<double>(begin: 0.0, end: 1.0),
          builder: (context, double animValue, child) {
            return Transform.translate(
              offset: Offset(0, 40 * (1 - animValue)),
              child: Opacity(
                opacity: animValue,
                child: _QuizCard(quiz: availableQuizzes[index]),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 800),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, double animationValue, child) {
        return Transform.scale(
          scale: animationValue,
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _QuizCard extends ConsumerStatefulWidget {
  final Map<String, dynamic> quiz;

  const _QuizCard({required this.quiz});

  @override
  ConsumerState<_QuizCard> createState() => _QuizCardState();
}

class _QuizCardState extends ConsumerState<_QuizCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );

    _elevationAnimation = Tween<double>(begin: 4.0, end: 12.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quiz = widget.quiz;
    final isCompleted = quiz['completed'] ?? false;

    return AnimatedBuilder(
      animation: _hoverController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Card(
            elevation: _elevationAnimation.value,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                context.push('/quiz/${quiz['id']}');
              },
              onTapDown: (_) => _hoverController.forward(),
              onTapUp: (_) => _hoverController.reverse(),
              onTapCancel: () => _hoverController.reverse(),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      (quiz['color'] as Color).withValues(alpha: 0.1),
                      (quiz['color'] as Color).withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with icon and completion status
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: (quiz['color'] as Color).withValues(
                              alpha: 0.2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            quiz['icon'] as IconData,
                            color: quiz['color'] as Color,
                            size: 20,
                          ),
                        ),
                        const Spacer(),
                        if (isCompleted)
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 16,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Title
                    Text(
                      quiz['title'],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Description
                    Text(
                      quiz['description'],
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const Spacer(),

                    // Footer info
                    Row(
                      children: [
                        Icon(Icons.quiz, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          '${quiz['questionCount']} câu',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(
                              quiz['difficulty'],
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            quiz['difficulty'],
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _getDifficultyColor(quiz['difficulty']),
                            ),
                          ),
                        ),
                      ],
                    ),

                    if (isCompleted) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.star, size: 14, color: Colors.amber[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${quiz['score']}/${quiz['questionCount']}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.amber[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Dễ':
        return Colors.green;
      case 'Trung bình':
        return Colors.orange;
      case 'Khó':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
