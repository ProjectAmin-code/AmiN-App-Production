import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/app_routes.dart';
import '../../shared/design/app_design_tokens.dart';
import '../../shared/motion/app_motion_navigation.dart';
import '../../shared/motion/app_motion_widgets.dart';
import '../models/quiz_level.dart';
import 'quiz_shell_screen.dart';

class QuizLevelGatewayScreen extends StatelessWidget {
  const QuizLevelGatewayScreen({
    super.key,
    required this.name,
    this.characterAdapter = const NativeAnimatedCharacterAdapter(),
  });

  final String name;
  final AnimatedCharacterAdapter characterAdapter;

  static const List<_QuizLevelItem> _levels = [
    _QuizLevelItem(
      level: QuizLevel.easy,
      title: 'Mudah',
      cardColor: Color(0xFF32C746),
      badgeColor: Color(0xFF1E9F3A),
      starCount: 1,
    ),
    _QuizLevelItem(
      level: QuizLevel.medium,
      title: 'Sederhana',
      cardColor: Color(0xFFFFB10A),
      badgeColor: Color(0xFFE88800),
      starCount: 2,
    ),
    _QuizLevelItem(
      level: QuizLevel.hard,
      title: 'Sukar',
      cardColor: Color(0xFFF0362E),
      badgeColor: Color(0xFFC92320),
      starCount: 3,
    ),
  ];

