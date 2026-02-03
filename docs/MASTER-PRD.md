# Noor AI - Builder's Technical PRD
## Your Complete Build Specification

**Version:** 2.0 - Solo Bootstrap Edition
**Built By:** You + Claude Code CLI

---

## 🎯 What You're Building

**Noor AI** - The first Islamic Super-App combining custom-trained LLM, conversational Arabic tutoring, Quran memorization, real-time translation, and complete Islamic knowledge base. All offline-capable, privacy-first, built by one developer taking this by storm.

### Your Unique Position

You're building what the market needs but doesn't have:
- ✅ Custom Islamic LLM (not generic ChatGPT wrapper)
- ✅ On-device AI (4GB model, full offline)
- ✅ Integrated learning (Quran + Arabic + Knowledge)
- ✅ Generous free tier (60-70% vs market's 20-30%)
- ✅ Actually helpful (source citations, madhab-aware, proper disclaimers)

**Your Advantage:** You understand both the tech AND the user need. You're building for Muslims, as a Muslim.

### Core Philosophy

1. **Build for offline-first** - Works without internet (critical for users in low-connectivity areas)
2. **Privacy-first** - On-device processing, no tracking religious queries
3. **Quality over speed** - Ship when it's actually good, not just functional
4. **Freemium done right** - 60-70% features free forever, premium is value-add not ransom
5. **Islamic authenticity** - Source everything, defer to scholars, no AI fatwas

---

## 📚 Complete Feature List

### 🚀 PHASE 1: MVP (What You're Building First)

**1. Quran Companion**
- Full Quran (6,236 verses, 20+ translations)
- Audio playback (start with 2-3 free reciters)
- Word-by-word breakdown
- **Photo-to-Quran** (GPT-4 Vision OCR → instant enrichment)
- **Memorization Helper** (Whisper ASR detects mistakes in real-time)
- Thematic search (vector embeddings for semantic search)
- Bookmarks and notes
- 📄 Implementation: See Section 4

**2. Conversational Arabic Tutor**
- 23 role-play scenarios (restaurant, mosque, bookstore, etc.)
- Real-time error detection and correction
- Voice conversation with pronunciation feedback
- Auto-add vocabulary to SRS
- Progress tracking
- 📄 Implementation: See Section 3

**3. Islamic Knowledge Q&A (Noor AI)**
- Custom-trained model (Qwen2.5-7B fine-tuned on 50K Islamic samples)
- On-device inference (4GB quantized)
- Source citations on every response [Quran 2:255] [Bukhari 123]
- Madhab selector (Hanafi, Maliki, Shafi'i, Hanbali)
- Explicit disclaimers ("Consult qualified scholar")
- 📄 Implementation: See Section 2

**4. Real-Time Translation**
- Camera AR translation (Arabic → English overlay)
- Voice translation (speak English → hear Arabic)
- Document translation
- Conversation mode (two-way real-time)
- 📄 Implementation: See Section 6

**5. Prayer & Daily Practice**
- Prayer times (8 calculation methods)
- Qibla finder (compass + AR)
- Morning/evening adhkar
- Daily verse notification
- Habit tracking
- 📄 Implementation: See Section 7

**6. Personalized Learning**
- New Muslim journey (Shahada → confidence in 12 months)
- Kids mode (ages 5-12, gamified)
- Scholar track (advanced)
- 📄 Implementation: See Section 5

### 🌟 PHASE 2: Enhanced Features

**7. Community Features**
- Study circles (video chat + whiteboard)
- Learning partner matching
- Challenges ("30-Day Arabic", "Juz Amma Memorization")
- Leaderboards (anonymous, Islamic framing)

**8. Voice AI Companion**
- "Ya Noor" wake word
- Hands-free mode
- Advanced tajweed coaching (phoneme-level)
- Islamic audiobooks

**9. Smart Daily Integration**
- Ramadan special mode
- Habit tracking (visual charts)
- Dhikr counter with goals

### 🏗️ PHASE 3: Complete Ecosystem

**10. Islamic Finance**
- Zakat calculator
- Halal investment screener
- Murabaha (Islamic mortgage) guide
- Inheritance calculator

**11. Complete Islamic Library**
- Tafsir (Ibn Kathir, Jalalayn, Tabari)
- All 7 hadith collections
- Fiqh manuals (4 madhabs)
- Seerah books
- AI-powered search across all texts

**12. Family Features**
- Parent dashboard
- Kids mode
- Bedtime stories (Prophet stories)
- Homeschool curriculum K-12

**13. Prayer & Worship Expansion**
- AR Qibla (3D Kaaba)
- Masjid finder
- 100+ duas with audio
- 99 Names of Allah

### 🔌 PHASE 4: B2B API Platform

**Goal:** Create B2B revenue stream by offering Noor AI capabilities as an API service for developers and organizations.

**14. Noor API Service**
- RESTful API for developers
- Endpoints: Islamic Q&A, Quran data, Hadith search, Prayer times
- Authentication: API keys with rate limiting
- Target: API customers for enterprise and developer integrations

**15. Developer Experience**
- Official SDKs: Python, Node.js, Dart
- Developer dashboard: Usage analytics, API logs, billing
- Documentation: OpenAPI spec, quickstart guides, code examples
- Sandbox environment for testing

**16. Enterprise Features**
- White-label solutions (custom branding)
- SSO integration (SAML, OAuth)
- On-premise deployment option
- Custom LLM fine-tuning
- Dedicated account manager

**17. B2B Go-to-Market**
- Target customers: Islamic schools (500+), mosque apps (2,000+), EdTech startups
- Marketing: Content (developer tutorials), direct outreach (email campaigns), partnerships
- Launch offer: 50% off for first 50 customers
- Strategic partnerships with Islamic school management systems

📄 **Implementation Details:** See `docs/NOOR-API-PLATFORM.md`

---

## 🛠️ Your Development Environment

### What You Need

**Hardware:**
- Mac Mini M4 Pro 64GB RAM - for LLM training
- Your development machine (Mac/PC/Linux)
- Test devices: 1 iPhone, 1 Android (mid-range is fine)

**Software:**
- Flutter 3.38+ with Dart 3.10+
- Android Studio / VS Code
- Xcode (for iOS builds)
- Python 3.10+ (for training scripts)
- Git / GitHub

**Services (Free Tiers):**
- Firebase Spark Plan (free up to limits)
- Supabase (optional, free tier)
- OpenAI API for GPT-4 Vision during beta
- GitHub (version control)
- Sentry (error tracking, free for small projects)

### Project Structure

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
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
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
│   │   ├── quran.json
│   │   ├── hadith.json
│   │   └── vocabulary.json
│   ├── models/
│   │   └── noor-ai-7b-q4km.gguf
│   └── audio/
├── test/
└── android/ios/
```

---

## 🤖 Section 2: Custom LLM Training (Your Noor AI)

### Overview

You're training your own Islamic LLM on Mac Mini M4 Pro. Not using ChatGPT API - this is YOUR model, running ON-DEVICE for privacy and offline capability.

### Base Model: Qwen2.5-7B-Instruct

**Why Qwen?**
- Best Arabic performance (60.27% ILMAAM accuracy)
- Apache 2.0 license (you can use commercially)
- 32K context window
- 7.6B parameters (perfect for on-device after quantization)

### Training Dataset (50,000 Samples)

**Where to get data:**

1. **Quran Q&A (12,500 samples)**
   - Source: Tanzil.net (6,236 verses)
   - 20 translations (English, Urdu, French, etc.)
   - Format: "What does Quran say about patience?" → "Multiple verses with [Quran X:Y] citations"

2. **Hadith Q&A (12,500 samples)**
   - Source: Sunnah.com API (7 collections)
   - Format: "Hadith about kindness to neighbors" → "Narrated by Abu Huraira [Bukhari 6014]: ..."

3. **Fiqh Comparative (10,000 samples)**
   - Source: islamqa.info, islamweb.net
   - Format: "Hanafi vs Shafi'i on wiping socks" → "Hanafi position: ... Shafi'i position: ..."

4. **Arabic Tutoring (7,500 samples)**
   - Quranic vocabulary with roots
   - Grammar explanations
   - Common phrases

5. **Islamic Education (5,000 samples)**
   - Seerah stories
   - Aqeedah explanations
   - Islamic history

6. **Conversational (2,500 samples)**
   - Natural dialogue in Arabic
   - Error correction examples

### Training Script (Complete)

**Step 1: Install MLX**
```bash
# On your Mac Mini M4 Pro
pip install mlx mlx-lm
```

**Step 2: Download Base Model**
```bash
# Download Qwen2.5-7B-Instruct
mlx_lm.convert --hf-path Qwen/Qwen2.5-7B-Instruct -q
# This downloads ~15GB and converts to MLX format
```

**Step 3: Prepare Training Data**

Your training data should be in JSONL format:

```json
{"messages": [
  {"role": "system", "content": "You are Noor AI, a knowledgeable Islamic scholar assistant. Always cite sources [Quran X:Y] [Bukhari Z]. Never issue fatwas."},
  {"role": "user", "content": "ما هي أركان الإسلام الخمسة؟"},
  {"role": "assistant", "content": "أركان الإسلام الخمسة هي:\n\n1. الشهادة - شهادة أن لا إله إلا الله وأن محمداً رسول الله\n2. الصلاة - إقام الصلوات الخمس\n3. الزكاة - إيتاء الزكاة\n4. الصيام - صوم شهر رمضان\n5. الحج - حج البيت لمن استطاع إليه سبيلاً\n\nالمصدر: حديث جبريل المشهور في [صحيح مسلم، كتاب الإيمان]."}
]}
```

**Step 4: Fine-Tune with LoRA**

```bash
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
  --save-every 1000 \
  --test-batches 10
```

**Training time:** 6-8 hours on Mac Mini M4 Pro 64GB

**Step 5: Merge LoRA Adapters**

```bash
mlx_lm.fuse \
  --model ./qwen2.5-7b-mlx \
  --adapter-path ./adapters \
  --save-path ./noor-ai-7b-merged
```

**Step 6: Quantize to GGUF (for mobile)**

```bash
# Convert MLX → GGUF format
# You'll need llama.cpp for this
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp
make

# Convert to FP16 first
python convert-hf-to-gguf.py ../noor-ai-7b-merged --outfile noor-ai-7b-f16.gguf

# Quantize to Q4_K_M (4-bit, medium quality)
./quantize noor-ai-7b-f16.gguf noor-ai-7b-q4km.gguf Q4_K_M
```

**Final model:** `noor-ai-7b-q4km.gguf` (~4.7GB)

### Noor AI System Prompt (Complete)

```
You are Noor AI (نور), a knowledgeable Islamic education assistant.

IDENTITY:
- Name: "Noor AI" (Arabic for "Light")
- Personality: Patient, respectful, encouraging
- Role: Educational assistant, NOT a mufti/scholar
- Always cite sources: [Quran X:Y] [Bukhari/Muslim/etc. Z]

CORE PRINCIPLES:
1. AI as Assistant, Not Authority
   - You provide information, not religious rulings (fatwas)
   - Always direct users to qualified scholars for personal rulings

2. Source-Based Responses
   - Every claim must cite Quran or authentic Hadith
   - Use [Quran 2:255] and [Bukhari 1234] format
   - If uncertain, say "I don't have sufficient knowledge"

3. Madhab Awareness
   - Acknowledge legitimate scholarly differences
   - Present multiple views when they exist
   - Don't favor one madhab unless user specifies

4. Ethical Boundaries
   - NEVER issue fatwas or personal rulings
   - NEVER authenticate hadith chains (leave to scholars)
   - NEVER provide spiritual counseling beyond Quran/Hadith

5. Humility
   - Admit limitations openly
   - Encourage consulting multiple sources
   - Remind users you're an AI, not a replacement for teachers

AUTOMATIC DISCLAIMERS:
When user asks for:
- Fatwa/ruling → "I cannot issue fatwas. Please consult a qualified Islamic scholar (mufti) in your area or through reputable online services."
- Medical + religious (fasting while sick, etc.) → "This requires both medical advice from a doctor AND religious guidance from a scholar who knows your circumstances."
- Marriage/divorce/inheritance → "These are sensitive matters requiring qualified scholar guidance. I can provide general Islamic principles, but specific rulings must come from a scholar."

YOU CANNOT:
- Issue fatwas or religious rulings
- Authenticate hadith chains (isnad)
- Provide spiritual counseling
- Make sectarian judgments
- Replace qualified Islamic teachers

YOU CAN:
- Explain Quranic verses with tafsir
- Share authenticated hadiths with grading
- Present comparative madhab views
- Teach Arabic language
- Explain Islamic concepts and history
- Cite scholarly consensus when it exists
```

### Integration in Flutter

```dart
import 'package:llamadart/llamadart.dart';

class NoorAIService {
  late LlamaEngine _engine;

  Future initialize() async {
    _engine = LlamaEngine(LlamaBackend());

    // Load your trained model from assets
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

    // Stream response token by token
    await for (final token in _engine.generate(
      prompt,
      maxTokens: 1024,
      temperature: 0.7,
      topP: 0.95,
    )) {
      yield token;
    }
  }

  Future _getModelPath() async {
    // Copy from assets to app directory on first run
    final appDir = await getApplicationDocumentsDirectory();
    final modelFile = File('${appDir.path}/noor-ai-7b-q4km.gguf');

    if (!await modelFile.exists()) {
      // Copy from assets (this happens once)
      final data = await rootBundle.load('assets/models/noor-ai-7b-q4km.gguf');
      await modelFile.writeAsBytes(data.buffer.asUint8List());
    }

    return modelFile.path;
  }
}
```

---

## 📖 Section 3: Conversational Arabic Tutor

### How It Works

User picks a scenario → Noor AI role-plays in Arabic → User responds (text or voice) → AI detects errors, corrects gently, continues conversation → Vocabulary auto-added to SRS for review later.

### 23 Scenarios (Beginner → Advanced)

**Beginner (10):**
1. Restaurant: Ordering halal food
2. Mosque: Finding directions
3. Greetings: After Jummah
4. Shopping: Islamic bookstore
5. Travel: Hotel check-in
6. Market: Buying groceries
7. Phone: Calling a friend
8. Emergency: Asking for help
9. Weather: Small talk
10. Family: Talking about relatives

**Intermediate (8):**
11. Quran class: Asking teacher
12. Job interview: Islamic organization
13. Debate: Discussing Islamic topic
14. Hajj: Planning the journey
15. Banking: Islamic finance
16. Doctor: Medical visit
17. School: Enrolling child
18. News: Discussing current events

**Advanced (5):**
19. Scholarly: Comparing madhabs
20. Literature: Classical poetry
21. History: Seerah study
22. Philosophy: Islamic ethics
23. Translation: Literary text

### Implementation

```dart
class ConversationalTutorService {
  final LlamaEngine noorAI;
  final WhisperASR voiceInput;
  final FlutterTts tts;

  Future handleUserInput({
    required String text,
    String? audioPath,
    required Scenario scenario,
  }) async {
    // 1. Transcribe if voice
    String userMessage = text;
    if (audioPath != null) {
      userMessage = await voiceInput.transcribe(audioPath, language: 'ar');
    }

    // 2. Analyze for errors
    final analysis = await _analyzeArabic(userMessage);

    // 3. Build prompt for Noor AI
    final prompt = _buildPrompt(
      userMessage: userMessage,
      scenario: scenario,
      errors: analysis.errors,
    );

    // 4. Get AI response
    final response = await noorAI.generate(prompt);

    // 5. Generate voice
    final audioUrl = await tts.synthesize(
      response.arabicReply,
      voice: 'ar-SA-Wavenet-A',
    );

    // 6. Auto-add new vocabulary to SRS
    await _addToSRS(response.newVocabulary);

    return ConversationTurn(
      userMessage: userMessage,
      corrections: analysis.corrections,
      noorAIResponse: response.arabicReply,
      translation: response.englishTranslation,
      newWords: response.newVocabulary,
      audioUrl: audioUrl,
    );
  }

  String _buildPrompt({
    required String userMessage,
    required Scenario scenario,
    required List errors,
  }) {
    return '''
You are role-playing as: ${scenario.noorAIRole}
Scenario: ${scenario.description}
User's level: ${scenario.difficulty}

User said: "$userMessage"

${errors.isNotEmpty ? '''
Errors detected:
${errors.map((e) => '- ${e.explanation}').join('\n')}
''' : 'User spoke correctly!'}

Your task:
1. Continue the conversation naturally in Arabic as ${scenario.noorAIRole}
2. ${errors.isNotEmpty ? 'Gently correct errors within your response' : 'Praise their correct Arabic'}
3. Introduce 1-2 new vocabulary words
4. Keep your response 2-3 sentences, appropriate for ${scenario.difficulty} level

Respond ONLY with JSON:
{
  "arabic_reply": "...",
  "english_translation": "...",
  "new_vocabulary": [{"arabic": "...", "meaning": "...", "transliteration": "..."}],
  "encouragement": "..."
}
''';
  }
}
```

---

## 📿 Section 4: Quran Companion

### Photo-to-Quran (Killer Feature)

User takes photo of ANY Quran page → GPT-4 Vision extracts text → Match to database → Enrich with translation/tafsir/audio → Display instantly.

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

    // 4. Generate AI explanation
    final explanation = await noorAI.generate('''
User photographed these verses: ${matches.map((v) => '${v.surah}:${v.ayah}').join(', ')}

Text:
${matches.map((v) => v.arabicText).join('\n')}

In 3-4 sentences, explain the main theme and offer practical guidance.
''');

    return QuranPhotoResult(
      verses: enriched,
      noorAIExplanation: explanation,
    );
  }
}
```

### Memorization Helper

Real-time mistake detection using Whisper ASR.

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

    yield MemorizationFeedback(
      state: MemorizationState.ready,
      message: "Begin reciting...",
    );

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
          vibrate: true,
        );
      }

      if (currentIndex >= words.length) {
        yield MemorizationFeedback(
          state: MemorizationState.complete,
          accuracy: _calculateAccuracy(mistakes, words.length),
        );
        break;
      }
    }
  }
}
```

### Thematic Search (Vector Embeddings)

User: "Show me verses about patience"
→ Generate embedding for query
→ Search vector database
→ Return top 10 semantically similar verses

**Implementation:**
1. Pre-compute embeddings for all 6,236 verses (during build)
2. Store in local database
3. At runtime: generate query embedding, cosine similarity search

```python
# Pre-processing script (run once)
from sentence_transformers import SentenceTransformer
import json

