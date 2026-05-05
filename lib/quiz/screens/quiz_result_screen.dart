import 'package:flutter/material.dart';

import '../../core/audio/winning_screen_audio.dart';
import '../../shared/gamification/gamification.dart';
import '../../shared/motion/app_motion_navigation.dart';
import '../logic/quiz_level_utils.dart';
import '../models/quiz_level.dart';
import 'quiz_level_gateway_screen.dart';
import 'quiz_shell_screen.dart';

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({
    super.key,
    required this.name,
    required this.level,
    required this.totalQuestions,
    required this.autoGradedQuestions,
    required this.correctAnswers,
    required this.manualCompleted,
    this.bonusCorrectAnswers = 0,
  });

  final String name;
  final QuizLevel? level;
  final int totalQuestions;
  final int autoGradedQuestions;
  final int correctAnswers;
  final int manualCompleted;
  final int bonusCorrectAnswers;

  QuizLevel? get _nextLevel => nextQuizLevel(level);

  int get _scoreBase {
    if (autoGradedQuestions > 0) {
      return autoGradedQuestions;
    }
    if (totalQuestions > 0) {
      return totalQuestions;
    }
    return 10;
  }

  String _levelResultLabel(QuizLevel? value) {
    switch (value) {
      case QuizLevel.easy:
        return 'Tahap Rendah';
      case QuizLevel.medium:
        return 'Tahap Sederhana';
      case QuizLevel.hard:
        return 'Tahap Sukar';
      case null:
        return 'kuiz ini';
    }
  }

  Color _headlineColor(QuizLevel? value) {
    switch (value) {
      case QuizLevel.easy:
        return const Color(0xFF1E8F46);
      case QuizLevel.medium:
        return const Color(0xFFEB8400);
      case QuizLevel.hard:
        return const Color(0xFF1E3A8A);
      case null:
        return const Color(0xFF1E3A8A);
    }
  }

  Color _primaryButtonColor(QuizLevel? value) {
    switch (value) {
      case QuizLevel.easy:
        return const Color(0xFF1F9B4F);
      case QuizLevel.medium:
        return const Color(0xFFF38B00);
      case QuizLevel.hard:
        return const Color(0xFF215EC7);
      case null:
        return const Color(0xFF215EC7);
    }
  }

  _UnlockTheme _unlockTheme() {
    final nextLevel = _nextLevel;
    if (nextLevel == QuizLevel.medium) {
      return const _UnlockTheme(
        background: Color(0xFFEAF8ED),
        border: Color(0xFFD2EAD7),
        iconColor: Color(0xFF2CA54A),
      );
    }
    if (nextLevel == QuizLevel.hard) {
      return const _UnlockTheme(
        background: Color(0xFFFFF3E5),
        border: Color(0xFFF5DFC0),
        iconColor: Color(0xFFEE8A00),
      );
    }
    return const _UnlockTheme(
      background: Color(0xFFEAF1FF),
      border: Color(0xFFD6E4FF),
      iconColor: Color(0xFF2A69D8),
    );
  }

  String get _primaryButtonLabel {
    final nextLevel = _nextLevel;
    if (nextLevel != null) {
      return 'Teruskan ke ${_levelResultLabel(nextLevel)}';
    }
    return 'Menu Kuiz';
  }

  void _goToNext(BuildContext context) {
    final nextLevel = _nextLevel;
    final gamification = GamificationScope.of(context);
    if (nextLevel != null) {
      gamification.unlockLevel(label: quizLevelLabel(nextLevel));
      pushReplacementAdaptive(
        context,
        QuizShellScreen(name: name, level: nextLevel),
      );
      return;
    }
    pushReplacementAdaptive(context, QuizLevelGatewayScreen(name: name));
  }

  Widget _buildCompletionText() {
    if (level == null) {
      return const Text(
        'Anda telah menamatkan\nkuiz ini.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          height: 1.28,
          fontWeight: FontWeight.w600,
          color: Color(0xFF0F172A),
        ),
      );
    }

    final levelLabel = _levelResultLabel(level);
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(
          fontSize: 16,
          height: 1.28,
          fontWeight: FontWeight.w600,
          color: Color(0xFF0F172A),
        ),
        children: [
          const TextSpan(text: 'Anda telah menamatkan\nkuiz '),
          TextSpan(
            text: levelLabel,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: _headlineColor(level),
            ),
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }

  Widget _buildPerformanceHeadline() {
    final color = _headlineColor(level);
    return Row(
      children: [
        const Icon(
          Icons.auto_awesome_rounded,
          size: 28,
          color: Color(0xFFF7C948),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            'Hebat! Teruskan\nusaha anda!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              height: 1.08,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ),
        const SizedBox(width: 4),
        const Icon(
          Icons.auto_awesome_rounded,
          size: 28,
          color: Color(0xFFF7C948),
        ),
      ],
    );
  }

  Widget _buildScoreCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _ResultInfoRow(
            icon: Icons.star_rounded,
            iconColor: const Color(0xFF2A69D8),
            label: 'Markah:',
            value: '$correctAnswers / $_scoreBase',
            valueColor: const Color(0xFF1E5BC1),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Color(0xFFE8EBF0)),
          ),
          _ResultInfoRow(
            icon: Icons.redeem_rounded,
            iconColor: const Color(0xFF2FA24A),
            label: 'Bonus:',
            value: '$bonusCorrectAnswers',
            valueColor: const Color(0xFF1D8E38),
          ),
        ],
      ),
    );
  }

  Widget _buildUnlockCard() {
    final nextLevel = _nextLevel;
    final theme = _unlockTheme();

    final subtitleText = nextLevel == null
        ? 'Teruskan belajar dan cuba lagi untuk markah terbaik!'
        : 'Teruskan ke tahap seterusnya!';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: theme.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.emoji_events_rounded, size: 54, color: theme.iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                    children: [
                      const TextSpan(text: 'Tahniah! '),
                      if (nextLevel != null)
                        TextSpan(
                          text: _levelResultLabel(nextLevel),
                          style: TextStyle(
                            color: quizLevelColor(nextLevel),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      if (nextLevel != null)
                        const TextSpan(text: '\ntelah dibuka.')
                      else
                        const TextSpan(text: 'Semua tahap kuiz telah selesai.'),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitleText,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isHighScore = correctAnswers >= ((_scoreBase * 0.8).ceil());
    final showDedicatedMenuButton = _nextLevel != null;
    final disableScrollForLevel =
        level == QuizLevel.easy || level == QuizLevel.medium;

    final resultContent = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 490),
      child: ConfettiCelebration(
        active: isHighScore,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const MascotWidget(
              assetPath: 'assets/Action Figures/AmiN answer correct.svg',
              width: 178,
              height: 178,
              state: MascotState.celebrate,
            ),
            const SizedBox(height: 4),
            Text(
              'Hai, $name!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 42,
                height: 1.08,
                fontWeight: FontWeight.w900,
                color: Color(0xFF123B8C),
              ),
            ),
            const SizedBox(height: 8),
            _buildCompletionText(),
            const SizedBox(height: 14),
            _buildPerformanceHeadline(),
            const SizedBox(height: 14),
            _buildScoreCard(),
            const SizedBox(height: 12),
            _buildUnlockCard(),
            const SizedBox(height: 14),
            _ResultActionButton(
              label: _primaryButtonLabel,
              icon: Icons.arrow_forward_rounded,
              filled: true,
              color: _primaryButtonColor(level),
              onTap: () => _goToNext(context),
            ),
            if (showDedicatedMenuButton) ...[
              const SizedBox(height: 10),
              _ResultActionButton(
                label: 'Menu Kuiz',
                icon: Icons.format_list_bulleted_rounded,
                filled: false,
                color: const Color(0xFF215EC7),
                onTap: () {
                  pushReplacementAdaptive(
                    context,
                    QuizLevelGatewayScreen(name: name),
                  );
                },
              ),
            ],
            const SizedBox(height: 10),
            _ResultActionButton(
              label: 'Cuba Lagi',
              icon: Icons.refresh_rounded,
              filled: false,
              color: const Color(0xFF215EC7),
              onTap: () {
                pushReplacementAdaptive(
                  context,
                  QuizShellScreen(name: name, level: level),
                );
              },
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF3),
      body: Stack(
        children: [
          const WinningScreenAudioCue(),
          SafeArea(
            child: Center(
              child: disableScrollForLevel
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SizedBox(
                            width: constraints.maxWidth,
                            height: constraints.maxHeight,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.topCenter,
                              child: SizedBox(
                                width: constraints.maxWidth,
                                child: resultContent,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                      child: resultContent,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultInfoRow extends StatelessWidget {
  const _ResultInfoRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: iconColor,
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w900,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _ResultActionButton extends StatelessWidget {
  const _ResultActionButton({
    required this.label,
    required this.icon,
    required this.filled,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool filled;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(18);
    if (filled) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onTap,
          icon: Icon(icon, size: 28),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            elevation: 0,
            minimumSize: const Size.fromHeight(62),
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );
    }
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 28),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color.withValues(alpha: 0.32), width: 2),
          minimumSize: const Size.fromHeight(62),
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _UnlockTheme {
  const _UnlockTheme({
    required this.background,
    required this.border,
    required this.iconColor,
  });

  final Color background;
  final Color border;
  final Color iconColor;
}
