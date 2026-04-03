import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'progress_snapshot.dart';

class ProgressSyncResult {
  const ProgressSyncResult({
    required this.success,
    required this.message,
    this.statusCode,
    this.data,
  });

  final bool success;
  final String message;
  final int? statusCode;
  final dynamic data;
}

class ProgressSyncService {
  ProgressSyncService._();

  static final ProgressSyncService instance = ProgressSyncService._();

  static const String defaultBaseUrl = 'http://10.0.2.2:8000';
  static const Duration requestTimeout = Duration(seconds: 8);

  Uri baseUri = Uri.parse(defaultBaseUrl);

  Uri get studentsUri => baseUri.resolve('/api/students');
  Uri get progressUri => baseUri.resolve('/api/progress');
  Uri get dashboardSummaryUri => baseUri.resolve('/api/dashboard/summary');
  Uri get legacyProgressUri => baseUri.resolve('/api/progress');

  void configureBaseUrl(String rawBaseUrl) {
    final parsed = Uri.tryParse(rawBaseUrl.trim());
    if (parsed != null &&
        (parsed.scheme == 'http' || parsed.scheme == 'https')) {
      baseUri = parsed;
    }
  }

  Future<ProgressSyncResult> registerStudent({
    required String userId,
    required String name,
    DateTime? createdAt,
    DateTime? updatedAt,
    Uri? overrideEndpoint,
  }) {
    final now = DateTime.now().toUtc();
    final payload = <String, dynamic>{
      'userId': userId,
      'name': name,
      'createdAt': (createdAt ?? now).toIso8601String(),
      'updatedAt': (updatedAt ?? now).toIso8601String(),
    };
    return _postJson(
      uri: overrideEndpoint ?? studentsUri,
      payload: payload,
      successMessage: 'Pelajar didaftarkan.',
      actionLabel: 'Daftar pelajar',
    );
  }

  Future<ProgressSyncResult> upsertProgress({
    required String userId,
    required String lessonId,
    required String status,
    required int score,
    DateTime? updatedAt,
    Uri? overrideEndpoint,
  }) {
    final payload = <String, dynamic>{
      'userId': userId,
      'lessonId': lessonId,
      'status': status,
      'score': score.clamp(0, 100),
      'updatedAt': (updatedAt ?? DateTime.now().toUtc()).toIso8601String(),
    };
    return _postJson(
      uri: overrideEndpoint ?? progressUri,
      payload: payload,
      successMessage: 'Kemajuan dihantar.',
      actionLabel: 'Hantar kemajuan',
    );
  }

  Future<ProgressSyncResult> uploadLegacySnapshot({
    required String userName,
    required ProgressSnapshot snapshot,
    Uri? overrideEndpoint,
  }) {
    final payload = <String, dynamic>{
      'userName': userName,
      'capturedAtUtc': DateTime.now().toUtc().toIso8601String(),
      'progress': <String, dynamic>{
        ...snapshot.toJson(),
        'onboardingRatio': snapshot.onboardingRatio,
        'belajarRatio': snapshot.belajarRatio,
        'quizRatio': snapshot.quizRatio,
        'gameRatio': snapshot.gameRatio,
        'overallRatio': snapshot.overallRatio,
      },
    };
    return _postJson(
      uri: overrideEndpoint ?? legacyProgressUri,
      payload: payload,
      successMessage: 'Legacy snapshot dihantar.',
      actionLabel: 'Hantar legacy snapshot',
    );
  }

  Future<ProgressSyncResult> fetchStudentByUserId({
    required String userId,
    Uri? overrideEndpoint,
  }) async {
    final encodedUserId = Uri.encodeComponent(userId);
    final endpoint =
        overrideEndpoint ?? baseUri.resolve('/api/students/$encodedUserId');
    try {
      final response = await http.get(endpoint).timeout(requestTimeout);
      if (response.statusCode == 404) {
        return const ProgressSyncResult(
          success: false,
          message: 'User ID tidak ditemui.',
          statusCode: 404,
        );
      }
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return ProgressSyncResult(
            success: true,
            message: 'Data pelajar dijumpai.',
            statusCode: response.statusCode,
            data: decoded,
          );
        }
      }
      return ProgressSyncResult(
        success: false,
        message: 'Dapatkan data pelajar gagal (HTTP ${response.statusCode}).',
        statusCode: response.statusCode,
      );
    } on TimeoutException {
      return const ProgressSyncResult(
        success: false,
        message: 'Dapatkan data pelajar gagal: timeout.',
      );
    } catch (error) {
      return ProgressSyncResult(
        success: false,
        message: 'Dapatkan data pelajar gagal: $error',
      );
    }
  }

  Future<ProgressSyncResult> fetchProgressByUserId({
    required String userId,
    Uri? overrideEndpoint,
  }) async {
    final encodedUserId = Uri.encodeComponent(userId);
    final endpoint =
        overrideEndpoint ?? baseUri.resolve('/api/progress/$encodedUserId');
    try {
      final response = await http.get(endpoint).timeout(requestTimeout);
      if (response.statusCode == 404) {
        return const ProgressSyncResult(
          success: false,
          message: 'Kemajuan untuk User ID tidak ditemui.',
          statusCode: 404,
        );
      }
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          return ProgressSyncResult(
            success: true,
            message: 'Data kemajuan dijumpai.',
            statusCode: response.statusCode,
            data: decoded,
          );
        }
      }
      return ProgressSyncResult(
        success: false,
        message: 'Dapatkan kemajuan gagal (HTTP ${response.statusCode}).',
        statusCode: response.statusCode,
      );
    } on TimeoutException {
      return const ProgressSyncResult(
        success: false,
        message: 'Dapatkan kemajuan gagal: timeout.',
      );
    } catch (error) {
      return ProgressSyncResult(
        success: false,
        message: 'Dapatkan kemajuan gagal: $error',
      );
    }
  }

  Future<ProgressSyncResult> _postJson({
    required Uri uri,
    required Map<String, dynamic> payload,
    required String successMessage,
    required String actionLabel,
  }) async {
    try {
      final response = await http
          .post(
            uri,
            headers: const <String, String>{'Content-Type': 'application/json'},
            body: jsonEncode(payload),
          )
          .timeout(requestTimeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ProgressSyncResult(
          success: true,
          message: successMessage,
          statusCode: response.statusCode,
        );
      }

      return ProgressSyncResult(
        success: false,
        message: '$actionLabel gagal (HTTP ${response.statusCode}).',
        statusCode: response.statusCode,
      );
    } on TimeoutException {
      return ProgressSyncResult(
        success: false,
        message: '$actionLabel gagal: timeout.',
      );
    } catch (error) {
      return ProgressSyncResult(
        success: false,
        message: '$actionLabel gagal: $error',
      );
    }
  }
}