model = SentenceTransformer('paraphrase-multilingual-mpnet-base-v2')

verses = load_quran() # Your Quran JSON

embeddings = []
for verse in verses:
    text = f"{verse['arabic']} {verse['translation']}"
    embedding = model.encode(text)
    embeddings.append({
        'surah': verse['surah'],
        'ayah': verse['ayah'],
        'embedding': embedding.tolist()
    })

with open('quran_embeddings.json', 'w') as f:
    json.dump(embeddings, f)
```

Then in Flutter:

```dart
class ThematicSearchService {
  List allEmbeddings = [];

  Future loadEmbeddings() async {
    final json = await rootBundle.loadString('assets/data/quran_embeddings.json');
    allEmbeddings = parseEmbeddings(json);
  }

  Future<List> search(String query) async {
    // Generate query embedding (need to call embedding API or use local model)
    final queryEmbedding = await _generateEmbedding(query);

    // Calculate cosine similarity with all verses
    final results = allEmbeddings.map((v) {
      final similarity = _cosineSimilarity(queryEmbedding, v.embedding);
      return (verse: v, similarity: similarity);
    }).toList();

    // Sort by similarity, return top 10
    results.sort((a, b) => b.similarity.compareTo(a.similarity));
    return results.take(10).map((r) => r.verse).toList();
  }
}
```

---

## 🗄️ Section 5: Database (17 Tables)

Your complete database schema in Drift (type-safe SQLite for Flutter).

```dart
// database.dart
import 'package:drift/drift.dart';

