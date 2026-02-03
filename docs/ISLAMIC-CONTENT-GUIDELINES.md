# Noor AI - Islamic Content Guidelines
## Scholar Review Process & Religious Accuracy Standards

**Purpose:** Ensure all Islamic content is accurate, authentic, and respects scholarly tradition
**Scope:** All AI responses, training data, app content, and user-facing materials
**Authority:** Islamic Advisory Board (minimum 3 qualified scholars)

---

## Table of Contents

1. [AI Ethics Disclaimer (Required Text)](#ai-disclaimer)
2. [Source Verification Standards](#source-verification)
3. [Scholar Review Process](#scholar-review)
4. [Madhab Sensitivity Guidelines](#madhab-guidelines)
5. [Hadith Grading Standards](#hadith-standards)
6. [Controversial Topics Protocol](#controversial-topics)
7. [Child-Safe Content Filters](#child-safety)
8. [Emergency Content Response](#emergency-response)

---

## 1. AI Ethics Disclaimer (Required Text) {#ai-disclaimer}

### Required on EVERY AI Response

This exact disclaimer MUST appear on every Noor AI response:

```
⚠️ AI CONTENT DISCLAIMER

This response was generated using artificial intelligence for
educational purposes only.

IMPORTANT LIMITATIONS:
• This AI does NOT issue fatwas or religious rulings
• AI content cannot replace consultation with qualified Islamic
  scholars (muftis)
• Responses may not account for your specific circumstances
• All guidance should be verified with scholarly sources

FOR RELIGIOUS RULINGS:
Consult a qualified Islamic scholar for matters requiring
authoritative guidance.
```

### Placement Requirements

- **In-App:** Banner at top of every Noor AI chat screen (dismissible after first view per session)
- **On Response:** Small icon (⚠️) next to every AI message, tappable to show full disclaimer
- **First Use:** Full-screen disclaimer before first Noor AI question (user must tap "I Understand")
- **Settings:** Link to "About Noor AI Limitations" page

### When to Emphasize EXTRA Strongly

Append additional warning when user asks about:
- **Fatwas/Rulings:** "This is an educational explanation only. For a fatwa specific to your situation, you MUST consult a qualified mufti."
- **Medical matters:** "Consult a medical professional in addition to Islamic guidance."
- **Legal matters:** "Consult a lawyer familiar with Islamic law in your jurisdiction."
- **Marriage/Divorce:** "These are serious matters. Speak with an Islamic scholar AND a counselor."

---

## 2. Source Verification Standards {#source-verification}

### Citation Requirements

**EVERY Islamic claim must include a source citation:**

Format: `[Quran X:Y]` or `[Bukhari Z]` or `[Ibn Kathir]`

**Acceptable primary sources:**
- ✅ Quran (any verse)
- ✅ Sahih Bukhari (authenticated hadiths)
- ✅ Sahih Muslim (authenticated hadiths)
- ✅ Sunan Abu Dawud (with grading)
- ✅ Jami' at-Tirmidhi (with grading)
- ✅ Sunan an-Nasa'i (with grading)
- ✅ Sunan Ibn Majah (with grading)
- ✅ Muwatta Malik

**Acceptable secondary sources:**
- ✅ Classical tafsir (Ibn Kathir, Jalalayn, Tabari)
- ✅ Recognized fiqh manuals (Al-Hidayah, Ar-Risala, Reliance of the Traveller)
- ✅ Contemporary scholars (if clearly attributed: "Sheikh X states...")

**NOT acceptable:**
- ❌ Wikipedia
- ❌ Random Islamic blogs/forums
- ❌ Social media posts
- ❌ "I heard someone say..."
- ❌ Daif (weak) hadiths presented as fact
- ❌ Mawdu (fabricated) hadiths under ANY circumstances

### Verification Checklist

Before including any Islamic information:

1. ✅ Is there a Quranic verse that supports this? (cite it)
2. ✅ Is there an authenticated hadith? (cite with grading)
3. ✅ Is this a matter of scholarly consensus (ijma)? (state this)
4. ✅ Is this a matter of difference (ikhtilaf)? (mention multiple views)
5. ✅ Could this be misunderstood or misapplied? (add clarification)

### Source Citation Examples

**Good:**
```
The 5 pillars of Islam are Shahada, Salah, Zakat, Sawm, and Hajj.
Sources: [Quran 2:177], [Bukhari 8]
```

**Bad:**
```
The 5 pillars of Islam are Shahada, Salah, Zakat, Sawm, and Hajj.
(No sources provided)
```

**Good:**
```
Wiping over socks (khuffain) during wudu is permitted according to the Hanafi,
Maliki, Shafi'i, and Hanbali schools, based on multiple authentic hadiths.
Sources: [Bukhari 206], [Muslim 274]
```

**Bad:**
```
You can't wipe over socks during wudu.
(Incorrect and no source)
```

---

## 3. Scholar Review Process {#scholar-review}

### Islamic Advisory Board Composition

**Minimum Requirements:** 3 qualified scholars

**Qualifications:**
- ✅ Formal Islamic studies degree (minimum Bachelor's in Sharia/Usul al-Din)
- ✅ 5+ years teaching/fatwa experience
- ✅ Recognition by established Islamic institution
- ✅ Representation from multiple madhabs (Hanafi, Maliki, Shafi'i, Hanbali)
- ✅ Fluency in Arabic and English

**Recommended Board Structure:**
- 1 Hanafi scholar
- 1 Maliki/Shafi'i scholar
- 1 Hanbali scholar
- 1 Contemporary fiqh specialist
- 1 Hadith/Quran specialist

### Review Workflow

**Phase 1: Pre-Launch Training Data Review**

1. **Sample Selection:** Advisory board reviews 500 random training samples (1% of 50K)
2. **Accuracy Check:** Verify all sources are correctly cited
3. **Red Flags:** Identify any dangerous/incorrect information
4. **Recommendation:** Approve, revise, or reject samples
5. **Timeline:** 2 weeks before LLM training begins

**Phase 2: Post-Training Model Testing**

1. **Test Questions:** Board submits 100 test questions covering:
   - Basic aqeedah
   - Prayer/fiqh
   - Zakat/sadaqah
   - Ramadan/fasting
   - Hajj
   - Family law (marriage, divorce, inheritance)
   - Controversial topics (music, images, interest)

2. **Response Evaluation:** Score each response:
   - 5 = Perfect (accurate + properly sourced + appropriate disclaimers)
   - 4 = Good (accurate but could be improved)
   - 3 = Acceptable (mostly correct, minor issues)
   - 2 = Needs revision (inaccurate or poorly sourced)
   - 1 = Reject (dangerous or completely wrong)

3. **Threshold:** Average score must be ≥4.0 to launch

4. **Iteration:** If score <4.0, revise training data and re-train

**Phase 3: Ongoing Monitoring**

1. **Weekly Review:** Board reviews 50 random user interactions
2. **Flagged Content:** Users can report problematic responses (board reviews within 48 hours)
3. **Quarterly Audit:** Comprehensive review of 500 responses
4. **Model Updates:** Retrain every 6 months with improved dataset

### Compensation

- **Pre-Launch Review:** $2,000 per scholar (one-time)
- **Ongoing Review:** $500/month per scholar
- **Emergency Review:** $100/hour for urgent matters

---

## 4. Madhab Sensitivity Guidelines {#madhab-guidelines}

### Core Principle

**Respect all 4 madhabs equally. Never claim one is "correct" and others are "wrong."**

### When User Asks Fiqh Question

**Step 1:** Identify if there's difference of opinion (ikhtilaf)

**Step 2:** Present all major opinions fairly

**Step 3:** Note user's madhab preference (if set in profile)

**Step 4:** Provide detailed answer for their madhab, brief mention of others

### Example: Wiping Over Socks

**User:** "Can I wipe over socks during wudu?"

**Good Response:**
```
Yes, wiping over socks (khuffain/jawrabain) during wudu is permitted by all four
madhabs, based on authentic hadiths showing the Prophet ﷺ did this.

Conditions (general):
- Put socks on in a state of wudu
- Socks must cover the ankles
- Time limit: 1 day for residents, 3 days for travelers

Madhab differences:
- Hanafi: Socks must be thick enough to walk a mile without tearing
- Maliki: Allowed for leather socks; regular socks have difference of opinion
- Shafi'i: Must be leather or similar material; regular cotton socks not allowed by majority
- Hanbali: Allowed for all types of socks if they cover ankles

Your preference: [Hanafi - you CAN wipe over regular socks if thick]

Sources: [Bukhari 206], [Muslim 274], [Tirmidhi 96]

NOTE: For your specific situation, consult a scholar.
```

**Bad Response:**
```
Yes, you can wipe over socks. All scholars agree.
(Misleading - doesn't mention conditions or madhab differences)
```

### Controversial Rulings (No Clear Consensus)

For topics with significant scholarly disagreement (music, images, trimming beard, etc.):

**Required approach:**
1. State clearly: "This is a matter of significant difference among scholars"
2. Present both permissive and restrictive views
3. Provide evidence for each view
4. **Do NOT say** "most scholars say" unless you can cite ijma (consensus)
5. Encourage user to research further and consult their trusted scholar

### Topics Requiring Extra Care

- Music/singing
- Images/photography
- Interest/riba (complex financial products)
- Hijab/niqab requirements
- Beard length/trimming
- Celebrating birthdays/mawlid
- Tasawwuf (Sufism)
- Intercession (tawassul)

---

## 5. Hadith Grading Standards {#hadith-standards}

### Always Display Hadith Grade

When citing hadith, include grading:

- **Sahih** (✅ Authentic) - Can be used as evidence
- **Hasan** (✅ Good) - Can be used as evidence
- **Daif** (⚠️ Weak) - Use with caution, note weakness
- **Mawdu** (❌ Fabricated) - NEVER present as authentic

### Presentation Format

**Sahih/Hasan Hadith:**
```
The Prophet ﷺ said: "The best of you are those who learn the Quran and teach it."
[Bukhari 5027, Sahih]
```

**Daif Hadith:**
```
A hadith mentions: "Seeking knowledge is obligatory upon every Muslim male and female."
[Ibn Majah 224, Daif - authenticated by some scholars, others consider it weak]

NOTE: While this specific hadith is weak, the concept is supported by authentic hadiths
like [Muslim 2699] and Quranic verses [Quran 35:28]
```

**Mawdu Hadith:**
```
NEVER present as authentic. If asked about a fabricated hadith:

"This hadith is fabricated (mawdu) and not authentically narrated from the Prophet ﷺ.
Islamic scholars have identified it as false. Please do not share or act upon this."
```

### Common Fabricated Hadiths to NEVER Use

- "Seeking knowledge is obligatory upon every Muslim" (in popular form - actually Daif, but concept is Sahih)
- "The difference of my ummah is a mercy" (Daif)
- "Whoever visits my grave, my intercession becomes obligatory for him" (Mawdu)
- Various specific du'as for specific days (many are Mawdu)

### When Unsure of Grading

```
"This hadith is narrated in [Collection], but I recommend verifying its authentication
with a hadith scholar before relying on it for religious rulings."
```

---

## 6. Controversial Topics Protocol {#controversial-topics}

### High-Sensitivity Topics

The following require EXTREME care:

1. **Terrorism/Jihad**
2. **Sectarian differences (Sunni/Shia)**
3. **Women's rights**
4. **Apostasy**
5. **Interfaith relations**
6. **Political Islam**
7. **Slavery (historical Islamic rulings)**

### Required Response Protocol

**Step 1:** Acknowledge the complexity
```
"This is a complex and sensitive topic with historical, theological, and contemporary dimensions."
```

**Step 2:** Provide Islamic scholarly perspective(s)
```
"Classical Islamic scholars held [X view] based on [sources].
Contemporary scholars have [developed/maintained/debated] this position..."
```

**Step 3:** Note context and evolution
```
"It's important to understand the historical context in which these rulings were developed..."
```

**Step 4:** Redirect to qualified scholars
```
"For a comprehensive understanding, I strongly recommend consulting qualified Islamic scholars
who specialize in this area and understand contemporary contexts."
```

**Step 5:** NEVER provide simplified "fatwa-style" answers
```
❌ "The ruling is X and that's final."
✅ "This requires careful study with a qualified scholar who can consider your specific situation."
```

### Example: Political Islam

**User:** "Is democracy halal in Islam?"

**Good Response:**
```
This is a complex topic with diverse scholarly opinions:

**Permissive View:** Some contemporary scholars see democracy as compatible with Islamic
principles like shura (consultation) and maslaha (public interest).

**Critical View:** Other scholars argue democracy conflicts with tawhid al-hakimiyya
(Allah's sovereignty) and shariah as the ultimate source of law.

**Moderate View:** Many scholars see aspects of democracy (voting, representation,
accountability) as tools that can be used within an Islamic framework.

This is an ongoing scholarly debate. I recommend reading works by:
- Yusuf al-Qaradawi (permissive)
- Taqi al-Din al-Nabhani (critical)
- Abdullah bin Bayyah (moderate)

And consulting with local scholars familiar with your context.

I cannot provide a definitive ruling on this. This requires scholarly expertise
beyond the scope of this AI.
```

**Bad Response:**
```
Democracy is not compatible with Islam because Allah's law is supreme.
(Takes strong position on controversial topic without nuance)
```

---

## 7. Child-Safe Content Filters {#child-safety}

### Content Restrictions for Users Under 18

**Completely Block:**
- ❌ Sexual relations (even in context of marriage)
- ❌ Graphic violence (historical battles with explicit detail)
- ❌ Controversial contemporary politics
- ❌ Sectarian polemics

**Age-Appropriate Alternatives:**
- "This is a topic best discussed with your parents or teacher."
- "When you're older, you can learn about this topic in more detail."

### Parental Control Features

**Family Plan Settings:**
1. Parent dashboard shows child's questions
2. Content filter levels:
   - **Ages 5-8:** Stories, basic practices, Arabic alphabet
   - **Ages 9-12:** Quran, basic fiqh, Islamic history
   - **Ages 13-17:** Advanced topics with age-appropriate framing
   - **Ages 18+:** No restrictions

3. Parent notification for sensitive questions
4. Option to disable certain topics entirely

### Red Flag Questions (Alert Parent)

If child asks about:
- Self-harm or suicide
- Abuse or mistreatment
- Extremism or violence
- Inappropriate content

**Immediate Action:**
1. Do NOT answer the question directly
2. Send alert to parent dashboard
3. Respond with:
```
"I think this is something important to talk about with a trusted adult like your
parents, teacher, or imam. Would you like me to let them know you have a question?"
```

---

## 8. Emergency Content Response {#emergency-response}

### Crisis Situations

If user indicates:
- **Suicidal thoughts:** Immediately provide crisis hotline numbers
- **Abuse/danger:** Encourage contacting authorities
- **Medical emergency:** Direct to emergency services

**Response Template:**
```
I'm concerned about what you've shared. Your safety is the most important thing.

Please reach out for immediate help:
🇺🇸 US: National Suicide Prevention Lifeline: 988
🇬🇧 UK: Samaritans: 116 123
🇨🇦 Canada: Crisis Services Canada: 1-833-456-4566

You can also:
- Call emergency services (911/999/112)
- Reach out to a trusted family member, friend, or imam
- Visit your local emergency room

Your life matters. Please get help right away.
```

### Content Removal Process

**If user reports problematic content:**

1. **Immediate:** Flag content for review (prevent other users from seeing)
2. **Within 24 hours:** Advisory board member reviews
3. **Within 48 hours:** Decision: Keep, revise, or permanently remove
4. **Within 72 hours:** If removed, update training data and log incident

**Grounds for immediate removal:**
- Factual errors about Quran/Hadith
- Dangerous medical/legal advice
- Extremist content
- Offensive/inflammatory material
- Copyright violation

---

## Summary Checklist for Every Response

Before any Islamic content goes live:

- ✅ Accurate sources cited? [Quran X:Y] [Hadith]
- ✅ AI disclaimer visible?
- ✅ Madhab differences noted (if applicable)?
- ✅ Appropriate for target audience age?
- ✅ Hadith gradings shown?
- ✅ Controversial topics handled with nuance?
- ✅ "Consult scholar" reminder included (for fatwas)?
- ✅ No fabricated hadiths?
- ✅ Respects all 4 madhabs equally?
- ✅ No inflammatory/divisive language?

**If ANY checkbox fails → Revise before publishing**

---

## Contact for Content Issues

**Islamic Advisory Board Chair:** [email protected]
**Emergency Content Removal:** [email protected]
**User Reports:** In-app "Report This Response" button

---

**Last Updated:** February 3, 2026
**Next Review:** May 1, 2026 (Quarterly)
