import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'progress_snapshot.dart';

class ProgressSyncResult {
  const ProgressSyncResult({
    required this.success,
    required this.message,
    this.statusCode,
  });

  final bool success;
  final String message;
  final int? statusCode;
}

class ProgressSyncService {
  ProgressSyncService._();

  static final ProgressSyncService instance = ProgressSyncService._();

  static const String defaultEndpoint = 'http://10.0.2.2:8000/api/progress';
  static const Duration requestTimeout = Duration(seconds: 8);

  Uri endpoint = Uri.parse(defaultEndpoint);

  void configureEndpoint(String rawEndpoint) {
    final parsed = Uri.tryParse(rawEndpoint.trim());
    if (parsed != null && (parsed.scheme == 'http' || parsed.scheme == 'https')) {
      endpoint = parsed;
    }
  }

  Future<ProgressSyncResult> uploadSnapshot({
    required String userName,
    required ProgressSnapshot snapshot,
    Uri? overrideEndpoint,
  }) async {
    final uri = overrideEndpoint ?? endpoint;
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

    try {
      final response = await http
          .post(
            uri,
            headers: const <String, String>{
              'Content-Type': 'application/json',
            },
            body: jsonEncode(payload),
          )
          .timeout(requestTimeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ProgressSyncResult(
          success: true,
          message: 'Sync berjaya.',
          statusCode: response.statusCode,
        );
      }

      return ProgressSyncResult(
        success: false,
        message: 'Sync gagal (HTTP ${response.statusCode}).',
        statusCode: response.statusCode,
      );
    } on TimeoutException {
      return const ProgressSyncResult(
        success: false,
        message: 'Sync gagal: timeout.',
      );
    } catch (error) {
      return ProgressSyncResult(
        success: false,
        message: 'Sync gagal: $error',
      );
    }
  }
}