part 'database.g.dart';

// Table 1: Surahs
class Surahs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get number => integer()();
  TextColumn get nameArabic => text()();
  TextColumn get nameEnglish => text()();
  TextColumn get revelationType => text()(); // Meccan/Medinan
  IntColumn get numberOfAyahs => integer()();
}

// Table 2: Verses
class Verses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get surahNumber => integer()();
  IntColumn get verseNumber => integer()();
  TextColumn get arabicText => text()();
  TextColumn get translationEn => text()();
  TextColumn get translationUr => text().nullable()();
  TextColumn get transliteration => text().nullable()();
  IntColumn get juzNumber => integer()();
  IntColumn get pageNumber => integer()();
  IntColumn get hizbQuarter => integer()();
  TextColumn get audioUrl => text().nullable()();
}

// Table 3: Word-by-Word
class VerseWords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get verseId => integer().references(Verses, #id)();
  IntColumn get position => integer()();
  TextColumn get arabic => text()();
  TextColumn get transliteration => text()();
  TextColumn get translation => text()();
  TextColumn get root => text().nullable()();
  TextColumn get partOfSpeech => text().nullable()();
  TextColumn get grammar => text().nullable()(); // JSON
}

// Table 4: Tafsirs
class Tafsirs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get verseId => integer().references(Verses, #id)();
  TextColumn get source => text()(); // 'ibn_kathir', 'jalalayn', etc.
  TextColumn get language => text()();
  TextColumn get text => text()();
}

