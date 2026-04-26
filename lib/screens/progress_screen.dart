import 'package:flutter/material.dart';

import '../shared/design/app_design_tokens.dart';
import '../shared/gamification/gamification.dart';
import '../shared/progress/progress_snapshot.dart';
import '../shared/progress/progress_sync_service.dart';
import '../shared/progress/progress_tracker.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key, required this.name});

  final String name;

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  ProgressTracker get _tracker => ProgressTracker.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tracker.setUserName(widget.name);
    });
  }

  Widget _progressTile({
    required String title,
    required String subtitle,
    required double value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: LessonCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            StarProgressBar(value: value, foregroundColor: color),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gamification = GamificationScope.of(context);
    return AnimatedBuilder(
      animation: _tracker,
      builder: (context, _) {
        final snapshot = _tracker.snapshot;
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Row(
              children: [
                const Text(
                  'Kemajuan',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                StreakWidget(streak: gamification.streak, compact: true),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final contentWidth = constraints.maxWidth;
                return SizedBox.expand(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: contentWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kemajuan pembelajaran ${widget.name}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 14),
                            _progressTile(
                              title: 'Onboarding',
                              subtitle:
                                  'Langkah awal: ${snapshot.onboardingReached}/${snapshot.onboardingTotal}',
                              value: snapshot.onboardingRatio,
                              color: const Color(0xFF4C78A8),
                            ),
                            _progressTile(
                              title: 'Belajar',
                              subtitle:
                                  'Modul selesai: ${snapshot.totalLearningReached}/${snapshot.totalLearningSteps}',
                              value: snapshot.belajarRatio,
                              color: const Color(0xFF2A9D8F),
                            ),
                            _progressTile(
                              title: 'Kuiz',
                              subtitle:
                                  'Soalan: ${snapshot.quizAnswered}/${snapshot.quizQuestionGoal} | Ketepatan: ${snapshot.quizAccuracyPercent}%',
                              value: snapshot.quizRatio,
                              color: const Color(0xFFF4A261),
                            ),
                            _progressTile(
                              title: 'Main',
                              subtitle:
                                  'Skor aktiviti: ${snapshot.gameStarsEarned}/${snapshot.gameStarsPossible} (${snapshot.gameSessionsCompleted} sesi)',
                              value: snapshot.gameRatio,
                              color: const Color(0xFFE76F51),
                            ),
                            _progressTile(
                              title: 'Keseluruhan',
                              subtitle: 'Skor kemajuan semasa',
                              value: snapshot.overallRatio,
                              color: const Color(0xFF1D3557),
                            ),
                            _syncCard(snapshot),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _syncCard(ProgressSnapshot snapshot) {
    final syncError = _tracker.lastSyncError;
    final syncedAt = _tracker.lastSyncedUtc;
    final String statusText;
    if (_tracker.isSyncing) {
      statusText = 'Sedang muat naik...';
    } else if (syncError != null) {
      statusText = syncError;
    } else if (syncedAt != null) {
      statusText = 'Muat naik terakhir: ${_formatDateTime(syncedAt.toLocal())}';
    } else {
      statusText = 'Belum pernah dimuat naik.';
    }

    return LessonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Integrasi Dashboard',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            'Base URL: ${ProgressSyncService.instance.baseUri}',
            style: const TextStyle(
              color: Color(0xFF4A5568),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'User ID: ${_tracker.userId.isEmpty ? '(belum dijana)' : _tracker.userId}',
            style: const TextStyle(
              color: Color(0xFF4A5568),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            statusText,
            style: TextStyle(
              color: syncError == null
                  ? const Color(0xFF1D3557)
                  : const Color(0xFFC0392B),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          AnimatedKidButton(
            label: 'Muat naik sekarang',
            icon: Icons.cloud_upload_rounded,
            onPressed: _tracker.isSyncing ? null : _tracker.forceSync,
          ),
          const SizedBox(height: 8),
          Text(
            'Data dihantar termasuk skor belajar, kuiz, main, dan masa kemas kini (${snapshot.lastUpdatedUtc.toLocal()}).',
            style: const TextStyle(
              color: Color(0xFF4A5568),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime value) {
    String twoDigits(int number) => number.toString().padLeft(2, '0');
    return '${value.year}-${twoDigits(value.month)}-${twoDigits(value.day)} '
        '${twoDigits(value.hour)}:${twoDigits(value.minute)}:${twoDigits(value.second)}';
  }
}
