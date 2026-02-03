# Noor AI - API Integration Playbook
## Complete External API Specifications & Implementation Guide

**Purpose:** Consolidate all external API documentation
**Timeline:** Reference during development (Months 1-4)

---

## 1. Al-Quran Cloud API

**Base URL:** `https://api.alquran.cloud/v1`
**Auth:** None
**Rate Limit:** Unspecified (use respectfully)
**Cost:** Free

### Key Endpoints

```dart
// Get full Quran in specific edition
GET /quran/{edition}
// Examples: quran-uthmani, en.sahih, ur.ahmedali

// Get single surah
GET /surah/{number}/{edition}
// number: 1-114

// Get single verse
GET /ayah/{reference}/{edition}
// reference: 1:1 (surah:ayah)

// Get surah list
GET /surah

// Get edition list
GET /edition
```

### Implementation Example

```dart
class QuranApiService {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.alquran.cloud/v1',
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 30),
  ));

  Future<QuranData> fetchFullQuran(String edition) async {
    try {
      final response = await dio.get('/quran/$edition');
      if (response.statusCode == 200) {
        return QuranData.fromJson(response.data['data']);
      }
      throw ApiException('Failed to fetch Quran');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw NetworkException('Connection timeout');
      }
      rethrow;
    }
  }

  Future<List<Edition>> getAvailableEditions() async {
    final response = await dio.get('/edition');
    return (response.data['data'] as List)
        .map((e) => Edition.fromJson(e))
        .toList();
  }
}
```

### Caching Strategy

```dart
// Cache full Quran locally after first fetch
await db.into(db.verses).insertAll(verses);

// Always check local DB first
final cachedVerses = await db.select(db.verses).get();
if (cachedVerses.isNotEmpty) {
  return cachedVerses; // Use cached
}

// Fetch from API only if not cached
return await quranApi.fetchFullQuran('quran-uthmani');
```

---

## 2. Sunnah.com Hadith API

**Base URL:** `https://api.sunnah.com/v1`
**Auth:** API Key (X-API-Key header)
**Rate Limit:** Contact for details
**Cost:** Free for non-commercial

### Getting API Key

1. Visit https://sunnah.api-docs.io/
2. Request API key via contact form
3. Specify: Educational/non-commercial use
4. Receive key via email (typically 1-2 days)

### Key Endpoints

```dart
// Get collections list
GET /collections

// Get hadith by number
GET /hadiths/{collection}/{hadithNumber}
// collection: bukhari, muslim, abudawud, tirmidhi, nasai, ibnmajah, malik

// Get book list
GET /collections/{collection}/books

// Get hadiths in book
GET /collections/{collection}/books/{bookNumber}/hadiths

// Search hadiths
GET /hadiths/search
// Query params: ?q=prayer&collection=bukhari
```

### Implementation

```dart
class HadithApiService {
  static const apiKey = 'YOUR_API_KEY_HERE';

  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.sunnah.com/v1',
    headers: {'X-API-Key': apiKey},
  ));

  Future<HadithCollection> getCollection(String name) async {
    final response = await dio.get('/collections/$name');
    return HadithCollection.fromJson(response.data);
  }

  Future<List<Hadith>> searchHadiths({
    required String query,
    String? collection,
    int page = 1,
  }) async {
    final response = await dio.get('/hadiths/search', queryParameters: {
      'q': query,
      if (collection != null) 'collection': collection,
      'page': page,
    });

    return (response.data['hadiths'] as List)
        .map((h) => Hadith.fromJson(h))
        .toList();
  }
}
```

### Rate Limiting

```dart
class RateLimiter {
  final maxRequests = 100;
  final perMinutes = 1;
  final requests = <DateTime>[];

  Future<void> checkLimit() async {
    final now = DateTime.now();
    requests.removeWhere(
      (time) => now.difference(time) > Duration(minutes: perMinutes)
    );

    if (requests.length >= maxRequests) {
      final oldestRequest = requests.first;
      final waitTime = Duration(minutes: perMinutes) -
                       now.difference(oldestRequest);
      await Future.delayed(waitTime);
    }

    requests.add(now);
  }
}
```

