import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/audio/winning_screen_audio.dart';
import '../../shared/gamification/gamification.dart';

class GameCompletionTemplate extends StatelessWidget {
  const GameCompletionTemplate({
    super.key,
    required this.score,
    required this.total,
    required this.statusTitle,
    required this.statusSubtitle,
    required this.onPlayAgain,
    required this.onMainMenu,
    this.confettiActive = true,
    this.title = 'Tahniah!',
    this.completionText = 'Anda telah menamatkan permainan ini.',
    this.playAgainLabel = 'Main Semula',
    this.mainMenuLabel = 'Menu Utama',
  });

  final int score;
  final int total;
  final String statusTitle;
  final String statusSubtitle;
  final VoidCallback onPlayAgain;
  final VoidCallback onMainMenu;
  final bool confettiActive;
  final String title;
  final String completionText;
  final String playAgainLabel;
  final String mainMenuLabel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFC3AEFF), Color(0xFFB295FF), Color(0xFFA282F5)],
          ),
        ),
        child: Stack(
          children: [
            const WinningScreenAudioCue(),
            const Positioned.fill(child: CustomPaint(painter: _RaysPainter())),
            const Positioned.fill(child: _ConfettiDecor()),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: ConfettiCelebration(
                      active: confettiActive,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const _TopStar(),
                          const SizedBox(height: 10),
                          _OutlinedTitle(title: title),
                          const SizedBox(height: 12),
                          _PurpleRibbon(text: completionText),
                          const SizedBox(height: 14),
                          _ScorePanel(
                            score: score,
                            total: total,
                            statusTitle: statusTitle,
                            statusSubtitle: statusSubtitle,
                          ),
                          const SizedBox(height: 18),
                          _PrimaryActionButton(
                            label: playAgainLabel,
                            onPressed: onPlayAgain,
                          ),
                          const SizedBox(height: 12),
                          _SecondaryActionButton(
                            label: mainMenuLabel,
                            onPressed: onMainMenu,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopStar extends StatelessWidget {
  const _TopStar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0x44FFFFFF),
        border: Border.all(color: const Color(0x55FFFFFF), width: 2),
      ),
      child: const Center(
        child: Icon(
          Icons.star_rounded,
          size: 74,
          color: Color(0xFFFFD53D),
          shadows: [
            Shadow(
              color: Color(0x66D18B00),
              offset: Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
      ),
    );
  }
}

class _OutlinedTitle extends StatelessWidget {
  const _OutlinedTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    const fillStyle = TextStyle(
      fontSize: 62,
      fontWeight: FontWeight.w900,
      color: Colors.white,
      height: 0.95,
      shadows: [
        Shadow(color: Color(0x77000000), offset: Offset(0, 5), blurRadius: 8),
      ],
    );
    const outlineStyle = TextStyle(
      fontSize: 62,
      fontWeight: FontWeight.w900,
      color: Color(0xFF5D3DD9),
      height: 0.95,
    );

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (final offset in const <Offset>[
            Offset(-3, -3),
            Offset(3, -3),
            Offset(-3, 3),
            Offset(3, 3),
            Offset(0, -4),
            Offset(0, 4),
            Offset(-4, 0),
            Offset(4, 0),
          ])
            Transform.translate(
              offset: offset,
              child: Text(title, style: outlineStyle),
            ),
          Text(title, style: fillStyle),
        ],
      ),
    );
  }
}

class _PurpleRibbon extends StatelessWidget {
  const _PurpleRibbon({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8C5BFF), Color(0xFF6D46DC)],
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x55000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          height: 1.15,
        ),
      ),
    );
  }
}

class _ScorePanel extends StatelessWidget {
  const _ScorePanel({
    required this.score,
    required this.total,
    required this.statusTitle,
    required this.statusSubtitle,
  });

