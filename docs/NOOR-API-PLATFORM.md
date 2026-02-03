# Noor AI - B2B API Platform
## Developer Documentation for Noor API

**Purpose:** Enable developers to integrate Islamic AI into their applications
**Target:** API customers for enterprise and developer integrations

---

## Table of Contents

1. [Platform Overview](#1-platform-overview)
2. [API Architecture](#2-api-architecture)
3. [Authentication & API Keys](#3-authentication--api-keys)
4. [API Endpoints Reference](#4-api-endpoints-reference)
5. [Rate Limiting & Quotas](#5-rate-limiting--quotas)
6. [SDKs & Integration Examples](#6-sdks--integration-examples)
7. [Developer Dashboard](#7-developer-dashboard)
8. [Security & Compliance](#8-security--compliance)

---

## 1. Platform Overview

### What is Noor API?

Noor API provides programmatic access to:
- **Islamic Q&A AI** - Custom Qwen2.5-7B trained on 50K Islamic Q&A pairs
- **Quran Data** - 6,236 verses with 20+ translations
- **Hadith Database** - 38,000+ authenticated hadiths
- **Arabic Learning** - Vocabulary, pronunciation, conversation endpoints
- **Prayer Times** - Global prayer time calculations

### Target Customers

**Primary (70% of focus):**
1. **Islamic Schools** (500+ in USA)
   - Need: Curriculum management, student progress tracking
   - Use case: Integrate AI tutor into school portal

2. **Mosque Apps** (2,000+ mosques in USA)
   - Need: Prayer times, Quran, Q&A for community
   - Use case: Custom mosque app with Noor backend

3. **Islamic EdTech Startups** (Growing market)
   - Need: AI capabilities without building LLM
   - Use case: White-label Islamic learning platforms

**Secondary (30% of focus):**
4. **Islamic Finance Apps**
5. **Muslim Travel/Lifestyle Apps**
6. **Islamic NGOs**

### Value Proposition

**vs. Building Your Own:**
- No LLM training infrastructure required
- No scholar oversight burden
- No infrastructure management
- Production-ready in hours

**vs. ChatGPT/Claude:**
- Islamic-specific training (50K Q&A pairs)
- Madhab-aware responses
- Cited sources [Quran X:Y] [Bukhari Z]
- Scholar-reviewed accuracy

---

## 2. API Architecture

### Infrastructure Stack

**API Server:**
- Platform: Google Cloud Run (auto-scaling)
- Language: Node.js (Express) or Python (FastAPI)
- Load Balancer: Cloud Load Balancing
- CDN: Cloudflare (API caching)

**LLM Inference:**
- Model: Qwen2.5-7B (same as consumer app)
- Hosting: Google Cloud TPU/GPU
- Scaling: Auto-scale based on request queue
- Fallback: OpenAI GPT-4o-mini (if overloaded)

**Database:**
- Primary: Firestore (same as consumer app)
- Read replicas for API traffic
- Vector DB: Qdrant (RAG search)

**Authentication:**
- Method: API keys (Bearer token)
- Storage: Firebase Auth + custom claims
- Rotation: 90-day forced rotation
- Scopes: Read-only, read-write permissions

### API Response Format

```json
{
  "data": {
    "answer": "Wudu is invalidated by...",
    "sources": [
      {"type": "quran", "reference": "5:6"},
      {"type": "hadith", "collection": "bukhari", "number": "135"}
    ],
    "madhab": "hanafi",
    "confidence": 0.95
  },
  "metadata": {
    "request_id": "req_abc123",
    "model": "noor-qwen-2.5-7b-v1",
    "processing_time_ms": 1200,
    "tokens_used": 450
  },
  "status": "success"
}
```

---

## 3. Authentication & API Keys

### Getting API Keys

**Steps:**
1. Sign up at https://api.noorai.app/signup
2. Verify email
3. Create organization
4. Generate API key from dashboard
5. Copy key (shown once)

### Using API Keys

**Header Authentication:**
```bash
curl https://api.noorai.app/v1/qa/ask \
  -H "Authorization: Bearer noor_sk_abc123..." \
  -H "Content-Type: application/json" \
  -d '{"question": "What breaks wudu?"}'
```

### Key Management

**Security Best Practices:**
- Never commit keys to git
- Use environment variables
- Rotate keys every 90 days
- Use separate keys for dev/prod
- Revoke compromised keys immediately

**Key Permissions:**
- `qa:read` - Ask AI questions
- `quran:read` - Access Quran data
- `hadith:read` - Access Hadith database
- `arabic:write` - Submit user progress
- `admin:*` - Full access (enterprise only)

---

## 4. API Endpoints Reference

### Base URL

```
Production: https://api.noorai.app/v1
Sandbox: https://sandbox-api.noorai.app/v1
```

### Endpoints

#### 1. Islamic Q&A

**POST /qa/ask**

Ask the Islamic AI a question.

**Request:**
```json
{
  "question": "What are the conditions for valid wudu?",
  "madhab": "hanafi",
  "language": "en",
  "include_sources": true
}
```

**Response:**
```json
{
  "data": {
    "answer": "Wudu has 4 fard (obligatory) actions according to the Hanafi madhab...",
    "sources": [
      {"type": "quran", "reference": "5:6", "text": "O you who believe..."},
      {"type": "hadith", "collection": "bukhari", "number": "135"}
    ],
    "madhab_notes": {
      "hanafi": "4 fard actions",
      "shafi": "6 fard actions (includes intention and order)"
    }
  },
  "metadata": {
    "confidence": 0.95,
    "processing_time_ms": 1200
  }
}
```

**Rate Limit:** 100 requests/minute

---

#### 2. Quran Access

**GET /quran/verse/:surah/:ayah**

Get a specific Quran verse.

**Request:**
```bash
GET /quran/verse/2/255
  ?translation=en.sahih
  &audio=mishary
```

**Response:**
```json
{
  "data": {
    "surah": 2,
    "ayah": 255,
    "text_arabic": "اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ...",
    "text_transliteration": "Allahu la ilaha illa huwa...",
    "translation": {
      "en.sahih": "Allah - there is no deity except Him..."
    },
    "audio_url": "https://cdn.noorai.app/audio/mishary/002255.mp3",
    "word_by_word": [...]
  }
}
```

---

#### 3. Hadith Search

**GET /hadith/search**

Search hadith database.

**Request:**
```bash
GET /hadith/search
  ?query=prayer
  &collection=bukhari
  &limit=10
```

**Response:**
```json
{
  "data": {
    "results": [
      {
        "collection": "bukhari",
        "book": 8,
        "hadith_number": 331,
        "text_arabic": "...",
        "text_english": "The Prophet said: 'Prayer is the pillar of Islam...'",
        "narrator": "Abdullah ibn Umar",
        "grade": "sahih"
      }
    ],
    "total": 47,
    "page": 1
  }
}
```

---

#### 4. Prayer Times

**GET /prayer-times**

Calculate prayer times for location.

**Request:**
```bash
GET /prayer-times
  ?lat=40.7128
  &lng=-74.0060
  &date=2026-02-15
  &method=isna
```

**Response:**
```json
{
  "data": {
    "date": "YYYY-MM-DD",
    "location": {"city": "New York", "country": "USA"},
    "times": {
      "fajr": "05:42",
      "sunrise": "07:08",
      "dhuhr": "12:18",
      "asr": "15:12",
      "maghrib": "17:28",
      "isha": "18:54"
    },
    "qibla_direction": 58.5
  }
}
```

---

## 5. Rate Limiting & Quotas

### Rate Limits by Tier

| Tier | Requests/Minute | Requests/Month | Burst Limit |
|------|-----------------|----------------|-------------|
| Developer | 10 | 10,000 | 50 |
| Startup | 100 | 100,000 | 500 |
| Business | 500 | 500,000 | 2,500 |
| Enterprise | Custom | Unlimited | Custom |

### Rate Limit Headers

```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 87
X-RateLimit-Reset: 1609459200
```

### Exceeding Rate Limits

**Response (429 Too Many Requests):**
```json
{
  "error": {
    "code": "rate_limit_exceeded",
    "message": "You have exceeded 100 requests/minute.",
    "retry_after": 45
  }
}
```

**Solutions:**
- Cache responses locally
- Implement exponential backoff
- Upgrade tier
- Contact support for higher limits

---

## 6. SDKs & Integration Examples

### Official SDKs

**Python:**
```python
from noor_api import NoorClient

client = NoorClient(api_key="noor_sk_abc123...")

# Ask AI question
response = client.qa.ask(
    question="What breaks wudu?",
    madhab="hanafi"
)
print(response.data.answer)
print(response.data.sources)
```

**Node.js:**
```javascript
const { NoorClient } = require('@noorai/sdk');

const client = new NoorClient({
  apiKey: process.env.NOOR_API_KEY
});

// Get Quran verse
const verse = await client.quran.getVerse(2, 255, {
  translation: 'en.sahih'
});
console.log(verse.data.translation);
```

**Dart/Flutter:**
```dart
import 'package:noor_api/noor_api.dart';

final client = NoorClient(apiKey: 'noor_sk_abc123...');

// Search hadith
final results = await client.hadith.search(
  query: 'prayer',
  collection: 'bukhari',
);
print(results.data.results);
```

### Community SDKs

- Ruby: `noor-ruby` (community-maintained)
- PHP: `noor-php` (community-maintained)
- Go: `noor-go` (community-maintained)

---

## 7. Developer Dashboard

### Dashboard Features

**URL:** https://dashboard.noorai.app

**Key Sections:**

1. **Overview**
   - API usage graphs (daily, weekly, monthly)
   - Quota consumption (X% of 100K calls used)
   - Response time metrics
   - Error rate trends

2. **API Keys**
   - Generate new keys
   - Revoke keys
   - View key permissions
   - Usage per key

3. **Logs**
   - Real-time request logs
   - Filter by endpoint, status code, date
   - Export logs (CSV, JSON)

4. **Documentation**
   - API reference (interactive)
   - Quickstart guides
   - Code examples
   - Postman collection

5. **Support**
   - Submit ticket
   - Community forum
   - Slack integration (Business+)

---

## 8. Security & Compliance

### Security Measures

**API Security:**
- HTTPS/TLS 1.3 only
- API key encryption at rest
- Rate limiting (DDoS protection)
- IP whitelisting (Enterprise)
- Request signing (optional)

**Data Privacy:**
- GDPR compliant
- CCPA compliant
- No user data stored beyond 30 days
- Data residency options (EU, US)
- End-to-end encryption for sensitive data

**Compliance:**
- SOC 2 Type II certification
- ISO 27001 certification
- Regular security audits
- Penetration testing

### Content Moderation

**AI Responses:**
- Scholar-reviewed training data
- Automated content filtering
- Human review queue for flagged responses
- Customer can report incorrect answers
- 24-hour SLA for corrections

---

**Noor API Platform - Technical Documentation Complete**
