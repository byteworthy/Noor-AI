# Noor AI - DevOps & Monitoring Guide
## Infrastructure, Deployment & Monitoring Strategy

**Purpose:** Ensure reliable, scalable, secure infrastructure
**Timeline:** Set up 2 weeks before launch
**Target:** 99.9% uptime, <2s API response time

---

## Table of Contents

1. [Infrastructure Architecture](#architecture)
2. [CI/CD Pipeline](#cicd)
3. [Monitoring & Alerting](#monitoring)
4. [Backup & Disaster Recovery](#backup)
5. [Security & Compliance](#security)
6. [Scaling Strategy](#scaling)
7. [Cost Optimization](#cost)
8. [Incident Response](#incident)

---

## 1. Infrastructure Architecture {#architecture}

### Tech Stack Overview

**Frontend (Mobile App):**
- Flutter (iOS + Android)
- State: Riverpod
- Local DB: SQLite (Hive for KV)
- Deployment: App Store + Google Play

**Backend:**
- Firebase (primary)
  - Firestore (database)
  - Firebase Auth (authentication)
  - Cloud Functions (serverless)
  - Cloud Storage (file storage)
  - Firebase Analytics
  - Crashlytics

**AI/ML:**
- On-device: Qwen2.5-7B (GGUF quantized)
- Cloud fallback: OpenAI GPT-4o-mini
- Hosting: Model bundled in app (4GB)

**External APIs:**
- Quran: Quran.com API
- Hadith: Sunnah.com API
- Prayer times: Aladhan API
- Translation: Google Cloud Translation
- STT/TTS: Google Cloud Speech/TTS

**Domain & DNS:**
- Domain: noorai.app (Namecheap)
- DNS: Cloudflare (free tier)
- SSL: Cloudflare SSL

---

### Architecture Diagram

```
┌──────────────────────────────────────────┐
│         Mobile App (Flutter)             │
│  ┌────────┐  ┌────────┐  ┌────────┐     │
│  │ Quran  │  │ Arabic │  │ AI Q&A │     │
│  └────────┘  └────────┘  └────────┘     │
│                                          │
│  Local Storage: SQLite + Hive            │
│  On-Device AI: Qwen2.5-7B (4GB)          │
└──────────────┬───────────────────────────┘
               │
               ↓ HTTPS
┌──────────────────────────────────────────┐
│         Firebase (Backend)               │
│  ┌────────────────────────────────────┐  │
│  │  Firestore (User data, progress)   │  │
│  │  Auth (Email, Google, Apple)       │  │
│  │  Cloud Functions (API gateway)     │  │
│  │  Storage (Quran audio, images)     │  │
│  │  Analytics (Events, metrics)       │  │
│  │  Crashlytics (Error tracking)      │  │
│  └────────────────────────────────────┘  │
└──────────────┬───────────────────────────┘
               │
               ↓ API Calls
┌──────────────────────────────────────────┐
│       External APIs                      │
│  ┌────────┐ ┌────────┐  ┌────────┐      │
│  │ Quran  │ │Hadith  │  │Google  │      │
│  │  API   │ │  API   │  │Cloud   │      │
│  └────────┘ └────────┘  └────────┘      │
└──────────────────────────────────────────┘
```

---

## 2. CI/CD Pipeline {#cicd}

### GitHub Actions Workflow

**File:** `.github/workflows/main.yml`

```yaml
name: Noor AI CI/CD

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  # Job 1: Test
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'

      - name: Install dependencies
        run: flutter pub get

      - name: Run tests
        run: flutter test

      - name: Check code coverage
        run: |
          flutter test --coverage
          lcov --summary coverage/lcov.info

      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v3
        with:
          files: coverage/lcov.info

  # Job 2: Lint & Format
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2

      - name: Run Flutter analyze
        run: flutter analyze

      - name: Check formatting
        run: flutter format --set-exit-if-changed .

  # Job 3: Build iOS
  build-ios:
    needs: [test, lint]
    runs-on: macos-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2

      - name: Install dependencies
        run: flutter pub get

      - name: Build iOS
        run: |
          flutter build ios --release --no-codesign

      - name: Upload to TestFlight (if tagged)
        if: startsWith(github.ref, 'refs/tags/v')
        run: |
          # Upload to App Store Connect
          # Requires: Apple certificates & provisioning profiles

  # Job 4: Build Android
  build-android:
    needs: [test, lint]
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2

      - name: Setup Java
        uses: actions/setup-java@v3
        with:
          distribution: 'zulu'
          java-version: '17'

      - name: Build Android APK
        run: flutter build apk --release

      - name: Build Android App Bundle
        run: flutter build appbundle --release

      - name: Sign AAB
        run: |
          # Sign with release keystore
          jarsigner -verbose -sigalg SHA256withRSA \
            -digestalg SHA-256 \
            -keystore ${{ secrets.ANDROID_KEYSTORE }} \
            build/app/outputs/bundle/release/app-release.aab \
            upload

      - name: Upload to Google Play (if tagged)
        if: startsWith(github.ref, 'refs/tags/v')
        uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.GOOGLE_PLAY_SERVICE_ACCOUNT }}
          packageName: com.noorai.app
          releaseFiles: build/app/outputs/bundle/release/app-release.aab
          track: production
          status: completed
```

---

### Deployment Strategy

**Environment Branches:**

```
main (production)
  ↑
develop (staging)
  ↑
feature/* (development)
```

**Release Process:**

1. **Development** (feature/* branches)
   - Developers work on features
   - CI runs tests on every commit
   - PR to `develop` requires:
     - All tests passing
     - Code coverage ≥70%
     - 1+ code review approval

2. **Staging** (`develop` branch)
   - Merge approved PRs
   - CI builds staging app
   - Deploy to internal testers (TestFlight/Internal Testing)
   - QA testing (2-3 days)

3. **Production** (`main` branch)
   - Create release tag (e.g., `v1.0.0`)
   - Merge `develop` → `main`
   - CI builds production app
   - Deploy to App Store & Google Play
   - Monitor for 24 hours

**Rollback Plan:**
- If critical bug found in production
- Revert to previous version immediately
- Fix bug in `develop`
- Hotfix release (e.g., `v1.0.1`)

---

## 3. Monitoring & Alerting {#monitoring}

### Monitoring Stack

**1. Firebase Crashlytics (Crash Reporting)**
- Tracks app crashes
- Captures stack traces
- Groups similar crashes
- Free tier: Unlimited

**2. Firebase Analytics (User Behavior)**
- Custom events
- User properties
- Conversion funnels
- Free tier: Unlimited

**3. Firebase Performance Monitoring**
- App startup time
- Network request latency
- Screen rendering time
- Free tier: Unlimited

**4. Sentry (Error Tracking)**
- Non-fatal errors
- Performance monitoring
- Release health
- Cost: $26/month (5K errors)

**5. UptimeRobot (API Monitoring)**
- Monitor API endpoints
- HTTP checks every 5 minutes
- Email/SMS alerts
- Cost: Free (50 monitors)

**6. Google Cloud Monitoring (Firebase)**
- Firebase usage metrics
- Firestore read/write ops
- Cloud Functions execution
- Included with Firebase

---

### Critical Metrics to Monitor

| Metric | Tool | Alert Threshold | Action |
|--------|------|----------------|--------|
| **Crash-free rate** | Crashlytics | <99% | P0 - Fix immediately |
| **API response time** | Sentry | >2s avg | P1 - Investigate |
| **Firestore errors** | Firebase Console | >1% error rate | P1 - Check quota |
| **App startup time** | Performance | >3s | P2 - Optimize |
| **Daily Active Users** | Analytics | -20% drop | P1 - Investigate |
| **Payment failures** | RevenueCat | >5% failure | P0 - Fix ASAP |
| **AI response time** | Sentry | >5s | P2 - Fallback to cloud |

---

### Alert Configuration

**Crashlytics Alerts (Email + Slack):**
```
Alert: Crash rate >1%
- Trigger: >10 crashes in 1 hour
- Recipients: engineering@noorai.app
- Slack: #engineering-alerts
- Priority: P0
```

**Firebase Performance Alerts:**
```
Alert: API response time >2s
- Trigger: Avg response >2s for 10 minutes
- Recipients: devops@noorai.app
- Slack: #performance-alerts
- Priority: P1
```

**UptimeRobot Alerts:**
```
Monitor: https://api.noorai.app/health
- Check interval: 5 minutes
- Alert after: 2 failed checks
- Recipients: SMS to [phone]
- Priority: P0
```

---

### Monitoring Dashboard

**Firebase Console Dashboard:**
- Crashlytics: Crash-free users (target: 99%+)
- Analytics: DAU, MAU, retention
- Performance: App startup, network latency
- Firestore: Read/write operations

**Sentry Dashboard:**
- Error trends (daily, weekly)
- Release health (by version)
- Performance regression detection

**RevenueCat Dashboard:**
- MRR (Monthly Recurring Revenue)
- Churn rate
- Trial-to-paid conversion
- LTV by cohort

---

## 4. Backup & Disaster Recovery {#backup}

### Backup Strategy

**1. Firestore Backups (Automated Daily)**

```bash
# Enable Firestore daily backups
gcloud firestore databases backup schedules create \
  --database='(default)' \
  --recurrence=daily \
  --retention=7d
```

**Location:** gs://noor-ai-backups/firestore/
**Retention:** 7 days (rolling)
**Cost:** ~$5/month

**2. User Data Export (On-Demand)**

Users can export their data via Settings:
- Progress data (JSON)
- Bookmarks (CSV)
- Conversation history (JSON)

**3. Code Repository (GitHub)**

- Main repo: github.com/noorai/noorai-app
- Branches: `main`, `develop`, `feature/*`
- Protected branches: Cannot force push to `main`
- Automated backups: GitHub handles this

**4. Environment Variables (Encrypted)**

Store in:
- GitHub Secrets (for CI/CD)
- Local `.env` file (gitignored)
- Firebase Environment Config

Never commit:
- API keys
- Service account credentials
- Encryption keys

---

### Disaster Recovery Plan

**Scenario 1: Firebase Outage**

**Impact:** Backend completely down, users can't sync

**Recovery:**
1. Check Firebase Status: https://status.firebase.google.com
2. Enable "Offline Mode" banner in app (if planned)
3. Communicate to users via social media
4. Estimate: Firebase SLA is 99.95% (4.5 hours/month max)

**Mitigation:**
- App works offline (SQLite local storage)
- Sync resumes when Firebase is back

---

**Scenario 2: Accidental Data Deletion**

**Impact:** User data deleted from Firestore

**Recovery:**
1. Restore from daily backup (within 24 hours)
2. If <24 hours ago, use Firestore point-in-time recovery
3. Command:
```bash
gcloud firestore databases restore \
  --source-backup=BACKUP_ID \
  --destination-database='(default)'
```

**Prevention:**
- Soft delete (mark as deleted, don't actually delete)
- Require double confirmation for delete actions
- Admin actions logged

---

**Scenario 3: Compromised API Keys**

**Impact:** Unauthorized API usage, potential billing spike

**Recovery:**
1. Immediately revoke compromised keys
2. Generate new keys
3. Update in Firebase Environment Config
4. Deploy new app version if needed
5. Monitor usage for 48 hours

**Prevention:**
- Use Firebase App Check
- Rotate keys every 90 days
- Set billing alerts

---

**Scenario 4: App Store Rejection After Launch**

**Impact:** Can't push critical updates

**Recovery:**
1. If P0 bug:
   - Submit urgent appeal to Apple
   - Provide detailed explanation
   - Escalate via Apple Developer support
2. If P1 bug:
   - Fix issue, resubmit within 24 hours
   - Communicate delay to users

**Prevention:**
- Thorough pre-submission testing
- Follow App Store guidelines strictly
- Have legal review religious content

---

## 5. Security & Compliance {#security}

### Security Checklist

**Authentication:**
- [x] Firebase Auth (secure by default)
- [x] Email verification required
- [x] Password requirements: 8+ chars, mix of letters/numbers
- [x] OAuth (Google, Apple Sign-In)
- [x] Session management (auto-logout after 30 days)

**Data Encryption:**
- [x] At rest: Firestore encrypted by default
- [x] In transit: HTTPS/TLS 1.2+
- [x] Local storage: SQLite with encryption (optional)

**API Security:**
- [x] Firebase App Check (prevents API abuse)
- [x] Rate limiting via Cloud Functions
- [x] API keys in environment variables (not hardcoded)

**GDPR / CCPA Compliance:**
- [x] Privacy policy published
- [x] Terms of service published
- [x] Cookie consent (web landing page)
- [x] Data export feature (Settings → Export Data)
- [x] Account deletion feature
- [x] Data retention: 30 days after deletion

**COPPA Compliance (Kids Mode):**
- [x] Parental consent required
- [x] No ads shown to kids
- [x] No data collection from kids <13
- [x] Age verification on signup

---

### Security Audits

**Monthly:**
- Review Firebase Security Rules
- Check for exposed API keys (GitHub secret scanning)
- Review user-reported security issues

**Quarterly:**
- Dependency audit: `flutter pub outdated`
- Vulnerability scan: `npm audit` (for any Node.js tools)
- Penetration testing (if budget allows)

**Annually:**
- Full security audit by 3rd party
- Update privacy policy
- Renew SSL certificates (auto via Cloudflare)

---

## 6. Scaling Strategy {#scaling}

### Expected Growth

| Month | Users | DAU | Firestore Reads/Day | Cost |
|-------|-------|-----|---------------------|------|
| phase | 10K | 3K | 300K | $50 |
| phase | 50K | 15K | 1.5M | $150 |
| phase | 100K | 30K | 3M | $300 |
| phase2 | 500K | 150K | 15M | $1,200 |

### Firebase Scaling Limits

**Firestore:**
- Free tier: 50K reads/day, 20K writes/day
- phase: Will exceed → Upgrade to Blaze plan
- Cost: $0.06 per 100K reads
- Optimization: Cache locally, batch requests

**Cloud Functions:**
- Free tier: 2M invocations/month
- phase: Will exceed
- Cost: $0.40 per million invocations
- Optimization: Reduce function calls, use client-side logic

**Cloud Storage:**
- Free tier: 5GB storage, 1GB egress/day
- Audio files: ~2GB initially
- phase: Will exceed
- Cost: $0.026/GB/month
- Optimization: Use CDN (Cloudflare)

### Scaling Actions

**phase:**
- Upgrade to Firebase Blaze (pay-as-you-go)
- Set billing alerts ($100, $500, $1000)
- Enable Firebase App Check

**phase:**
- Implement aggressive caching
- Move static content to Cloudflare CDN
- Optimize Firestore indexes

**phase:**
- Consider migrating heavy workloads to GCP
- Implement read replicas if needed
- Horizontal scaling via Cloud Run (if using custom backend)

---

## 7. Cost Optimization {#cost}

### Current Monthly Costs (Estimated)

| Service | phase | phase | phase2 |
|---------|---------|---------|----------|
| Firebase (Blaze) | $50 | $300 | $1,200 |
| Sentry | $26 | $26 | $80 |
| Domain (noorai.app) | $1 | $1 | $1 |
| Cloudflare (Free) | $0 | $0 | $0 |
| GitHub (Free) | $0 | $0 | $0 |
| **TOTAL** | **$77** | **$327** | **$1,281** |

### Cost Optimization Tips

**1. Cache Aggressively**
- User data: Cache for 24 hours
- Quran text: Cache locally (never expires)
- Prayer times: Cache for 1 day

**2. Batch Firestore Requests**
```dart
// ❌ Bad: 100 separate reads
for (var i = 0; i < 100; i++) {
  await firestore.collection('verses').doc(i).get();
}

// ✅ Good: 1 batched read
final snapshot = await firestore.collection('verses')
  .where('id', whereIn: ids)
  .get();
```

**3. Use Firebase Emulator for Development**
```bash
# Run local Firebase emulator (free)
firebase emulators:start
```

**4. Compress Assets**
- Audio: Opus codec (50% smaller than MP3)
- Images: WebP format
- On-device model: GGUF Q4 quantization (4GB vs 15GB)

**5. Set Billing Alerts**
```bash
# Firebase console → Billing → Budget alerts
Alert at: $50, $100, $500, $1000
Action: Email + Slack notification
```

---

## 8. Incident Response {#incident}

### Incident Severity Levels

**P0 - Critical**
- App completely down for all users
- Payment processing broken
- Data breach / security incident
- **Response:** Immediate (within 15 minutes)
- **Communication:** Public status page + social media

**P1 - High**
- Core feature broken (affects >10% users)
- Significant performance degradation
- **Response:** Within 1 hour
- **Communication:** Support email to affected users

**P2 - Medium**
- Minor feature broken
- Performance issue
- **Response:** Within 4 hours
- **Communication:** Internal tracking only

**P3 - Low**
- UI bug, no functionality impact
- **Response:** Next business day
- **Communication:** Bug tracker

---

### Incident Response Runbook

**Step 1: Detection (0-5 minutes)**
- Alert received (Crashlytics, Sentry, UptimeRobot)
- Incident commander assigned
- Create Slack channel: #incident-YYYY-MM-DD

**Step 2: Assessment (5-15 minutes)**
- Confirm incident severity
- Identify affected users (%)
- Determine root cause (initial hypothesis)

**Step 3: Communication (15-30 minutes)**
- Update status page: https://status.noorai.app
- Post on social media (if P0):
  ```
  We're aware of an issue affecting Noor AI.
  Our team is investigating. Updates: status.noorai.app
  ```
- Notify internal team (Slack)

**Step 4: Mitigation (30 minutes - 2 hours)**
- Deploy hotfix (if possible)
- Roll back to previous version (if safer)
- Implement workaround

**Step 5: Resolution**
- Verify fix works
- Monitor for 1 hour
- Mark incident as resolved

**Step 6: Post-Mortem (Within 48 hours)**
- Write incident report:
  - What happened
  - Root cause
  - Impact (# users, duration)
  - Prevention measures
- Share with team
- Implement improvements

---

### Example Incident: Firestore Quota Exceeded

**Timeline:**
- **10:00 AM:** Alert: Firestore quota exceeded
- **10:05 AM:** Incident confirmed - users can't sync data
- **10:10 AM:** Tweet: "We're experiencing sync issues..."
- **10:15 AM:** Root cause: Viral tweet → 10x traffic spike
- **10:20 AM:** Mitigation: Increase Firestore quota
- **10:30 AM:** Resolved: Sync working again
- **10:45 AM:** Tweet: "Issue resolved. Thank you for patience!"

**Post-Mortem Actions:**
- Set up auto-scaling alerts
- Increase default quota buffer
- Add rate limiting to prevent abuse

---

## Summary: DevOps Readiness Checklist

**2 Weeks Before Launch:**
- [ ] CI/CD pipeline configured (GitHub Actions)
- [ ] Firebase project set up (production + staging)
- [ ] Monitoring tools configured (Crashlytics, Sentry)
- [ ] Backup strategy implemented (daily Firestore backups)
- [ ] Security audit complete
- [ ] Billing alerts set ($100, $500, $1000)

**1 Week Before Launch:**
- [ ] Load testing (simulate 10K users)
- [ ] Disaster recovery plan documented
- [ ] Incident response runbook reviewed
- [ ] Status page created (status.noorai.app)
- [ ] Team trained on incident response

**Launch Day:**
- [ ] Monitor all metrics 24/7
- [ ] On-call rotation (if team >1)
- [ ] Slack #engineering-alerts active
- [ ] Hourly check: crash rate, API latency, DAU

**initial period Post-Launch:**
- [ ] Review all incidents
- [ ] Optimize based on real usage patterns
- [ ] Adjust scaling thresholds
- [ ] Write post-launch retrospective

---

**DevOps & monitoring complete - infrastructure is production-ready! 🚀**
