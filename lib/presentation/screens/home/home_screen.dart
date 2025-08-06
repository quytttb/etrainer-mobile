import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/theme_constants.dart';
import '../../../core/providers/theme_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardTab(),
    const JourneyTab(),
    const PracticeTab(),
    const ProfileTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Journey',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz_outlined),
            activeIcon: Icon(Icons.quiz),
            label: 'Practice',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Dashboard Tab
class DashboardTab extends ConsumerWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(ThemeConstants.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(ThemeConstants.spacingLarge),
              decoration: BoxDecoration(
                gradient: ThemeConstants.primaryGradient,
                borderRadius: BorderRadius.circular(
                  ThemeConstants.borderRadiusMedium,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome back, John!',
                    style: TextStyle(
                      color: ThemeConstants.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: ThemeConstants.spacingSmall),
                  const Text(
                    'Ready to continue your English journey?',
                    style: TextStyle(color: ThemeConstants.white, fontSize: 16),
                  ),
                  const SizedBox(height: ThemeConstants.spacingMedium),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Continue learning
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeConstants.white,
                      foregroundColor: ThemeConstants.primaryColor,
                    ),
                    child: const Text('Continue Learning'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: ThemeConstants.spacingLarge),

            // Quick Stats
            const Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Current Streak',
                    value: '7',
                    subtitle: 'days',
                    icon: Icons.local_fire_department,
                    color: ThemeConstants.warningColor,
                  ),
                ),
                SizedBox(width: ThemeConstants.spacingMedium),
                Expanded(
                  child: _StatCard(
                    title: 'Total Points',
                    value: '1,250',
                    subtitle: 'points',
                    icon: Icons.stars,
                    color: ThemeConstants.successColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: ThemeConstants.spacingMedium),

            const Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Level',
                    value: 'B1',
                    subtitle: 'Intermediate',
                    icon: Icons.trending_up,
                    color: ThemeConstants.primaryColor,
                  ),
                ),
                SizedBox(width: ThemeConstants.spacingMedium),
                Expanded(
                  child: _StatCard(
                    title: 'Progress',
                    value: '65%',
                    subtitle: 'complete',
                    icon: Icons.timeline,
                    color: ThemeConstants.accentColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: ThemeConstants.spacingLarge),

            // Quick Actions
            Text(
              'Quick Actions',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: ThemeConstants.spacingMedium),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: ThemeConstants.spacingMedium,
              crossAxisSpacing: ThemeConstants.spacingMedium,
              childAspectRatio: 1.5,
              children: [
                _ActionCard(
                  title: 'Daily Quiz',
                  subtitle: 'Test your knowledge',
                  icon: Icons.quiz,
                  color: ThemeConstants.primaryColor,
                  onTap: () {},
                ),
                _ActionCard(
                  title: 'Vocabulary',
                  subtitle: 'Learn new words',
                  icon: Icons.book,
                  color: ThemeConstants.secondaryColor,
                  onTap: () {},
                ),
                _ActionCard(
                  title: 'Grammar',
                  subtitle: 'Practice rules',
                  icon: Icons.spellcheck,
                  color: ThemeConstants.accentColor,
                  onTap: () {},
                ),
                _ActionCard(
                  title: 'Speaking',
                  subtitle: 'Improve pronunciation',
                  icon: Icons.mic,
                  color: ThemeConstants.warningColor,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Other tabs (placeholder implementations)
class JourneyTab extends StatelessWidget {
  const JourneyTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Journey')),
      body: const Center(child: Text('Journey Tab - Coming Soon')),
    );
  }
}

class PracticeTab extends StatelessWidget {
  const PracticeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Practice')),
      body: const Center(child: Text('Practice Tab - Coming Soon')),
    );
  }
}

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Theme toggle for testing
          ListTile(
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: ref.watch(isDarkModeProvider),
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).toggleTheme();
              },
            ),
          ),
          const Center(child: Text('Profile Tab - Coming Soon')),
        ],
      ),
    );
  }
}

// Helper Widgets
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.spacingMedium),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: ThemeConstants.spacingSmall),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: ThemeConstants.spacingSmall),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMedium),
      child: Container(
        padding: const EdgeInsets.all(ThemeConstants.spacingMedium),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(
            ThemeConstants.borderRadiusMedium,
          ),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: ThemeConstants.spacingSmall),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
