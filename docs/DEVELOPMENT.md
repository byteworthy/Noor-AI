# Noor AI - Development Implementation Guide
## Complete Development Roadmap & Technical Implementation

**Purpose:** Technical implementation guide for all phases of Noor AI development
**Timeline:** Months 1-18 and beyond

---

## Table of Contents

1. [Phase 1: MVP (Months 1-4)](#phase-1-mvp-months-1-4)
2. [Phase 2: Enhanced (Months 5-12)](#phase-2-enhanced-months-5-12)
3. [Phase 3: Complete Ecosystem (Year 2+)](#phase-3-complete-ecosystem-year-2)
4. [Phase 4: B2B API Platform (Months 13-18)](#phase-4-b2b-api-platform-months-13-18)

---

## Phase 1: MVP (Months 1-4)

### Month 1: Foundation

**What you're building:**
- Flutter project setup
- Database (Drift with 17 tables)
- Navigation (GoRouter)
- Authentication (Firebase Auth)
- Basic UI shell

**Deliverable:** App opens, has screens, database works

**Implementation Steps:**

**Step 1: Project Setup**

```bash
# Create Flutter project
flutter create noor_ai
cd noor_ai

# Initialize git
git init
git add .
git commit -m "Initial commit"
```

**Step 2: Install Dependencies**

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # State Management
  flutter_riverpod: ^3.0.0
  riverpod_annotation: ^3.0.0

  # Database
  drift: ^2.27.0
  drift_flutter: ^0.2.4
  sqlite3_flutter_libs: ^0.5.41

  # Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  flutter_secure_storage: ^9.0.0
  path_provider: ^2.1.2

  # Navigation
  go_router: ^14.0.0

  # Network
  dio: ^5.4.0
  connectivity_plus: ^6.0.0

  # On-Device LLM
  llamadart: ^latest

  # Audio
  just_audio: ^0.9.36
  record: ^5.0.0
  flutter_tts: ^4.0.2

  # Camera
  camera: ^0.10.5
  image_picker: ^1.0.7

  # Permissions
  permission_handler: ^11.0.0

  # Background
  workmanager: ^0.5.2
  flutter_local_notifications: ^17.0.0

  # Payments
  purchases_flutter: ^9.8.0

  # Firebase
  firebase_core: ^2.25.0
  firebase_auth: ^4.16.0
  firebase_analytics: ^10.8.0
  firebase_crashlytics: ^3.4.0
  cloud_firestore: ^4.14.0

  # Utils
  uuid: ^4.3.0
  intl: ^0.19.0
  url_launcher: ^6.2.0
  share_plus: ^7.2.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  drift_dev: ^2.27.0
  riverpod_generator: ^3.0.0
  build_runner: ^2.4.8
  mockito: ^5.4.4
  very_good_analysis: ^5.1.0
```

**Step 3: Database Schema (17 Tables)**

See complete schema in `MASTER-PRD.md` Section 5, including:
1. Surahs
2. Verses
3. VerseWords (word-by-word breakdown)
4. Tafsirs
5. Hadiths
6. ReviewCards (SRS)
7. ReviewLogs
8. Users
9. UserProgress
10. PrayerTimes
11. VocabularyDecks
12. VocabularyWords
13. ConversationHistory
14. HabitLogs
15. DownloadedContent
16. Bookmarks
17. NoorAIConversations

**Step 4: Project Structure**

```
noor_ai/
├── lib/
│   ├── main.dart
│   ├── app/
│   │   ├── app.dart
│   │   ├── router.dart
│   │   └── theme/
│   ├── core/
│   │   ├── constants/
│   │   ├── utils/
│   │   └── network/
│   ├── features/
│   │   ├── quran/
│   │   ├── arabic_learning/
│   │   ├── noor_ai/
│   │   ├── prayer/
│   │   ├── memorization/
│   │   └── translation/
│   └── shared/
│       ├── data/
│       ├── providers/
│       └── widgets/
├── assets/
│   ├── data/
│   ├── models/
│   └── audio/
└── test/
```

---

### Month 2: LLM Training

**What you're doing:**
- Get Mac Mini M4 Pro
- Collect 50K training samples
- Fine-tune Qwen2.5-7B (6-8 hours)
- Quantize to GGUF (Q4_K_M)
- Integrate in Flutter

**Deliverable:** Working Noor AI chatbot on-device

**Training Dataset (50,000 Samples):**

1. **Quran Q&A (12,500 samples)**
   - Source: Tanzil.net (6,236 verses)
   - 20 translations (English, Urdu, French, etc.)

2. **Hadith Q&A (12,500 samples)**
   - Source: Sunnah.com API (7 collections)

3. **Fiqh Comparative (10,000 samples)**
   - Source: islamqa.info, islamweb.net

4. **Arabic Tutoring (7,500 samples)**
   - Quranic vocabulary with roots
   - Grammar explanations

5. **Islamic Education (5,000 samples)**
   - Seerah stories
   - Aqeedah explanations

6. **Conversational (2,500 samples)**
   - Natural dialogue in Arabic

**Training Script:**

```bash
# Step 1: Install MLX
pip install mlx mlx-lm

# Step 2: Download Base Model
mlx_lm.convert --hf-path Qwen/Qwen2.5-7B-Instruct -q

# Step 3: Prepare data in JSONL format
# See MASTER-PRD.md Section 2 for example format

# Step 4: Fine-Tune with LoRA
mlx_lm.lora \
  --model Qwen/Qwen2.5-7B-Instruct \
  --train \
  --data ./islamic_training_data.jsonl \
  --batch-size 4 \
  --lora-layers 16 \
  --lora-rank 64 \
  --lora-alpha 128 \
  --learning-rate 2e-4 \
  --iters 5000 \
  --save-every 1000

# Step 5: Merge LoRA Adapters
mlx_lm.fuse \
  --model ./qwen2.5-7b-mlx \
  --adapter-path ./adapters \
  --save-path ./noor-ai-7b-merged

# Step 6: Quantize to GGUF
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp
make
python convert-hf-to-gguf.py ../noor-ai-7b-merged --outfile noor-ai-7b-f16.gguf
./quantize noor-ai-7b-f16.gguf noor-ai-7b-q4km.gguf Q4_K_M
```

**Flutter Integration:**

```dart
import 'package:llamadart/llamadart.dart';

class NoorAIService {
  late LlamaEngine _engine;

  Future initialize() async {
    _engine = LlamaEngine(LlamaBackend());
    final modelPath = await _getModelPath();
    await _engine.loadModel(modelPath);
  }

  Stream askNoorAI(String question) async* {
    final systemPrompt = '''
You are Noor AI, a knowledgeable Islamic scholar assistant.
Always cite sources [Quran X:Y] [Bukhari Z].
Never issue fatwas - direct to qualified scholars for rulings.
''';

    final prompt = '''
system
$systemPrompt

user
$question

assistant
''';

    await for (final token in _engine.generate(
      prompt,
      maxTokens: 1024,
      temperature: 0.7,
      topP: 0.95,
    )) {
      yield token;
    }
  }
}
```

---

### Month 3: Core Features

**What you're building:**
- Quran reader (full text, audio, word-by-word)
- Arabic tutor (10 beginner scenarios)
- Prayer times
- First 100 vocabulary words
- FSRS system

**Deliverable:** MVP that's actually useful

**1. Quran Companion Implementation:**

```dart
class QuranPhotoService {
  final OpenAI gpt4Vision;
  final QuranDatabase db;

  Future processPhoto(File image) async {
    // 1. Send to GPT-4 Vision
    final visionResult = await gpt4Vision.analyze(
      image: image,
      prompt: '''
Extract all Arabic text from this Quran page.
Return JSON: {
  "arabic_text": "...",
  "surah": "...",
  "verses": [1, 2, 3]
}
''',
    );

    // 2. Match to database
    final matches = await db.findVersesByText(
      visionResult.arabicText,
      fuzzyMatch: true,
    );

    // 3. Enrich with everything
    final enriched = await Future.wait(
      matches.map((v) => _enrichVerse(v))
    );

    return QuranPhotoResult(verses: enriched);
  }
}
```

**2. Memorization Helper:**

```dart
class MemorizationSession {
  final WhisperASR asr;
  final QuranDatabase db;

  Stream startSession({
    required int surah,
    required List verseRange,
  }) async* {
    final targetVerses = await db.getVerses(surah, verseRange);
    final words = targetVerses.map((v) => v.arabicText).join(' ').split(' ');

    int currentIndex = 0;

    await for (final transcription in asr.streamTranscription()) {
      final comparison = _compareWords(
        expected: words[currentIndex],
        actual: transcription.text,
      );

      if (comparison.isCorrect) {
        currentIndex++;
        yield MemorizationFeedback(state: MemorizationState.correct);
      } else {
        yield MemorizationFeedback(
          state: MemorizationState.mistake,
          correctWord: words[currentIndex],
          yourWord: transcription.text,
        );
      }
    }
  }
}
```

**3. FSRS Implementation:**

```dart
import 'package:fsrs/fsrs.dart';

class SRSService {
  late Scheduler _scheduler;

  void initialize() {
    _scheduler = Scheduler(
      parameters: [
        0.2172, 1.1771, 3.2602, 16.1507, 7.0114, 0.57, 2.0966, 0.0069,
        1.5261, 0.112, 1.0178, 1.849, 0.1133, 0.3127, 2.2934, 0.2191,
        3.0004, 0.7536, 0.3332, 0.1437, 0.2,
      ],
      desiredRetention: 0.9,
      learningSteps: [
        Duration(minutes: 1),
        Duration(minutes: 10),
      ],
      maximumInterval: 365,
      enableFuzzing: true,
    );
  }

  ReviewResult reviewCard(Card card, Rating rating) {
    return _scheduler.reviewCard(card, rating);
  }
}
```

---

### Month 4: Polish & Enhanced

**What you're adding:**
- Photo-to-Quran (GPT-4 Vision)
- Memorization helper (Whisper)
- Real-time translation
- Pronunciation feedback
- Offline mode
- Premium paywall (RevenueCat)

**Deliverable:** Feature-complete for launch

**Launch:** January 19, 2026 (Pre-Ramadan)

**Launch Checklist:**

- [ ] App Store Connect setup complete
- [ ] Google Play Console setup complete
- [ ] Privacy policy URL live
- [ ] Terms of service URL live
- [ ] App Store screenshots
- [ ] RevenueCat products configured
- [ ] Firebase production project ready
- [ ] Sentry error tracking active
- [ ] TestFlight beta with 20+ testers
- [ ] All critical bugs fixed (crash-free >99%)
- [ ] App Store submission (7-10 days approval)

---

## Phase 2: Enhanced (Months 5-12)

### Community Features

**7. Study Circles**
- Video chat + whiteboard
- Learning partner matching
- Challenges ("30-Day Arabic", "Juz Amma Memorization")
- Leaderboards (anonymous, Islamic framing)

**Implementation:**
```dart
// WebRTC-based video chat
class StudyCircleService {
  final WebRTCClient rtcClient;

  Future createCircle({
    required String topic,
    required int maxParticipants,
  }) async {
    final room = await rtcClient.createRoom();

    return StudyCircle(
      id: room.id,
      topic: topic,
      participants: [],
      maxParticipants: maxParticipants,
      whiteboardUrl: await _createWhiteboard(),
    );
  }
}
```

### Voice AI Companion

**8. Voice Features**
- "Ya Noor" wake word
- Hands-free mode
- Advanced tajweed coaching (phoneme-level)
- Islamic audiobooks

**Implementation:**
```dart
class VoiceCompanionService {
  final WakeWordDetector wakeWord;
  final FlutterTts tts;

  Stream listenForWakeWord() async* {
    await for (final audio in wakeWord.stream) {
      if (audio.detectedPhrase == "Ya Noor") {
        yield WakeWordDetected();
      }
    }
  }
}
```

### Smart Daily Integration

**9. Daily Features**
- Ramadan special mode
- Habit tracking (visual charts)
- Dhikr counter with goals

---

## Phase 3: Complete Ecosystem (Year 2+)

### Islamic Finance

**10. Finance Tools**
- Zakat calculator
- Halal investment screener
- Murabaha (Islamic mortgage) guide
- Inheritance calculator

**Implementation:**
```dart
class ZakatCalculator {
  double calculateZakat({
    required double cash,
    required double gold,
    required double silver,
    required double investments,
    required double debts,
  }) {
    final totalAssets = cash + gold + silver + investments;
    final netAssets = totalAssets - debts;

    final nisab = 85 * goldPricePerGram; // Current nisab threshold

    if (netAssets >= nisab) {
      return netAssets * 0.025; // 2.5%
    }
    return 0;
  }
}
```

### Complete Islamic Library

**11. Library Features**
- Tafsir (Ibn Kathir, Jalalayn, Tabari)
- All 7 hadith collections
- Fiqh manuals (4 madhabs)
- Seerah books
- AI-powered search across all texts

### Family Features

**12. Family Tools**
- Parent dashboard
- Kids mode
- Bedtime stories (Prophet stories)
- Homeschool curriculum K-12

### Prayer & Worship Expansion

**13. Advanced Prayer Features**
- AR Qibla (3D Kaaba)
- Masjid finder
- 100+ duas with audio
- 99 Names of Allah

**AR Qibla Implementation:**
```dart
class ARQiblaService {
  final ARCore arCore;
  final CompassService compass;

  Future showQiblaDirection() async {
    final qiblaDirection = compass.getQiblaDirection();

    await arCore.placeObject(
      object: KaabaModel3D(),
      rotation: qiblaDirection,
      distance: 5.0, // meters
    );
  }
}
```

---

## Phase 4: B2B API Platform (Months 13-18)

**Timeline:** Post-consumer app launch (January 2026+)

**Goal:** Build and launch B2B API platform to generate $50K MRR from 100 API customers.

---

### Phase 4.1: Core API Infrastructure (Months 13-14)

**Objective:** Launch MVP API with 10 beta customers

**New Directory Structure:**

```
noor-ai-api/                    # New repository (separate from consumer app)
├── src/
│   ├── routes/
│   │   ├── qa.routes.js        # POST /qa/ask
│   │   ├── quran.routes.js     # GET /quran/verse/:surah/:ayah
│   │   ├── hadith.routes.js    # GET /hadith/search
│   │   └── prayer.routes.js    # GET /prayer-times
│   ├── middleware/
│   │   ├── auth.middleware.js  # API key validation
│   │   ├── rateLimit.middleware.js
│   │   └── errorHandler.middleware.js
│   ├── services/
│   │   ├── llm.service.js      # Qwen2.5-7B inference
│   │   ├── quran.service.js
│   │   ├── hadith.service.js
│   │   └── prayer.service.js
│   ├── models/
│   │   ├── apiKey.model.js
│   │   ├── usage.model.js
│   │   └── customer.model.js
│   └── index.js                # Express server
├── dashboard/                   # Developer dashboard (Next.js)
│   ├── pages/
│   │   ├── index.js            # Overview
│   │   ├── api-keys.js         # Manage API keys
│   │   ├── logs.js             # Request logs
│   │   └── billing.js          # Billing
│   └── components/
├── docs/                        # API documentation
│   ├── openapi.yaml            # OpenAPI spec
│   └── guides/
├── .github/
│   └── workflows/
│       └── deploy-api.yml      # CI/CD for API
└── package.json
```

**Implementation Steps:**

**Step 1: Set Up API Server (Week 1-2)**

```bash
# Create new repository
git clone https://github.com/noorai/noorai-api
cd noorai-api

# Initialize Node.js project
npm init -y
npm install express cors helmet morgan dotenv
npm install @google-cloud/firestore
npm install firebase-admin
npm install express-rate-limit
```

**Create `src/index.js`:**
```javascript
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const routes = require('./routes');
const { authMiddleware } = require('./middleware/auth.middleware');
const { errorHandler } = require('./middleware/errorHandler.middleware');

const app = express();

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());

// Authentication
app.use('/v1', authMiddleware);

// Routes
app.use('/v1/qa', routes.qa);
app.use('/v1/quran', routes.quran);
app.use('/v1/hadith', routes.hadith);
app.use('/v1/prayer-times', routes.prayer);

// Error handling
app.use(errorHandler);

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: Date.now() });
});

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`Noor API listening on port ${PORT}`);
});
```

**Step 2: Implement Authentication (Week 2)**

**Create `src/middleware/auth.middleware.js`:**
```javascript
const admin = require('firebase-admin');

