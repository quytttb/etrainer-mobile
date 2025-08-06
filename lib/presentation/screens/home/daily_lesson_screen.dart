import 'package:flutter/material.dart';

class DailyLessonScreen extends StatelessWidget {
  const DailyLessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài học hàng ngày'),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: const Center(child: Text('Daily Lesson Screen - Coming Soon')),
    );
  }
}
