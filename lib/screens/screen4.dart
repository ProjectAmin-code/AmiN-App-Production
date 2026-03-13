import 'package:flutter/material.dart';

import '../shared/design/app_design_tokens.dart';
import '../shared/gamification/gamification.dart';
import '../shared/motion/app_motion_navigation.dart';
import 'screen5.dart';

class Screen4 extends StatelessWidget {
  const Screen4({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final gamification = GamificationScope.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Apa Itu Imbuhan?'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const MascotWidget(
                assetPath: 'assets/aminPage4.png',
                width: 130,
                height: 130,
                state: MascotState.idle,
              ),
              const SizedBox(height: 10),
              LessonCard(
                child: Text(
                  'Hello, $name!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const LessonCard(
                child: Text(
                  'Imbuhan ialah morfem terikat yang tidak boleh berdiri sendiri.\nImbuhan perlu ditambah pada kata dasar untuk membentuk kata baharu atau kata terbitan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),
              const LessonCard(
                child: Text(
                  'Kata berimbuhan ialah kata yang mempunyai imbuhan seperti:',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: const [
                  _ExampleWord(text: 'berlari'),
                  _ExampleWord(text: 'tertawa'),
                  _ExampleWord(text: 'membaca'),
                  _ExampleWord(text: 'menjadikan'),
                  _ExampleWord(text: 'dibelikan'),
                  _ExampleWord(text: 'masakan'),
                ],
              ),
              const SizedBox(height: 18),
              AnimatedKidButton(
                label: 'Teruskan',
                icon: Icons.arrow_forward_rounded,
                onPressed: () {
                  gamification.awardXp(8, reason: 'Teruskan pembelajaran');
                  pushAdaptive(context, Screen5(name: name));
                },
                backgroundColor: const Color(0xFF0288D1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExampleWord extends StatelessWidget {
  const _ExampleWord({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
