import 'package:flutter/material.dart';

class DailyLessonScreen extends StatelessWidget {
  final String stageId;
  final String dayId;

  const DailyLessonScreen({
    super.key,
    required this.stageId,
    required this.dayId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bài học ngày $dayId - Giai đoạn $stageId'),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: const Center(child: Text('Daily Lesson Screen - Coming Soon')),
    );
  }
}
