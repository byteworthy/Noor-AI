import 'package:flutter/material.dart';

class ArabicLearningScreen extends StatelessWidget {
  const ArabicLearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn Arabic'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.language_outlined,
              size: 80,
              color: Colors.blue.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Arabic Learning',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Coming Soon',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                '• Learn Arabic alphabet\n'
                '• Conversational Arabic tutor\n'
                '• Vocabulary flashcards\n'
                '• Pronunciation practice',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