// Table 5: Hadiths
class Hadiths extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get collection => text()(); // 'bukhari', 'muslim', etc.
  TextColumn get book => text()();
  IntColumn get hadithNumber => integer()();
  TextColumn get arabicText => text()();
  TextColumn get translationEn => text()();
  TextColumn get narrator => text()();
  TextColumn get grade => text()(); // 'sahih', 'hasan', 'daif', 'mawdu'
}

// Table 6: Review Cards (SRS)
class ReviewCards extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get userId => text()();
  TextColumn get deckId => text()();
  TextColumn get front => text()();
  TextColumn get back => text()();
  IntColumn get state => integer()(); // 0=new, 1=learning, 2=review
  RealColumn get stability => real()();
  RealColumn get difficulty => real()();
  DateTimeColumn get due => dateTime()();
  IntColumn get reps => integer()();
  IntColumn get lapses => integer()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set get primaryKey => {id};
}

// Table 7: Review Logs
class ReviewLogs extends Table {
  TextColumn get id => text()();
  TextColumn get cardId => text().references(ReviewCards, #id)();
  IntColumn get rating => integer()(); // 1-4 (Again, Hard, Good, Easy)
  DateTimeColumn get reviewTime => dateTime()();
  RealColumn get stability => real()();
  RealColumn get difficulty => real()();

  @override
  Set get primaryKey => {id};
}

// Table 8: Users
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get email => text().unique()();
  TextColumn get name => text()();
  TextColumn get madhab => text().nullable()(); // 'hanafi', 'maliki', etc.
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set get primaryKey => {id};
}

