<div align="center">

# Noor AI

### Islamic Education Platform with On-Device Artificial Intelligence

**A comprehensive mobile application combining authentic Islamic knowledge with cutting-edge AI technology**

[![Flutter](https://img.shields.io/badge/Flutter-3.38%2B-02569B?style=flat-square&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.10%2B-0175C2?style=flat-square&logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=flat-square)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](CONTRIBUTING.md)

[Features](#features) • [Architecture](#architecture) • [Documentation](#documentation) • [Installation](#installation) • [Contributing](#contributing)

---

</div>

## Overview

Noor AI is an Islamic education platform that leverages artificial intelligence to provide accessible, authentic Islamic knowledge. Built with privacy-first architecture and offline-capable infrastructure, the platform serves Muslims worldwide through mobile applications and developer APIs.

### Mission Statement

To empower Muslims globally with accessible, authentic Islamic education through innovative technology while respecting user privacy and honoring traditional Islamic scholarship.

### Key Differentiators

- **Custom Language Model**: Fine-tuned Qwen2.5-7B trained on 50,000 Islamic Q&A pairs
- **On-Device Processing**: Privacy-first architecture with local AI inference
- **Scholarly Authentication**: All content vetted and sourced from authentic Islamic texts
- **Offline Capability**: Full functionality without internet connectivity
- **Multi-School Support**: Respects different madhabs (schools of Islamic jurisprudence)

---

## Features

### Core Platform Capabilities

<table>
<tr>
<td width="50%">

#### Quranic Study Suite

**Comprehensive Quranic Learning Tools**

- Complete Quranic text (6,236 verses)
- 20+ verified translations
- Word-by-word morphological analysis
- Root word etymology and grammar
- Audio recitations from authenticated reciters
- Photo recognition technology for physical Quran pages
- Real-time memorization assistance with speech recognition
- Thematic search using semantic embeddings
- Personal bookmarking and annotation system

</td>
<td width="50%">

#### Artificial Intelligence Assistant

**Context-Aware Islamic Knowledge System**

- Custom-trained language model (50,000 Q&A samples)
- Source citation for every response
- Madhab-aware jurisprudential analysis
- Multi-language support (Arabic, English, Urdu)
- Ethical AI framework with scholarly oversight
- Privacy-preserving on-device inference
- Offline functionality
- Explicit limitations and scholarly disclaimers

</td>
</tr>
<tr>
<td width="50%">

#### Arabic Language Learning

**Structured Language Acquisition Program**

- 23 contextual conversation scenarios
- Real-time pronunciation feedback
- Grammar and syntax correction
- FSRS-based spaced repetition system
- Quranic vocabulary integration
- Progress tracking and analytics
- Voice-enabled conversational practice
- Adaptive difficulty scaling

</td>
<td width="50%">

#### Islamic Practice Tools

**Daily Worship Assistance**

- Prayer time calculations (8 calculation methods)
- Qibla direction finder with compass and AR
- Morning and evening adhkar (remembrances)
- Islamic calendar with Hijri dates
- Habit tracking for spiritual routines
- Intelligent notification system
- Ramadan-specific features
- Customizable reminder preferences

</td>
</tr>
<tr>
<td width="50%">

#### Hadith Reference Library

**Authenticated Prophetic Traditions**

- Seven major hadith collections
- Advanced search functionality
- Grading classifications (Sahih, Hasan, Daif)
- Chain of narration (Isnad) verification
- Multi-language translations
- Personal collection management
- Cross-referencing capabilities
- Scholar commentary integration

</td>
<td width="50%">

#### Adaptive Learning System

**Personalized Educational Pathways**

- FSRS (Free Spaced Repetition Scheduler) algorithm
- Comprehensive progress analytics
- Multiple learning tracks (New Muslim, Scholar, Children)
- Achievement milestone system
- Streak tracking for consistency
- Study circle coordination
- Daily Quranic verse delivery
- Performance visualization

</td>
</tr>
</table>

### B2B API Platform (Phase 4)

Enterprise-grade API infrastructure enabling developers to integrate Islamic AI capabilities into third-party applications.

**Target Market Segments**

- Islamic Educational Institutions (500+ schools in USA)
- Mosque Management Systems (2,000+ mosques nationally)
- Islamic EdTech Startups
- Muslim Lifestyle Applications
- Islamic Finance Platforms

**Pricing Structure**

| Tier | Monthly Cost | API Calls | Target Segment |
|------|--------------|-----------|----------------|
| Developer | $99 | 10,000 | Individual developers, testing |
| Startup | $499 | 100,000 | Growing applications |
| Business | $1,999 | 500,000 | Established organizations |
| Enterprise | Custom | Unlimited | White-label solutions |

**API Capabilities**: Islamic Q&A • Quranic Data Access • Hadith Search • Prayer Time Calculations • Arabic Learning Modules

**Documentation**: [Full API Specification](docs/NOOR-API-PLATFORM.md)

---

## Architecture

### Technology Stack

<table>
<tr>
<td width="33%" align="center">

**Frontend Framework**

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart&logoColor=white)

State Management: Riverpod<br>
Navigation: GoRouter<br>
UI Framework: Material Design 3

</td>
<td width="33%" align="center">

**Data Infrastructure**

![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat-square&logo=firebase&logoColor=black)
![SQLite](https://img.shields.io/badge/SQLite-07405E?style=flat-square&logo=sqlite&logoColor=white)

Database: Drift (Type-safe SQLite)<br>
Local Storage: Hive<br>
Authentication: Firebase Auth

</td>
<td width="33%" align="center">

**AI & Machine Learning**

![Python](https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white)

LLM: Qwen2.5-7B (Custom Fine-tuned)<br>
Training: MLX Framework<br>
Inference: llama.cpp<br>
ASR: OpenAI Whisper

</td>
</tr>
</table>

### System Requirements

**Mobile Platforms**
- iOS 14.0 or higher
- Android API Level 21 (Android 5.0) or higher

**Development Environment**
- Flutter SDK 3.38.0+
- Dart SDK 3.10.0+
- Xcode 14+ (for iOS development)
- Android Studio (for Android development)

### Database Schema

The application employs a comprehensive 17-table relational database structure:

**Core Tables**: Surahs, Verses, VerseWords, Tafsirs<br>
**Hadith System**: Hadiths, HadithCollections, HadithGrades<br>
**Learning System**: ReviewCards, ReviewLogs, VocabularyDecks, VocabularyWords<br>
**User Management**: Users, UserProgress, ConversationHistory<br>
**Utilities**: PrayerTimes, HabitLogs, DownloadedContent, Bookmarks

Complete schema documentation: `lib/shared/data/database/database.dart`

---

## Installation

### Prerequisites

Ensure the following software is installed:

```
Flutter SDK 3.38.0+
Dart SDK 3.10.0+
Git version control
```

### Setup Instructions

**1. Clone Repository**

```bash
git clone https://github.com/byteworthy/Noor-AI.git
cd Noor-AI
```

**2. Install Dependencies**

```bash
flutter pub get
```

**3. Generate Code**

```bash
dart run build_runner build --delete-conflicting-outputs
```

**4. Firebase Configuration**

- Create project at [Firebase Console](https://console.firebase.google.com)
- Download configuration files:
  - Android: `google-services.json` → `android/app/`
  - iOS: `GoogleService-Info.plist` → `ios/Runner/`
- Enable required services: Authentication, Firestore, Analytics

**5. Environment Configuration**

Create `.env` file in project root:

```env
OPENAI_API_KEY=your_api_key
SUNNAH_API_KEY=your_api_key
```

**6. Run Application**

```bash
flutter run
```

For detailed setup instructions: [Development Guide](docs/DEVELOPMENT.md)

---

## Project Roadmap

### Phase 1: Minimum Viable Product

**Core Deliverables**
- Quranic companion with photo recognition
- On-device AI assistant (custom LLM)
- Conversational Arabic tutor
- Prayer times and Qibla finder
- Spaced repetition learning system

### Phase 2: Enhanced Features

**Target**: 10,000 active users

**Deliverables**
- Community study circles
- Voice AI companion
- Advanced tajweed coaching
- Ramadan-specific features
- Learning partner matching system

### Phase 3: Complete Ecosystem

**Target**: 100,000 active users

**Deliverables**
- Islamic finance tools
- Complete Islamic library (Tafsir, Fiqh, Seerah)
- Family and children's features
- Augmented reality Qibla finder
- Homeschool curriculum integration

### Phase 4: B2B API Platform

**Target**: 100 API customers, $50,000 MRR

**Deliverables**
- RESTful API infrastructure
- Official SDKs (Python, Node.js, Dart)
- Developer dashboard and documentation
- White-label solutions
- Enterprise SSO integration

Comprehensive roadmap: [Master PRD](docs/MASTER-PRD.md)

---

## Documentation

### Technical Documentation

| Document | Description |
|----------|-------------|
| [Master PRD](docs/MASTER-PRD.md) | Complete product requirements specification |
| [Development Guide](docs/DEVELOPMENT.md) | Implementation roadmap and technical details |
| [API Platform](docs/NOOR-API-PLATFORM.md) | B2B API documentation and specifications |
| [LLM Training](docs/LLM-TRAINING-WORKBOOK.md) | Model training procedures and guidelines |

### Operational Documentation

| Document | Description |
|----------|-------------|
| [Marketing Strategy](docs/MARKETING-GTM-STRATEGY.md) | Go-to-market and growth strategies |
| [Testing Manual](docs/TESTING-QA-MANUAL.md) | Quality assurance procedures |
| [Analytics Guide](docs/ANALYTICS-METRICS.md) | Metrics tracking and KPI definitions |
| [Launch Kit](docs/APP-STORE-LAUNCH-KIT.md) | App store optimization guidelines |

### Content Guidelines

| Document | Description |
|----------|-------------|
| [Islamic Guidelines](docs/ISLAMIC-CONTENT-GUIDELINES.md) | Content authenticity standards |
| [Support Playbook](docs/CUSTOMER-SUPPORT-PLAYBOOK.md) | Customer support procedures |

---

## Contributing

We welcome contributions from the developer community. Please review our contribution guidelines before submitting pull requests.

### Contribution Process

1. Review [Contributing Guidelines](CONTRIBUTING.md)
2. Read [Code of Conduct](CODE_OF_CONDUCT.md)
3. Check [Islamic Content Guidelines](docs/ISLAMIC-CONTENT-GUIDELINES.md)
4. Browse [Open Issues](https://github.com/byteworthy/Noor-AI/issues)

### Areas for Contribution

- Bug reports and fixes
- Feature suggestions and implementations
- Documentation improvements
- Translation support
- Code optimization
- Test coverage expansion

---

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) file for complete terms.

### Proprietary Components

The following components are not covered by the MIT License and remain proprietary:

- Custom Language Model (fine-tuned Qwen2.5-7B)
- Training datasets and scripts
- B2B API Platform infrastructure

For commercial API access: [api.noorai.app](https://api.noorai.app)

---

## Acknowledgments

### Data Sources

- Quranic text: [Al-Quran Cloud API](https://alquran.cloud/api) and [Tanzil.net](http://tanzil.net)
- Hadith collections: [Sunnah.com](https://sunnah.com)
- Prayer calculations: [adhan-dart](https://pub.dev/packages/adhan_dart) package

### Technology

- Base LLM: [Qwen2.5-7B-Instruct](https://huggingface.co/Qwen/Qwen2.5-7B-Instruct)
- Typography: Amiri font, KFGQPC Uthmanic Script

---

## Support

### Contact Information

- **Issues**: [GitHub Issue Tracker](https://github.com/byteworthy/Noor-AI/issues)
- **Discussions**: [GitHub Discussions](https://github.com/byteworthy/Noor-AI/discussions)
- **Security**: security@noorai.app
- **General Inquiries**: hello@noorai.app

---

<div align="center">

**Version 1.0.0** • **Platform: iOS & Android**

**Privacy-First • Offline-Capable • Open Source**

Copyright © 2026 ByteWorthy. Licensed under MIT License.

---

*This application is designed for educational purposes. For religious rulings (fatwas), please consult qualified Islamic scholars.*

</div>
