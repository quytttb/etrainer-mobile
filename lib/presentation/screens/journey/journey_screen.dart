import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/animated_loading_widget.dart';

enum JourneyLevel { beginner, intermediate, advanced }

class Journey {
  final String id;
  final String title;
  final String description;
  final JourneyLevel level;
  final int totalStages;
  final int completedStages;
  final bool isUnlocked;
  final int estimatedDuration;

  Journey({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.totalStages,
    required this.completedStages,
    required this.isUnlocked,
    required this.estimatedDuration,
  });
}

// Mock journey provider
final journeyProvider = StateProvider<List<Journey>>((ref) {
  return [
    Journey(
      id: '1',
      title: 'Tiếng Anh Cơ Bản',
      description: 'Khóa học dành cho người mới bắt đầu',
      level: JourneyLevel.beginner,
      totalStages: 10,
      completedStages: 3,
      isUnlocked: true,
      estimatedDuration: 30,
    ),
    Journey(
      id: '2',
      title: 'Tiếng Anh Giao Tiếp',
      description: 'Luyện tập kỹ năng giao tiếp hàng ngày',
      level: JourneyLevel.intermediate,
      totalStages: 15,
      completedStages: 0,
      isUnlocked: true,
      estimatedDuration: 45,
    ),
    Journey(
      id: '3',
      title: 'Tiếng Anh Thương Mại',
      description: 'Tiếng Anh chuyên nghiệp cho công việc',
      level: JourneyLevel.advanced,
      totalStages: 20,
      completedStages: 0,
      isUnlocked: false,
      estimatedDuration: 60,
    ),
  ];
});

class JourneyScreen extends ConsumerStatefulWidget {
  const JourneyScreen({super.key});

  @override
  ConsumerState<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends ConsumerState<JourneyScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _slideAnimationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    // Simulate loading
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      _fadeAnimationController.forward();
      await Future.delayed(const Duration(milliseconds: 100));
      _slideAnimationController.forward();
    }
  }

  @override
  void dispose() {
    _slideAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final journeys = ref.watch(journeyProvider);

    if (_isLoading) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoading(
                  child: Container(
                    width: 200,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ShimmerLoading(
                  child: Container(
                    width: 150,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: ShimmerLoading(
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: FadeTransition(
          opacity: _fadeAnimation,
          child: const Text('Hành trình học tập'),
        ),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        elevation: 0,
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                // Header Progress Card
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tiến độ tổng thể',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatItem(
                            context,
                            'Đã hoàn thành',
                            '${journeys.fold<int>(0, (sum, j) => sum + j.completedStages)}',
                            Icons.check_circle,
                          ),
                          _buildStatItem(
                            context,
                            'Tổng bài học',
                            '${journeys.fold<int>(0, (sum, j) => sum + j.totalStages)}',
                            Icons.book,
                          ),
                          _buildStatItem(
                            context,
                            'Streak',
                            '7 ngày',
                            Icons.local_fire_department,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Journey List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: journeys.length,
                    itemBuilder: (context, index) {
                      final journey = journeys[index];
                      return TweenAnimationBuilder(
                        duration: Duration(milliseconds: 300 + (index * 100)),
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        builder: (context, double value, child) {
                          return Transform.translate(
                            offset: Offset(0, 50 * (1 - value)),
                            child: Opacity(
                              opacity: value,
                              child: _JourneyCard(journey: journey),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
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

class _JourneyCard extends ConsumerStatefulWidget {
  final Journey journey;

  const _JourneyCard({required this.journey});

  @override
  ConsumerState<_JourneyCard> createState() => _JourneyCardState();
}

class _JourneyCardState extends ConsumerState<_JourneyCard>
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

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
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
    final progress =
        widget.journey.completedStages / widget.journey.totalStages;
    final isLocked = !widget.journey.isUnlocked;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: AnimatedBuilder(
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
                onTap: isLocked
                    ? null
                    : () {
                        context.push('/journey/${widget.journey.id}/stages');
                      },
                onTapDown: (_) => _hoverController.forward(),
                onTapUp: (_) => _hoverController.reverse(),
                onTapCancel: () => _hoverController.reverse(),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        children: [
                          // Level Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getLevelColor(
                                widget.journey.level,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _getLevelText(widget.journey.level),
                              style: TextStyle(
                                color: _getLevelColor(widget.journey.level),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const Spacer(),
                          if (isLocked)
                            Icon(Icons.lock, color: Colors.grey[400], size: 20)
                          else
                            Icon(
                              Icons.play_circle_filled,
                              color: Theme.of(context).colorScheme.primary,
                              size: 24,
                            ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Title and Description
                      Text(
                        widget.journey.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isLocked ? Colors.grey[400] : null,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.journey.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isLocked ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Progress Section
                      if (!isLocked) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${widget.journey.completedStages}/${widget.journey.totalStages} bài học',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '${(progress * 100).round()}%',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TweenAnimationBuilder(
                          duration: Duration(
                            milliseconds: 1000 + (progress * 1000).round(),
                          ),
                          tween: Tween<double>(begin: 0.0, end: progress),
                          builder: (context, double animatedProgress, child) {
                            return LinearProgressIndicator(
                              value: animatedProgress,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _getLevelColor(widget.journey.level),
                              ),
                              borderRadius: BorderRadius.circular(4),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '~${widget.journey.estimatedDuration} phút',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.lock,
                                color: Colors.grey[500],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Hoàn thành khóa học trước để mở khóa',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getLevelColor(JourneyLevel level) {
    switch (level) {
      case JourneyLevel.beginner:
        return Colors.green;
      case JourneyLevel.intermediate:
        return Colors.orange;
      case JourneyLevel.advanced:
        return Colors.red;
    }
  }

  String _getLevelText(JourneyLevel level) {
    switch (level) {
      case JourneyLevel.beginner:
        return 'Cơ bản';
      case JourneyLevel.intermediate:
        return 'Trung cấp';
      case JourneyLevel.advanced:
        return 'Nâng cao';
    }
  }
}
