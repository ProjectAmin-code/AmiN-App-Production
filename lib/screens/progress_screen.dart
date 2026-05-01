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
    required bool compact,
  }) {
    return LessonCard(
      padding: EdgeInsets.all(compact ? 12 : 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: compact ? 16 : 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            softWrap: true,
            style: TextStyle(
              fontSize: compact ? 13 : 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          StarProgressBar(value: value, foregroundColor: color),
        ],
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
            title: const Text(
              'Kemajuan',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 12),
                child: Center(
                  child: StreakWidget(
                    streak: gamification.streak,
                    compact: true,
                  ),
                ),
              ),
            ],
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final horizontalPadding = constraints.maxWidth < 360
                  ? 10.0
                  : 16.0;
              final availableWidth =
                  constraints.maxWidth - horizontalPadding * 2;
              final contentWidth = availableWidth.clamp(0.0, 760.0).toDouble();
              final useTwoColumns = contentWidth >= 620;
              final gap = useTwoColumns ? 14.0 : 12.0;
              final tileWidth = useTwoColumns
                  ? ((contentWidth - gap) / 2).floorToDouble()
                  : contentWidth;
              final compact = contentWidth < 380;

              final progressTiles = <Widget>[
                _progressTile(
                  title: 'Onboarding',
                  subtitle:
                      'Langkah awal: ${snapshot.onboardingReached}/${snapshot.onboardingTotal}',
                  value: snapshot.onboardingRatio,
                  color: const Color(0xFF4C78A8),
                  compact: compact,
                ),
                _progressTile(
                  title: 'Belajar',
                  subtitle:
                      'Modul selesai: ${snapshot.totalLearningReached}/${snapshot.totalLearningSteps}',
                  value: snapshot.belajarRatio,
                  color: const Color(0xFF2A9D8F),
                  compact: compact,
                ),
                _progressTile(
                  title: 'Kuiz',
                  subtitle:
                      'Soalan: ${snapshot.quizAnswered}/${snapshot.quizQuestionGoal} | Ketepatan: ${snapshot.quizAccuracyPercent}%',
                  value: snapshot.quizRatio,
                  color: const Color(0xFFF4A261),
                  compact: compact,
                ),
                _progressTile(
                  title: 'Main',
                  subtitle:
                      'Skor aktiviti: ${snapshot.gameStarsEarned}/${snapshot.gameStarsPossible} (${snapshot.gameSessionsCompleted} sesi)',
                  value: snapshot.gameRatio,
                  color: const Color(0xFFE76F51),
                  compact: compact,
                ),
                _progressTile(
                  title: 'Keseluruhan',
                  subtitle: 'Skor kemajuan semasa',
                  value: snapshot.overallRatio,
                  color: const Color(0xFF1D3557),
                  compact: compact,
                ),
              ];

              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  12,
                  horizontalPadding,
                  20 + MediaQuery.paddingOf(context).bottom,
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: contentWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kemajuan pembelajaran ${widget.name}',
                          softWrap: true,
                          style: TextStyle(
                            fontSize: compact ? 18 : 20,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: compact ? 12 : 14),
                        Wrap(
                          spacing: gap,
                          runSpacing: gap,
                          children: [
                            for (final tile in progressTiles)
                              SizedBox(width: tileWidth, child: tile),
                          ],
                        ),
                        SizedBox(height: gap),
                        _syncCard(snapshot, compact: compact),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _syncCard(ProgressSnapshot snapshot, {required bool compact}) {
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
      padding: EdgeInsets.all(compact ? 12 : 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Integrasi Dashboard',
            style: TextStyle(
              fontSize: compact ? 16 : 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          SelectableText(
            'Base URL: ${ProgressSyncService.instance.baseUri}',
            style: TextStyle(
              fontSize: compact ? 12 : 14,
              color: Color(0xFF4A5568),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          SelectableText(
            'User ID: ${_tracker.userId.isEmpty ? '(belum dijana)' : _tracker.userId}',
            style: TextStyle(
              fontSize: compact ? 12 : 14,
              color: Color(0xFF4A5568),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            statusText,
            style: TextStyle(
              fontSize: compact ? 13 : 14,
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
            height: compact ? 48 : 54,
            labelFontSize: compact ? 15 : 18,
          ),
          const SizedBox(height: 8),
          Text(
            'Data dihantar termasuk skor belajar, kuiz, main, dan masa kemas kini (${snapshot.lastUpdatedUtc.toLocal()}).',
            softWrap: true,
            style: TextStyle(
              fontSize: compact ? 12 : 14,
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