---

## 3. OpenAI GPT-4 Vision API

**Base URL:** `https://api.openai.com/v1`
**Auth:** Bearer token
**Rate Limit:** 500 requests/day (Tier 1)
**Cost:** per image + per 1K tokens

### Use Case: Photo-to-Quran

```dart
class QuranPhotoService {
  static const apiKey = 'YOUR_OPENAI_API_KEY';

  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.openai.com/v1',
    headers: {'Authorization': 'Bearer $apiKey'},
  ));

  Future<QuranRecognitionResult> recognizeQuranPage(String imagePath) async {
    // Convert image to base64
    final bytes = await File(imagePath).readAsBytes();
    final base64Image = base64Encode(bytes);

    final response = await dio.post('/chat/completions', data: {
      'model': 'gpt-4-vision-preview',
      'messages': [
        {
          'role': 'user',
          'content': [
            {
              'type': 'text',
              'text': '''Extract Arabic text from this Quran page.

Return JSON format:
{
  "arabic_text": "extracted text",
  "surah_number": estimated surah (1-114),
  "confidence": 0.0-1.0
}'''
            },
            {
              'type': 'image_url',
              'image_url': {
                'url': 'data:image/jpeg;base64,$base64Image'
              }
            }
          ]
        }
      ],
      'max_tokens': 1000,
    });

    final content = response.data['choices'][0]['message']['content'];
    final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(content);
    final json = jsonDecode(jsonMatch!.group(0)!);

    return QuranRecognitionResult.fromJson(json);
  }
}
```

### Cost Optimization

```dart
// Compress image before sending
Future<File> compressImage(File file) async {
  final img = img_lib.decodeImage(await file.readAsBytes())!;

  // Resize to max 1024px
  final resized = img_lib.copyResize(img, width: 1024);

  // Compress to JPEG 85% quality
  final compressed = img_lib.encodeJpg(resized, quality: 85);

  final compressedFile = File('${file.path}_compressed.jpg');
  await compressedFile.writeAsBytes(compressed);

  return compressedFile;
}

// Cache results to avoid re-processing
final cacheKey = sha256.convert(imageBytes).toString();
final cached = await cache.get(cacheKey);
if (cached != null) return cached;
```

---

## 4. Google Cloud APIs

### Google Translate API

**Cost:** per 1M characters
**Rate Limit:** 100 requests/100 seconds

```dart
class TranslationService {
  static const apiKey = 'YOUR_GOOGLE_CLOUD_API_KEY';

  Future<String> translateText(String text, {
    required String targetLang,
    String sourceLang = 'ar',
  }) async {
    final dio = Dio();
    final response = await dio.post(
      'https://translation.googleapis.com/language/translate/v2',
      queryParameters: {'key': apiKey},
      data: {
        'q': text,
        'target': targetLang,
        'source': sourceLang,
        'format': 'text',
      },
    );

    return response.data['data']['translations'][0]['translatedText'];
  }
}
```

### Cost Optimization

```dart
// Batch translations (up to 128 texts)
Future<List<String>> translateBatch(List<String> texts) async {
  final response = await dio.post(url, data: {
    'q': texts, // Array of strings
    'target': 'en',
  });

  return (response.data['data']['translations'] as List)
      .map((t) => t['translatedText'] as String)
      .toList();
}

// Cache common translations
final cached = await translationCache.get('$text:$targetLang');
if (cached != null) return cached;
```

---

## 5. ElevenLabs TTS API

**Base URL:** `https://api.elevenlabs.io/v1`
**Auth:** xi-api-key header
**Cost:** monthly (Creator plan, 30K characters)
**Rate Limit:** 100 requests/month (free tier)

### Use Case: Arabic TTS

