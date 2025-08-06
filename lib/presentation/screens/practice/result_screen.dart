import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String resultId;

  const ResultScreen({super.key, required this.resultId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kết quả')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events, size: 100, color: Colors.amber),
            SizedBox(height: 16),
            Text(
              'Kết quả Quiz',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Màn hình hiển thị kết quả chi tiết sẽ được phát triển.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
