# Noor AI - Analytics & Metrics Implementation
## Complete Data Tracking Strategy

**Purpose:** Track all KPIs for product decisions
**Timeline:** Implement in Period, optimize ongoing
**Tools:** Firebase Analytics + Mixpanel + RevenueCat

---

## Table of Contents

1. [Analytics Architecture](#architecture)
2. [Event Taxonomy](#event-taxonomy)
3. [Core Metrics Dashboard](#dashboard)
4. [Funnel Analysis](#funnels)
5. [Cohort Analysis](#cohorts)
6. [Implementation Guide](#implementation)
7. [Privacy Compliance](#privacy)

---

## 1. Analytics Architecture {#architecture}

### Tools Stack

**Firebase Analytics (Primary)**
- User properties
- Core events
- Crash reporting via Crashlytics
- Free tier sufficient

**Mixpanel (Product Analytics)**
- Advanced funnel analysis
- Cohort retention
- A/B test tracking
- Free tier: 100K events/month

**RevenueCat (Subscription Analytics)**
- recurring revenue tracking
- Churn rate
- LTV calculations
- Trial-to-paid conversion

```dart
// lib/core/analytics/analytics_service.dart

class AnalyticsService {
  final FirebaseAnalytics _firebase;
  final Mixpanel _mixpanel;

  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    // Log to both platforms
    await _firebase.logEvent(name: name, parameters: parameters);
    await _mixpanel.track(name, properties: parameters);
  }

  Future<void> setUserProperties(Map<String, dynamic> properties) async {
    for (var entry in properties.entries) {
      await _firebase.setUserProperty(
        name: entry.key,
        value: entry.value?.toString(),
      );
    }
    await _mixpanel.getPeople().set(properties);
  }
}
```

---

## 2. Event Taxonomy {#event-taxonomy}

### Naming Convention

**Format:** `category_action_object`

Examples:
- `quran_read_surah`
- `arabic_complete_lesson`
- `ai_send_question`
- `premium_start_trial`

### Event Categories

#### 1. User Lifecycle Events

```dart
// Onboarding
analytics.logEvent(name: 'onboarding_started');
analytics.logEvent(name: 'onboarding_step_completed', parameters: {
  'step_number': 1,
  'step_name': 'persona_selection',
});
analytics.logEvent(name: 'onboarding_completed', parameters: {
  'time_spent_seconds': 120,
  'steps_completed': 4,
});

// Account
analytics.logEvent(name: 'account_created', parameters: {
  'method': 'email', // or 'google', 'apple'
});
analytics.logEvent(name: 'login', parameters: {
  'method': 'email',
});
```

#### 2. Quran Events

```dart
analytics.logEvent(name: 'quran_open_surah', parameters: {
  'surah_number': 1,
  'surah_name': 'Al-Fatiha',
});

analytics.logEvent(name: 'quran_play_audio', parameters: {
  'surah_number': 1,
  'ayah_number': 1,
  'reciter': 'Mishary Rashid',
});

analytics.logEvent(name: 'quran_bookmark_verse', parameters: {
  'surah_number': 1,
  'ayah_number': 1,
});

analytics.logEvent(name: 'quran_search', parameters: {
  'query': 'prayer',
  'results_count': 47,
});
```

#### 3. Arabic Learning Events

```dart
analytics.logEvent(name: 'arabic_start_lesson', parameters: {
  'lesson_id': 'alphabet_01',
  'lesson_name': 'Arabic Alphabet',
  'difficulty': 'beginner',
});

analytics.logEvent(name: 'arabic_complete_lesson', parameters: {
  'lesson_id': 'alphabet_01',
  'duration_seconds': 180,
  'score': 85,
});

analytics.logEvent(name: 'arabic_review_card', parameters: {
  'card_id': '123',
  'rating': 'good', // again, hard, good, easy
  'interval_days': 7,
});
```

#### 4. Noor AI Events

```dart
analytics.logEvent(name: 'ai_send_question', parameters: {
  'question_length': 50,
  'conversation_turn': 1,
});

analytics.logEvent(name: 'ai_receive_response', parameters: {
  'response_length': 300,
  'sources_count': 2,
  'response_time_ms': 2000,
});

analytics.logEvent(name: 'ai_copy_response');
analytics.logEvent(name: 'ai_share_response');
```

#### 5. Premium Events

```dart
analytics.logEvent(name: 'premium_view_paywall', parameters: {
  'trigger': 'photo_to_quran', // what feature triggered it
});

analytics.logEvent(name: 'premium_start_trial', parameters: {
  'plan': 'monthly', // monthly, annual, lifetime
  'price': 6.99,
});

analytics.logEvent(name: 'premium_purchase', parameters: {
  'plan': 'annual',
  'price': 49.99,
  'is_trial_conversion': true,
});

analytics.logEvent(name: 'premium_cancel', parameters: {
  'reason': 'too_expensive',
  'days_subscribed': 45,
});
```

---

## 3. Core Metrics Dashboard {#dashboard}

### North Star Metric

**Weekly Active Users (WAU)** engaged with core value
= Users who read Quran OR used AI OR practiced Arabic in past 7 days

```dart
// Track engagement
analytics.logEvent(name: 'core_value_delivered', parameters: {
  'feature': 'quran_reading', // or 'ai_chat', 'arabic_practice'
});
```

### Product Metrics

| Metric | Definition | Target | Critical Threshold |
|--------|------------|--------|-------------------|
| **DAU** | Daily Active Users | 10K | >5K |
| **WAU** | Weekly Active Users | 40K | >20K |
| **MAU** | Monthly Active Users | 120K | >60K |
| **Stickiness** | DAU/MAU ratio | 25% | >15% |
| **D1 Retention** | Return next day | 40% | >30% |
| **D7 Retention** | Return day 7 | 25% | >15% |
| **D30 Retention** | Return day 30 | 15% | >10% |

### Business Metrics

| Metric | Definition | Target | Critical Threshold |
|--------|------------|--------|-------------------|
| **Conversion Rate** | Free → Trial | 15% | >10% |
| **Trial Conversion** | Trial → Paid | 60% | >40% |
| **recurring revenue** | Monthly Recurring Revenue | target revenue | >target revenue |
| **ARPU** | Avg Revenue Per User | subscription | >subscription |
| **LTV** | Lifetime Value | subscription | >subscription |
| **CAC** | Customer Acquisition Cost | subscription | <subscription |
| **LTV:CAC** | Ratio | 6:1 | >3:1 |
| **Churn Rate** | Monthly churn | <5% | <8% |

---

## 4. Funnel Analysis {#funnels}

### Onboarding Funnel

```
App Install (1000 users)
    ↓ 90%
Onboarding Started (900)
    ↓ 70%
Onboarding Completed (630)
    ↓ 80%
First Core Action (504)
    ↓ 50%
Account Created (252)
    ↓ 40%
D1 Active (100)
```

**Tracking Code:**
```dart
// Step 1
analytics.logEvent(name: 'funnel_onboarding_install');

// Step 2
analytics.logEvent(name: 'funnel_onboarding_started');

// Step 3
analytics.logEvent(name: 'funnel_onboarding_completed');

// Step 4
analytics.logEvent(name: 'funnel_onboarding_first_action', parameters: {
  'action_type': 'quran_read',
});

// Step 5
analytics.logEvent(name: 'funnel_onboarding_account_created');
```

### Premium Conversion Funnel

```
Premium Feature Click (1000 users)
    ↓ 60%
View Paywall (600)
    ↓ 25%
Start Trial (150)
    ↓ 60%
Convert to Paid (90)

Conversion Rate: 9% (click → paid)
```

**Tracking Code:**
```dart
analytics.logEvent(name: 'funnel_premium_feature_click', parameters: {
  'feature': 'photo_to_quran',
});

analytics.logEvent(name: 'funnel_premium_paywall_view');

analytics.logEvent(name: 'funnel_premium_trial_start');

analytics.logEvent(name: 'funnel_premium_paid_conversion');
```

---

## 5. Cohort Analysis {#cohorts}

### User Properties (for segmentation)

```dart
analytics.setUserProperties({
  'persona': 'new_muslim', // new_muslim, arabic_learner, quran_student, parent
  'arabic_level': 'beginner', // beginner, intermediate, advanced
  'madhab': 'hanafi', // hanafi, maliki, shafi, hanbali
  'registration_date': 'YYYY-MM-DD',
  'lifetime_value': 49.99,
  'is_premium': true,
  'days_since_install': 30,
});
```

### Retention Cohorts

**Example: January 2026 Cohort**

| Day | Active Users | Retention % |
|-----|--------------|-------------|
| D0  | 1000         | 100%        |
| D1  | 400          | 40%         |
| D7  | 250          | 25%         |
| D14 | 180          | 18%         |
| D30 | 150          | 15%         |

**Cohort Comparison:**

| Cohort | D1 | D7 | D30 |
|--------|----|----|-----|
| Dec 2025 | 35% | 20% | 12% |
| Jan 2026 | 40% | 25% | 15% |
| Feb 2026 | 45% | 28% | 18% |

---

## 6. Implementation Guide {#implementation}

### Firebase Setup

```dart
// pubspec.yaml
dependencies:
  firebase_core: ^2.24.0
  firebase_analytics: ^10.7.4
  firebase_crashlytics: ^3.4.8

// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Enable Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  runApp(MyApp());
}

// Track screen views automatically
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
      home: HomeScreen(),
    );
  }
}
```

### Mixpanel Setup

```dart
// pubspec.yaml
dependencies:
  mixpanel_flutter: ^2.1.1

// Initialize
final mixpanel = await Mixpanel.init(
  'YOUR_MIXPANEL_TOKEN',
  trackAutomaticEvents: true,
);

// Identify user
mixpanel.identify(userId);
mixpanel.getPeople().set({
  '\$name': 'Ahmad',
  '\$email': '[email protected]',
  'persona': 'new_muslim',
});

// Track event
mixpanel.track('quran_read_surah', properties: {
  'surah_number': 1,
  'surah_name': 'Al-Fatiha',
});
```

### RevenueCat Setup

```dart
// pubspec.yaml
dependencies:
  purchases_flutter: ^6.0.0

// Initialize
await Purchases.configure(
  PurchasesConfiguration('YOUR_REVENUECAT_API_KEY')
    ..appUserID = userId,
);

// Track subscription events (automatic)
Purchases.addCustomerInfoUpdateListener((customerInfo) {
  if (customerInfo.entitlements.active.isNotEmpty) {
    analytics.logEvent(name: 'subscription_active');
  }
});
```

---

## 7. Privacy Compliance {#privacy}

### Data Collection Consent

```dart
class ConsentManager {
  Future<void> requestConsent() async {
    final consent = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Help us improve'),
        content: Text(
          'We collect anonymous usage data to improve the app. '
          'You can opt-out anytime in Settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('No thanks'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Allow'),
          ),
        ],
      ),
    );

    await analytics.setAnalyticsCollectionEnabled(consent ?? false);
    await prefs.setBool('analytics_consent', consent ?? false);
  }
}
```

### GDPR Compliance

- Provide opt-out in settings
- Delete user data on request
- Don't track PII without consent
- Use anonymized user IDs

```dart
// Settings screen
SwitchListTile(
  title: Text('Analytics'),
  subtitle: Text('Help improve Noor AI'),
  value: analyticsEnabled,
  onChanged: (value) async {
    await analytics.setAnalyticsCollectionEnabled(value);
    setState(() => analyticsEnabled = value);
  },
);

// Delete user data
Future<void> deleteUserData(String userId) async {
  // Firebase
  await FirebaseAnalytics.instance.resetAnalyticsData();

  // Mixpanel
  await mixpanel.reset();

  // RevenueCat
  await Purchases.logOut();
}
```

---

## Summary: Analytics Checklist

**Before Launch:**
- [ ] Firebase Analytics configured
- [ ] Mixpanel configured
- [ ] RevenueCat configured
- [ ] All core events tracked
- [ ] User properties set
- [ ] Dashboards created
- [ ] Privacy consent implemented
- [ ] GDPR compliance verified

**Week 1 Post-Launch:**
- [ ] Monitor DAU/MAU daily
- [ ] Check funnel drop-offs
- [ ] Review crash reports
- [ ] Validate event accuracy

**Period Post-Launch:**
- [ ] Analyze cohort retention
- [ ] Calculate LTV
- [ ] Optimize based on data
- [ ] Set up alerts for anomalies

---

**Analytics implemented - data-driven decisions ready! 📊**