  final int score;
  final int total;
  final String statusTitle;
  final String statusSubtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.star_rounded,
                size: 70,
                color: Color(0xFFFFD53D),
                shadows: [
                  Shadow(
                    color: Color(0x66D18B00),
                    offset: Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Text(
                '$score / $total',
                style: const TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF4E2CC9),
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFDCD2F8), thickness: 2, height: 2),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF56D15B),
                  border: Border.all(color: const Color(0xFF3DBE48), width: 3),
                ),
                child: const Icon(
                  Icons.sentiment_very_satisfied_rounded,
                  size: 52,
                  color: Color(0xFFFFD742),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusTitle,
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF32218E),
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      statusSubtitle,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2E2172),
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4B9CFF), Color(0xFF246BEE)],
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x55000000),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.refresh_rounded, size: 34),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(76),
            elevation: 0,
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
              side: const BorderSide(color: Color(0xAAFFFFFF), width: 2),
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryActionButton extends StatelessWidget {
  const _SecondaryActionButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.home_rounded, size: 32),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(76),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF4E2CC9),
          side: const BorderSide(color: Color(0xFF8E71EB), width: 3),
          textStyle: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),
    );
  }
}

class _ConfettiDecor extends StatelessWidget {
  const _ConfettiDecor();

  @override
  Widget build(BuildContext context) {
    const decorations = [
      _DecorItem(
        top: 90,
        left: 18,
        icon: Icons.star_rounded,
        color: 0x66FFE36E,
      ),
      _DecorItem(
        top: 120,
        right: 30,
        icon: Icons.star_rounded,
        color: 0x66FFE36E,
      ),
      _DecorItem(
        top: 205,
        left: 26,
        icon: Icons.circle,
        color: 0x66FF8A8A,
        size: 10,
      ),
      _DecorItem(
        top: 240,
        right: 24,
        icon: Icons.circle,
        color: 0x6656D15B,
        size: 10,
      ),
      _DecorItem(
        top: 350,
        left: 34,
        icon: Icons.star_rounded,
        color: 0x66FFFFFF,
      ),
      _DecorItem(
        top: 390,
        right: 22,
        icon: Icons.star_rounded,
        color: 0x66FFFFFF,
      ),
      _DecorItem(
        bottom: 210,
        left: 40,
        icon: Icons.circle,
        color: 0x6685B7FF,
        size: 10,
      ),
      _DecorItem(
        bottom: 180,
        right: 36,
        icon: Icons.circle,
        color: 0x66FFD063,
        size: 10,
      ),
    ];
    return IgnorePointer(
      child: Stack(
        children: [
          for (final item in decorations)
            Positioned(
              top: item.top,
              bottom: item.bottom,
              left: item.left,
              right: item.right,
              child: Icon(item.icon, size: item.size, color: Color(item.color)),
            ),
        ],
      ),
    );
  }
}

class _DecorItem {
  const _DecorItem({
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.icon,
    required this.color,
    this.size = 20,
  });

  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final IconData icon;
  final int color;
  final double size;
}

class _RaysPainter extends CustomPainter {
  const _RaysPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, 0);
    const rays = 12;
    final sweep = (math.pi * 1.2) / rays;
    final start = math.pi - ((rays * sweep) / 2);
    final radius = math.sqrt(
      (size.width * size.width) + (size.height * size.height),
    );
    final rayPaint = Paint()..style = PaintingStyle.fill;

    for (var i = 0; i < rays; i++) {
      final opacity = i.isEven ? 0.14 : 0.07;
      rayPaint.color = Colors.white.withValues(alpha: opacity);

      final angleA = start + (i * sweep);
      final angleB = angleA + sweep;
      final p1 = center + Offset(math.cos(angleA), math.sin(angleA)) * radius;
      final p2 = center + Offset(math.cos(angleB), math.sin(angleB)) * radius;

      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..lineTo(p1.dx, p1.dy)
        ..lineTo(p2.dx, p2.dy)
        ..close();
      canvas.drawPath(path, rayPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
