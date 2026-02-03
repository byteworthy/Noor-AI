import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

// ============================================================================
// TABLE DEFINITIONS (17 Tables)
// ============================================================================

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
  TextColumn get content => text()(); // Renamed from 'text' to avoid conflict
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
  Set<Column> get primaryKey => {id};
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
  Set<Column> get primaryKey => {id};
}

// Table 8: Users
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get email => text().unique()();
  TextColumn get name => text()();
  TextColumn get madhab => text().nullable()(); // 'hanafi', 'maliki', etc.
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// Table 9: User Progress
@DataClassName('UserProgressData')
class UserProgress extends Table {
  TextColumn get userId => text().references(Users, #id)();
  IntColumn get currentStreak => integer()();
  IntColumn get longestStreak => integer()();
  IntColumn get totalVersesRead => integer()();
  IntColumn get totalVersesMemorized => integer()();
  IntColumn get vocabularyMastered => integer()();
  DateTimeColumn get lastActive => dateTime()();

  @override
  Set<Column> get primaryKey => {userId};
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
  Set<Column> get primaryKey => {id};
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
  Set<Column> get primaryKey => {id};
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
  Set<Column> get primaryKey => {id};
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
  Set<Column> get primaryKey => {id};
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
  Set<Column> get primaryKey => {id};
}

// Table 16: Bookmarks
class Bookmarks extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  IntColumn get verseId => integer().references(Verses, #id)();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// Table 17: Noor AI Conversations
class NoorAIConversations extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get question => text()();
  TextColumn get answer => text()();
  TextColumn get sources => text()(); // JSON array of [Quran X:Y] [Hadith Z]
  IntColumn get rating => integer().nullable()(); // 1-5 stars

  @override
  Set<Column> get primaryKey => {id};
}

// ============================================================================
// DATABASE CLASS
// ============================================================================

@DriftDatabase(
  tables: [
    Surahs,
    Verses,
    VerseWords,
    Tafsirs,
    Hadiths,
    ReviewCards,
    ReviewLogs,
    Users,
    UserProgress,
    PrayerTimes,
    VocabularyDecks,
    VocabularyWords,
    ConversationHistory,
    HabitLogs,
    DownloadedContent,
    Bookmarks,
    NoorAIConversations,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Handle migrations here when schema version changes
          // Example:
          // if (from == 1 && to == 2) {
          //   await m.addColumn(users, users.newColumn);
          // }
        },
      );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'noor_ai_db');
  }

  // ============================================================================
  // QUERY METHODS (Examples)
  // ============================================================================

  // Quran Queries
  Future<List<Surah>> getAllSurahs() => select(surahs).get();

  Future<Surah> getSurahByNumber(int number) =>
      (select(surahs)..where((s) => s.number.equals(number))).getSingle();

  Future<List<Verse>> getVersesBySurah(int surahNumber) =>
      (select(verses)..where((v) => v.surahNumber.equals(surahNumber))).get();

  Future<Verse> getVerse(int surahNumber, int verseNumber) =>
      (select(verses)
            ..where((v) => v.surahNumber.equals(surahNumber) & v.verseNumber.equals(verseNumber)))
          .getSingle();

  // Hadith Queries
  Future<List<Hadith>> getHadithsByCollection(String collection) =>
      (select(hadiths)..where((h) => h.collection.equals(collection))).get();

  Future<List<Hadith>> getSahihHadiths() =>
      (select(hadiths)..where((h) => h.grade.equals('sahih'))).get();

  // User Queries
  Future<User?> getUserById(String userId) =>
      (select(users)..where((u) => u.id.equals(userId))).getSingleOrNull();

  Future<UserProgressData?> getUserProgress(String userId) =>
      (select(userProgress)..where((p) => p.userId.equals(userId))).getSingleOrNull();

  // Review Card Queries (for SRS)
  Future<List<ReviewCard>> getDueCards(String userId, DateTime now) =>
      (select(reviewCards)
            ..where((c) => c.userId.equals(userId) & c.due.isSmallerOrEqualValue(now))
            ..orderBy([(c) => OrderingTerm.asc(c.due)]))
          .get();

  // Vocabulary Queries
  Future<List<VocabularyWord>> getWordsByDeck(String deckId) =>
      (select(vocabularyWords)..where((w) => w.deckId.equals(deckId))).get();

  // Bookmark Queries
  Future<List<Bookmark>> getUserBookmarks(String userId) =>
      (select(bookmarks)
            ..where((b) => b.userId.equals(userId))
            ..orderBy([(b) => OrderingTerm.desc(b.createdAt)]))
          .get();

  // Noor AI Conversation Queries
  Future<List<NoorAIConversation>> getRecentConversations(String userId, {int limit = 20}) =>
      (select(noorAIConversations)
            ..where((c) => c.userId.equals(userId))
            ..orderBy([(c) => OrderingTerm.desc(c.timestamp)])
            ..limit(limit))
          .get();

  // ============================================================================
  // INSERT/UPDATE/DELETE METHODS (Examples)
  // ============================================================================

  // Insert methods
  Future<int> insertSurah(SurahsCompanion surah) => into(surahs).insert(surah);
  Future<int> insertVerse(VersesCompanion verse) => into(verses).insert(verse);
  Future<int> insertHadith(HadithsCompanion hadith) => into(hadiths).insert(hadith);

  // Batch insert for seeding
  Future<void> insertSurahs(List<SurahsCompanion> surahList) async {
    await batch((batch) {
      batch.insertAll(surahs, surahList);
    });
  }

  Future<void> insertVerses(List<VersesCompanion> verseList) async {
    await batch((batch) {
      batch.insertAll(verses, verseList);
    });
  }

  Future<void> insertHadiths(List<HadithsCompanion> hadithList) async {
    await batch((batch) {
      batch.insertAll(hadiths, hadithList);
    });
  }

  // Update methods
  Future<bool> updateUser(UsersCompanion user) => update(users).replace(user);
  Future<bool> updateUserProgress(UserProgressCompanion progress) =>
      update(userProgress).replace(progress);
  Future<bool> updateReviewCard(ReviewCardsCompanion card) =>
      update(reviewCards).replace(card);

  // Delete methods
  Future<int> deleteBookmark(String bookmarkId) =>
      (delete(bookmarks)..where((b) => b.id.equals(bookmarkId))).go();

  Future<int> deleteConversation(String conversationId) =>
      (delete(noorAIConversations)..where((c) => c.id.equals(conversationId))).go();
}
