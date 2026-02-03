# Noor AI - Development Guide

This guide explains how to develop Noor AI step-by-step, following the implementation phases outlined in the Master PRD.

## Quick Start

```bash
# 1. Clone and install
git clone <repo-url>
cd noor-ai
flutter pub get

# 2. Generate code
dart run build_runner build --delete-conflicting-outputs

# 3. Run the app
flutter run
```

## Development Phases

### Phase 1: Foundation ✅

**Status**: Completed

- ✅ Flutter project structure
- ✅ Dependencies in pubspec.yaml
- ✅ Material 3 theme system
- ✅ GoRouter navigation
- ✅ Riverpod state management setup
- ✅ Basic screens (Home, Quran, Arabic Learning, Noor AI, Prayer)

**Next Steps**: Implement database schema (see Phase 2)

### Phase 2: Database Implementation

Create the complete Drift database schema with 17 tables.

**File**: `lib/shared/data/database/database.dart`

**Tables to implement**:
1. Surahs (114 rows)
2. Verses (6,236 rows)
3. Translations
4. VerseWords (77,430+ rows)
5. Hadiths (38,000+ rows)
6. HadithCollections
7. HadithGrades
8. Users
9. UserProgress
10. ReviewCards (FSRS)
11. ReviewLogs
12. Decks
13. VocabularyWords
14. ConversationHistory
15. PrayerTimes
16. HabitLogs
17. DownloadedContent

**Command**:
```bash
dart run build_runner build --delete-conflicting-outputs
```

See `docs/MASTER-PRD.md` for complete schema specifications.

### Phase 3: Core Features

#### 3.1 Quran Reader

**Files**:
- `lib/features/quran/data/datasources/quran_remote_datasource.dart`
- `lib/features/quran/data/repositories/quran_repository_impl.dart`
- `lib/features/quran/domain/entities/surah.dart`
- `lib/features/quran/domain/entities/verse.dart`
- `lib/features/quran/presentation/screens/surah_list_screen.dart`
- `lib/features/quran/presentation/screens/verse_reader_screen.dart`

**API**: https://api.alquran.cloud/v1

**Features**:
- Display 114 surahs
- Verse-by-verse reading
- Multiple translations
- Audio playback
- Bookmarking
- Offline caching

#### 3.2 Prayer Times

**Files**:
- `lib/features/prayer/data/services/prayer_times_service.dart`
- `lib/features/prayer/presentation/screens/prayer_times_screen.dart`
- `lib/features/prayer/presentation/screens/qibla_screen.dart`

**Package**: `adhan_dart`

**Features**:
- Calculate 5 daily prayers + sunrise
- Qibla direction with compass
- Prayer notifications
- Multiple calculation methods
- Location-based automatic calculation

#### 3.3 Arabic Alphabet Learning

**Files**:
- `lib/features/arabic_learning/data/datasources/alphabet_local_datasource.dart`
- `lib/features/arabic_learning/presentation/screens/alphabet_grid_screen.dart`
- `lib/features/arabic_learning/presentation/screens/letter_detail_screen.dart`

**Data**: Create `assets/data/arabic_alphabet.json`

**Features**:
- 28 Arabic letters
- Letter forms (isolated, initial, medial, final)
- Audio pronunciation
- Example words
- Writing practice guides

### Phase 4: AI Integration

#### 4.1 Noor AI Service

**Files**:
- `lib/features/noor_ai/data/services/noor_ai_service.dart`
- `lib/features/noor_ai/presentation/screens/noor_ai_chat_screen.dart`
- `lib/features/noor_ai/presentation/widgets/message_bubble.dart`
- `lib/features/noor_ai/presentation/widgets/source_citation_chip.dart`

**Package**: `llamadart` or `flutter_llama`

**Model**: `noor-ai-7b-q4km.gguf` (place in `assets/models/`)

**Features**:
- Streaming chat responses
- Source citations [Quran X:Y] [Bukhari Z]
- Conversation history
- Usage limits

#### 4.2 LLM Training (Parallel - on Mac Mini)

**Location**: Separate from Flutter project

**Steps**:
1. Prepare dataset (`islamic_training_data.jsonl`)
2. Train with MLX: `mlx_lm.lora --model Qwen/Qwen2.5-7B-Instruct ...`
3. Merge LoRA weights: `mlx_lm.fuse ...`
4. Convert to GGUF: `llama.cpp/convert.py`
5. Quantize: `llama.cpp/quantize ... Q4_K_M`
6. Copy `noor-ai-7b-q4km.gguf` to Flutter project

See `docs/MASTER-PRD.md` Section 4.2 for complete training pipeline.

### Phase 5: Advanced Features

#### 5.1 Photo-to-Quran Recognition

