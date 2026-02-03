# Noor AI - Testing & QA Manual
## Comprehensive Quality Assurance Strategy

**Purpose:** Ensure production-ready quality before launch
**Timeline:** Implement throughout development (Months 1-4)
**Target:** 70% unit test coverage, 50% widget test coverage, zero critical bugs

---

## Table of Contents

1. [Testing Philosophy](#philosophy)
2. [Unit Testing Strategy](#unit-tests)
3. [Widget Testing](#widget-tests)
4. [Integration Testing](#integration-tests)
5. [Golden Testing (UI Regression)](#golden-tests)
6. [Manual Testing Checklist](#manual-testing)
7. [Device Testing Matrix](#device-matrix)
8. [Performance Benchmarks](#performance)
9. [Beta Testing Guide](#beta-testing)
10. [Bug Reporting & Triage](#bug-triage)

---

## 1. Testing Philosophy {#philosophy}

### The Testing Pyramid

```
           /\
          /  \  E2E (5%)
         /    \
        /------\  Integration (15%)
       /        \
      /----------\  Widget (30%)
     /            \
    /--------------\  Unit (50%)
```

**Unit Tests (50%):** Business logic, utilities, data models
**Widget Tests (30%):** UI components, user interactions
**Integration Tests (15%):** Feature flows, API integration
**E2E Tests (5%):** Critical user journeys

### Quality Gates

**Before Code Review:**
- [ ] All new code has unit tests
- [ ] Widget tests for UI changes
- [ ] No compiler warnings
- [ ] Code formatted (`dart format`)

**Before Merging to Main:**
- [ ] All tests passing
- [ ] Code coverage ≥70% for changed files
- [ ] Integration tests passing
- [ ] No regressions in golden tests

**Before Release:**
- [ ] All critical flows tested manually
- [ ] Beta tested by 100+ users
- [ ] Performance benchmarks met
- [ ] Zero critical/high bugs
- [ ] App Store compliance verified

---

## 2. Unit Testing Strategy {#unit-tests}

### What to Unit Test

**Always Test:**
- ✅ Business logic (FSRS algorithm, prayer time calculation)
- ✅ Data models (JSON serialization/deserialization)
- ✅ Utility functions (date formatting, string manipulation)
- ✅ Repositories (data fetching and caching logic)
- ✅ Validators (email, password, Arabic text validation)

**Don't Unit Test:**
- ❌ Flutter framework code
- ❌ Third-party packages (assume they're tested)
- ❌ UI layouts (use widget tests instead)

### Example: FSRS Algorithm Unit Test

```dart
// test/core/fsrs_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:noor_ai/core/fsrs/fsrs_scheduler.dart';

void main() {
  group('FSRSScheduler', () {
    late FSRSScheduler scheduler;

    setUp(() {
      scheduler = FSRSScheduler(
        desiredRetention: 0.9,
        maximumInterval: 365,
      );
    });

    test('new card has correct initial state', () {
      final card = Card.newCard();

      expect(card.state, CardState.newCard);
      expect(card.stability, 0);
      expect(card.difficulty, 0);
      expect(card.reps, 0);
    });

    test('rating Again increases difficulty', () {
      final card = Card.newCard();
      final result = scheduler.reviewCard(card, Rating.again);

      expect(result.card.difficulty, greaterThan(card.difficulty));
      expect(result.card.state, CardState.learning);
    });

    test('rating Easy after learning moves to review', () {
      var card = Card.newCard();

      // First review: Again
      var result = scheduler.reviewCard(card, Rating.again);
      card = result.card;

      // Second review: Easy
      result = scheduler.reviewCard(card, Rating.easy);

      expect(result.card.state, CardState.review);
      expect(result.card.interval, greaterThan(1));
    });

    test('stability increases with successful reviews', () {
      var card = Card.newCard();
      final initialStability = card.stability;

      final result = scheduler.reviewCard(card, Rating.good);

      expect(result.card.stability, greaterThan(initialStability));
    });

    test('retrievability calculation is correct', () {
      final card = Card(
        stability: 10,
        difficulty: 5,
        elapsedDays: 5,
      );

      final retrievability = scheduler.getRetrievability(card);

      expect(retrievability, greaterThan(0));
      expect(retrievability, lessThanOrEqualTo(1));
    });

    test('next interval respects maximum interval', () {
      final card = Card(stability: 1000);
      final result = scheduler.reviewCard(card, Rating.easy);

      expect(result.card.interval, lessThanOrEqualTo(365));
    });
  });

  group('FSRSScheduler edge cases', () {
    test('handles very high stability', () {
      final scheduler = FSRSScheduler();
      final card = Card(stability: 10000);

      expect(() => scheduler.reviewCard(card, Rating.good),
             returnsNormally);
    });

    test('handles negative elapsed days gracefully', () {
      final scheduler = FSRSScheduler();
      final card = Card(elapsedDays: -1);

      final retrievability = scheduler.getRetrievability(card);
      expect(retrievability, greaterThanOrEqualTo(0));
    });
  });
}
```

### Example: Prayer Time Calculation Test

```dart
// test/features/prayer/prayer_times_test.dart

void main() {
  group('PrayerTimesService', () {
    late PrayerTimesService service;

    setUp(() {
      service = PrayerTimesService();
    });

    test('calculates correct prayer times for Mecca', () {
      final times = service.calculatePrayerTimes(
        latitude: 21.4225,
        longitude: 39.8262,
        date: DateTime(2026, 1, 1),
        method: CalculationMethod.ummAlQura,
      );

      // Fajr should be before sunrise
      expect(times.fajr.isBefore(times.sunrise), true);

      // Dhuhr should be around noon
      expect(times.dhuhr.hour, inInclusiveRange(11, 13));

      // Maghrib should be after sunset
      expect(times.maghrib.isAfter(times.sunset), true);

      // All times should be on the same day
      expect(times.fajr.day, 1);
      expect(times.isha.day, 1);
    });

    test('different calculation methods produce different results', () {
      final mwlTimes = service.calculatePrayerTimes(
        latitude: 40.7128,
        longitude: -74.0060,
        method: CalculationMethod.muslimWorldLeague,
      );

      final isnaTimes = service.calculatePrayerTimes(
        latitude: 40.7128,
        longitude: -74.0060,
        method: CalculationMethod.northAmerica,
      );

      // Fajr time should differ between methods
      expect(mwlTimes.fajr, isNot(equals(isnaTimes.fajr)));
    });

    test('handles locations near poles gracefully', () {
      // High latitude location
      expect(
        () => service.calculatePrayerTimes(
          latitude: 70.0,
          longitude: 20.0,
        ),
        returnsNormally,
      );
    });
  });
}
```

### Running Unit Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/core/fsrs_test.dart

# Run tests matching pattern
flutter test --name="FSRS"

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## 3. Widget Testing {#widget-tests}

### What to Widget Test

**Test These UI Components:**
- ✅ Custom widgets (QuranVerseCard, VocabularyCard)
- ✅ User interactions (button taps, form submissions)
- ✅ State changes (loading → success → error)
- ✅ Navigation flows
- ✅ Form validation

### Example: QuranVerseCard Widget Test

```dart
// test/widgets/quran_verse_card_test.dart

void main() {
  testWidgets('QuranVerseCard displays verse correctly', (tester) async {
    final verse = Verse(
      surahNumber: 1,
      ayahNumber: 1,
      arabicText: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
      translation: 'In the name of Allah, the Entirely Merciful...',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: QuranVerseCard(verse: verse),
        ),
      ),
    );

    // Verify Arabic text is displayed
    expect(find.text(verse.arabicText), findsOneWidget);

    // Verify translation is displayed
    expect(find.text(verse.translation), findsOneWidget);

    // Verify verse reference is shown
    expect(find.text('1:1'), findsOneWidget);
  });

  testWidgets('QuranVerseCard bookmark button works', (tester) async {
    var bookmarked = false;
    final verse = Verse(surahNumber: 1, ayahNumber: 1);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: QuranVerseCard(
            verse: verse,
            isBookmarked: bookmarked,
            onBookmarkToggle: () => bookmarked = !bookmarked,
          ),
        ),
      ),
    );

    // Find and tap bookmark button
    final bookmarkButton = find.byIcon(Icons.bookmark_border);
    expect(bookmarkButton, findsOneWidget);

    await tester.tap(bookmarkButton);
    await tester.pump();

    // Verify callback was called
    expect(bookmarked, true);
  });

  testWidgets('QuranVerseCard shows loading state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: QuranVerseCard.loading(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
```

### Example: Form Validation Widget Test

```dart
// test/widgets/arabic_input_test.dart

void main() {
  testWidgets('ArabicInputField validates input', (tester) async {
    String? submittedValue;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ArabicInputField(
            onSubmit: (value) => submittedValue = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter Arabic text';
              }
              if (!value.contains(RegExp(r'[\u0600-\u06FF]'))) {
                return 'Must contain Arabic characters';
              }
              return null;
            },
          ),
        ),
      ),
    );

    // Test empty input
    await tester.enterText(find.byType(TextField), '');
    await tester.pump();

    expect(find.text('Please enter Arabic text'), findsOneWidget);

    // Test English input
    await tester.enterText(find.byType(TextField), 'hello');
    await tester.pump();

    expect(find.text('Must contain Arabic characters'), findsOneWidget);

    // Test valid Arabic input
    await tester.enterText(find.byType(TextField), 'السلام عليكم');
    await tester.pump();

    expect(find.text('Please enter Arabic text'), findsNothing);
    expect(find.text('Must contain Arabic characters'), findsNothing);
  });
}
```

---

## 4. Integration Testing {#integration-tests}

### Critical User Flows to Test

1. **Quran Reading Flow**
2. **Arabic Conversation Flow**
3. **Noor AI Q&A Flow**
4. **Photo-to-Quran Flow**
5. **Memorization Session Flow**
6. **Prayer Times Setup Flow**
7. **Premium Upgrade Flow**

### Example: Quran Reading Integration Test

```dart
// integration_test/quran_reading_flow_test.dart

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Complete Quran reading flow', (tester) async {
    await tester.pumpWidget(MyApp());

    // 1. Navigate to Quran tab
    await tester.tap(find.text('Quran'));
    await tester.pumpAndSettle();

    // 2. Verify surah list is displayed
    expect(find.text('Al-Fatiha'), findsOneWidget);
    expect(find.text('Al-Baqarah'), findsOneWidget);

    // 3. Tap on Al-Fatiha
    await tester.tap(find.text('Al-Fatiha'));
    await tester.pumpAndSettle();

    // 4. Verify verses are displayed
    expect(find.text('بِسْمِ ٱللَّهِ'), findsOneWidget);

    // 5. Test audio playback
    final playButton = find.byIcon(Icons.play_arrow);
    await tester.tap(playButton);
    await tester.pump(Duration(seconds: 1));

    // 6. Verify pause button appears
    expect(find.byIcon(Icons.pause), findsOneWidget);

    // 7. Test bookmark functionality
    await tester.tap(find.byIcon(Icons.bookmark_border).first);
    await tester.pumpAndSettle();

    // 8. Verify bookmark was added
    expect(find.byIcon(Icons.bookmark), findsOneWidget);

    // 9. Navigate to bookmarks
    await tester.tap(find.byIcon(Icons.bookmarks));
    await tester.pumpAndSettle();

    // 10. Verify bookmarked verse appears
    expect(find.text('Al-Fatiha 1:1'), findsOneWidget);
  });
}
```

### Example: Premium Upgrade Flow

```dart
void main() {
  testWidgets('Premium upgrade flow', (tester) async {
    await tester.pumpWidget(MyApp());

    // 1. Try to access premium feature
    await tester.tap(find.text('Photo-to-Quran'));
    await tester.pumpAndSettle();

    // 2. Verify paywall appears
    expect(find.text('Premium Feature'), findsOneWidget);
    expect(find.text('Upgrade to Premium'), findsOneWidget);

    // 3. Tap upgrade button
    await tester.tap(find.text('Upgrade to Premium'));
    await tester.pumpAndSettle();

    // 4. Verify pricing options displayed
    expect(find.text('\$6.99/month'), findsOneWidget);
    expect(find.text('\$49.99/year'), findsOneWidget);

    // 5. Select annual plan
    await tester.tap(find.text('Annual'));
    await tester.pumpAndSettle();

    // 6. Verify "Start Free Trial" button
    expect(find.text('Start 7-Day Free Trial'), findsOneWidget);

    // Note: Can't actually complete purchase in test
    // This would require App Store sandbox testing
  });
}
```

---

## 5. Golden Testing (UI Regression) {#golden-tests}

### What is Golden Testing?

Golden tests capture screenshots of widgets and compare them to reference images. Any visual change will fail the test, preventing unintended UI regressions.

### Example: Golden Test for QuranVerseCard

```dart
// test/golden/quran_verse_card_golden_test.dart

import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  testGoldens('QuranVerseCard golden test', (tester) async {
    final verse = Verse(
      surahNumber: 1,
      ayahNumber: 1,
      arabicText: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
      translation: 'In the name of Allah, the Entirely Merciful...',
    );

    final builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: [
        Device.phone,
        Device.tabletLandscape,
      ])
      ..addScenario(
        widget: QuranVerseCard(verse: verse),
        name: 'default',
      )
      ..addScenario(
        widget: QuranVerseCard(verse: verse, isBookmarked: true),
        name: 'bookmarked',
      );

    await tester.pumpDeviceBuilder(builder);

    await screenMatchesGolden(tester, 'quran_verse_card');
  });
}
```

### Running Golden Tests

```bash
# Generate golden files (first time)
flutter test --update-goldens

# Run golden tests
flutter test --tags golden

# Update goldens after intentional UI change
flutter test --update-goldens test/golden/
```

---

## 6. Manual Testing Checklist {#manual-testing}

### Pre-Release Testing (Complete Before Launch)

**Onboarding Flow:**
- [ ] App launches without crash
- [ ] Splash screen displays correctly
- [ ] Welcome screens swipe smoothly
- [ ] Sign up form validates correctly
- [ ] Email verification works
- [ ] Sign in with existing account works
- [ ] Forgot password flow works
- [ ] Skip onboarding option works

**Quran Features:**
- [ ] Surah list loads within 2 seconds
- [ ] Verses display correctly (Arabic + translation)
- [ ] Audio playback works
- [ ] Audio playback controls (play/pause/seek) work
- [ ] Multiple reciters selectable
- [ ] Bookmarks save and load correctly
- [ ] Search finds relevant verses
- [ ] Word-by-word breakdown works
- [ ] Offline mode works (no internet)

**Arabic Learning:**
- [ ] Alphabet screen displays all 28 letters
- [ ] Letter audio plays correctly
- [ ] Vocabulary flashcards flip properly
- [ ] SRS scheduling works (cards appear at correct intervals)
- [ ] Conversation scenarios load
- [ ] Voice input records correctly
- [ ] Pronunciation feedback appears
- [ ] Progress is saved and displayed

**Noor AI:**
- [ ] Chat interface loads
- [ ] User can type and send questions
- [ ] AI responds within 5 seconds
- [ ] Responses include source citations
- [ ] Streaming text appears smoothly
- [ ] Disclaimer is visible
- [ ] Free tier limits enforced (25 questions/day)
- [ ] Conversation history saves

**Prayer Times:**
- [ ] Location permission request works
- [ ] Prayer times display correctly for current location
- [ ] Qibla compass shows accurate direction
- [ ] Notifications trigger at prayer times
- [ ] Calculation method can be changed
- [ ] Manual location entry works

**Premium Features:**
- [ ] Paywall appears when accessing premium features
- [ ] Pricing displays correctly
- [ ] Free trial offer visible
- [ ] Purchase flow works (sandbox)
- [ ] Premium features unlock after purchase
- [ ] Restore purchases works

**Settings:**
- [ ] Language can be changed
- [ ] Theme toggle works (light/dark)
- [ ] Notification settings save
- [ ] Account deletion works
- [ ] Privacy policy link opens
- [ ] Terms of service link opens
- [ ] Logout works

**Edge Cases:**
- [ ] App handles no internet gracefully
- [ ] App handles slow internet (3G simulation)
- [ ] App doesn't crash when killing mid-operation
- [ ] Battery saver mode doesn't break features
- [ ] Low storage warning appears if < 500MB free
- [ ] Large Quran audio downloads complete successfully

---

## 7. Device Testing Matrix {#device-matrix}

### Minimum Test Coverage (10+ Devices)

| Device | OS Version | Screen Size | Priority | Test Focus |
|--------|------------|-------------|----------|------------|
| iPhone 15 Pro Max | iOS 17 | 6.7" | High | Latest features, performance |
| iPhone 12 | iOS 15 | 6.1" | High | Minimum iOS support |
| iPhone SE (2020) | iOS 15 | 4.7" | Medium | Small screen, older chip |
| iPad Pro 12.9" | iPadOS 17 | 12.9" | Medium | Tablet layout |
| Pixel 8 Pro | Android 14 | 6.7" | High | Latest Android |
| Samsung Galaxy S21 | Android 13 | 6.2" | High | Popular device |
| OnePlus 9 | Android 12 | 6.5" | Medium | Alternative OEM |
| Xiaomi Redmi Note 10 | Android 11 | 6.4" | Medium | Budget device, emerging markets |
| Samsung Galaxy Tab S8 | Android 12 | 11" | Low | Android tablet |
| Google Pixel 5 | Android 12 | 6.0" | Medium | Mid-range performance |

### Performance Benchmarks by Device

| Device | Cold Start | LLM Response | Screen FPS | Battery Drain |
|--------|------------|--------------|------------|---------------|
| iPhone 15 Pro Max | <2s | 15-17 tok/s | 60 FPS | <4%/30min |
| iPhone 12 | <3s | 10-12 tok/s | 60 FPS | <5%/30min |
| Pixel 8 Pro | <2.5s | 12-15 tok/s | 90 FPS | <4%/30min |
| Samsung S21 | <3s | 10-13 tok/s | 60 FPS | <6%/30min |
| Budget Android | <4s | 7-10 tok/s | 60 FPS | <8%/30min |

**Alert Thresholds:**
- ❌ Cold start >5s
- ❌ LLM response <5 tok/s
- ❌ Any screen <30 FPS
- ❌ Battery drain >10%/30min

---

## 8. Performance Benchmarks {#performance}

### Load Time Benchmarks

```dart
// test/performance/load_time_test.dart

void main() {
  test('App cold start time', () async {
    final stopwatch = Stopwatch()..start();

    await app.initialize();

    stopwatch.stop();
    expect(stopwatch.elapsedMilliseconds, lessThan(3000)); // <3s
  });

  test('Quran surah list loads quickly', () async {
    final stopwatch = Stopwatch()..start();

    final surahs = await quranRepository.getSurahs();

    stopwatch.stop();
    expect(stopwatch.elapsedMilliseconds, lessThan(500)); // <500ms
    expect(surahs.length, 114);
  });
}
```

### Memory Usage Test

```dart
// Run with: flutter run --profile
// Then use DevTools to monitor memory

void main() {
  test('Memory usage stays under 200MB', () async {
    final initialMemory = await getMemoryUsage();

    // Load Quran data
    await quranRepository.loadFullQuran();

    // Load LLM model
    await noorAI.loadModel();

    final finalMemory = await getMemoryUsage();
    final memoryIncrease = finalMemory - initialMemory;

    expect(memoryIncrease, lessThan(200 * 1024 * 1024)); // <200MB
  });
}
```

### Frame Rate Test

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Scrolling maintains 60 FPS', (tester) async {
    await tester.pumpWidget(MyApp());

    // Navigate to Quran
    await tester.tap(find.text('Quran'));
    await tester.pumpAndSettle();

    // Scroll and measure frame time
    await tester.fling(
      find.byType(ListView),
      Offset(0, -500),
      3000, // 3000 pixels/second
    );

    // Pump frames and check timing
    for (int i = 0; i < 100; i++) {
      await tester.pump(Duration(milliseconds: 16)); // 60 FPS = 16ms/frame
    }

    // No jank should occur (frames >16ms)
    // This is verified visually or with DevTools
  });
}
```

---

## 9. Beta Testing Guide {#beta-testing}

### Beta Program Structure

**Internal Beta (initial period-2):**
- Team members + friends/family
- Size: 20-30 testers
- Focus: Critical bugs, crashes

**Closed Beta (initial period-4):**
- Islamic community members, Arabic learners
- Size: 100-200 testers
- Focus: Feature usability, content accuracy

**Open Beta (initial period-6):**
- Public signups
- Size: 500-1000 testers
- Focus: Scale testing, diverse devices

### TestFlight Setup (iOS)

```bash
# 1. Archive build in Xcode
# 2. Upload to App Store Connect
# 3. Add beta testers in TestFlight section
# 4. Send invitations

# External beta requires App Review (1-2 days)
```

### Google Play Internal Testing

```bash
# 1. Build release AAB
# 2. Upload to Play Console
# 3. Create internal testing track
# 4. Add tester emails (max 100)
# 5. Share opt-in link
```

### Beta Tester Feedback Form

```markdown
**Noor AI Beta Feedback Form**

Device: [iPhone/Android model]
OS Version: [iOS X / Android X]
App Version: [1.0.0-beta.1]

**What feature did you test?**
[ ] Quran reading
[ ] Arabic learning
[ ] Noor AI Q&A
[ ] Prayer times
[ ] Other: __________

**Did you encounter any bugs?**
[ ] Yes (describe below)
[ ] No

**Bug Description:**
[Detailed steps to reproduce]

**What did you like most?**
[Open feedback]

**What needs improvement?**
[Open feedback]

**Overall rating:** ⭐⭐⭐⭐⭐

**Would you recommend Noor AI to a friend?**
[ ] Definitely
[ ] Probably
[ ] Not sure
[ ] Probably not
[ ] Definitely not
```

---

## 10. Bug Reporting & Triage {#bug-triage}

### Bug Severity Levels

**Critical (P0):** App crash, data loss, payment issues
- Response: Immediate (within 1 hour)
- Fix: Same day hotfix

**High (P1):** Core feature broken, major UI issue
- Response: Within 24 hours
- Fix: Within 1 week

**Medium (P2):** Feature partially broken, minor UI issue
- Response: Within 3 days
- Fix: Next release

**Low (P3):** Cosmetic issue, enhancement request
- Response: Acknowledged
- Fix: Backlog (future releases)

### Bug Report Template

```markdown
**Bug Title:** [Clear, descriptive title]

**Severity:** [Critical/High/Medium/Low]

**Environment:**
- Device: [iPhone 15 Pro / Pixel 8]
- OS: [iOS 17.2 / Android 14]
- App Version: [1.0.0]

**Steps to Reproduce:**
1. Open app
2. Navigate to Quran
3. Tap on Surah Al-Fatiha
4. Tap play audio
5. [Bug occurs]

**Expected Behavior:**
Audio should play smoothly

**Actual Behavior:**
Audio plays for 2 seconds then stops

**Screenshots/Video:**
[Attach if applicable]

**Logs:**
[Paste crash logs or error messages]

**Frequency:**
[ ] Always
[ ] Often (>50%)
[ ] Sometimes (<50%)
[ ] Rare (<10%)

**First Occurrence:** [Date when first noticed]
```

### Triage Process

**Daily Standup Review:**
1. Review new bugs from last 24 hours
2. Assign severity levels
3. Assign to developers
4. Set fix deadlines

**Weekly Bug Review:**
1. Review open bugs
2. Re-prioritize if needed
3. Close fixed bugs
4. Update release notes

---

## Summary: Testing Checklist

**Before Each Release:**
- [ ] All unit tests passing (70%+ coverage)
- [ ] All widget tests passing (50%+ coverage)
- [ ] Critical integration tests passing
- [ ] Golden tests passing (no UI regressions)
- [ ] Manual testing checklist complete
- [ ] Tested on 10+ devices
- [ ] Performance benchmarks met
- [ ] Beta tested by 100+ users
- [ ] Zero critical/high bugs
- [ ] Sentry error rate <0.1%

**Continuous Monitoring:**
- [ ] CI/CD runs tests on every commit
- [ ] Code coverage tracked and reported
- [ ] Performance monitored in production
- [ ] Crash reports reviewed daily
- [ ] User feedback triaged weekly

---

**Quality assurance process ready! Ship with confidence! 🚀**
