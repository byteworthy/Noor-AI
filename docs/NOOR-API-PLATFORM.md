# Noor AI - B2B API Platform
## Developer Documentation for Noor API

**Purpose:** Enable developers to integrate Islamic AI into their applications
**Timeline:** Phase 4 - Months 13-18 (Post-Consumer App Launch)
**Target:** 100 API customers by Month 18

---

## Table of Contents

1. [Platform Overview](#1-platform-overview)
2. [Business Model & Pricing](#2-business-model--pricing)
3. [API Architecture](#3-api-architecture)
4. [Authentication & API Keys](#4-authentication--api-keys)
5. [API Endpoints Reference](#5-api-endpoints-reference)
6. [Rate Limiting & Quotas](#6-rate-limiting--quotas)
7. [SDKs & Integration Examples](#7-sdks--integration-examples)
8. [Developer Dashboard](#8-developer-dashboard)
9. [Security & Compliance](#9-security--compliance)
10. [Implementation Phases](#10-implementation-phases)
11. [Go-to-Market Strategy](#11-go-to-market-strategy)
12. [Success Metrics](#12-success-metrics)

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
- No $500K+ LLM training cost
- No scholar oversight burden
- No infrastructure management
- Production-ready in hours, not months

**vs. ChatGPT/Claude:**
- Islamic-specific training (50K Q&A pairs)
- Madhab-aware responses
- Cited sources [Quran X:Y] [Bukhari Z]
- Scholar-reviewed accuracy

---

## 2. Business Model & Pricing

### Pricing Tiers

| Tier | Price | API Calls/Month | Use Case |
|------|-------|-----------------|----------|
| **Developer** | $99/month | 10,000 | Testing, small projects |
| **Startup** | $499/month | 100,000 | Growing apps |
| **Business** | $1,999/month | 500,000 | Islamic schools, mosques |
| **Enterprise** | Custom | Unlimited | White-label solutions |

### Revenue Model

**Assumptions (Conservative):**
- Month 13: 10 customers (avg $500/mo) = $5K MRR
- Month 15: 30 customers = $15K MRR
- Month 18: 100 customers = $50K MRR

**Unit Economics:**
- Average Revenue Per Customer: $500/month
- Cost to Serve (GCP inference): $50/month
- Gross Margin: 90%
- CAC: $500 (content marketing + sales)
- Payback Period: 1 month

### What's Included

**All Tiers:**
- RESTful API access
- OpenAPI documentation
- Developer dashboard
- Email support
- 99.9% uptime SLA

**Business+ Tiers:**
- SDK support (Python, Node.js, Dart)
- Dedicated Slack channel
- Custom rate limits
- Monthly usage reports

**Enterprise Only:**
- White-label options
- Custom LLM fine-tuning
- On-premise deployment
- SSO integration (SAML)
- Dedicated account manager

---

## 3. API Architecture

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

## 4. Authentication & API Keys

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

## 5. API Endpoints Reference

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
    "date": "2026-02-15",
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

## 6. Rate Limiting & Quotas

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

## 7. SDKs & Integration Examples

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

## 8. Developer Dashboard

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

4. **Billing**
   - Current plan: Startup ($499/month)
   - Next billing date
   - Usage overage warnings
   - Upgrade/downgrade plan

5. **Documentation**
   - API reference (interactive)
   - Quickstart guides
   - Code examples
   - Postman collection

6. **Support**
   - Submit ticket
   - Community forum
   - Slack integration (Business+)

---

## 9. Security & Compliance

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
- SOC 2 Type II certified (target: Year 2)
- ISO 27001 certified (target: Year 3)
- Regular security audits
- Penetration testing (annual)

### Content Moderation

**AI Responses:**
- Scholar-reviewed training data
- Automated content filtering
- Human review queue for flagged responses
- Customer can report incorrect answers
- 24-hour SLA for corrections

---

## 10. Implementation Phases

### Phase 4.1: Core API Infrastructure (Months 13-14)

**Goal:** Launch MVP API for 10 beta customers

**Deliverables:**
- RESTful API (Node.js/Express on Cloud Run)
- Authentication system (API keys)
- Core endpoints:
  - POST /qa/ask
  - GET /quran/verse/:surah/:ayah
  - GET /hadith/search
  - GET /prayer-times
- Developer dashboard (basic)
- Documentation (API reference)

**Tech Stack:**
- Backend: Node.js (Express) on Google Cloud Run
- Database: Firestore (shared with consumer app)
- LLM: Same Qwen2.5-7B model (Cloud TPU)
- Auth: Firebase Auth + custom API key system
- Docs: Swagger/OpenAPI

**Success Criteria:**
- 10 beta customers signed up
- <2s average API response time
- 99.9% uptime
- $5K MRR

---

### Phase 4.2: Developer Experience (Months 15-16)

**Goal:** Scale to 30 customers with excellent DX

**Deliverables:**
- Official SDKs (Python, Node.js, Dart)
- Enhanced dashboard (usage graphs, logs)
- Webhooks (event notifications)
- Sandbox environment
- Postman collection
- Video tutorials

**New Features:**
- Batch request endpoint (process multiple questions)
- Streaming responses (SSE)
- Custom model fine-tuning (Enterprise)
- Advanced caching

**Success Criteria:**
- 30 customers
- SDK adoption: 70%+
- Developer satisfaction: 4.5/5 stars
- $15K MRR

---

### Phase 4.3: Enterprise & Scale (Months 17-18)

**Goal:** 100 customers, enterprise-ready

**Deliverables:**
- White-label solutions
- SSO integration (SAML, OAuth)
- On-premise deployment option
- Advanced analytics dashboard
- SLA guarantees (99.95%+)
- Dedicated support (Business+)

**Partnerships:**
- Islamic school management systems
- Mosque management software
- Islamic EdTech platforms

**Success Criteria:**
- 100 customers (10 enterprise)
- $50K MRR
- 5 strategic partnerships
- SOC 2 Type II certified

---

## 11. Go-to-Market Strategy

### Target Customer Acquisition

**Channel Strategy:**

**1. Content Marketing (40% of effort)**
- Blog: "How to Build Islamic Apps with AI"
- Case studies: Islamic school using Noor API
- Developer tutorials on YouTube
- SEO: "Islamic API", "Quran API", "Hadith API"

**2. Direct Outreach (30%)**
- Email campaign to 500 Islamic schools
- Partner with Islamic school associations
- Attend Islamic education conferences
- Cold outreach to mosque app developers

**3. Developer Community (20%)**
- Launch on ProductHunt (dev edition)
- Post on HackerNews: "We built an Islamic AI API"
- Reddit: r/islam, r/programming
- GitHub: Open-source example apps

**4. Strategic Partnerships (10%)**
- Islamic school management systems (e.g., MyMasjid)
- Muslim app networks
- Islamic finance platforms

### Pricing Strategy

**Launch Offer:**
- First 50 customers: 50% off for 6 months
- Free Developer tier for open-source projects
- Free migration support (from other APIs)

**Upsell Path:**
```
Free Tier (10 calls/day)
    ↓ Upgrade prompt after 7 days
Developer ($99/mo)
    ↓ Upgrade prompt at 80% quota
Startup ($499/mo)
    ↓ Sales outreach at 80% quota
Business/Enterprise
```

---

## 12. Success Metrics

### North Star Metric

**Active API Keys** (monthly)
= Number of API keys with ≥100 requests/month

### Key Metrics

| Metric | Month 13 | Month 15 | Month 18 | Long-term |
|--------|----------|----------|----------|-----------|
| **Total Customers** | 10 | 30 | 100 | 1,000 |
| **MRR** | $5K | $15K | $50K | $500K |
| **API Calls/Month** | 100K | 500K | 2M | 50M |
| **Response Time** | <2s | <1.5s | <1s | <500ms |
| **Uptime** | 99.9% | 99.9% | 99.95% | 99.99% |
| **Churn Rate** | N/A | <5% | <3% | <2% |
| **NPS** | 40 | 50 | 60 | 70+ |

### Business Metrics

**Unit Economics:**
- ARPU (Average Revenue Per User): $500/month
- LTV (Lifetime Value): $18,000 (3 years retention)
- CAC (Customer Acquisition Cost): $500
- LTV:CAC Ratio: 36:1 (Excellent)
- Gross Margin: 90%
- Payback Period: 1 month

---

## Summary: API Platform Readiness Checklist

**Phase 4.1 (Months 13-14):**
- [ ] API infrastructure built (Cloud Run)
- [ ] Authentication system (API keys)
- [ ] Core 4 endpoints live
- [ ] Developer dashboard (basic)
- [ ] API documentation published
- [ ] 10 beta customers onboarded

**Phase 4.2 (Months 15-16):**
- [ ] SDKs released (Python, Node.js, Dart)
- [ ] Webhooks implemented
- [ ] Sandbox environment live
- [ ] Video tutorials published
- [ ] 30 customers acquired

**Phase 4.3 (Months 17-18):**
- [ ] White-label solutions available
- [ ] SSO integration complete
- [ ] Enterprise SLA agreements
- [ ] 100 customers milestone
- [ ] $50K MRR achieved

---

**Noor API Platform documentation complete - ready to build B2B revenue stream!**
