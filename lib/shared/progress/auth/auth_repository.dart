import 'package:drift/drift.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../data/progress_database.dart';
import '../data/remote_data_sources.dart';
import '../domain/student_identity.dart';

class AuthResult {
  const AuthResult({required this.success, required this.message});

  final bool success;
  final String message;
}

abstract interface class AuthRepository {
  Future<AuthResult> createStudent(String displayName, String pin);
  Future<AuthResult> completePendingRegistration();
  Future<AuthResult> recover(String studentId, String pin);
  Future<void> signOut();
}

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    required ProgressDatabase database,
    required String installationId,
    FirebaseAuth? firebaseAuth,
    StudentRemoteDataSource? studentRemote,
    ProgressRemoteDataSource? progressRemote,
    FlutterSecureStorage secureStorage = const FlutterSecureStorage(),
  }) : _db = database,
       _installationId = installationId,
       _auth = firebaseAuth,
       _studentRemote = studentRemote,
       _progressRemote = progressRemote,
       _secureStorage = secureStorage;

  static const _pendingPinKey = 'amin_pending_recovery_pin_v1';

  final ProgressDatabase _db;
  final String _installationId;
  final FirebaseAuth? _auth;
  final StudentRemoteDataSource? _studentRemote;
  final ProgressRemoteDataSource? _progressRemote;
  final FlutterSecureStorage _secureStorage;

  @override
  Future<AuthResult> createStudent(String displayName, String pin) async {
    if (kDebugMode) debugPrint('[AmiNProgress] registration_started');
    final cleanedName = displayName.trim();
    if (cleanedName.isEmpty) {
      return const AuthResult(success: false, message: 'Sila masukkan nama pelajar.');
    }
    if (!StudentIdentity.isValidPin(pin)) {
      return const AuthResult(success: false, message: 'PIN mesti mempunyai 6 nombor.');
    }
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    final current = await _currentProfile();
    if (current == null) {
      await _db.into(_db.studentProfiles).insert(
        StudentProfilesCompanion.insert(
          localId: const Uuid().v4(),
          publicStudentId: StudentIdentity.generate(),
          displayName: cleanedName,
          createdAtMillis: now,
          updatedAtMillis: now,
        ),
      );
    } else {
      await (_db.update(_db.studentProfiles)..where((t) => t.localId.equals(current.localId))).write(
        StudentProfilesCompanion(
          displayName: Value(cleanedName),
          authState: const Value('pending'),
          updatedAtMillis: Value(now),
        ),
      );
    }
    await _secureStorage.write(key: _pendingPinKey, value: pin);
    return completePendingRegistration();
  }

  @override
  Future<AuthResult> completePendingRegistration() async {
    final profile = await _currentProfile();
    if (profile == null) {
      return const AuthResult(success: false, message: 'Profil pelajar belum tersedia.');
    }
    if (profile.firebaseUid != null) {
      return _finishCloudProfile(profile, profile.firebaseUid!);
    }
    final pin = await _secureStorage.read(key: _pendingPinKey);
    if (pin == null || _auth == null || _studentRemote == null) {
      return const AuthResult(
        success: true,
        message: 'Kemajuan disimpan pada peranti dan akan disandarkan apabila dalam talian.',
      );
    }

    var studentId = profile.publicStudentId;
    UserCredential credential;
    try {
      credential = await _auth.createUserWithEmailAndPassword(
        email: StudentIdentity.internalEmail(studentId),
        password: pin,
      );
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        studentId = StudentIdentity.generate();
        credential = await _auth.createUserWithEmailAndPassword(
          email: StudentIdentity.internalEmail(studentId),
          password: pin,
        );
      } else {
        return const AuthResult(
          success: true,
          message: 'Kemajuan disimpan pada peranti dan akan disandarkan apabila dalam talian.',
        );
      }
    } catch (_) {
      return const AuthResult(
        success: true,
        message: 'Kemajuan disimpan pada peranti dan akan disandarkan apabila dalam talian.',
      );
    }

    final uid = credential.user!.uid;
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    await _db.transaction(() async {
      await (_db.update(_db.studentProfiles)..where((t) => t.localId.equals(profile.localId))).write(
        StudentProfilesCompanion(
          firebaseUid: Value(uid),
          publicStudentId: Value(studentId),
          authState: const Value('registered'),
          updatedAtMillis: Value(now),
        ),
      );
      await (_db.update(_db.learningEvents)..where((t) => t.localProfileId.equals(profile.localId))).write(
        LearningEventsCompanion(firebaseUid: Value(uid)),
      );
    });
    return _finishCloudProfile(
      profile.copyWith(firebaseUid: Value(uid), publicStudentId: studentId, authState: 'registered', updatedAtMillis: now),
      uid,
    );
  }

  Future<AuthResult> _finishCloudProfile(StudentProfile profile, String uid) async {
    if (_studentRemote == null) {
      return const AuthResult(success: true, message: 'Kemajuan disimpan pada peranti.');
    }
    try {
      await _studentRemote.upsertStudent(uid, {
        'schemaVersion': 1,
        'publicStudentId': profile.publicStudentId,
        'displayName': profile.displayName,
        'createdAtMillis': profile.createdAtMillis,
        'updatedAtMillis': profile.updatedAtMillis,
      });
      await _registerInstallation(uid);
      await _secureStorage.delete(key: _pendingPinKey);
      if (kDebugMode) debugPrint('[AmiNProgress] registration_completed');
      return AuthResult(success: true, message: 'ID Pelajar anda ialah ${profile.publicStudentId}.');
    } catch (_) {
      return const AuthResult(
        success: true,
        message: 'Kemajuan disimpan pada peranti dan akan disandarkan apabila dalam talian.',
      );
    }
  }

  @override
  Future<AuthResult> recover(String studentId, String pin) async {
    if (kDebugMode) debugPrint('[AmiNProgress] recovery_started');
    if (!StudentIdentity.isValidPin(pin)) {
      return const AuthResult(success: false, message: 'PIN mesti mempunyai 6 nombor.');
    }
    if (_auth == null || _studentRemote == null || _progressRemote == null) {
      return const AuthResult(success: false, message: 'Pemulihan memerlukan sambungan internet.');
    }
    try {
      final normalized = StudentIdentity.normalize(studentId);
      final credential = await _auth.signInWithEmailAndPassword(
        email: StudentIdentity.internalEmail(normalized),
        password: pin,
      );
      final uid = credential.user!.uid;
      final state = await _progressRemote.fetchRecoveryState(uid);
      final student = state['student'];
      if (student is! Map<String, dynamic>) {
        await _auth.signOut();
        return const AuthResult(success: false, message: 'Data pelajar tidak ditemui.');
      }
      await _restore(uid, normalized, student, state);
      await _registerInstallation(uid);
      if (kDebugMode) debugPrint('[AmiNProgress] recovery_completed');
      return const AuthResult(success: true, message: 'Data berjaya dipulihkan.');
    } on FormatException catch (error) {
      return AuthResult(success: false, message: error.message.toString());
    } on FirebaseAuthException {
      return const AuthResult(success: false, message: 'ID Pelajar atau PIN tidak betul.');
    } catch (_) {
      return const AuthResult(success: false, message: 'Pemulihan tidak berjaya. Cuba lagi apabila dalam talian.');
    }
  }

  Future<void> _restore(
    String uid,
    String studentId,
    Map<String, dynamic> student,
    Map<String, dynamic> state,
  ) async {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    await _db.transaction(() async {
      await _db.delete(_db.syncQueueItems).go();
      await _db.delete(_db.learningEvents).go();
      await _db.delete(_db.quizAnswers).go();
      await _db.delete(_db.quizAttempts).go();
      await _db.delete(_db.gameSessions).go();
      await _db.delete(_db.learningSessions).go();
      await _db.delete(_db.lessonProgressRows).go();
      await _db.delete(_db.legacyProgressBaselines).go();
      await _db.delete(_db.syncMetadataRows).go();
      await _db.delete(_db.installations).go();
      await _db.delete(_db.studentProfiles).go();
      final localId = const Uuid().v4();
      await _db.into(_db.studentProfiles).insert(
        StudentProfilesCompanion.insert(
          localId: localId,
          firebaseUid: Value(uid),
          publicStudentId: studentId,
          displayName: '${student['displayName'] ?? 'Pelajar'}',
          authState: const Value('registered'),
          createdAtMillis: _asInt(student['createdAtMillis'], now),
          updatedAtMillis: now,
        ),
      );
      final lessons = state['lessonProgress'];
      if (lessons is Map) {
        for (final entry in lessons.entries) {
          final data = Map<String, dynamic>.from(entry.value as Map);
          await _db.into(_db.lessonProgressRows).insertOnConflictUpdate(
            LessonProgressRowsCompanion.insert(
              localProfileId: localId,
              lessonId: '${entry.key}',
              status: Value('${data['status'] ?? 'started'}'),
              startedAtMillis: _asInt(data['startedAtMillis'], now),
              completedAtMillis: Value(_nullableInt(data['completedAtMillis'])),
              totalTimeSpentSeconds: Value(_asInt(data['totalTimeSpentSeconds'], 0)),
              visitCount: Value(_asInt(data['visitCount'], 1)),
              updatedAtMillis: _asInt(data['updatedAtMillis'], now),
            ),
          );
        }
      }
      final attempts = state['quizAttempts'];
      if (attempts is Map) {
        for (final entry in attempts.entries) {
          final data = Map<String, dynamic>.from(entry.value as Map);
          final attemptId = '${entry.key}';
          await _db.into(_db.quizAttempts).insertOnConflictUpdate(
            QuizAttemptsCompanion.insert(
              attemptId: attemptId,
              localProfileId: localId,
              quizId: '${data['quizId'] ?? 'MALAYALAM_QUIZ'}',
              quizLevel: '${data['quizLevel'] ?? 'all'}',
              status: Value('${data['status'] ?? 'completed'}'),
              startedAtMillis: _asInt(data['startedAtMillis'], now),
              completedAtMillis: Value(_nullableInt(data['completedAtMillis'])),
              correctAnswers: Value(_asInt(data['correctAnswers'], 0)),
              wrongAnswers: Value(_asInt(data['wrongAnswers'], 0)),
              bonusCorrect: Value(_asInt(data['bonusCorrect'], 0)),
              totalScore: Value(_asInt(data['totalScore'], 0)),
              durationSeconds: Value(_asInt(data['durationSeconds'], 0)),
            ),
          );
          final answers = data['answers'];
          if (answers is List) {
            for (final rawAnswer in answers.whereType<Map>()) {
              final answer = Map<String, dynamic>.from(rawAnswer);
              final questionId = '${answer['questionId'] ?? ''}';
              if (questionId.isEmpty) continue;
              await _db.into(_db.quizAnswers).insertOnConflictUpdate(
                QuizAnswersCompanion.insert(
                  answerId: '$attemptId:$questionId',
                  attemptId: attemptId,
                  questionId: questionId,
                  selectedAnswer: '${answer['selectedAnswer'] ?? ''}',
                  isAutoGraded: Value(answer['isAutoGraded'] != false),
                  isCorrect: answer['isCorrect'] == true,
                  isBonusQuestion: answer['isBonusQuestion'] == true,
                  responseTimeMilliseconds: _asInt(answer['responseTimeMilliseconds'], 0),
                  answeredAtMillis: _asInt(answer['answeredAtMillis'], now),
                ),
              );
            }
          }
        }
      }
      final games = state['gameSessions'];
      if (games is Map) {
        for (final entry in games.entries) {
          final data = Map<String, dynamic>.from(entry.value as Map);
          await _db.into(_db.gameSessions).insertOnConflictUpdate(
            GameSessionsCompanion.insert(
              gameSessionId: '${entry.key}',
              localProfileId: localId,
              gameType: '${data['gameType'] ?? 'unknown'}',
              gameId: '${data['gameId'] ?? entry.key}',
              status: Value('${data['status'] ?? 'completed'}'),
              startedAtMillis: _asInt(data['startedAtMillis'], now),
              completedAtMillis: Value(_nullableInt(data['completedAtMillis'])),
              durationSeconds: Value(_asInt(data['durationSeconds'], 0)),
              score: Value(_nullableInt(data['score'])),
              correctCount: Value(_nullableInt(data['correctCount'])),
              wrongCount: Value(_nullableInt(data['wrongCount'])),
              attemptCount: Value(_nullableInt(data['attemptCount'])),
            ),
          );
        }
      }
      final sessions = state['learningSessions'];
      if (sessions is Map) {
        for (final entry in sessions.entries) {
          final data = Map<String, dynamic>.from(entry.value as Map);
          await _db.into(_db.learningSessions).insertOnConflictUpdate(
            LearningSessionsCompanion.insert(
              sessionId: '${entry.key}',
              localProfileId: localId,
              startedAtMillis: _asInt(data['startedAtMillis'], now),
              endedAtMillis: Value(_nullableInt(data['endedAtMillis'])),
              activeLearningSeconds: Value(_asInt(data['activeLearningSeconds'], 0)),
              status: const Value('ended'),
            ),
          );
        }
      }
      final summary = state['summary'];
      if (summary is Map) {
        final restoredAnswers = await (_db.select(_db.quizAnswers).join([
          innerJoin(_db.quizAttempts, _db.quizAttempts.attemptId.equalsExp(_db.quizAnswers.attemptId)),
        ])..where(_db.quizAttempts.localProfileId.equals(localId))).get();
        final restoredAttempts = await (_db.select(_db.quizAttempts)
              ..where((t) => t.localProfileId.equals(localId) & t.status.equals('completed')))
            .get();
        final restoredGames = await (_db.select(_db.gameSessions)
              ..where((t) => t.localProfileId.equals(localId) & t.status.equals('completed')))
            .get();
        final representedQuestions = restoredAnswers.map((r) => r.readTable(_db.quizAnswers).questionId).toSet().length;
        final representedCorrect = restoredAnswers.where((r) => r.readTable(_db.quizAnswers).isCorrect).length;
        final representedGameEarned = restoredGames.fold<int>(0, (sum, row) => sum + (row.correctCount ?? row.score ?? 0));
        final representedGamePossible = restoredGames.fold<int>(0, (sum, row) => sum + (row.correctCount ?? 0) + (row.wrongCount ?? 0));
        await _db.into(_db.legacyProgressBaselines).insertOnConflictUpdate(
          LegacyProgressBaselinesCompanion.insert(
            localProfileId: localId,
            quizAnswered: Value((_asInt(summary['quizQuestionsCompleted'], 0) - representedQuestions).clamp(0, 1 << 30)),
            quizAutoCorrect: Value((_asInt(summary['quizCorrectAnswers'], 0) - representedCorrect).clamp(0, 1 << 30)),
            quizAutoTotal: Value((_asInt(summary['quizAutoTotal'], 0) - restoredAnswers.length).clamp(0, 1 << 30)),
            quizSessionsCompleted: Value((_asInt(summary['quizLevelsCompleted'], 0) - restoredAttempts.length).clamp(0, 1 << 30)),
            gameStarsEarned: Value((_asInt(summary['gameScoreEarned'], 0) - representedGameEarned).clamp(0, 1 << 30)),
            gameStarsPossible: Value((_asInt(summary['gameScorePossible'], 0) - representedGamePossible).clamp(0, 1 << 30)),
            gameSessionsCompleted: Value((_asInt(summary['gamesCompleted'], 0) - restoredGames.length).clamp(0, 1 << 30)),
            migratedAtMillis: now,
          ),
        );
      }
    });
  }

  Future<void> _registerInstallation(String uid) async {
    final installation = await (_db.select(_db.installations)
          ..where((t) => t.installationId.equals(_installationId)))
        .getSingleOrNull();
    if (installation == null || _studentRemote == null) return;
    await _studentRemote.upsertInstallation(uid, _installationId, {
      'schemaVersion': 1,
      'platform': installation.platform,
      'appVersion': installation.appVersion,
      'firstSeenAtMillis': installation.firstSeenAtMillis,
      'lastSeenAtMillis': installation.lastSeenAtMillis,
      'lastSyncAtMillis': installation.lastSyncAtMillis,
    });
  }

  Future<StudentProfile?> _currentProfile() =>
      _db.select(_db.studentProfiles).getSingleOrNull();

  static int _asInt(Object? value, int fallback) => value is num ? value.toInt() : fallback;
  static int? _nullableInt(Object? value) => value is num ? value.toInt() : null;

  @override
  Future<void> signOut() => _auth?.signOut() ?? Future.value();
}