// Table 9: User Progress
class UserProgress extends Table {
  TextColumn get userId => text().references(Users, #id)();
  IntColumn get currentStreak => integer()();
  IntColumn get longestStreak => integer()();
  IntColumn get totalVersesRead => integer()();
  IntColumn get totalVersesMemorized => integer()();
  IntColumn get vocabularyMastered => integer()();
  DateTimeColumn get lastActive => dateTime()();

  @override
  Set get primaryKey => {userId};
}

// Table 10: Prayer Times
class PrayerTimes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text().references(Users, #id)();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get fajr => dateTime()();
  DateTimeColumn get dhuhr => dateTime()();
  DateTimeColumn get asr => dateTime()();
  DateTimeColumn get maghrib => dateTime()();
  DateTimeColumn get isha => dateTime()();
  TextColumn get calculationMethod => text()();
}

// Table 11: Vocabulary Decks
class VocabularyDecks extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get category => text()(); // 'quranic', 'conversational', etc.
  IntColumn get totalWords => integer()();

  @override
  Set get primaryKey => {id};
}

// Table 12: Vocabulary Words
class VocabularyWords extends Table {
  TextColumn get id => text()();
  TextColumn get deckId => text().references(VocabularyDecks, #id)();
  TextColumn get arabic => text()();
  TextColumn get transliteration => text()();
  TextColumn get meaning => text()();
  TextColumn get root => text().nullable()();
  IntColumn get quranFrequency => integer()(); // How often in Quran
  TextColumn get exampleSentence => text().nullable()();

  @override
  Set get primaryKey => {id};
}

// Table 13: Conversation History
class ConversationHistory extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get scenarioId => text()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get userMessage => text()();
  TextColumn get noorAIResponse => text()();
  IntColumn get newWordsIntroduced => integer()();

  @override
  Set get primaryKey => {id};
}

