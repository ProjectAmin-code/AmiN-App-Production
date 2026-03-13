import 'package:flutter/material.dart';

import '../learning/screens/learning_flow_screen.dart';
import '../shared/design/app_design_tokens.dart';
import '../shared/gamification/gamification.dart';
import '../shared/motion/app_motion_navigation.dart';

class Screen6 extends StatelessWidget {
  const Screen6({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final gamification = GamificationScope.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Kenali Imbuhan Awalan meN-'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const MascotWidget(
                assetPath: 'assets/aminPage4.png',
                width: 130,
                height: 130,
                state: MascotState.idle,
              ),
              const SizedBox(height: 12),
              LessonCard(
                child: Text(
                  'Hello, $name!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 10),
              const LessonCard(
                child: Column(
                  children: [
                    Text(
                      'Imbuhan meN- digunakan untuk membentuk kata kerja.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    Text(
                      'Ia menunjukkan sesuatu perbuatan atau tindakan.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Contoh imbuhan awalan meN-:',
                style: TextStyle(fontSize: 18, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: const [
                  _ExampleWord(text: 'menari'),
                  _ExampleWord(text: 'memasak'),
                  _ExampleWord(text: 'mengecat'),
                ],
              ),
              const Spacer(),
              AnimatedKidButton(
                label: 'Teruskan',
                icon: Icons.arrow_forward_rounded,
                onPressed: () {
                  gamification.awardXp(10, reason: 'Sedia ke modul utama');
                  pushAdaptive(context, LearningFlowScreen(name: name));
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
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(8),
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