```dart
class TTSService {
  static const apiKey = 'YOUR_ELEVENLABS_API_KEY';

  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.elevenlabs.io/v1',
    headers: {'xi-api-key': apiKey},
  ));

  Future<File> synthesizeSpeech(String text, {
    String voiceId = 'pNInz6obpgDQGcFmaJgB', // Arabic voice
  }) async {
    final response = await dio.post(
      '/text-to-speech/$voiceId',
      data: {
        'text': text,
        'model_id': 'eleven_multilingual_v2',
        'voice_settings': {
          'stability': 0.5,
          'similarity_boost': 0.75,
        }
      },
      options: Options(responseType: ResponseType.bytes),
    );

    final file = File('${Directory.systemTemp.path}/tts_${DateTime.now().millisecondsSinceEpoch}.mp3');
    await file.writeAsBytes(response.data);

    return file;
  }
}
```

### Free Alternative: On-Device TTS

```dart
import 'package:flutter_tts/flutter_tts.dart';

class OnDeviceTTS {
  final tts = FlutterTts();

  Future<void> speak(String text) async {
    await tts.setLanguage('ar-SA');
    await tts.setSpeechRate(0.5);
    await tts.speak(text);
  }
}
```

---

## 6. Prayer Times (adhan_dart)

**Package:** `adhan_dart`
**Cost:** Free (offline calculation)
**No API required**

### Implementation

```dart
import 'package:adhan_dart/adhan_dart.dart';

class PrayerTimesService {
  PrayerTimes calculatePrayerTimes({
    required double latitude,
    required double longitude,
    DateTime? date,
    CalculationMethod method = CalculationMethod.muslimWorldLeague,
  }) {
    final coordinates = Coordinates(latitude, longitude);
    final params = method.params;
    final dateComponents = DateComponents.from(date ?? DateTime.now());

    return PrayerTimes(
      coordinates: coordinates,
      dateComponents: dateComponents,
      calculationParameters: params,
    );
  }

  Future<void> scheduleNotifications(PrayerTimes times) async {
    await FlutterLocalNotifications.zonedSchedule(
      id: 1,
      title: 'Fajr Prayer',
      body: 'It\'s time for Fajr prayer',
      scheduledDate: times.fajr,
      notificationDetails: NotificationDetails(...),
    );

    // Repeat for other prayers
  }
}
```

### Calculation Methods Comparison

| Method | Used In | Fajr Angle | Isha Angle |
|--------|---------|------------|------------|
| Muslim World League | Europe, Americas | 18° | 17° |
| ISNA | North America | 15° | 15° |
| Egyptian | Africa, Middle East | 19.5° | 17.5° |
| Umm al-Qura | Saudi Arabia | 18.5° | 90 min after Maghrib |
| Karachi | Pakistan | 18° | 18° |
| Tehran | Iran | 17.7° | 14° |

---

## 7. Error Handling Strategy

### Centralized Error Handler

```dart
class ApiErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return 'Connection timeout. Check your internet.';
        case DioExceptionType.sendTimeout:
          return 'Request timeout. Try again.';
        case DioExceptionType.receiveTimeout:
          return 'Server response timeout.';
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          if (statusCode == 401) return 'Invalid API key';
          if (statusCode == 429) return 'Rate limit exceeded. Try later.';
          if (statusCode == 500) return 'Server error. Try later.';
          return 'Request failed (Error $statusCode)';
        case DioExceptionType.cancel:
          return 'Request cancelled';
        default:
          return 'Network error. Check connection.';
      }
    }

    return 'Unexpected error: ${error.toString()}';
  }
}
```

### Retry Logic with Exponential Backoff