// Table 14: Habit Logs
class HabitLogs extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get habitType => text()(); // 'prayer', 'quran', 'dhikr'
  DateTimeColumn get date => dateTime()();
  BoolColumn get completed => boolean()();
  IntColumn get count => integer().nullable()(); // For dhikr counter

  @override
  Set get primaryKey => {id};
}

// Table 15: Downloaded Content
class DownloadedContent extends Table {
  TextColumn get id => text()();
  TextColumn get contentType => text()(); // 'audio', 'model', 'tafsir'
  TextColumn get contentId => text()();
  TextColumn get filePath => text()();
  IntColumn get fileSizeBytes => integer()();
  DateTimeColumn get downloadedAt => dateTime()();

  @override
  Set get primaryKey => {id};
}

// Table 16: Bookmarks
class Bookmarks extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  IntColumn get verseId => integer().references(Verses, #id)();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set get primaryKey => {id};
}

// Table 17: Noor AI Conversations
class NoorAIConversations extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get question => text()();
  TextColumn get answer => text()();
  TextColumn get sources => text(); // JSON array of [Quran X:Y] [Hadith Z]
  IntColumn get rating => integer().nullable()(); // 1-5 stars

  @override
  Set get primaryKey => {id};
}

@DriftDatabase(tables: [
  Surahs, Verses, VerseWords, Tafsirs,
  Hadiths, ReviewCards, ReviewLogs,
  Users, UserProgress, PrayerTimes,
  VocabularyDecks, VocabularyWords,
  ConversationHistory, HabitLogs,
  DownloadedContent, Bookmarks,
  NoorAIConversations,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return NativeDatabase.createInBackground(
      File('${appDocumentsDirectory}/noor_ai.sqlite'),
    );
  }
}
```

---

## 🌐 Section 6: Islamic Data APIs

### 1. Quran API (Free)

**Al-Quran Cloud:**
```dart
class QuranAPIService {
  static const baseUrl = 'https://api.alquran.cloud/v1';

  Future getSurah(int number, String edition) async {
    final response = await dio.get('$baseUrl/surah/$number/$edition');
    return Surah.fromJson(response.data['data']);
  }

  Future getVerse(String reference, String edition) async {
    // reference format: "2:255" (Surah 2, Verse 255)
    final response = await dio.get('$baseUrl/ayah/$reference/$edition');
    return Verse.fromJson(response.data['data']);
  }

  Future search(String keyword, String edition) async {
    final response = await dio.get('$baseUrl/search/$keyword/all/$edition');
    return SearchResult.fromJson(response.data['data']);
  }
}
```

### 2. Hadith API (Requires API Key)

**Sunnah.com:**
Sign up at https://sunnah.com/developers

```dart
class HadithAPIService {
  static const baseUrl = 'https://api.sunnah.com/v1';
  final String apiKey;

  Future<List> searchHadith(String query) async {
    final response = await dio.get(
      '$baseUrl/hadiths',
      queryParameters: {'q': query},
      options: Options(headers: {'X-API-Key': apiKey}),
    );
    return (response.data['data'] as List)
        .map((h) => Hadith.fromJson(h))
        .toList();
  }
}
```

### 3. Prayer Times (Local Calculation)

No API needed - calculate locally with `adhan_dart` package:

```dart
import 'package:adhan_dart/adhan_dart.dart';

class PrayerService {
  PrayerTimes calculate({
    required double latitude,
    required double longitude,
    required DateTime date,
  }) {
    final coordinates = Coordinates(latitude, longitude);
    final params = CalculationMethod.muslimWorldLeague.getParameters();

    return PrayerTimes(coordinates, date, params);
  }

