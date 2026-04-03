import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/app_routes.dart';
import '../../shared/gamification/gamification.dart';
import '../../shared/motion/app_motion_spec.dart';
import '../../shared/motion/app_motion_widgets.dart';
import '../../shared/progress/progress_tracker.dart';
import '../../shared/settings/app_settings_service.dart';
import '../models/learning_models.dart';
import '../services/amin_tts_service.dart';

class LearningFlowScreen extends StatefulWidget {
  const LearningFlowScreen({super.key, required this.name});

  final String name;

  @override
  State<LearningFlowScreen> createState() => _LearningFlowScreenState();
}

class _LearningFlowScreenState extends State<LearningFlowScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final List<LearningStep> _steps;

  int _currentIndex = 0;
  bool _voiceEnabled = AppSettingsService.instance.voiceOverEnabled;

  LearningStep get _currentStep => _steps[_currentIndex];
  bool get _isLastStep => _currentIndex == _steps.length - 1;

  @override
  void initState() {
    super.initState();
    _steps = _buildSteps();
    _pulseController = AnimationController(
      vsync: this,
      duration: AppMotionSpec.pulse,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ProgressTracker.instance.updateLearningStep(
        reachedStep: _currentIndex + 1,
        totalSteps: _steps.length,
      );
      _speakCurrentStep();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotionSpec.reduceMotion(context)) {
      _pulseController.stop();
      _pulseController.value = 0;
    } else if (!_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    AminTtsService.instance.stop();
    super.dispose();
  }

  Future<void> _speakCurrentStep() async {
    if (!_voiceEnabled || _currentStep.voiceScript.trim().isEmpty) {
      return;
    }
    await AminTtsService.instance.speak(_currentStep.voiceScript);
  }

  Future<void> _toggleVoice() async {
    setState(() {
      _voiceEnabled = !_voiceEnabled;
    });
    await AppSettingsService.instance.setVoiceOverEnabled(_voiceEnabled);
    if (_voiceEnabled) {
      await _speakCurrentStep();
    } else {
      await AminTtsService.instance.stop();
    }
  }

  Future<void> _goBack() async {
    await AminTtsService.instance.stop();
    if (!mounted) {
      return;
    }
    if (_currentIndex == 0) {
      context.go(AppRoutes.s003MainMenu);
      return;
    }
    setState(() => _currentIndex -= 1);
    await _speakCurrentStep();
  }

  Future<void> _goNext() async {
    final gamification = GamificationScope.of(context);
    if (_isLastStep) {
      await AminTtsService.instance.stop();
      if (!mounted) {
        return;
      }
      context.go(AppRoutes.s003MainMenu);
      return;
    }
    await AminTtsService.instance.stop();
    if (!mounted) {
      return;
    }
    setState(() => _currentIndex += 1);
    gamification.awardXp(8, reason: 'Belajar ${_currentStep.id}');
    gamification.updateStreak(success: true);
    ProgressTracker.instance.updateLearningStep(
      reachedStep: _currentIndex + 1,
      totalSteps: _steps.length,
    );
    await _speakCurrentStep();
  }

  Future<void> _openHotspot(LearningHotspot hotspot) async {
    if (_voiceEnabled) {
      await AminTtsService.instance.speakPair(
        hotspot.baseWord,
        hotspot.derivedWord,
      );
    }
    if (!mounted) {
      return;
    }
    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                hotspot.baseWord,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1D3557),
                ),
              ),
              const SizedBox(height: 8),
              const Icon(
                Icons.arrow_downward_rounded,
                color: Color(0xFF0B7285),
              ),
              const SizedBox(height: 8),
              Text(
                hotspot.derivedWord,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0B7285),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopBar() {
    final step = _currentStep;
    final progress = (_currentIndex + 1) / _steps.length;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: _goBack,
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1D3557),
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(value: progress, minHeight: 6),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _speakCurrentStep,
            icon: const Icon(Icons.volume_up_rounded),
          ),
          IconButton(
            onPressed: _toggleVoice,
            icon: Icon(
              _voiceEnabled
                  ? Icons.hearing_rounded
                  : Icons.hearing_disabled_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _titleBubble(
    String text, {
    Color bubbleColor = const Color(0xFFFFE082),
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.w900,
          color: Color(0xFF1D3557),
        ),
      ),
    );
  }

  Widget _contentCard({required Widget child, Color color = Colors.white}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }

  Widget _buildTableStep(LearningStep step) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleBubble(step.title),
          const SizedBox(height: 10),
          if (step.subtitle.isNotEmpty)
            _contentCard(
              child: Text(
                step.subtitle,
                style: const TextStyle(
                  fontSize: 15.5,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(height: 10),
          _tableCard(step),
          if (step.footerNote.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              step.footerNote,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF2F4858),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _tableCard(LearningStep step) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final minTableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width - 48;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFD0E6F5)),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: minTableWidth),
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                defaultColumnWidth: const IntrinsicColumnWidth(),
                border: const TableBorder(
                  horizontalInside: BorderSide(color: Color(0xFFE8F1F8)),
                  verticalInside: BorderSide(color: Color(0xFFE8F1F8)),
                ),
                children: [
                  TableRow(
                    decoration: const BoxDecoration(color: Color(0xFF0B7285)),
                    children: step.tableHeaders
                        .map(
                          (header) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            child: Text(
                              header,
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  ...step.tableRows.asMap().entries.map((rowEntry) {
                    final rowIndex = rowEntry.key;
                    final row = rowEntry.value;
                    return TableRow(
                      decoration: BoxDecoration(
                        color: rowIndex.isEven
                            ? const Color(0xFFF6FCFF)
                            : const Color(0xFFEFF8FF),
                      ),
                      children: row.cells.asMap().entries.map((cellEntry) {
                        final cellIndex = cellEntry.key;
                        final cell = cellEntry.value;
                        return TweenAnimationBuilder<double>(
                          key: ValueKey(
                            '${_currentStep.id}-table-$rowIndex-$cellIndex',
                          ),
                          tween: Tween(begin: 0, end: 1),
                          duration: Duration(
                            milliseconds: 300 + (rowIndex * 80),
                          ),
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, (1 - value) * 8),
                                child: child,
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            child: Text(
                              cell,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChangeCardsStep(LearningStep step) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleBubble(step.title, bubbleColor: const Color(0xFFFFB347)),
          const SizedBox(height: 10),
          _contentCard(
            color: const Color(0xFFFFF5E0),
            child: Text(
              step.subtitle,
              style: const TextStyle(
                fontSize: 15.5,
                height: 1.35,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ...step.changeCards.asMap().entries.map((entry) {
            final index = entry.key;
            final card = entry.value;
            return TweenAnimationBuilder<double>(
              key: ValueKey('${_currentStep.id}-change-$index'),
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 280 + (index * 100)),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, (1 - value) * 8),
                    child: child,
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFCA3A),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        card.letter,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            card.example,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0B7285),
                            ),
                          ),
                          Text(
                            card.note,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          if (step.footerNote.isNotEmpty)
            Text(
              step.footerNote,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1D3557),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSituationStep(LearningStep step) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFE6F5FF), Color(0xFFCBEAFF)],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 16,
                  bottom: 10,
                  child: Image.asset(
                    'assets/aminPage1.png',
                    width: 116,
                    height: 116,
                    fit: BoxFit.contain,
                  ),
                ),
                ...step.hotspots.asMap().entries.map((entry) {
                  final index = entry.key;
                  final hotspot = entry.value;
                  return Align(
                    alignment: hotspot.alignment,
                    child: TweenAnimationBuilder<double>(
                      key: ValueKey('${_currentStep.id}-hotspot-$index'),
                      tween: Tween(begin: 0, end: 1),
                      duration: Duration(milliseconds: 280 + (index * 100)),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.scale(
                            scale: 0.9 + (0.1 * value),
                            child: child,
                          ),
                        );
                      },
                      child: Builder(
                        builder: (context) {
                          final reduceMotion = AppMotionSpec.reduceMotion(
                            context,
                          );
                          final scaleAnimation = reduceMotion
                              ? const AlwaysStoppedAnimation(1.0)
                              : Tween<double>(begin: 0.95, end: 1.08).animate(
                                  CurvedAnimation(
                                    parent: _pulseController,
                                    curve: Curves.easeInOut,
                                  ),
                                );
                          return ScaleTransition(
                            scale: scaleAnimation,
                            child: IconButton.filled(
                              onPressed: () => _openHotspot(hotspot),
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xFFFFCA3A),
                                foregroundColor: const Color(0xFF1D3557),
                              ),
                              icon: const Icon(Icons.star_rounded),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryStep(LearningStep step) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 360 ? 1 : 2;
        return Stack(
          children: [
            GridView.builder(
              itemCount: step.summaryCards.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.05,
              ),
              itemBuilder: (context, index) {
                final card = step.summaryCards[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFDDEAF6)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.prefix,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0B7285),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        card.ruleText,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      Text(
                        'Contoh: ${card.example}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1D3557),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Positioned(
              right: 6,
              bottom: 2,
              child: IgnorePointer(
                child: Image.asset(
                  'assets/aminPage2.png',
                  width: 96,
                  height: 96,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCompletionStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BreathingCharacter(
                child: Image(
                  image: AssetImage('assets/aminPage3.png'),
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Tahniah! Anda selesai modul Belajar.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1D3557),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Text(
              'Teruskan ke Menu Utama untuk pilih aktiviti seterusnya.',
              style: TextStyle(
                color: Color(0xFF1D3557),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          AnimatedKidButton(
            label: 'Kembali ke Main',
            icon: Icons.home_rounded,
            onPressed: () => context.go(AppRoutes.s003MainMenu),
            backgroundColor: const Color(0xFF2A9D8F),
          ),
        ],
      ),
    );
  }

  Widget _buildStepBody(LearningStep step) {
    switch (step.type) {
      case LearningStepType.table:
        return _buildTableStep(step);
      case LearningStepType.changeCards:
        return _buildChangeCardsStep(step);
      case LearningStepType.situation:
        return _buildSituationStep(step);
      case LearningStepType.summary:
        return _buildSummaryStep(step);
      case LearningStepType.quizGateway:
        return _buildCompletionStep();
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = _currentStep;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [step.backgroundTop, step.backgroundBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  child: AnimatedSwitcher(
                    duration: AppMotionSpec.chooseDuration(
                      context,
                      AppMotionSpec.switcher,
                      AppMotionSpec.switcherReduced,
                    ),
                    transitionBuilder: (child, animation) {
                      return buildAdaptiveSwitcherTransition(
                        context: context,
                        animation: animation,
                        child: child,
                      );
                    },
                    child: Container(
                      key: ValueKey(step.id),
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.48),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildStepBody(step)),
                          if (step.type != LearningStepType.quizGateway) ...[
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: AnimatedBuilder(
                                animation: _pulseController,
                                builder: (context, child) {
                                  final reduceMotion =
                                      AppMotionSpec.reduceMotion(context);
                                  final angle = reduceMotion
                                      ? 0.0
                                      : math.sin(
                                              _pulseController.value * math.pi,
                                            ) *
                                            0.02;
                                  return Transform.rotate(
                                    angle: angle,
                                    child: child,
                                  );
                                },
                                child: AnimatedKidButton(
                                  label: _isLastStep
                                      ? 'Selesai'
                                      : step.buttonText,
                                  icon: Icons.arrow_forward_rounded,
                                  onPressed: _goNext,
                                  backgroundColor: const Color(0xFFFFC300),
                                  foregroundColor: const Color(0xFF1D3557),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<LearningStep> _buildSteps() {
  return const [
    LearningStep(
      id: 'S007',
      title: 'Variasi Imbuhan meN-',
      type: LearningStepType.table,
      subtitle:
          'Imbuhan meN- mempunyai lima bentuk yang berubah mengikut huruf pertama kata dasar.',
      voiceScript:
          'Bentuk pertama ialah me, digunakan untuk huruf vokal, l, m, n, r, w, dan y. '
          'Bentuk men digunakan untuk huruf d, j, z, dan sy. '
          'Bentuk mem digunakan untuk huruf b dan f, huruf p gugur. '
          'Bentuk meng digunakan untuk huruf g, h, dan kh, huruf k gugur. '
          'Bentuk menge digunakan untuk kata dasar dua suku kata tanpa perbuatan.',
      backgroundTop: Color(0xFFFFF8D2),
      backgroundBottom: Color(0xFFFFEBB1),
      tableHeaders: ['Bentuk', 'Digunakan apabila', 'Contoh'],
      tableRows: [
        LearningRuleRow(
          cells: ['me-', 'Huruf vokal, l, m, n, r, w, y', 'melukis'],
        ),
        LearningRuleRow(cells: ['men-', 'Huruf d, j, z, sy', 'menari']),
        LearningRuleRow(cells: ['mem-', 'Huruf b, f (p gugur)', 'memasak']),
        LearningRuleRow(
          cells: ['meng-', 'Huruf g, h, kh (k gugur)', 'menggali'],
        ),
        LearningRuleRow(
          cells: [
            'menge-',
            'Kata dasar dua suku kata tanpa perbuatan',
            'mengecat',
          ],
        ),
      ],
    ),
    LearningStep(
      id: 'S008',
      title: 'Penggunaan imbuhan me-',
      type: LearningStepType.table,
      subtitle:
          'Gunakan imbuhan me- apabila kata dasar bermula dengan huruf l, m, n, r, w atau y.\nHuruf awal kata dasar kekal.',
      voiceScript:
          'Imbuhan me digunakan apabila kata dasar bermula dengan huruf l, m, n, r, w dan y. '
          'Contohnya melukis, memasak dan meronda. '
          'Dalam skrin seterusnya, kita akan lihat huruf lain yang mengubah bentuk imbuhan meN.',
      tableHeaders: ['Huruf', 'Kata Dasar', 'Imbuhan', 'Kata Berimbuhan'],
      tableRows: [
        LearningRuleRow(cells: ['l', 'lukis', 'me-', 'melukis']),
        LearningRuleRow(cells: ['m', 'masak', 'me-', 'memasak']),
        LearningRuleRow(cells: ['n', 'naik', 'me-', 'menaik']),
        LearningRuleRow(cells: ['r', 'ronda', 'me-', 'meronda']),
        LearningRuleRow(cells: ['w', 'warna', 'me-', 'mewarna']),
      ],
      footerNote:
          'Huruf lain seperti p, t, k dan s akan menyebabkan imbuhan meN- berubah bentuk. Itu akan diterangkan dalam skrin seterusnya.',
    ),
    LearningStep(
      id: 'S009',
      title: 'Kenapa imbuhan meN- berubah?',
      type: LearningStepType.changeCards,
      subtitle:
          'Kadangkala imbuhan meN- berubah bunyi supaya sebutan menjadi lebih lancar.\nBerikut ialah perubahan biasa yang berlaku:',
      voiceScript:
          'Kadang-kadang imbuhan meN berubah bunyi supaya sebutan lebih lancar. '
          'Huruf p menjadi m, t menjadi n, k menjadi ng dan s menjadi ny. '
          'Contohnya potong menjadi memotong, tulis menjadi menulis, kawal menjadi mengawal dan sapu menjadi menyapu. '
          'Ingat, imbuhan berubah supaya senang disebut.',
      backgroundTop: Color(0xFFFFF4CC),
      backgroundBottom: Color(0xFFFFE6A3),
      changeCards: [
        LearningChangeCard(
          letter: 'p',
          example: 'potong -> memotong',
          note: 'Bunyi p berubah menjadi m',
        ),
        LearningChangeCard(
          letter: 't',
          example: 'tulis -> menulis',
          note: 'Bunyi t berubah menjadi n',
        ),
        LearningChangeCard(
          letter: 'k',
          example: 'kawal -> mengawal',
          note: 'Bunyi k berubah menjadi ng',
        ),
        LearningChangeCard(
          letter: 's',
          example: 'sapu -> menyapu',
          note: 'Bunyi s berubah menjadi ny',
        ),
      ],
      footerNote: 'Imbuhan berubah supaya senang disebut!',
    ),
    LearningStep(
      id: 'S010',
      title: 'Penggunaan imbuhan mem-',
      type: LearningStepType.table,
      subtitle:
          'Gunakan imbuhan mem- apabila kata dasar bermula dengan huruf b atau f. Konsonan awal (b/f) tidak berubah.',
      voiceScript:
          'Sekarang kita lihat imbuhan mem. Kita guna mem apabila kata dasar bermula dengan huruf b atau f. '
          'Contohnya baca menjadi membaca, bantu menjadi membantu, fikir menjadi memikir dan fail menjadi memfail. '
          'Huruf b dan f tidak berubah.',
      backgroundTop: Color(0xFFFFE5CD),
      backgroundBottom: Color(0xFFFFD0A6),
      tableHeaders: ['Huruf Awal', 'Kata Dasar', 'Imbuhan', 'Kata Berimbuhan'],
      tableRows: [
        LearningRuleRow(cells: ['b', 'baca', 'mem-', 'membaca']),
        LearningRuleRow(cells: ['b', 'bantu', 'mem-', 'membantu']),
        LearningRuleRow(cells: ['f', 'fitnah', 'mem-', 'memfitnah']),
        LearningRuleRow(cells: ['f', 'fokus', 'mem-', 'memfokus']),
      ],
    ),
    LearningStep(
      id: 'S011',
      title: 'Penggunaan imbuhan meny-',
      type: LearningStepType.table,
      subtitle:
          'Gunakan imbuhan meny- apabila kata dasar bermula dengan huruf s.',
      voiceScript:
          'Imbuhan meny digunakan apabila kata dasar bermula dengan huruf s. '
          'Bunyi s berubah menjadi ny supaya sebutan lebih lancar. '
          'Contohnya, sapu menjadi menyapu, sebut menjadi menyebut dan sikat menjadi menyikat.',
      backgroundTop: Color(0xFFDFF7F4),
      backgroundBottom: Color(0xFFC5EFE8),
      tableHeaders: ['Kata Dasar', 'Perubahan', 'Kata Berimbuhan'],
      tableRows: [
        LearningRuleRow(cells: ['sapu', 's -> ny', 'menyapu']),
        LearningRuleRow(cells: ['simpan', 's -> ny', 'menyimpan']),
        LearningRuleRow(cells: ['sebut', 's -> ny', 'menyebut']),
        LearningRuleRow(cells: ['salin', 's -> ny', 'menyalin']),
        LearningRuleRow(cells: ['sikat', 's -> ny', 'menyikat']),
      ],
      footerNote: 'Bunyi s berubah menjadi ny supaya sebutan lebih lancar.',
    ),
    LearningStep(
      id: 'S012',
      title: 'Penggunaan imbuhan men-',
      type: LearningStepType.table,
      subtitle:
          'Gunakan imbuhan men- apabila kata dasar bermula dengan huruf c, z, d, j atau sy.',
      voiceScript:
          'Imbuhan men digunakan apabila kata dasar bermula dengan huruf c, z, d, j atau sy. '
          'Huruf awal kata dasar tidak berubah. '
          'Contohnya, cetak menjadi mencetak, dengar menjadi mendengar, jawab menjadi menjawab dan syelek menjadi mensyelek.',
      backgroundTop: Color(0xFFFFF7D0),
      backgroundBottom: Color(0xFFE0F8EF),
      tableHeaders: ['Huruf Awal', 'Kata Dasar', 'Imbuhan', 'Kata Berimbuhan'],
      tableRows: [
        LearningRuleRow(cells: ['c', 'cetak', 'men-', 'mencetak']),
        LearningRuleRow(cells: ['z', 'ziarah', 'men-', 'menziarah']),
        LearningRuleRow(cells: ['d', 'dengar', 'men-', 'mendengar']),
        LearningRuleRow(cells: ['j', 'jawab', 'men-', 'menjawab']),
        LearningRuleRow(cells: ['sy', 'syelek', 'men-', 'mensyelek']),
      ],
      footerNote:
          'Huruf awal kata dasar kekal apabila menggunakan imbuhan men-.',
    ),
    LearningStep(
      id: 'S013',
      title: 'Penggunaan imbuhan meng-',
      type: LearningStepType.table,
      subtitle:
          'Gunakan imbuhan meng- apabila kata dasar bermula dengan huruf vokal (a, e, i, o, u), g atau h.',
      voiceScript:
          'Imbuhan meng digunakan apabila kata dasar bermula dengan huruf vokal, huruf g atau huruf h. '
          'Contohnya, angkat menjadi mengangkat, otot menjadi mengotot, gali menjadi menggali dan halang menjadi menghalang. '
          'Huruf awal kata dasar kekal.',
      backgroundTop: Color(0xFFE3F0FF),
      backgroundBottom: Color(0xFFD2E6FF),
      tableHeaders: ['Huruf Awal', 'Kata Dasar', 'Imbuhan', 'Kata Berimbuhan'],
      tableRows: [
        LearningRuleRow(cells: ['a', 'angkat', 'meng-', 'mengangkat']),
        LearningRuleRow(cells: ['e', 'edar', 'meng-', 'mengedar']),
        LearningRuleRow(cells: ['i', 'ikat', 'meng-', 'mengikat']),
        LearningRuleRow(cells: ['o', 'otot', 'meng-', 'mengotot']),
        LearningRuleRow(cells: ['u', 'ukur', 'meng-', 'mengukur']),
        LearningRuleRow(cells: ['g', 'gali', 'meng-', 'menggali']),
        LearningRuleRow(cells: ['h', 'halang', 'meng-', 'menghalang']),
      ],
      footerNote:
          'Huruf awal kata dasar kekal apabila menggunakan imbuhan meng-.',
    ),
    LearningStep(
      id: 'S014',
      title: 'Penggunaan imbuhan menge-',
      type: LearningStepType.table,
      subtitle:
          'Imbuhan menge- digunakan apabila kata dasar terdiri daripada satu suku kata.',
      voiceScript:
          'Imbuhan menge digunakan apabila kata dasar terdiri daripada satu suku kata. '
          'Contohnya, cat menjadi mengecat, zip menjadi mengezip, bom menjadi mengebom dan lap menjadi mengelap. '
          'Jadi, jika kata dasarnya satu suku kata, kita gunakan imbuhan menge.',
      backgroundTop: Color(0xFFFFF3B7),
      backgroundBottom: Color(0xFFFFE490),
      tableHeaders: ['Kata Dasar (1 suku kata)', 'Imbuhan', 'Kata Berimbuhan'],
      tableRows: [
        LearningRuleRow(cells: ['cat', 'menge-', 'mengecat']),
        LearningRuleRow(cells: ['zip', 'menge-', 'mengezip']),
        LearningRuleRow(cells: ['bom', 'menge-', 'mengebom']),
        LearningRuleRow(cells: ['lap', 'menge-', 'mengelap']),
      ],
    ),
    LearningStep(
      id: 'S015',
      title: 'AmiN di Dalam Kelas',
      type: LearningStepType.situation,
      backgroundTop: Color(0xFFEAF5FF),
      backgroundBottom: Color(0xFFD2EAFF),
      hotspots: [
        LearningHotspot(
          label: 'Buku',
          baseWord: 'baca',
          derivedWord: 'membaca',
          alignment: Alignment(-0.62, -0.05),
        ),
        LearningHotspot(
          label: 'Pensel',
          baseWord: 'tulis',
          derivedWord: 'menulis',
          alignment: Alignment(0.64, -0.24),
        ),
        LearningHotspot(
          label: 'Guru',
          baseWord: 'ajar',
          derivedWord: 'mengajar',
          alignment: Alignment(0.30, -0.70),
        ),
        LearningHotspot(
          label: 'Jawab',
          baseWord: 'jawab',
          derivedWord: 'menjawab',
          alignment: Alignment(-0.06, -0.48),
        ),
      ],
    ),
    LearningStep(
      id: 'S016',
      title: 'AmiN di Padang Sekolah',
      type: LearningStepType.situation,
      backgroundTop: Color(0xFFE5FFE8),
      backgroundBottom: Color(0xFFCFF4D7),
      hotspots: [
        LearningHotspot(
          label: 'Tendang',
          baseWord: 'tendang',
          derivedWord: 'menendang',
          alignment: Alignment(-0.62, -0.28),
        ),
        LearningHotspot(
          label: 'Lompat',
          baseWord: 'lompat',
          derivedWord: 'melompat',
          alignment: Alignment(0.62, -0.20),
        ),
        LearningHotspot(
          label: 'Kejar',
          baseWord: 'kejar',
          derivedWord: 'mengejar',
          alignment: Alignment(0.03, -0.64),
        ),
        LearningHotspot(
          label: 'Angkat',
          baseWord: 'angkat',
          derivedWord: 'mengangkat',
          alignment: Alignment(-0.14, 0.0),
        ),
      ],
    ),
    LearningStep(
      id: 'S017',
      title: 'AmiN di Dapur',
      type: LearningStepType.situation,
      backgroundTop: Color(0xFFFFF0D8),
      backgroundBottom: Color(0xFFFFE3BF),
      hotspots: [
        LearningHotspot(
          label: 'Masak',
          baseWord: 'masak',
          derivedWord: 'memasak',
          alignment: Alignment(-0.60, -0.44),
        ),
        LearningHotspot(
          label: 'Potong',
          baseWord: 'potong',
          derivedWord: 'memotong',
          alignment: Alignment(0.60, -0.16),
        ),
        LearningHotspot(
          label: 'Lap',
          baseWord: 'lap',
          derivedWord: 'mengelap',
          alignment: Alignment(-0.08, -0.64),
        ),
        LearningHotspot(
          label: 'Cuci',
          baseWord: 'cuci',
          derivedWord: 'mencuci',
          alignment: Alignment(0.24, 0.02),
        ),
      ],
    ),
    LearningStep(
      id: 'S018',
      title: 'AmiN di Aktiviti Seni',
      type: LearningStepType.situation,
      backgroundTop: Color(0xFFEAF2FF),
      backgroundBottom: Color(0xFFD4E4FF),
      hotspots: [
        LearningHotspot(
          label: 'Cat',
          baseWord: 'cat',
          derivedWord: 'mengecat',
          alignment: Alignment(-0.62, -0.54),
        ),
        LearningHotspot(
          label: 'Warna',
          baseWord: 'warna',
          derivedWord: 'mewarna',
          alignment: Alignment(0.64, -0.38),
        ),
        LearningHotspot(
          label: 'Lukis',
          baseWord: 'lukis',
          derivedWord: 'melukis',
          alignment: Alignment(-0.10, -0.16),
        ),
        LearningHotspot(
          label: 'Gunting',
          baseWord: 'gunting',
          derivedWord: 'menggunting',
          alignment: Alignment(0.36, 0.02),
        ),
      ],
    ),
    LearningStep(
      id: 'S019',
      title: 'AmiN Gotong-Royong di Sekolah',
      type: LearningStepType.situation,
      backgroundTop: Color(0xFFE6FFF1),
      backgroundBottom: Color(0xFFCDF4DF),
      hotspots: [
        LearningHotspot(
          label: 'Sapu',
          baseWord: 'sapu',
          derivedWord: 'menyapu',
          alignment: Alignment(-0.64, -0.34),
        ),
        LearningHotspot(
          label: 'Buang',
          baseWord: 'buang',
          derivedWord: 'membuang',
          alignment: Alignment(0.62, -0.24),
        ),
        LearningHotspot(
          label: 'Pangkas',
          baseWord: 'pangkas',
          derivedWord: 'memangkas',
          alignment: Alignment(0.22, -0.62),
        ),
        LearningHotspot(
          label: 'Kutip',
          baseWord: 'kutip',
          derivedWord: 'mengutip',
          alignment: Alignment(-0.08, 0.03),
        ),
      ],
    ),
    LearningStep(
      id: 'S020',
      title: 'Ringkasan Imbuhan Awalan meN-',
      type: LearningStepType.summary,
      voiceScript:
          'Ini ialah ringkasan imbuhan awalan meN-. Ingat pola ini untuk membantu awak memilih imbuhan yang betul.',
      backgroundTop: Color(0xFFFFF8D5),
      backgroundBottom: Color(0xFFFFE9B1),
      summaryCards: [
        LearningSummaryCard(
          prefix: 'me-',
          ruleText: 'Huruf: l, m, n, r, w, y',
          example: 'melukis',
        ),
        LearningSummaryCard(
          prefix: 'mem-',
          ruleText: 'Huruf: b, f',
          example: 'membaca',
        ),
        LearningSummaryCard(
          prefix: 'men-',
          ruleText: 'Huruf: c, d, j, z, sy',
          example: 'menulis',
        ),
        LearningSummaryCard(
          prefix: 'meny-',
          ruleText: 'Huruf: s',
          example: 'menyapu',
        ),
        LearningSummaryCard(
          prefix: 'meng-',
          ruleText: 'Huruf vokal, g, h',
          example: 'mengangkat',
        ),
        LearningSummaryCard(
          prefix: 'menge-',
          ruleText: 'Satu suku kata',
          example: 'mengecat',
        ),
      ],
    ),
    LearningStep(
      id: 'S021',
      title: 'Selesai Belajar',
      type: LearningStepType.quizGateway,
      backgroundTop: Color(0xFFE6F2FF),
      backgroundBottom: Color(0xFFCFE5FF),
    ),
  ];
}