```dart
class RetryInterceptor extends Interceptor {
  final maxRetries = 3;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.requestOptions.extra['retryCount'] == null) {
      err.requestOptions.extra['retryCount'] = 0;
    }

    final retryCount = err.requestOptions.extra['retryCount'] as int;

    if (retryCount < maxRetries && _shouldRetry(err)) {
      err.requestOptions.extra['retryCount'] = retryCount + 1;

      // Exponential backoff: 1s, 2s, 4s
      final delay = Duration(seconds: pow(2, retryCount).toInt());
      await Future.delayed(delay);

      try {
        final response = await dio.fetch(err.requestOptions);
        return handler.resolve(response);
      } catch (e) {
        return handler.next(e as DioException);
      }
    }

    return handler.next(err);
  }

  bool _shouldRetry(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
           error.type == DioExceptionType.receiveTimeout ||
           (error.response?.statusCode ?? 0) >= 500;
  }
}
```

---

## 8. Rate Limiting & Cost Optimization

### API Usage Tracker

```dart
class ApiUsageTracker {
  final db = Get.find<AppDatabase>();

  Future<void> logApiCall({
    required String apiName,
    required double cost,
  }) async {
    await db.into(db.apiUsageLogs).insert(
      ApiUsageLogsCompanion.insert(
        apiName: apiName,
        cost: cost,
        timestamp: DateTime.now(),
      ),
    );
  }

  Future<double> getTodaysCost() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);

    final query = db.select(db.apiUsageLogs)
      ..where((log) => log.timestamp.isBiggerOrEqualValue(startOfDay));

    final logs = await query.get();
    return logs.fold(0.0, (sum, log) => sum + log.cost);
  }

  Future<bool> canMakeApiCall(String apiName, double estimatedCost) async {
    final todaysCost = await getTodaysCost();
    const dailyBudget = 10.0; // daily limit

    return (todaysCost + estimatedCost) <= dailyBudget;
  }
}
```

### Cost Alerts

```dart
Future<void> checkCostAlerts() async {
  final usage = await apiUsageTracker.getTodaysCost();

  if (usage > 8.0) {
    await sendSlackAlert('API cost alert: \$usage spent today');
  }

  if (usage > 10.0) {
    await disableNonEssentialApis();
  }
}
```

---

## 9. API Testing Guide

### Unit Tests

```dart
void main() {
  group('QuranApiService', () {
    late QuranApiService service;
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      service = QuranApiService(dio: mockDio);
    });

    test('fetchFullQuran returns data on success', () async {
      when(mockDio.get('/quran/quran-uthmani')).thenAnswer(
        (_) async => Response(
          data: {'data': {'surahs': []}},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await service.fetchFullQuran('quran-uthmani');
      expect(result, isA<QuranData>());
    });

    test('throws ApiException on error', () async {
      when(mockDio.get(any)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(
        () => service.fetchFullQuran('invalid'),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
```

### Integration Tests

```dart
void main() {
  testWidgets('Photo-to-Quran flow', (tester) async {
    await tester.pumpWidget(MyApp());

    // Navigate to camera
    await tester.tap(find.byIcon(Icons.camera));
    await tester.pumpAndSettle();

    // Mock camera capture
    final mockImage = File('test_resources/quran_page.jpg');

    // Trigger recognition
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump();

    // Verify loading indicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for API response
    await tester.pumpAndSettle(Duration(seconds: 5));

    // Verify results displayed
    expect(find.text('Surah Al-Fatiha'), findsOneWidget);
  });
}
```

---

## Summary: API Integration Checklist

**Before Development:**
- [ ] Obtain all API keys
- [ ] Test each API in Postman/Insomnia
- [ ] Set up rate limiting
- [ ] Configure error handling
- [ ] Set up usage tracking

**During Development:**
- [ ] Implement caching for all APIs
- [ ] Add retry logic with exponential backoff
- [ ] Test error scenarios (timeout, 500, 401, etc.)
- [ ] Monitor costs daily

**Before Launch:**
- [ ] Test with production API keys
- [ ] Verify rate limits won't be exceeded
- [ ] Set up cost alerts
- [ ] Document all API dependencies
- [ ] Create fallback for API failures

---

**All APIs documented and ready for integration! 🚀**