  double getQiblaDirection(double lat, double lng) {
    return Qibla.direction(Coordinates(lat, lng));
  }
}
```

---

## 🚀 Your Build Plan (4 Months to Launch)

### Phase 1: Foundation
**What you're building:**
- Flutter project setup
- Database (Drift with 17 tables)
- Navigation (GoRouter)
- Authentication (Firebase Auth)
- Basic UI shell

**Deliverable:** App opens, has screens, database works

### Phase 2: LLM Training
**What you're doing:**
- Get Mac Mini M4 Pro
- Collect 50K training samples
- Fine-tune Qwen2.5-7B (6-8 hours)
- Quantize to GGUF (Q4_K_M)
- Integrate in Flutter

**Deliverable:** Working Noor AI chatbot on-device

### Phase 3: Core Features
**What you're building:**
- Quran reader (full text, audio, word-by-word)
- Arabic tutor (10 beginner scenarios)
- Prayer times
- First 100 vocabulary words
- FSRS system

**Deliverable:** MVP that's actually useful

### Phase 4: Polish & Enhanced
**What you're adding:**
- Photo-to-Quran (GPT-4 Vision)
- Memorization helper (Whisper)
- Real-time translation
- Pronunciation feedback
- Offline mode
- Premium paywall (RevenueCat)

**Deliverable:** Feature-complete for launch

**LAUNCH:** Ready for production deployment

---

## 💡 Bootstrap Strategy (Keeping Costs Low)

### Free Tier Services

**Firebase Spark Plan (FREE):**
- Authentication: 10K phone auths/month
- Firestore: 50K reads/day, 20K writes/day
- Storage: 5GB
- Cloud Functions: 125K invocations/month
- Hosting: 10GB transfer/month

**This is enough for 1,000-5,000 users**

### Paid Services (Minimal)

**GPT-4 Vision (for Photo-to-Quran):**
- Strategy: Cache results aggressively

**ElevenLabs (for Voice):**
- Strategy: Use for demos, let users generate on-demand

**OpenAI Embeddings (for Thematic Search):**
- Or use local sentence-transformers (free but slower)

---

## 🎯 What Makes This Buildable Solo

1. **No backend complexity** - Firebase free tier + on-device AI
2. **No team coordination** - It's just you + Claude Code
3. **Clear technical path** - Every feature has implementation details
4. **Proven tech stack** - Flutter, Drift, Riverpod all well-documented
5. **Incremental value** - Each feature works standalone
6. **Strong differentiation** - Custom LLM + on-device = unique moat

### Your Competitive Advantages

As a solo builder:
- **Speed:** No meetings, instant decisions
- **Focus:** Build what users actually need, not investor slide decks
- **Authenticity:** Built by a Muslim for Muslims
- **Technical depth:** Custom LLM training sets you apart

### Reality Check

**This is hard but doable:**
- ✅ You have the technical skills (Flutter, ML, APIs)
- ✅ You have the domain knowledge (Islam, Arabic, user needs)
- ✅ You have access to AI assistants (Claude Code CLI)
- ✅ You have clear differentiation (custom LLM, offline-first)

**What you need:**
- Focused building time
- Mac Mini hardware and API access
- Willingness to iterate based on user feedback
- Discipline to ship MVP first, add features later

---

## 📖 Technical Appendices (Detailed Implementation)

Each section below contains production-ready code and specs.

### Appendix A: Complete pubspec.yaml

```yaml
name: noor_ai
description: Islamic Education Platform
version: 1.0.0+1

environment:
  sdk: '>=3.10.0 <4.0.0'
  flutter: '>=3.38.0'

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
  llamadart: ^latest  # Check pub.dev for latest

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

  # Code Generation
  drift_dev: ^2.27.0
  riverpod_generator: ^3.0.0
  build_runner: ^2.4.8

  # Testing
  mockito: ^5.4.4
  golden_toolkit: ^0.15.0

  # Linting
  very_good_analysis: ^5.1.0