  Widget _buildLevelCard(BuildContext context, _QuizLevelItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: _QuizLevelCard(
        title: item.title,
        cardColor: item.cardColor,
        badgeColor: item.badgeColor,
        starCount: item.starCount,
        onTap: () {
          pushAdaptive(context, QuizShellScreen(name: name, level: item.level));
        },
      ),
    );
  }

  void _goToMainMenu(BuildContext context) {
    context.go(AppRoutes.s003MainMenu);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0A73E3), Color(0xFF4DB3FF)],
              ),
            ),
          ),
          const _BottomCloudDecor(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact =
                      constraints.maxHeight < 720 || constraints.maxWidth < 360;
                  final menuButtonFontSize = compact ? 15.0 : 18.0;
                  final bannerHeight = constraints.maxHeight
                      .clamp(0.0, compact ? 176.0 : 214.0)
                      .toDouble();
                  final characterHeight = bannerHeight;
                  final characterWidth = characterHeight * 0.9;
                  final characterLeft = compact ? -26.0 : -40.0;
                  final speechBubbleLeft = compact ? 92.0 : 128.0;
                  final speechBubbleBottom = compact ? 28.0 : 40.0;

                  return Column(
                    children: [
                      SizedBox(
                        height: bannerHeight,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              left: characterLeft,
                              bottom: 0,
                              child: characterAdapter.buildCharacter(
                                context: context,
                                assetPath:
                                    'assets/Action Figures/AmiN thinking.svg',
                                width: characterWidth,
                                height: characterHeight,
                              ),
                            ),
                            Positioned(
                              left: speechBubbleLeft,
                              right: 8,
                              bottom: speechBubbleBottom,
                              child: const _SpeechBubble(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: _levels
                              .map((item) => _buildLevelCard(context, item))
                              .toList(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: constraints.maxHeight * 0.09,
                        ),
                        child: OutlinedButton.icon(
                          onPressed: () => _goToMainMenu(context),
                          icon: Icon(
                            Icons.home_rounded,
                            size: compact ? 20 : 22,
                          ),
                          label: const Text('Kembali ke Menu Utama'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.background,
                            side: const BorderSide(
                              color: Colors.white70,
                              width: 1.2,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: compact ? 14 : 18,
                              vertical: compact ? 10 : 12,
                            ),
                            textStyle: TextStyle(
                              fontSize: menuButtonFontSize,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpeechBubble extends StatelessWidget {
  const _SpeechBubble();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 110,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F7FB),
            borderRadius: BorderRadius.circular(34),
            boxShadow: const [
              BoxShadow(
                color: Color(0x2A000000),
                blurRadius: 14,
                offset: Offset(0, 7),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 190;
              return Text(
                'Pilih tahap\nKuiz!',
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                  fontSize: compact ? 25 : 31,
                  height: 1.05,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0A3D8F),
                ),
              );
            },
          ),
        ),
        Positioned(
          left: -12,
          bottom: 36,
          child: Transform.rotate(
            angle: -0.65,
            child: Container(
              width: 26,
              height: 26,
              decoration: const BoxDecoration(
                color: Color(0xFFF6F7FB),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _QuizLevelCard extends StatefulWidget {
  const _QuizLevelCard({
    required this.title,
    required this.cardColor,
    required this.badgeColor,
    required this.starCount,
    required this.onTap,
  });

  final String title;
  final Color cardColor;
  final Color badgeColor;
  final int starCount;
  final VoidCallback onTap;

  @override
  State<_QuizLevelCard> createState() => _QuizLevelCardState();
}

class _QuizLevelCardState extends State<_QuizLevelCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? 0.98 : 1,
      duration: const Duration(milliseconds: 110),
      curve: Curves.easeOut,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          width: double.infinity,
          height: 122,
          decoration: BoxDecoration(
            color: widget.cardColor,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Color(0x30000000),
                blurRadius: 10,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(28),
            onHighlightChanged: (pressed) {
              if (!mounted) {
                return;
              }
              setState(() => _pressed = pressed);
            },
            onTap: widget.onTap,
            splashColor: Colors.white24,
            highlightColor: Colors.white12,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    width: 94,
                    height: 94,
                    decoration: BoxDecoration(
                      color: widget.badgeColor,
                      shape: BoxShape.circle,
                    ),
                    child: _StarCluster(starCount: widget.starCount),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        const baseStyle = TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 52,
                          height: 1,
                        );
                        final painter = TextPainter(
                          text: const TextSpan(
                            text: 'Sederhana',
                            style: baseStyle,
                          ),
                          maxLines: 1,
                          textDirection: TextDirection.ltr,
                        )..layout(maxWidth: double.infinity);
                        final scale = painter.width > constraints.maxWidth
                            ? constraints.maxWidth / painter.width
                            : 1.0;

                        return Text(
                          widget.title,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.clip,
                          style: baseStyle.copyWith(
                            fontSize: (baseStyle.fontSize ?? 52) * scale,
                          ),
                        );
                      },
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white,
                    size: 54,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StarCluster extends StatelessWidget {
  const _StarCluster({required this.starCount});

  final int starCount;

  Widget _star({double size = 34}) {
    return Icon(
      Icons.star_rounded,
      size: size,
      color: const Color(0xFFFFF36A),
      shadows: const [
        Shadow(color: Color(0x8A8A5F00), blurRadius: 6, offset: Offset(0, 2)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          left: 12,
          top: 10,
          child: Icon(Icons.auto_awesome, color: Color(0x66FFFFFF), size: 20),
        ),
        if (starCount == 1) Center(child: _star(size: 48)),
        if (starCount == 2) ...[
          Positioned(left: 12, top: 30, child: _star(size: 42)),
          Positioned(right: 12, top: 30, child: _star(size: 42)),
        ],
        if (starCount == 3) ...[
          Positioned(top: 10, left: 31, child: _star(size: 34)),
          Positioned(left: 10, bottom: 10, child: _star(size: 38)),
          Positioned(right: 10, bottom: 10, child: _star(size: 38)),
        ],
      ],
    );
  }
}

class _BottomCloudDecor extends StatelessWidget {
  const _BottomCloudDecor();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: 86,
          width: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            children: const [
              Positioned(left: -16, bottom: -36, child: _CloudBlob(size: 124)),
              Positioned(left: 72, bottom: -44, child: _CloudBlob(size: 110)),
              Positioned(left: 156, bottom: -28, child: _CloudBlob(size: 92)),
              Positioned(right: 164, bottom: -38, child: _CloudBlob(size: 102)),
              Positioned(right: 76, bottom: -42, child: _CloudBlob(size: 112)),
              Positioned(right: -20, bottom: -36, child: _CloudBlob(size: 128)),
            ],
          ),
        ),
      ),
    );
  }
}

class _CloudBlob extends StatelessWidget {
  const _CloudBlob({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0x66FFFFFF),
      ),
    );
  }
}

class _QuizLevelItem {
  const _QuizLevelItem({
    required this.level,
    required this.title,
    required this.cardColor,
    required this.badgeColor,
    required this.starCount,
  });

  final QuizLevel level;
  final String title;
  final Color cardColor;
  final Color badgeColor;
  final int starCount;
}
