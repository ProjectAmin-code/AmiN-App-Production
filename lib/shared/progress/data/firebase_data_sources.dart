import 'package:cloud_firestore/cloud_firestore.dart';

import 'remote_data_sources.dart';

class FirebaseProgressDataSource
    implements
        StudentRemoteDataSource,
        ProgressRemoteDataSource,
        SyncRemoteDataSource {
  FirebaseProgressDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<void> upsertStudent(String uid, Map<String, Object?> data) async {
    final reference = _firestore.doc('students/$uid');
    await _firestore.runTransaction((transaction) async {
      final current = (await transaction.get(reference)).data();
      final currentUpdated = current?['updatedAtMillis'] as num?;
      final incomingUpdated = data['updatedAtMillis'] as num?;
      if (currentUpdated == null || incomingUpdated == null || incomingUpdated >= currentUpdated) {
        transaction.set(reference, data, SetOptions(merge: true));
      }
    });
  }

  @override
  Future<Map<String, dynamic>?> fetchStudent(String uid) async {
    return (await _firestore.doc('students/$uid').get()).data();
  }

  @override
  Future<void> upsertInstallation(
    String uid,
    String installationId,
    Map<String, Object?> data,
  ) {
    return _firestore
        .doc('students/$uid/installations/$installationId')
        .set(data, SetOptions(merge: true));
  }

  @override
  Future<void> writeBatch(List<RemoteWrite> writes) async {
    final summaryWrites = writes.where((write) => write.path.endsWith('/summary/current')).toList();
    final ordinaryWrites = writes.where((write) => !write.path.endsWith('/summary/current')).toList();
    final batch = _firestore.batch();
    for (final write in ordinaryWrites) {
      batch.set(_firestore.doc(write.path), write.data, SetOptions(merge: true));
    }
    if (ordinaryWrites.isNotEmpty) await batch.commit();
    for (final write in summaryWrites) {
      final reference = _firestore.doc(write.path);
      await _firestore.runTransaction((transaction) async {
        final current = (await transaction.get(reference)).data() ?? <String, dynamic>{};
        final merged = <String, dynamic>{...current, ...write.data};
        for (final key in const [
          'overallProgress', 'lessonsCompleted', 'quizQuestionsCompleted',
          'quizCorrectAnswers', 'quizAutoTotal', 'quizLevelsCompleted',
          'gamesCompleted', 'gameScoreEarned', 'gameScorePossible',
        ]) {
          final oldValue = current[key];
          final newValue = write.data[key];
          if (oldValue is num && newValue is num && oldValue > newValue) merged[key] = oldValue;
        }
        transaction.set(reference, merged, SetOptions(merge: true));
      });
    }
  }

  @override
  Future<Map<String, dynamic>> fetchRecoveryState(String uid) async {
    final studentRef = _firestore.collection('students').doc(uid);
    final results = await Future.wait([
      studentRef.get(),
      studentRef.collection('lesson_progress').get(),
      studentRef.collection('quiz_attempts').get(),
      studentRef.collection('game_sessions').get(),
      studentRef.collection('learning_sessions').get(),
      studentRef.collection('summary').doc('current').get(),
    ]);
    Map<String, dynamic> rows(QuerySnapshot<Map<String, dynamic>> snapshot) => {
      for (final document in snapshot.docs) document.id: document.data(),
    };
    return {
      'student': (results[0] as DocumentSnapshot<Map<String, dynamic>>).data(),
      'lessonProgress': rows(results[1] as QuerySnapshot<Map<String, dynamic>>),
      'quizAttempts': rows(results[2] as QuerySnapshot<Map<String, dynamic>>),
      'gameSessions': rows(results[3] as QuerySnapshot<Map<String, dynamic>>),
      'learningSessions': rows(results[4] as QuerySnapshot<Map<String, dynamic>>),
      'summary': (results[5] as DocumentSnapshot<Map<String, dynamic>>).data(),
    };
  }
}
