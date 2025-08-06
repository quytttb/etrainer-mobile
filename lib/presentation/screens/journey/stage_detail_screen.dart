import 'package:flutter/material.dart';

class StageDetailScreen extends StatelessWidget {
  final String stageId;

  const StageDetailScreen({super.key, required this.stageId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết giai đoạn $stageId'),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: const Center(child: Text('Stage Detail Screen - Coming Soon')),
    );
  }
}
