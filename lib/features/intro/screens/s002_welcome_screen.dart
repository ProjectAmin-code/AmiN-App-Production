import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/animations/animations.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/theme/app_design_tokens.dart';
import '../../../core/widgets/animated_kid_button.dart';
import '../../../core/widgets/lesson_card.dart';
import '../../../shared/progress/progress_tracker.dart';

class S002WelcomeScreen extends StatefulWidget {
  const S002WelcomeScreen({super.key});

  @override
  State<S002WelcomeScreen> createState() => _S002WelcomeScreenState();
}

class _S002WelcomeScreenState extends State<S002WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final TextEditingController _nameController;
  late final TextEditingController _userIdController;
  String? _nameError;
  String? _userIdError;
  bool _recoverMode = false;
  bool _recovering = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: ProgressTracker.instance.userName.trim(),
    );
    _userIdController = TextEditingController();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ProgressTracker.instance.hasIdentity && mounted) {
        context.go(AppRoutes.s003MainMenu);
        return;
      }
      ProgressTracker.instance.updateOnboardingStep(
        reachedStep: 2,
        totalSteps: 3,
      );
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _nameController.dispose();
    _userIdController.dispose();
    super.dispose();
  }

  Future<void> _goNext() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _nameError = 'Sila masukkan nama pelajar';
      });
      return;
    }

    setState(() {
      _nameError = null;
    });

    await ProgressTracker.instance.setUserName(name);
    if (!mounted) {
      return;
    }
    context.go(AppRoutes.s003MainMenu);
  }

  Future<void> _recoverByUserId() async {
    final userId = _userIdController.text.trim();
    if (userId.isEmpty || _recovering) {
      setState(() {
        _userIdError = 'Sila masukkan User ID';
      });
      return;
    }
    setState(() {
      _userIdError = null;
      _recovering = true;
    });

    final result = await ProgressTracker.instance.restoreFromUserId(userId);
    setState(() {
      _recovering = false;
    });
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(result.message)));
    if (result.success) {
      context.go(AppRoutes.s003MainMenu);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxHeight < 620;
            final mascotSize = (constraints.maxHeight * 0.28).clamp(
              140.0,
              240.0,
            );
            final insetsBottom = MediaQuery.viewInsetsOf(context).bottom;
            final minHeight = math.max(0.0, constraints.maxHeight - 24);

            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + insetsBottom),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 560,
                    minHeight: minHeight,
                  ),
                  child: Column(
                    mainAxisAlignment: isCompact
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    children: [
                      AminCharacter(
                        width: mascotSize,
                        height: mascotSize,
                        pose: AminPose.schoolUniform,
                        motions: <AminMotion>{
                          AminMotion.idleBreathing,
                          AminMotion.blink,
                          AminMotion.lightBounce,
                          AminMotion.smile,
                        },
                        backend: AminCharacterBackend.auto,
                        placeholderAsset:
                            'assets/Action Figures/AmiN thinking.svg',
                      ),
                      SizedBox(height: isCompact ? 10 : 16),
                      const LessonCard(
                        child: Text(
                          'Selamat datang ke aplikasi AmiN!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SegmentedButton<bool>(
                        segments: const [
                          ButtonSegment<bool>(
                            value: false,
                            label: Text('Pengguna Baru'),
                            icon: Icon(Icons.person_add_alt_rounded),
                          ),
                          ButtonSegment<bool>(
                            value: true,
                            label: Text('Guna User ID'),
                            icon: Icon(Icons.vpn_key_rounded),
                          ),
                        ],
                        selected: <bool>{_recoverMode},
                        onSelectionChanged: (value) {
                          setState(() {
                            _recoverMode = value.first;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      LessonCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!_recoverMode) ...[
                              const Text(
                                'Nama pelajar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _nameController,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) => _goNext(),
                                decoration: InputDecoration(
                                  hintText: 'Contoh: Amina',
                                  errorText: _nameError,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFBFD7EA),
                                    ),
                                  ),
                                ),
                              ),
                            ] else ...[
                              const Text(
                                'User ID',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _userIdController,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) => _recoverByUserId(),
                                decoration: InputDecoration(
                                  hintText: 'Masukkan User ID anda',
                                  errorText: _userIdError,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFBFD7EA),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(height: isCompact ? 14 : 24),
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          final scale =
                              1 +
                              (math.sin(_pulseController.value * math.pi) *
                                  0.04);
                          return Transform.scale(scale: scale, child: child);
                        },
                        child: AnimatedKidButton(
                          label: _recoverMode
                              ? (_recovering
                                    ? 'Memulihkan...'
                                    : 'Pulihkan Data')
                              : 'Teruskan',
                          icon: Icons.play_arrow_rounded,
                          onPressed: _recoverMode ? _recoverByUserId : _goNext,
                          backgroundColor: AppColors.secondary,
                          foregroundColor: AppColors.textPrimary,
                          labelFontSize: _recoverMode ? 18 : 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
