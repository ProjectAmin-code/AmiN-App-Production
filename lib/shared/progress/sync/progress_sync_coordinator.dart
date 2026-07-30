import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../data/local_progress_repository.dart';
import '../data/progress_database.dart';
import '../data/remote_data_sources.dart';

class ProgressSyncCoordinator {
  ProgressSyncCoordinator({
    required this.database,
    required this.local,
    required this.remote,
    required this.uidProvider,
    this.batchSize = 100,
  });

  final ProgressDatabase database;
  final LocalProgressRepository local;
  final SyncRemoteDataSource? remote;
  final String? Function() uidProvider;
  final int batchSize;
  bool _running = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Timer? _debounce;
  VoidCallback? onStatusChanged;

  bool get isRunning => _running;

  void startConnectivityMonitoring() {
    _connectivitySubscription ??= Connectivity().onConnectivityChanged.listen((results) {
      if (!results.contains(ConnectivityResult.none)) schedule();
    });
  }

  void schedule() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 2), syncNow);
  }

  Future<bool> syncNow({bool ignoreBackoff = false}) async {
    final uid = uidProvider();
    if (_running || uid == null || remote == null) return false;
    _running = true;
    if (kDebugMode) debugPrint('[AmiNProgress] sync_started');
    onStatusChanged?.call();
    try {
      while (true) {
        final now = DateTime.now().toUtc().millisecondsSinceEpoch;
        final query = database.select(database.syncQueueItems)
          ..where((t) => t.status.isIn(['pending', 'failed']));
        if (!ignoreBackoff) {
          query.where((t) => t.nextAttemptAtMillis.isNull() | t.nextAttemptAtMillis.isSmallerOrEqualValue(now));
        }
        query
          ..orderBy([(t) => OrderingTerm.asc(t.createdAtMillis)])
          ..limit(batchSize);
        final items = await query.get();
        if (items.isEmpty) break;
        final ids = items.map((e) => e.queueId).toList();
        await (database.update(database.syncQueueItems)..where((t) => t.queueId.isIn(ids))).write(
          SyncQueueItemsCompanion(status: const Value('syncing'), updatedAtMillis: Value(now)),
        );
        try {
          if (kDebugMode) debugPrint('[AmiNProgress] sync_batch {size: ${items.length}}');
          final writes = items.map((item) {
            final decoded = jsonDecode(item.payloadJson);
            return RemoteWrite(
              path: 'students/$uid/${item.documentPath}',
              data: Map<String, dynamic>.from(decoded as Map),
            );
          }).toList();
          await remote!.writeBatch(writes);
          if (kDebugMode) debugPrint('[AmiNProgress] sync_batch_completed {size: ${items.length}}');
          final syncedAt = DateTime.now().toUtc().millisecondsSinceEpoch;
          await database.transaction(() async {
            await (database.update(database.syncQueueItems)..where((t) => t.queueId.isIn(ids))).write(
              SyncQueueItemsCompanion(status: const Value('synced'), lastError: const Value(null), nextAttemptAtMillis: const Value(null), updatedAtMillis: Value(syncedAt)),
            );
            final eventIds = items.where((e) => e.queueId.startsWith('event:')).map((e) => e.documentId).toList();
            if (eventIds.isNotEmpty) {
              await (database.update(database.learningEvents)..where((t) => t.eventId.isIn(eventIds))).write(
                LearningEventsCompanion(syncStatus: const Value('synced'), syncedAtMillis: Value(syncedAt)),
              );
            }
            final profile = await local.currentProfile();
            if (profile != null) {
              await database.into(database.syncMetadataRows).insertOnConflictUpdate(
                SyncMetadataRowsCompanion.insert(localProfileId: profile.localId, lastSyncAtMillis: Value(syncedAt), lastResult: const Value('Sandaran berjaya.')),
              );
              await (database.update(database.installations)..where((t) => t.installationId.equals(local.installationId))).write(
                InstallationsCompanion(lastSyncAtMillis: Value(syncedAt), lastSeenAtMillis: Value(syncedAt)),
              );
            }
          });
        } catch (error) {
          if (kDebugMode) debugPrint('[AmiNProgress] sync_failed {errorType: ${error.runtimeType}}');
          final attempt = items.fold<int>(0, (maxValue, row) => max(maxValue, row.attemptCount)) + 1;
          final delaySeconds = min(3600, 5 * pow(2, min(attempt, 8)).toInt()) + Random().nextInt(5);
          final retryAt = DateTime.now().toUtc().add(Duration(seconds: delaySeconds)).millisecondsSinceEpoch;
          await (database.update(database.syncQueueItems)..where((t) => t.queueId.isIn(ids))).write(
            SyncQueueItemsCompanion(
              status: const Value('failed'),
              attemptCount: Value(attempt),
              nextAttemptAtMillis: Value(retryAt),
              lastError: Value(_sanitize(error)),
              updatedAtMillis: Value(DateTime.now().toUtc().millisecondsSinceEpoch),
            ),
          );
          final profile = await local.currentProfile();
          if (profile != null) {
            final previous = await (database.select(database.syncMetadataRows)
                  ..where((t) => t.localProfileId.equals(profile.localId)))
                .getSingleOrNull();
            await database.into(database.syncMetadataRows).insertOnConflictUpdate(
              SyncMetadataRowsCompanion.insert(
                localProfileId: profile.localId,
                lastSyncAtMillis: Value(previous?.lastSyncAtMillis),
                lastResult: const Value('Sandaran belum berjaya. Kemajuan selamat pada peranti.'),
              ),
            );
          }
          break;
        }
      }
      return true;
    } finally {
      _running = false;
      onStatusChanged?.call();
    }
  }

  Future<void> dispose() async {
    _debounce?.cancel();
    await _connectivitySubscription?.cancel();
  }

  static String _sanitize(Object error) {
    final text = error.toString();
    return text.length <= 180 ? text : text.substring(0, 180);
  }
}
