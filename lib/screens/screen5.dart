import 'package:flutter/material.dart';

import '../shared/gamification/gamification.dart';
import '../shared/motion/app_motion_navigation.dart';
import 'screen6.dart';

class Screen5 extends StatelessWidget {
  const Screen5({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final gamification = GamificationScope.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF9E29B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D9CDB)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Apa Itu Imbuhan Awalan?',
          style: TextStyle(
            color: Color(0xFF2D9CDB),
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: LessonCard(
                backgroundColor: const Color(0xFFFFF3C9),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    const LessonCard(
                      backgroundColor: Color(0xFFBEE8FF),
                      child: Text(
                        'APA ITU\nIMBUHAN\nAWALAN?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          height: 1.05,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1F4E79),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            _avatarCircle('assets/boy.png', Icons.face),
                            const SizedBox(height: 10),
                            _avatarSquare('assets/hand.png', Icons.touch_app_rounded),
                          ],
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: LessonCard(
                            backgroundColor: Color(0xFFFFF7DC),
                            child: Text(
                              'Imbuhan awalan\nialah imbuhan yang\nditambah di hadapan\nkata dasar untuk\nmembentuk kata\nbaharu.',
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.25,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2E2E2E),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const _ExampleRow(
                      pillText: 'ber',
                      pillColor: Color(0xFFF2C94C),
                      wordIconAsset: 'assets/run.png',
                      wordFallbackIcon: 'R',
                      wordText: 'lari',
                      isBold: false,
                    ),
                    const SizedBox(height: 12),
                    const _ExampleRow(
                      pillText: 'meN-',
                      pillColor: Color(0xFFF2994A),
                      wordIconAsset: null,
                      wordFallbackIcon: '',
                      wordText: 'membaca',
                      isBold: true,
                    ),
                    const SizedBox(height: 12),
                    const _ExampleRow(
                      pillText: 'di',
                      pillColor: Color(0xFF56CCF2),
                      wordIconAsset: null,
                      wordFallbackIcon: '',
                      wordText: 'dibeli',
                      isBold: true,
                    ),
                    const SizedBox(height: 12),
                    const _ExampleRow(
                      pillText: 'ter',
                      pillColor: Color(0xFF6FCF97),
                      wordIconAsset: 'assets/zzz.png',
                      wordFallbackIcon: 'Z',
                      wordText: 'tertidur',
                      isBold: true,
                    ),
                    const SizedBox(height: 18),
                    AnimatedKidButton(
                      label: 'Teruskan',
                      onPressed: () {
                        gamification.awardXp(8, reason: 'Teruskan ke skrin seterusnya');
                        pushAdaptive(context, Screen6(name: name));
                      },
                      backgroundColor: const Color(0xFF0288D1),
                      foregroundColor: const Color(0xFFE91E63),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _avatarCircle(String path, IconData fallback) {
    return Container(
      width: 78,
      height: 78,
      decoration: BoxDecoration(
        color: const Color(0xFFFFD4B3),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF2E2E2E), width: 1),
      ),
      child: ClipOval(
        child: Image.asset(
          path,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(child: Icon(fallback, size: 40, color: const Color(0xFF2E2E2E)));
          },
        ),
      ),
    );
  }

  Widget _avatarSquare(String path, IconData fallback) {
    return Container(
      width: 78,
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFFF2994A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2E2E2E), width: 1),
      ),
      child: Center(
        child: Image.asset(
          path,
          width: 28,
          height: 28,
          errorBuilder: (context, error, stackTrace) {
            return Icon(fallback, size: 28, color: const Color(0xFF2E2E2E));
          },
        ),
      ),
    );
  }
}

class _ExampleRow extends StatelessWidget {
  const _ExampleRow({
    required this.pillText,
    required this.pillColor,
    required this.wordIconAsset,
    required this.wordFallbackIcon,
    required this.wordText,
    required this.isBold,
  });

  final String pillText;
  final Color pillColor;
  final String? wordIconAsset;
  final String wordFallbackIcon;
  final String wordText;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 68,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: pillColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            pillText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          '+',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Color(0xFF2E2E2E),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF9BD7FF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.menu_book_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        if (wordIconAsset != null) ...[
          Image.asset(
            wordIconAsset!,
            width: 18,
            height: 18,
            errorBuilder: (context, error, stackTrace) {
              return Text(wordFallbackIcon, style: const TextStyle(fontSize: 18));
            },
          ),
          const SizedBox(width: 8),
        ] else if (wordFallbackIcon.isNotEmpty) ...[
          Text(wordFallbackIcon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
        ],
        Text(
          wordText,
          style: TextStyle(
            fontSize: 20,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
            color: const Color(0xFF2E2E2E),
          ),
        ),
      ],
    );
  }
}
