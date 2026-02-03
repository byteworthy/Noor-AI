import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/quran/presentation/screens/quran_screen.dart';
import '../features/arabic_learning/presentation/screens/arabic_learning_screen.dart';
import '../features/noor_ai/presentation/screens/noor_ai_chat_screen.dart';
import '../features/prayer/presentation/screens/prayer_screen.dart';

// Router provider
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/quran',
        name: 'quran',
        builder: (context, state) => const QuranScreen(),
      ),
      GoRoute(
        path: '/arabic-learning',
        name: 'arabic-learning',
        builder: (context, state) => const ArabicLearningScreen(),
      ),
      GoRoute(
        path: '/noor-ai',
        name: 'noor-ai',
        builder: (context, state) => const NoorAIChatScreen(),
      ),
      GoRoute(
        path: '/prayer',
        name: 'prayer',
        builder: (context, state) => const PrayerScreen(),
      ),
    ],
  );
});