async function authMiddleware(req, res, next) {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({
      error: {
        code: 'unauthorized',
        message: 'Missing or invalid API key'
      }
    });
  }

  const apiKey = authHeader.split('Bearer ')[1];

  try {
    // Validate API key against Firestore
    const keyDoc = await admin.firestore()
      .collection('api_keys')
      .doc(apiKey)
      .get();

    if (!keyDoc.exists || keyDoc.data().revoked) {
      return res.status(401).json({
        error: {
          code: 'invalid_api_key',
          message: 'API key is invalid or revoked'
        }
      });
    }

    // Attach customer info to request
    req.customer = keyDoc.data();
    next();
  } catch (error) {
    console.error('Auth error:', error);
    return res.status(500).json({
      error: {
        code: 'internal_error',
        message: 'Authentication failed'
      }
    });
  }
}

module.exports = { authMiddleware };
```

**Step 3: Implement Core Endpoints (Week 3-4)**

**Create `src/routes/qa.routes.js`:**
```javascript
const express = require('express');
const { LLMService } = require('../services/llm.service');

const router = express.Router();
const llmService = new LLMService();

router.post('/ask', async (req, res, next) => {
  try {
    const { question, madhab, language, include_sources } = req.body;

    // Track usage
    await trackUsage(req.customer.id, 'qa_ask');

    // Call LLM
    const response = await llmService.ask({
      question,
      madhab: madhab || 'hanafi',
      language: language || 'en',
      include_sources: include_sources !== false
    });

    res.json({
      data: response,
      metadata: {
        request_id: req.id,
        processing_time_ms: response.processing_time,
        model: 'noor-qwen-2.5-7b-v1'
      },
      status: 'success'
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
```

**Step 4: Deploy to Google Cloud Run (Week 5)**

```bash
# Build Docker image
docker build -t gcr.io/noor-ai/api:v1 .

# Push to Google Container Registry
docker push gcr.io/noor-ai/api:v1

# Deploy to Cloud Run
gcloud run deploy noor-api \
  --image gcr.io/noor-ai/api:v1 \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --set-env-vars NODE_ENV=production

# Set up custom domain
gcloud run domain-mappings create \
  --service noor-api \
  --domain api.noorai.app
```

**Step 5: Build Developer Dashboard (Week 6-8)**

```bash
# Create Next.js app
npx create-next-app@latest dashboard
cd dashboard
npm install @noorai/sdk recharts tailwindcss
```

**Create `dashboard/pages/index.js`:**
```javascript
import { useEffect, useState } from 'react';
import { Line } from 'recharts';

export default function Dashboard() {
  const [usage, setUsage] = useState([]);

  useEffect(() => {
    // Fetch usage data
    fetch('/api/usage')
      .then(res => res.json())
      .then(data => setUsage(data));
  }, []);

  return (
    <div className="p-8">
      <h1 className="text-3xl font-bold mb-8">API Usage</h1>

      <div className="grid grid-cols-3 gap-4 mb-8">
        <Card title="Requests Today" value="1,234" />
        <Card title="Quota Used" value="12%" />
        <Card title="Avg Response" value="1.2s" />
      </div>

      <UsageChart data={usage} />
    </div>
  );
}
```

---

### Phase 4.2: Developer Experience (Months 15-16)

**Objective:** Scale to 30 customers with excellent DX

**SDK Development:**

**Python SDK (`noor-python`):**
```bash
# Create Python package
mkdir noor-python
cd noor-python
poetry init
poetry add requests pydantic
```

**Create `noor_api/client.py`:**
```python
import requests
from typing import Optional, List

class NoorClient:
    def __init__(self, api_key: str, base_url: str = "https://api.noorai.app/v1"):
        self.api_key = api_key
        self.base_url = base_url
        self.session = requests.Session()
        self.session.headers.update({
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json"
        })

    def ask(
        self,
        question: str,
        madhab: str = "hanafi",
        language: str = "en",
        include_sources: bool = True
    ) -> dict:
        """Ask the Islamic AI a question."""
        response = self.session.post(
            f"{self.base_url}/qa/ask",
            json={
                "question": question,
                "madhab": madhab,
                "language": language,
                "include_sources": include_sources
            }
        )
        response.raise_for_status()
        return response.json()

    def get_verse(
        self,
        surah: int,
        ayah: int,
        translation: str = "en.sahih",
        audio: Optional[str] = None
    ) -> dict:
        """Get a specific Quran verse."""
        params = {"translation": translation}
        if audio:
            params["audio"] = audio

        response = self.session.get(
            f"{self.base_url}/quran/verse/{surah}/{ayah}",
            params=params
        )
        response.raise_for_status()
        return response.json()

    def search_hadith(
        self,
        query: str,
        collection: Optional[str] = None,
        limit: int = 10
    ) -> dict:
        """Search hadith database."""
        params = {"query": query, "limit": limit}
        if collection:
            params["collection"] = collection

        response = self.session.get(
            f"{self.base_url}/hadith/search",
            params=params
        )
        response.raise_for_status()
        return response.json()

    def get_prayer_times(
        self,
        lat: float,
        lng: float,
        date: Optional[str] = None,
        method: str = "isna"
    ) -> dict:
        """Calculate prayer times for location."""
        params = {
            "lat": lat,
            "lng": lng,
            "method": method
        }
        if date:
            params["date"] = date

        response = self.session.get(
            f"{self.base_url}/prayer-times",
            params=params
        )
        response.raise_for_status()
        return response.json()
```

**Publish to PyPI:**
```bash
poetry build
poetry publish
```

**Node.js SDK (`@noorai/sdk`):**

```bash
mkdir noor-nodejs
cd noor-nodejs
npm init -y
npm install axios
```

**Create `src/index.js`:**
```javascript
const axios = require('axios');

class NoorClient {
  constructor({ apiKey, baseUrl = 'https://api.noorai.app/v1' }) {
    this.apiKey = apiKey;
    this.baseUrl = baseUrl;
    this.client = axios.create({
      baseURL: baseUrl,
      headers: {
        'Authorization': `Bearer ${apiKey}`,
        'Content-Type': 'application/json'
      }
    });
  }

  async ask(question, options = {}) {
    const response = await this.client.post('/qa/ask', {
      question,
      madhab: options.madhab || 'hanafi',
      language: options.language || 'en',
      include_sources: options.include_sources !== false
    });
    return response.data;
  }

  async getVerse(surah, ayah, options = {}) {
    const response = await this.client.get(`/quran/verse/${surah}/${ayah}`, {
      params: {
        translation: options.translation || 'en.sahih',
        audio: options.audio
      }
    });
    return response.data;
  }

  async searchHadith(query, options = {}) {
    const response = await this.client.get('/hadith/search', {
      params: {
        query,
        collection: options.collection,
        limit: options.limit || 10
      }
    });
    return response.data;
  }

  async getPrayerTimes(lat, lng, options = {}) {
    const response = await this.client.get('/prayer-times', {
      params: {
        lat,
        lng,
        date: options.date,
        method: options.method || 'isna'
      }
    });
    return response.data;
  }
}

module.exports = { NoorClient };
```

**Publish to npm:**
```bash
npm publish --access public
```

**Dart/Flutter SDK (`noor_api`):**

```bash
mkdir noor_dart
cd noor_dart
dart create -t package noor_api
```

**Create `lib/noor_api.dart`:**
```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class NoorClient {
  final String apiKey;
  final String baseUrl;
  late http.Client _client;

  NoorClient({
    required this.apiKey,
    this.baseUrl = 'https://api.noorai.app/v1',
  }) {
    _client = http.Client();
  }

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $apiKey',
    'Content-Type': 'application/json',
  };

  Future<Map<String, dynamic>> ask({
    required String question,
    String madhab = 'hanafi',
    String language = 'en',
    bool includeSources = true,
  }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/qa/ask'),
      headers: _headers,
      body: json.encode({
        'question': question,
        'madhab': madhab,
        'language': language,
        'include_sources': includeSources,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to ask question: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getVerse({
    required int surah,
    required int ayah,
    String translation = 'en.sahih',
    String? audio,
  }) async {
    final queryParams = {
      'translation': translation,
      if (audio != null) 'audio': audio,
    };

    final uri = Uri.parse('$baseUrl/quran/verse/$surah/$ayah')
        .replace(queryParameters: queryParams);

    final response = await _client.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get verse: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> searchHadith({
    required String query,
    String? collection,
    int limit = 10,
  }) async {
    final queryParams = {
      'query': query,
      'limit': limit.toString(),
      if (collection != null) 'collection': collection,
    };

    final uri = Uri.parse('$baseUrl/hadith/search')
        .replace(queryParameters: queryParams);

    final response = await _client.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to search hadith: ${response.body}');
    }
  }

  void dispose() {
    _client.close();
  }
}
```

**Publish to pub.dev:**
```bash
dart pub publish
```

---

### Phase 4.3: Enterprise & Scale (Months 17-18)

**Objective:** 100 customers, enterprise-ready

**White-Label Implementation:**

```javascript
// src/routes/whitelabel.routes.js
const express = require('express');
const router = express.Router();

router.post('/create-subdomain', async (req, res) => {
  const { subdomain, customer_id, branding } = req.body;

  // Validate subdomain
  if (!subdomain.match(/^[a-z0-9-]+$/)) {
    return res.status(400).json({
      error: { code: 'invalid_subdomain', message: 'Subdomain must be alphanumeric' }
    });
  }

  // Create custom subdomain (e.g., school-name.noorapi.app)
  await createSubdomain(subdomain);

  // Apply custom branding
  await applyBranding(customer_id, {
    logo_url: branding.logo_url,
    primary_color: branding.primary_color,
    company_name: branding.company_name
  });

  res.json({
    subdomain_url: `https://${subdomain}.noorapi.app`,
    dashboard_url: `https://${subdomain}.noorapi.app/dashboard`
  });
});

module.exports = router;
```

**SSO Integration (SAML):**
```javascript
const passport = require('passport');
const saml = require('passport-saml');

// Configure SAML strategy
passport.use(new saml.Strategy({
  path: '/login/callback',
  entryPoint: process.env.SAML_ENTRY_POINT,
  issuer: 'noor-api',
  cert: process.env.SAML_CERT
}, (profile, done) => {
  // Authenticate user via SSO
  const user = {
    email: profile.email,
    name: profile.displayName,
    organization: profile.organization
  };
  return done(null, user);
}));

// SSO login route
app.post('/auth/saml/login',
  passport.authenticate('saml', { failureRedirect: '/login', failureFlash: true }),
  (req, res) => {
    res.redirect('/dashboard');
  }
);

// SSO callback
app.post('/auth/saml/callback',
  passport.authenticate('saml', { failureRedirect: '/login', failureFlash: true }),
  (req, res) => {
    // Create session
    req.session.user = req.user;
    res.redirect('/dashboard');
  }
);
```

**On-Premise Deployment:**

```dockerfile
# Dockerfile for on-premise deployment
FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy application code
COPY src/ ./src/
COPY .env.production ./.env

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
  CMD node healthcheck.js || exit 1

# Run application
CMD ["node", "src/index.js"]
```

**Deployment script:**
```bash
# deploy-onpremise.sh
#!/bin/bash

# Build Docker image
docker build -t noor-api-onpremise:latest .

# Save image to tar
docker save noor-api-onpremise:latest > noor-api.tar

# Create deployment package
tar -czf noor-api-deployment.tar.gz \
  noor-api.tar \
  docker-compose.yml \
  .env.example \
  setup.sh \
  README-ONPREMISE.md

echo "Deployment package created: noor-api-deployment.tar.gz"
```

---

## Testing Strategy

**API Testing:**

```javascript
// tests/api/qa.test.js
const request = require('supertest');
const app = require('../src/index');

describe('POST /v1/qa/ask', () => {
  const TEST_API_KEY = process.env.TEST_API_KEY;

  it('should return Islamic answer with sources', async () => {
    const response = await request(app)
      .post('/v1/qa/ask')
      .set('Authorization', `Bearer ${TEST_API_KEY}`)
      .send({
        question: 'What breaks wudu?',
        madhab: 'hanafi'
      });

    expect(response.status).toBe(200);
    expect(response.body.data.answer).toContain('wudu');
    expect(response.body.data.sources.length).toBeGreaterThan(0);
    expect(response.body.metadata.model).toBe('noor-qwen-2.5-7b-v1');
  });

  it('should enforce rate limits', async () => {
    // Make 101 requests (exceeding 100/min limit)
    const requests = Array(101).fill().map(() =>
      request(app)
        .post('/v1/qa/ask')
        .set('Authorization', `Bearer ${TEST_API_KEY}`)
        .send({ question: 'test' })
    );

    const responses = await Promise.all(requests);
    const rateLimited = responses.filter(r => r.status === 429);
    expect(rateLimited.length).toBeGreaterThan(0);
  });

  it('should reject invalid API keys', async () => {
    const response = await request(app)
      .post('/v1/qa/ask')
      .set('Authorization', 'Bearer invalid_key')
      .send({ question: 'test' });

    expect(response.status).toBe(401);
    expect(response.body.error.code).toBe('invalid_api_key');
  });

  it('should include correct headers', async () => {
    const response = await request(app)
      .post('/v1/qa/ask')
      .set('Authorization', `Bearer ${TEST_API_KEY}`)
      .send({ question: 'test' });

    expect(response.headers['x-ratelimit-limit']).toBeDefined();
    expect(response.headers['x-ratelimit-remaining']).toBeDefined();
  });
});
```

---

## Deployment Checklist

**Phase 4.1 Launch (Month 13):**
- [ ] API server deployed to Cloud Run
- [ ] API keys system implemented
- [ ] Core 4 endpoints working
- [ ] Rate limiting configured
- [ ] Developer dashboard live
- [ ] API documentation published
- [ ] 10 beta customers onboarded
- [ ] Monitoring alerts set up (Sentry, Datadog)
- [ ] Load testing completed (1000 req/s)
- [ ] Security audit completed

**Phase 4.2 Launch (Month 15):**
- [ ] Python SDK published to PyPI
- [ ] Node.js SDK published to npm
- [ ] Dart SDK published to pub.dev
- [ ] Webhooks implemented
- [ ] Sandbox environment live
- [ ] Video tutorials on YouTube (10+ videos)
- [ ] Interactive API playground
- [ ] Postman collection published
- [ ] 30 customers acquired
- [ ] Developer satisfaction survey (target: 4.5/5)

**Phase 4.3 Launch (Month 18):**
- [ ] White-label solutions live
- [ ] SSO integration complete (SAML, OAuth)
- [ ] On-premise deployment option
- [ ] Advanced analytics dashboard
- [ ] SOC 2 Type II certification (in progress)
- [ ] Enterprise SLA agreements (99.95% uptime)
- [ ] Dedicated support channels (Slack, phone)
- [ ] 100 customers milestone
- [ ] $50K MRR achieved
- [ ] 5 strategic partnerships signed

---

## Monitoring & Observability

**Metrics to Track:**

```javascript
// src/middleware/metrics.middleware.js
const prometheus = require('prom-client');

// API request counter
const apiRequestCounter = new prometheus.Counter({
  name: 'noor_api_requests_total',
  help: 'Total number of API requests',
  labelNames: ['endpoint', 'method', 'status']
});

// API response time histogram
const apiResponseTime = new prometheus.Histogram({
  name: 'noor_api_response_time_seconds',
  help: 'API response time in seconds',
  labelNames: ['endpoint', 'method'],
  buckets: [0.1, 0.5, 1, 2, 5]
});

// LLM inference time
const llmInferenceTime = new prometheus.Histogram({
  name: 'noor_llm_inference_time_seconds',
  help: 'LLM inference time in seconds',
  buckets: [0.5, 1, 2, 5, 10]
});

// Active API keys gauge
const activeApiKeys = new prometheus.Gauge({
  name: 'noor_active_api_keys',
  help: 'Number of active API keys'
});

module.exports = {
  apiRequestCounter,
  apiResponseTime,
  llmInferenceTime,
  activeApiKeys
};
```

**Logging Strategy:**

```javascript
const winston = require('winston');

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  defaultMeta: { service: 'noor-api' },
  transports: [
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' }),
    new winston.transports.Console({
      format: winston.format.simple()
    })
  ]
});

// Log all API requests
app.use((req, res, next) => {
  logger.info({
    method: req.method,
    path: req.path,
    customer_id: req.customer?.id,
    ip: req.ip,
    timestamp: new Date().toISOString()
  });
  next();
});
```

---

📄 **For complete API specification, see:** `docs/NOOR-API-PLATFORM.md`
📄 **For business model details, see:** `docs/MASTER-PRD.md` (Phase 4)