**Files**:
- `lib/features/quran/presentation/screens/quran_photo_screen.dart`
- `lib/features/quran/data/services/quran_photo_service.dart`

**API**: OpenAI GPT-4 Vision

**Flow**:
1. User takes photo of Quran page
2. Image sent to GPT-4 Vision
3. Arabic text extracted
4. Matched to verse database
5. Display enriched results

#### 5.2 FSRS Spaced Repetition

**Files**:
- `lib/features/arabic_learning/data/services/srs_service.dart`
- `lib/features/arabic_learning/presentation/screens/review_screen.dart`
- `lib/features/arabic_learning/presentation/screens/deck_list_screen.dart`

**Package**: `fsrs` (or implement algorithm)

**Features**:
- FSRS algorithm (better than SM-2/Anki)
- Vocabulary flashcards
- Review due cards
- Track statistics

#### 5.3 Conversational Arabic Tutor

**Files**:
- `lib/features/arabic_learning/presentation/screens/conversation_screen.dart`
- `lib/features/arabic_learning/data/services/arabic_tutor_service.dart`

**Features**:
- Real-time conversation scenarios
- Voice input (Whisper ASR)
- Corrections and feedback
- Progress tracking

## Code Generation

Whenever you modify:
- Drift tables (`.dart` files with `@DataClassName`)
- Riverpod providers with `@riverpod` annotation
- Freezed data classes with `@freezed`

Run:
```bash
dart run build_runner build --delete-conflicting-outputs

# Or watch for changes:
dart run build_runner watch
```

## Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Integration tests (on device/emulator)
flutter test integration_test/
```

## API Keys Setup

1. Copy `.env.example` to `.env`
2. Fill in your API keys
3. Never commit `.env` to git

## Debugging Tips

### Database Issues

```dart
// View all tables
final db = ref.read(databaseProvider);
final surahs = await db.select(db.surahs).get();
print(surahs);

// Clear database
await db.delete(db.surahs).go();
```

### State Management

```dart
// Use Riverpod DevTools in VS Code/Android Studio
// Install: https://github.com/rrousselGit/riverpod/tree/master/packages/riverpod_analyzer_plugin
```

### Performance Profiling

```bash
# Profile performance
flutter run --profile

# Profile with DevTools
flutter run --profile
# Open DevTools from the terminal link
```

## Common Issues

### Build Runner Not Working

```bash
# Clean and rebuild
flutter clean
flutter pub get
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### Firebase Not Initialized

Make sure you have:
1. `google-services.json` in `android/app/`
2. `GoogleService-Info.plist` in `ios/Runner/`
3. Firebase initialized in `main.dart`

### Font Not Loading

1. Check fonts are in `assets/fonts/`
2. Verify `pubspec.yaml` font declarations
3. Run `flutter clean && flutter pub get`

## Architecture Guidelines

### Clean Architecture Layers

```
Presentation Layer (UI)
├── Screens
├── Widgets
└── Providers (Riverpod)
       ↓
Domain Layer (Business Logic)
├── Entities
├── Repositories (interfaces)
└── Use Cases
       ↓
Data Layer (Implementation)
├── Data Sources (API, Local DB)
├── Models (JSON serialization)
└── Repositories (implementations)
```

### File Naming Conventions

- Screens: `*_screen.dart`
- Widgets: `*_widget.dart` or descriptive name
- Providers: `*_provider.dart`
- Repositories: `*_repository.dart`
- Services: `*_service.dart`
- Models: `*_model.dart`
- Entities: `*.dart` (simple name)

### State Management with Riverpod

```dart
// Provider (read-only)
final surahsProvider = FutureProvider<List<Surah>>((ref) async {
  final repository = ref.read(quranRepositoryProvider);
  return repository.getSurahs();
});

// StateNotifier (mutable state)
@riverpod
class QuranReader extends _$QuranReader {
  @override
  QuranState build() => QuranState.initial();

  void selectSurah(int surahNumber) {
    state = state.copyWith(selectedSurah: surahNumber);
  }
}
```

## Next Steps

1. Complete database schema implementation
2. Implement Quran reader with API integration
3. Add prayer times feature
4. Integrate Noor AI LLM
5. Build FSRS spaced repetition system
6. Add photo-to-Quran recognition
7. Complete conversational Arabic tutor

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [Drift Documentation](https://drift.simonbinder.eu/)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Al-Quran Cloud API](https://alquran.cloud/api)
- [Sunnah.com API](https://sunnah.api-docs.io/)

## Support

For questions or issues:
- Check `docs/MASTER-PRD.md` for detailed specifications
- Review this development guide
- Open an issue on GitHub
- Contact the development team

---

**Remember**: This is a faith-based educational app. Accuracy in Islamic content is paramount. Always verify Quran verses, hadith authenticity, and Islamic rulings with qualified scholars.