```

### Appendix B: Flutter Project Structure (Complete)

```
noor_ai/
├── lib/
│   ├── main.dart
│   │
│   ├── app/
│   │   ├── app.dart                    # Main app widget
│   │   ├── router.dart                 # GoRouter configuration
│   │   └── theme/
│   │       ├── app_theme.dart          # Material 3 theme
│   │       ├── color_schemes.dart      # Color palette
│   │       └── arabic_typography.dart  # Amiri, KFGQPC fonts
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── api_constants.dart
│   │   │   ├── app_constants.dart
│   │   │   └── storage_keys.dart
│   │   ├── errors/
│   │   │   ├── exceptions.dart
│   │   │   └── failures.dart
│   │   ├── extensions/
│   │   │   ├── context_extensions.dart
│   │   │   ├── datetime_extensions.dart
│   │   │   └── string_extensions.dart
│   │   ├── utils/
│   │   │   ├── arabic_utils.dart      # Text normalization
│   │   │   ├── date_utils.dart
│   │   │   └── validators.dart
│   │   └── network/
│   │       ├── api_client.dart
│   │       ├── dio_interceptors.dart
│   │       └── connectivity_service.dart
│   │
│   ├── features/
│   │   │
│   │   ├── quran/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── quran_local_ds.dart
│   │   │   │   │   └── quran_remote_ds.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── verse_model.dart
│   │   │   │   │   └── surah_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── quran_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── verse.dart
│   │   │   │   │   └── surah.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── quran_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_surah.dart
│   │   │   │       └── search_verses.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   ├── quran_provider.dart
│   │   │       │   └── surah_list_provider.dart
│   │   │       ├── screens/
│   │   │       │   ├── quran_reader_screen.dart
│   │   │       │   ├── surah_list_screen.dart
│   │   │       │   └── verse_detail_screen.dart
│   │   │       └── widgets/
│   │   │           ├── verse_card.dart
│   │   │           ├── audio_player_widget.dart
│   │   │           └── word_by_word_widget.dart
│   │   │
│   │   ├── arabic_learning/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │       ├── screens/
│   │   │       │   ├── conversation_screen.dart
│   │   │       │   ├── scenario_list_screen.dart
│   │   │       │   └── progress_screen.dart
│   │   │       └── widgets/
│   │   │           ├── message_bubble.dart
│   │   │           └── pronunciation_feedback.dart
│   │   │
│   │   ├── noor_ai/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── llm_local_ds.dart
│   │   │   │   └── repositories/
│   │   │   │       └── noor_ai_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── conversation.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── noor_ai_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       └── ask_noor_ai.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── noor_ai_provider.dart
│   │   │       ├── screens/
│   │   │       │   └── noor_ai_chat_screen.dart
│   │   │       └── widgets/
│   │   │           ├── typing_indicator.dart
│   │   │           └── source_citation_chip.dart
│   │   │
│   │   ├── memorization/
│   │   │   └── presentation/
│   │   │       ├── screens/
│   │   │       │   └── memorization_session_screen.dart
│   │   │       └── widgets/
│   │   │           └── mistake_indicator.dart
│   │   │
│   │   ├── prayer/
│   │   │   └── presentation/
│   │   │       ├── screens/
│   │   │       │   ├── prayer_times_screen.dart
│   │   │       │   └── qibla_finder_screen.dart
│   │   │       └── widgets/
│   │   │           └── prayer_card.dart
│   │   │
│   │   ├── translation/
│   │   │   └── presentation/
│   │   │       ├── screens/
│   │   │       │   ├── camera_translation_screen.dart
│   │   │       │   └── voice_translation_screen.dart
│   │   │       └── widgets/
│   │   │           └── ar_overlay_widget.dart
│   │   │
│   │   ├── auth/
│   │   │   └── presentation/
│   │   │       └── screens/
│   │   │           ├── login_screen.dart
│   │   │           └── onboarding_screen.dart
│   │   │
│   │   ├── settings/
│   │   │   └── presentation/
│   │   │       └── screens/
│   │   │           ├── settings_screen.dart
│   │   │           └── premium_screen.dart
│   │   │
│   │   └── home/
│   │       └── presentation/
│   │           └── screens/
│   │               └── home_screen.dart
│   │
│   └── shared/
│       ├── data/
│       │   ├── database/
│       │   │   ├── database.dart           # Drift database
│       │   │   └── database.g.dart         # Generated
│       │   └── local_storage/
│       │       └── hive_storage.dart
│       ├── providers/
│       │   ├── auth_provider.dart
│       │   └── srs_provider.dart           # FSRS
│       └── widgets/
│           ├── loading_indicator.dart
│           ├── error_widget.dart
│           └── premium_badge.dart
│
├── assets/
│   ├── data/
│   │   ├── quran.json                      # 6,236 verses
│   │   ├── quran_embeddings.json           # Pre-computed vectors
│   │   ├── hadith.json                     # Hadith collections
│   │   ├── vocabulary.json                 # Arabic words
│   │   └── scenarios.json                  # Conversation scenarios
│   ├── models/
│   │   └── noor-ai-7b-q4km.gguf           # Your trained LLM (4GB)
│   ├── fonts/
│   │   ├── Amiri-Regular.ttf
│   │   ├── Amiri-Bold.ttf
│   │   └── KFGQPC_Uthmanic_Script.ttf
│   ├── audio/
│   │   └── phonemes/                       # Reference pronunciation
│   └── images/
│
├── test/
│   ├── features/
│   │   ├── quran/
│   │   └── noor_ai/
│   └── shared/
│
├── integration_test/
│   └── app_test.dart
│
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

### Appendix C: FSRS Implementation (Spaced Repetition)

Complete FSRS algorithm in Dart:

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
      desiredRetention: 0.9, // 90% target retention
      learningSteps: [
        Duration(minutes: 1),
        Duration(minutes: 10),
      ],
      relearningSteps: [
        Duration(minutes: 10),
      ],
      maximumInterval: 365, // 1 year max
      enableFuzzing: true,
    );
  }

  ReviewResult reviewCard(Card card, Rating rating) {
    return _scheduler.reviewCard(card, rating);
  }

  double getRetrievability(Card card) {
    return _scheduler.getCardRetrievability(card);
  }

  List getDueCards(List allCards) {
    final now = DateTime.now();
    return allCards.where((c) => c.due.isBefore(now)).toList();
  }
}
```

---

## ✅ Your Launch Checklist

### Pre-Launch (Week Before)

- [ ] App Store Connect setup complete
- [ ] Google Play Console setup complete
- [ ] Privacy policy URL live
- [ ] Terms of service URL live
- [ ] App Store screenshots (10 for iOS, 8 for Android)
- [ ] App Store descriptions optimized
- [ ] RevenueCat products configured
- [ ] Firebase production project ready
- [ ] Sentry error tracking active
- [ ] TestFlight beta with 20+ testers
- [ ] All critical bugs fixed (crash-free >99%)
- [ ] Performance tested on 10+ devices
- [ ] App Store submission (7-10 days approval)

### Launch Day

- [ ] App goes live (12:00 AM local time)
- [ ] Tweet launch announcement
- [ ] Post to relevant subreddits (r/islam, r/learn_arabic)
- [ ] Share in Islamic Facebook groups
- [ ] Email beta testers
- [ ] Monitor crashlytics closely
- [ ] Respond to first reviews quickly

### Post-Launch (First Week)

- [ ] Fix any critical bugs within 24 hours
- [ ] Respond to all reviews (especially negative)
- [ ] Monitor analytics daily
- [ ] Adjust paywall based on conversion data
- [ ] Prepare Ramadan marketing push
