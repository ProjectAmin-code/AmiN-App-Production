import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/app_routes.dart';
import '../../shared/gamification/gamification.dart';
import '../../shared/motion/app_motion_spec.dart';
import '../../shared/motion/app_motion_widgets.dart';
import '../../shared/progress/progress_tracker.dart';
import '../../shared/settings/app_settings_service.dart';
import '../../shared/widgets/adaptive_asset_image.dart';
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
  static const double _headingFontSize = 25;
  static const double _bodyFontSize = 20;
  static const double _buttonFontSize = 20;
  static const List<String> _fontFallback = [
    'Poppins',
    'Roboto',
    'Noto Sans',
    'Arial',
  ];
  static const List<Color> _highlightPalette = [
    Color(0xFFF59E0B),
    Color(0xFF10B981),
    Color(0xFF3B82F6),
    Color(0xFF8B5CF6),
    Color(0xFFEF4444),
    Color(0xFFEC4899),
  ];
  // Set this to false to remove all B07-B10 mascot animations and gap tuning.
  static const bool _enableB7ToB10ArrowEnhancements = true;
  static const Set<String> _arrowEnhancedStepIds = {'B07', 'B08', 'B09', 'B10'};
  static const String _arrowMascotRightAsset =
      'assets/Action Figures/AmiN pointing right.svg';
  static const String _arrowMascotPointingAsset =
      'assets/Action Figures/AmiN Pointing.svg';

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
    final gamification = _tryGetGamificationController();
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
    gamification?.awardXp(8, reason: 'Belajar ${_currentStep.id}');
    gamification?.updateStreak(success: true);
    ProgressTracker.instance.updateLearningStep(
      reachedStep: _currentIndex + 1,
      totalSteps: _steps.length,
    );
    await _speakCurrentStep();
  }

  GamificationController? _tryGetGamificationController() {
    final element = context
        .getElementForInheritedWidgetOfExactType<GamificationScope>();
    final widget = element?.widget;
    if (widget is GamificationScope) {
      return widget.notifier;
    }
    return null;
  }

  Future<void> _safeSpeak(Future<void> Function() speakAction) async {
    try {
      await speakAction();
    } catch (_) {
      // Keep UI interactions responsive even if TTS is unavailable.
    }
  }

  Future<void> _openHotspot(LearningHotspot hotspot) async {
    var revealAnswer = false;
    if (!mounted) {
      return;
    }
    final reducedFont = _useReducedFontForStep(_currentStep);
    final baseWordFontSize = reducedFont ? 28.0 : 30.0;
    final derivedWordFontSize = reducedFont ? 32.0 : 34.0;
    final noteFontSize = reducedFont ? 14.0 : 16.0;
    final modalFuture = showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            void revealAnswerInSameBox() {
              if (revealAnswer) {
                return;
              }
              setModalState(() => revealAnswer = true);
              if (_voiceEnabled) {
                unawaited(
                  _safeSpeak(
                    () => AminTtsService.instance.speakPair(
                      hotspot.baseWord,
                      hotspot.derivedWord,
                    ),
                  ),
                );
              }
            }

            return Dialog(
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 56,
                vertical: 120,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: revealAnswerInSameBox,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 260),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          hotspot.baseWord,
                          style: TextStyle(
                            fontSize: baseWordFontSize,
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
                        _buildHotspotDerivedWordText(
                          hotspot: hotspot,
                          revealAnswer: revealAnswer,
                          fontSize: derivedWordFontSize,
                          stepId: _currentStep.id,
                        ),
                        if (revealAnswer &&
                            hotspot.ruleNote.trim().isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Text(
                            hotspot.ruleNote,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: noteFontSize,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF334155),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (_voiceEnabled) {
      unawaited(
        _safeSpeak(() => AminTtsService.instance.speak(hotspot.baseWord)),
      );
    }

    await modalFuture;
  }

  Widget _buildHotspotDerivedWordText({
    required LearningHotspot hotspot,
    required bool revealAnswer,
    required double fontSize,
    required String stepId,
  }) {
    if (!revealAnswer) {
      return Text(
        '----',
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          color: const Color(0xFF94A3B8),
        ),
      );
    }

    final derivedWord = hotspot.derivedWord;
    final normalizedBaseWord = hotspot.baseWord.trim().toLowerCase();
    if (stepId == 'B13' && normalizedBaseWord == 'kejar') {
      final lower = derivedWord.toLowerCase();
      final clusterIndex = lower.indexOf('ng');
      if (clusterIndex >= 0) {
        final before = derivedWord.substring(0, clusterIndex);
        final highlighted = derivedWord.substring(
          clusterIndex,
          clusterIndex + 2,
        );
        final after = derivedWord.substring(clusterIndex + 2);
        return Text.rich(
          TextSpan(
            children: [
              TextSpan(text: before),
              TextSpan(
                text: highlighted,
                style: const TextStyle(
                  color: Color(0xFFEC4899),
                  fontWeight: FontWeight.w900,
                ),
              ),
              TextSpan(text: after),
            ],
          ),
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0B7285),
          ),
        );
      }
    }
    if (stepId == 'B13' &&
        normalizedBaseWord == 'tendang' &&
        derivedWord.length >= 3) {
      final before = derivedWord.substring(0, 2);
      final highlighted = derivedWord.substring(2, 3);
      final after = derivedWord.substring(3);
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(text: before),
            TextSpan(
              text: highlighted,
              style: const TextStyle(
                color: Color(0xFFEC4899),
                fontWeight: FontWeight.w900,
              ),
            ),
            TextSpan(text: after),
          ],
        ),
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          color: const Color(0xFF0B7285),
        ),
      );
    }
    if (stepId == 'B14' &&
        normalizedBaseWord == 'potong' &&
        derivedWord.length >= 3) {
      final before = derivedWord.substring(0, 2);
      final highlighted = derivedWord.substring(2, 3);
      final after = derivedWord.substring(3);
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(text: before),
            TextSpan(
              text: highlighted,
              style: const TextStyle(
                color: Color(0xFFEC4899),
                fontWeight: FontWeight.w900,
              ),
            ),
            TextSpan(text: after),
          ],
        ),
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          color: const Color(0xFF0B7285),
        ),
      );
    }
    if (stepId == 'B12' &&
        normalizedBaseWord == 'tulis' &&
        derivedWord.length >= 3) {
      final before = derivedWord.substring(0, 2);
      final highlighted = derivedWord.substring(2, 3);
      final after = derivedWord.substring(3);
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(text: before),
            TextSpan(
              text: highlighted,
              style: const TextStyle(
                color: Color(0xFFEC4899),
                fontWeight: FontWeight.w900,
              ),
            ),
            TextSpan(text: after),
          ],
        ),
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          color: const Color(0xFF0B7285),
        ),
      );
    }
    if (normalizedBaseWord == 'pangkas' && derivedWord.length >= 3) {
      final before = derivedWord.substring(0, 2);
      final highlighted = derivedWord.substring(2, 3);
      final after = derivedWord.substring(3);
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(text: before),
            TextSpan(
              text: highlighted,
              style: const TextStyle(
                color: Color(0xFFEC4899),
                fontWeight: FontWeight.w900,
              ),
            ),
            TextSpan(text: after),
          ],
        ),
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          color: const Color(0xFF0B7285),
        ),
      );
    }
    final customCluster = switch (normalizedBaseWord) {
      'kutip' => 'ng',
      'sapu' => 'ny',
      _ => null,
    };
    if (customCluster != null) {
      final lower = derivedWord.toLowerCase();
      final clusterIndex = lower.indexOf(customCluster);
      if (clusterIndex >= 0) {
        final before = derivedWord.substring(0, clusterIndex);
        final highlighted = derivedWord.substring(
          clusterIndex,
          clusterIndex + customCluster.length,
        );
        final after = derivedWord.substring(
          clusterIndex + customCluster.length,
        );
        return Text.rich(
          TextSpan(
            children: [
              TextSpan(text: before),
              TextSpan(
                text: highlighted,
                style: const TextStyle(
                  color: Color(0xFFEC4899),
                  fontWeight: FontWeight.w900,
                ),
              ),
              TextSpan(text: after),
            ],
          ),
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0B7285),
          ),
        );
      }
    }

    final prefixLength = switch (normalizedBaseWord) {
      'kejar' => 0,
      'angkat' || 'angkar' => 4,
      'cat' => 5,
      'lap' => 5,
      'lukis' => 2,
      'lompat' => 2,
      'masak' => 2,
      'gunting' => 4,
      'warna' => 2,
      'ajar' => 4,
      _ => 3,
    };
    final clampedPrefixLength = math.min(prefixLength, derivedWord.length);
    final pinkPrefix = derivedWord.substring(0, clampedPrefixLength);
    final suffix = derivedWord.substring(clampedPrefixLength);

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: pinkPrefix,
            style: const TextStyle(
              color: Color(0xFFEC4899),
              fontWeight: FontWeight.w900,
            ),
          ),
          TextSpan(text: suffix),
        ],
      ),
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w900,
        color: const Color(0xFF0B7285),
      ),
    );
  }

  Alignment _hotspotAlignmentForStep(
    LearningStep step,
    LearningHotspot hotspot,
  ) {
    if (step.id == 'B12') {
      const b12PreciseAlignments = <String, Alignment>{
        'membaca': Alignment(-0.53, 0.07),
        'menulis': Alignment(0.45, 0.35),
        'mengajar': Alignment(-0.06, -0.74),
        'menjawab': Alignment(0.47, -0.22),
      };
      return b12PreciseAlignments[hotspot.label] ?? hotspot.alignment;
    }
    if (step.id == 'B13') {
      final normalizedBaseWord = hotspot.baseWord.trim().toLowerCase();
      if (normalizedBaseWord == 'angkat' || normalizedBaseWord == 'angat') {
        return const Alignment(0.40, 0.56);
      }
      if (normalizedBaseWord == 'kejar') {
        return Alignment(hotspot.alignment.x, 0.20);
      }
      if (normalizedBaseWord == 'tendang') {
        return Alignment(hotspot.alignment.x + 0.04, 0.60);
      }
      if (normalizedBaseWord == 'lompat') {
        return Alignment(-0.41, -0.52);
      }
    }
    if (step.id == 'B14') {
      final normalizedBaseWord = hotspot.baseWord.trim().toLowerCase();
      if (normalizedBaseWord == 'lap') {
        return Alignment(hotspot.alignment.x + 0.20, 0.78);
      }
      if (normalizedBaseWord == 'potong') {
        return const Alignment(-0.26, 0.62);
      }
      if (normalizedBaseWord == 'cuci') {
        return const Alignment(0.78, 0.34);
      }
      if (normalizedBaseWord == 'masak') {
        return const Alignment(-0.96, -0.10);
      }
    }
    if (step.id == 'B15' && hotspot.baseWord.trim().toLowerCase() == 'cat') {
      return Alignment(hotspot.alignment.x + 0.04, hotspot.alignment.y - 0.04);
    }
    if (step.id == 'B15' && hotspot.baseWord.trim().toLowerCase() == 'lukis') {
      return Alignment(hotspot.alignment.x + 0.04, 0.97);
    }
    if (step.id == 'B15' && hotspot.baseWord.trim().toLowerCase() == 'warna') {
      return const Alignment(-0.40, 0.50);
    }
    if (step.id == 'B15' &&
        hotspot.baseWord.trim().toLowerCase() == 'gunting') {
      return const Alignment(0.90, 0.78);
    }
    if (step.id == 'B16' &&
        hotspot.baseWord.trim().toLowerCase() == 'pangkas') {
      return Alignment(hotspot.alignment.x + 0.25, 0.37);
    }
    if (step.id == 'B16' && hotspot.baseWord.trim().toLowerCase() == 'buang') {
      return const Alignment(-0.27, -0.50);
    }
    if (step.id == 'B16' && hotspot.baseWord.trim().toLowerCase() == 'kutip') {
      return const Alignment(0.75, 0.88);
    }
    if (step.id == 'B16' && hotspot.baseWord.trim().toLowerCase() == 'sapu') {
      return const Alignment(-0.95, 0.10);
    }
    return hotspot.alignment;
  }

  bool _usesRoundedHotspotStyle(LearningStep step) {
    return const {'B12', 'B13', 'B14', 'B15', 'B16', 'B17'}.contains(step.id);
  }

  Widget _buildHotspotStarButton({
    required LearningStep step,
    required VoidCallback onPressed,
  }) {
    final useRoundedStyle = _usesRoundedHotspotStyle(step);
    final button = IconButton.filled(
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: useRoundedStyle
            ? const Color(0xFFFFF4CC)
            : const Color(0xFFFFCA3A),
        foregroundColor: useRoundedStyle
            ? const Color(0xFFB45309)
            : const Color(0xFF1D3557),
        minimumSize: useRoundedStyle ? const Size(30, 30) : const Size(36, 36),
        padding: useRoundedStyle
            ? const EdgeInsets.fromLTRB(4, 3, 4, 5)
            : const EdgeInsets.all(6),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: useRoundedStyle
            ? const BorderSide(color: Color(0xFFF59E0B), width: 1.2)
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(useRoundedStyle ? 11 : 18),
        ),
        elevation: useRoundedStyle ? 2 : 0,
        shadowColor: useRoundedStyle ? const Color(0x55A16207) : null,
      ),
      icon: Icon(
        useRoundedStyle ? Icons.star : Icons.star_rounded,
        size: useRoundedStyle ? 16 : 20,
      ),
    );
    if (!useRoundedStyle) {
      return button;
    }
    return Padding(padding: const EdgeInsets.only(bottom: 2), child: button);
  }

  Widget _buildTopBar() {
    final progress = (_currentIndex + 1) / _steps.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 6),
      child: Row(
        children: [
          IconButton(
            onPressed: _goBack,
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(value: progress, minHeight: 6),
            ),
          ),
          const SizedBox(width: 4),
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

  Widget _titleBubble(String text, {double fontSize = _headingFontSize}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w800,
        color: Color(0xFF1D3557),
        fontFamily: 'Poppins',
        fontFamilyFallback: _fontFallback,
      ),
    );
  }

  Widget _contentCard({required Widget child, Color color = Colors.white}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  Widget _fitScaledContent({
    required Widget child,
    Alignment alignment = Alignment.topLeft,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox.expand(
          child: Align(
            alignment: alignment,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: alignment,
              child: SizedBox(width: constraints.maxWidth, child: child),
            ),
          ),
        );
      },
    );
  }

  bool _useReducedFontForStep(LearningStep step) {
    return const {'B12', 'B13', 'B14', 'B15', 'B16', 'B17'}.contains(step.id);
  }

  bool _useLeftAlignedParagraphs(LearningStep step) {
    return const {'B12', 'B13', 'B14', 'B15', 'B16'}.contains(step.id);
  }

  double _stepHeadingFontSize(LearningStep step) {
    return _useReducedFontForStep(step)
        ? _headingFontSize - 2
        : _headingFontSize;
  }

  double _stepBodyFontSize(LearningStep step) {
    return _useReducedFontForStep(step) ? _bodyFontSize - 2 : _bodyFontSize;
  }

  bool _isArrowEnhancedStep(LearningStep step) {
    return _enableB7ToB10ArrowEnhancements &&
        _arrowEnhancedStepIds.contains(step.id);
  }

  double _extraBottomSpacingFromB09(LearningStep step) {
    if (!_isArrowEnhancedStep(step)) {
      return 0;
    }
    switch (step.id) {
      case 'B07':
        return 44;
      case 'B08':
        return 18;
      case 'B10':
        return 72;
      case 'B09':
      default:
        return 0;
    }
  }

  String _arrowMascotAssetForStep(LearningStep step) {
    switch (step.id) {
      case 'B08':
      case 'B10':
        return _arrowMascotPointingAsset;
      case 'B07':
      case 'B09':
      default:
        return _arrowMascotRightAsset;
    }
  }

  double _arrowMascotSizeForStep(LearningStep step) {
    switch (step.id) {
      case 'B10':
        return 148;
      case 'B08':
        return 126;
      case 'B07':
        return 118;
      case 'B09':
      default:
        return 96;
    }
  }

  Alignment _arrowMascotAlignmentForStep(LearningStep step) {
    return Alignment.bottomRight;
  }

  Widget _buildB7ToB10MascotOverlay(LearningStep step) {
    final alignment = _arrowMascotAlignmentForStep(step);
    final edgePadding = alignment == Alignment.bottomLeft
        ? const EdgeInsets.only(left: 4, bottom: 2)
        : const EdgeInsets.only(right: 4, bottom: 2);
    final horizontalDirection = alignment == Alignment.bottomLeft ? -1.0 : 1.0;

    return IgnorePointer(
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: edgePadding,
          child: TweenAnimationBuilder<double>(
            key: ValueKey('arrow-mascot-${step.id}'),
            tween: Tween(begin: 0, end: 1),
            duration: AppMotionSpec.chooseDuration(
              context,
              const Duration(milliseconds: 360),
              const Duration(milliseconds: 220),
            ),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(
                    (1 - value) * 14 * horizontalDirection,
                    (1 - value) * 12,
                  ),
                  child: child,
                ),
              );
            },
            child: BreathingCharacter(
              begin: 0.99,
              end: 1.03,
              child: AdaptiveAssetImage(
                assetPath: _arrowMascotAssetForStep(step),
                width: _arrowMascotSizeForStep(step),
                height: _arrowMascotSizeForStep(step),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEquationExamplesStep(LearningStep step) {
    return _fitScaledContent(
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: _titleBubble(step.title),
          ),
          if (step.subtitle.isNotEmpty) ...[
            const SizedBox(height: 12),
            _contentCard(
              child: Text(
                step.subtitle,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: _bodyFontSize,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  fontFamilyFallback: _fontFallback,
                ),
              ),
            ),
          ],
          if (step.equationExamples.isNotEmpty) ...[
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                step.exampleSubheading,
                style: const TextStyle(
                  fontSize: _bodyFontSize + 2,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0B7285),
                  fontFamily: 'Poppins',
                  fontFamilyFallback: _fontFallback,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ...step.equationExamples.asMap().entries.map((entry) {
              final index = entry.key;
              final row = entry.value;
              return TweenAnimationBuilder<double>(
                key: ValueKey('${_currentStep.id}-equation-$index'),
                tween: Tween(begin: 0, end: 1),
                duration: Duration(milliseconds: 260 + (index * 70)),
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
                  padding: const EdgeInsets.only(bottom: 8),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _equationChip(row.left, row.leftColor),
                        _equationSymbol('+'),
                        _equationChip(row.middle, row.middleColor),
                        _equationSymbol('='),
                        _equationChip(row.right, row.rightColor),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
          if (step.colorLegends.isNotEmpty) ...[
            const SizedBox(height: 10),
            _contentCard(
              color: const Color(0xFFFCFFFC),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: step.colorLegends.map((legend) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: legend.color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Text(
                            '${legend.name}: ${legend.description}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF334155),
                              fontFamily: 'Poppins',
                              fontFamilyFallback: _fontFallback,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
          if (step.footerNote.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              step.footerNote,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF334155),
                height: 1.35,
                fontFamily: 'Poppins',
                fontFamilyFallback: _fontFallback,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildArrowExamplesStep(LearningStep step) {
    final extraBottomSpacing = _extraBottomSpacingFromB09(step);
    final content = _fitScaledContent(
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: _titleBubble(step.title),
          ),
          if (step.subtitle.isNotEmpty) ...[
            const SizedBox(height: 12),
            _contentCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.subtitle,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: _bodyFontSize,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      fontFamilyFallback: _fontFallback,
                    ),
                  ),
                  if (step.highlightedLetters.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text.rich(
                      _highlightedLettersSpan(step),
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF334155),
                        height: 1.35,
                        fontFamily: 'Poppins',
                        fontFamilyFallback: _fontFallback,
                      ),
                    ),
                  ],
                  if (step.afterHighlightLine.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      step.afterHighlightLine,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontSize: _bodyFontSize,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        fontFamilyFallback: _fontFallback,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
          if (step.exampleSubheading.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              step.exampleSubheading,
              style: const TextStyle(
                fontSize: _bodyFontSize + 2,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0B7285),
                fontFamily: 'Poppins',
                fontFamilyFallback: _fontFallback,
              ),
            ),
          ],
          if (step.arrowRows.isNotEmpty) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: step.arrowRows.asMap().entries.map((entry) {
                      final index = entry.key;
                      final row = entry.value;
                      final showLetterChip = row.letter.trim().isNotEmpty;
                      return TweenAnimationBuilder<double>(
                        key: ValueKey('${_currentStep.id}-arrow-$index'),
                        tween: Tween(begin: 0, end: 1),
                        duration: Duration(milliseconds: 240 + (index * 70)),
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
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (showLetterChip) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 9,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _arrowLetterColor(step, row, index),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    row.letter,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                      fontFamilyFallback: _fontFallback,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  '\u2192',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF1D3557),
                                    fontFamily: 'Poppins',
                                    fontFamilyFallback: _fontFallback,
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Text(
                                row.baseWord,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1D3557),
                                  fontFamily: 'Poppins',
                                  fontFamilyFallback: _fontFallback,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '\u2192',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF1D3557),
                                  fontFamily: 'Poppins',
                                  fontFamilyFallback: _fontFallback,
                                ),
                              ),
                              const SizedBox(width: 8),
                              _highlightPrefixOnly(
                                row.derivedWord,
                                step.highlightedPrefix,
                                prefixColor: const Color(0xFFEC4899),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
          if (step.footerNote.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              step.footerNote,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF334155),
                height: 1.35,
                fontFamily: 'Poppins',
                fontFamilyFallback: _fontFallback,
              ),
            ),
          ],
          if (extraBottomSpacing > 0) SizedBox(height: extraBottomSpacing),
        ],
      ),
    );

    if (!_isArrowEnhancedStep(step)) {
      return content;
    }

    return Stack(
      fit: StackFit.expand,
      children: [content, _buildB7ToB10MascotOverlay(step)],
    );
  }

  TextSpan _highlightedLettersSpan(LearningStep step) {
    if (step.id == 'B09' && step.highlightedLetters.length >= 7) {
      final letters = step.highlightedLetters;
      return TextSpan(
        children: [
          const TextSpan(text: 'huruf vokal ('),
          _coloredLetterSpan(letters[0], 0),
          const TextSpan(text: ', '),
          _coloredLetterSpan(letters[1], 1),
          const TextSpan(text: ', '),
          _coloredLetterSpan(letters[2], 2),
          const TextSpan(text: ', '),
          _coloredLetterSpan(letters[3], 3),
          const TextSpan(text: ', '),
          _coloredLetterSpan(letters[4], 4),
          const TextSpan(text: ') dan huruf konsonan ('),
          _coloredLetterSpan(letters[5], 5),
          const TextSpan(text: ','),
          _coloredLetterSpan(letters[6], 6),
          const TextSpan(text: ')'),
        ],
      );
    }
    return _commaSeparatedHighlightedLetters(step.highlightedLetters);
  }

  TextSpan _commaSeparatedHighlightedLetters(List<String> letters) {
    final children = <InlineSpan>[];
    for (var i = 0; i < letters.length; i++) {
      children.add(_coloredLetterSpan(letters[i], i));
      if (i < letters.length - 1) {
        children.add(const TextSpan(text: ', '));
      } else {
        children.add(const TextSpan(text: '.'));
      }
    }
    return TextSpan(children: children);
  }

  TextSpan _coloredLetterSpan(String text, int index) {
    return TextSpan(
      text: text,
      style: TextStyle(
        color: _highlightColorForIndex(index),
        fontWeight: FontWeight.w900,
        fontSize: 22,
      ),
    );
  }

  Color _highlightColorForIndex(int index) {
    return _highlightPalette[index % _highlightPalette.length];
  }

  Color _arrowLetterColor(LearningStep step, LearningArrowRow row, int index) {
    if (step.id == 'B07') {
      final normalizedLetter = row.letter.trim().toLowerCase();
      if (normalizedLetter == 'b') {
        return const Color(0xFFF59E0B); // Orange
      }
      if (normalizedLetter == 'f') {
        return const Color(0xFF10B981); // Green
      }
    }
    return _highlightColorForIndex(index);
  }

  Widget _highlightPrefixOnly(
    String word,
    String prefix, {
    required Color prefixColor,
  }) {
    if (prefix.isEmpty || !word.startsWith(prefix)) {
      return Text(
        word,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1D3557),
          fontFamily: 'Poppins',
          fontFamilyFallback: _fontFallback,
        ),
      );
    }

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: prefix,
            style: TextStyle(color: prefixColor, fontWeight: FontWeight.w900),
          ),
          TextSpan(text: word.substring(prefix.length)),
        ],
      ),
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1D3557),
        fontFamily: 'Poppins',
        fontFamilyFallback: _fontFallback,
      ),
    );
  }

  Widget _equationChip(String text, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w800,
          fontFamily: 'Poppins',
          fontFamilyFallback: _fontFallback,
        ),
      ),
    );
  }

  Widget _equationSymbol(String symbol) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        symbol,
        style: const TextStyle(
          color: Color(0xFF1D3557),
          fontSize: 23,
          fontWeight: FontWeight.w900,
          fontFamily: 'Poppins',
          fontFamilyFallback: _fontFallback,
        ),
      ),
    );
  }

  Widget _buildTableStep(LearningStep step) {
    return _fitScaledContent(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleBubble(step.title),
          const SizedBox(height: 12),
          if (step.subtitle.isNotEmpty)
            _contentCard(
              child: Text(
                step.subtitle,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: _bodyFontSize,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  fontFamilyFallback: _fontFallback,
                ),
              ),
            ),
          if (step.exampleSubheading.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              step.exampleSubheading,
              style: const TextStyle(
                fontSize: _bodyFontSize + 2,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0B7285),
                fontFamily: 'Poppins',
                fontFamilyFallback: _fontFallback,
              ),
            ),
          ],
          const SizedBox(height: 12),
          _tableCard(step),
          if (step.footerNote.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              step.footerNote,
              style: const TextStyle(
                fontSize: _bodyFontSize,
                height: 1.4,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2F4858),
                fontFamily: 'Poppins',
                fontFamilyFallback: _fontFallback,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Map<int, TableColumnWidth> _tableColumnWidths(int columnCount) {
    if (columnCount <= 2) {
      return const {0: FlexColumnWidth(1.1), 1: FlexColumnWidth(2.1)};
    }
    if (columnCount == 3) {
      return const {
        0: FlexColumnWidth(0.9),
        1: FlexColumnWidth(1.8),
        2: FlexColumnWidth(1.3),
      };
    }
    if (columnCount >= 4) {
      return const {
        0: FlexColumnWidth(0.9),
        1: FlexColumnWidth(1.2),
        2: FlexColumnWidth(1.0),
        3: FlexColumnWidth(1.35),
      };
    }
    return {};
  }

  Widget _tableCard(LearningStep step) {
    final columnWidths = _tableColumnWidths(step.tableHeaders.length);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD0E6F5)),
      ),
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        defaultColumnWidth: const FlexColumnWidth(),
        columnWidths: columnWidths,
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
                      vertical: 12,
                    ),
                    child: Text(
                      header,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: _bodyFontSize,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Poppins',
                        fontFamilyFallback: _fontFallback,
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
                  duration: Duration(milliseconds: 300 + (rowIndex * 80)),
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
                      vertical: 12,
                    ),
                    child: Text(
                      cell,
                      style: const TextStyle(
                        fontSize: _bodyFontSize,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        fontFamily: 'Poppins',
                        fontFamilyFallback: _fontFallback,
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildChangeCardsStep(LearningStep step) {
    return _fitScaledContent(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleBubble(step.title),
          if (step.subtitle.isNotEmpty) ...[
            const SizedBox(height: 12),
            _contentCard(
              color: const Color(0xFFFFF5E0),
              child: Text(
                step.subtitle,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: _bodyFontSize,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  fontFamilyFallback: _fontFallback,
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          ...step.changeCards.asMap().entries.map((entry) {
            final index = entry.key;
            final card = entry.value;
            final accentColor = card.accentColor;
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
                      decoration: BoxDecoration(
                        color: accentColor,
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
                            style: TextStyle(
                              fontSize: _bodyFontSize,
                              fontWeight: FontWeight.w900,
                              color: accentColor,
                              fontFamily: 'Poppins',
                              fontFamilyFallback: _fontFallback,
                            ),
                          ),
                          Text(
                            card.note,
                            style: TextStyle(
                              fontSize: _bodyFontSize,
                              fontWeight: FontWeight.w700,
                              color: accentColor.withValues(alpha: 0.9),
                              fontFamily: 'Poppins',
                              fontFamilyFallback: _fontFallback,
                            ),
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
                fontSize: _bodyFontSize,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1D3557),
                fontFamily: 'Poppins',
                fontFamilyFallback: _fontFallback,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildB11ImageHeadingStep(LearningStep step) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final imageSize = math.min(constraints.maxWidth * 0.72, 280.0);
        return Center(
          child: TweenAnimationBuilder<double>(
            key: ValueKey('b11-image-heading-${step.id}'),
            tween: Tween(begin: 0, end: 1),
            duration: AppMotionSpec.chooseDuration(
              context,
              const Duration(milliseconds: 420),
              const Duration(milliseconds: 220),
            ),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, (1 - value) * 16),
                  child: child,
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BreathingCharacter(
                  begin: 0.99,
                  end: 1.03,
                  child: AdaptiveAssetImage(
                    assetPath:
                        'assets/Action Figures/AmiN showing both hands.svg',
                    width: imageSize,
                    height: imageSize,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  step.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: _headingFontSize,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1D3557),
                    fontFamily: 'Poppins',
                    fontFamilyFallback: _fontFallback,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSituationStep(LearningStep step) {
    final headingSize = _stepHeadingFontSize(step);
    final bodySize = _stepBodyFontSize(step);
    final paragraphAlign = _useLeftAlignedParagraphs(step)
        ? TextAlign.left
        : TextAlign.justify;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (step.instructionTitle.isNotEmpty || step.instructionBody.isNotEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5D6),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFF4D47D)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (step.instructionTitle.isNotEmpty)
                  Text(
                    step.instructionTitle,
                    style: TextStyle(
                      fontSize: headingSize,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1D3557),
                      fontFamily: 'Poppins',
                      fontFamilyFallback: _fontFallback,
                    ),
                  ),
                if (step.instructionBody.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    step.instructionBody,
                    textAlign: paragraphAlign,
                    style: TextStyle(
                      fontSize: bodySize,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF334155),
                      fontFamily: 'Poppins',
                      fontFamilyFallback: _fontFallback,
                    ),
                  ),
                ],
              ],
            ),
          ),
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (step.sceneImageAsset.isNotEmpty)
                    AdaptiveAssetImage(
                      assetPath: step.sceneImageAsset,
                      fit: BoxFit.cover,
                    ),
                  Container(color: Colors.black.withValues(alpha: 0.08)),
                  ...step.hotspots.asMap().entries.map((entry) {
                    final index = entry.key;
                    final hotspot = entry.value;
                    return Align(
                      alignment: _hotspotAlignmentForStep(step, hotspot),
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
                              child: _buildHotspotStarButton(
                                step: step,
                                onPressed: () => _openHotspot(hotspot),
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
        ),
      ],
    );
  }

  Widget _buildSummaryStep(LearningStep step) {
    final isB17 = step.id == 'B17';
    final headingSize = isB17
        ? _headingFontSize + 1
        : _stepHeadingFontSize(step);
    final bodySize = isB17 ? _bodyFontSize : _stepBodyFontSize(step);
    Widget summaryContent(BoxConstraints constraints) {
      final contentWidth = isB17
          ? constraints.maxWidth * 0.9
          : constraints.maxWidth;
      final cardWidth = isB17 || constraints.maxWidth < 360
          ? contentWidth
          : (constraints.maxWidth - 10) / 2;

      return Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: contentWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _titleBubble(step.title, fontSize: headingSize),
              if (step.subtitle.isNotEmpty) ...[
                const SizedBox(height: 10),
                _contentCard(
                  child: Text(
                    step.subtitle,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: bodySize,
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                      color: Color(0xFF334155),
                      fontFamily: 'Poppins',
                      fontFamilyFallback: _fontFallback,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: step.summaryCards
                    .map(
                      (card) => SizedBox(
                        width: cardWidth,
                        child: _summaryCard(
                          card,
                          headingSize: headingSize,
                          bodySize: bodySize,
                        ),
                      ),
                    )
                    .toList(),
              ),
              if (!isB17) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: IgnorePointer(
                    child: AdaptiveAssetImage(
                      assetPath:
                          'assets/Action Figures/AmiN pointing right.svg',
                      width: 96,
                      height: 96,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    if (isB17) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(child: summaryContent(constraints));
        },
      );
    }

    return _fitScaledContent(
      alignment: Alignment.topCenter,
      child: LayoutBuilder(
        builder: (context, constraints) => summaryContent(constraints),
      ),
    );
  }

  Widget _summaryCard(
    LearningSummaryCard card, {
    required double headingSize,
    required double bodySize,
  }) {
    final accentColor = _summaryCardAccentColor(card.prefix);
    final boxColor = Color.alphaBlend(
      accentColor.withValues(alpha: 0.14),
      Colors.white,
    );
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accentColor.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            card.prefix,
            style: TextStyle(
              fontSize: headingSize,
              fontWeight: FontWeight.w900,
              color: accentColor,
              fontFamily: 'Poppins',
              fontFamilyFallback: _fontFallback,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            card.ruleText,
            style: TextStyle(
              fontSize: bodySize,
              fontWeight: FontWeight.w700,
              height: 1.35,
              color: const Color(0xFF1D3557),
              fontFamily: 'Poppins',
              fontFamilyFallback: _fontFallback,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Contoh: ${card.example}',
            style: TextStyle(
              fontSize: bodySize,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1D3557),
              fontFamily: 'Poppins',
              fontFamilyFallback: _fontFallback,
            ),
          ),
        ],
      ),
    );
  }

  Color _summaryCardAccentColor(String prefix) {
    switch (prefix.trim().toLowerCase()) {
      case 'me-':
        return const Color(0xFF4DA8FF);
      case 'men-':
        return const Color(0xFF26B99A);
      case 'mem-':
        return const Color(0xFFFF9F43);
      case 'meng-':
        return const Color(0xFF8E6CFF);
      case 'menge-':
        return const Color(0xFFFF6FAE);
      default:
        return const Color(0xFF0B7285);
    }
  }

  Widget _buildCompletionStep() {
    return _fitScaledContent(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BreathingCharacter(
                child: AdaptiveAssetImage(
                  assetPath: 'assets/Icon/AmiN for APP Pic.min.svg',
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
                    'Anda telah menyelesaikan pembelajaran imbuhan meN-.',
                    style: TextStyle(
                      fontSize: _bodyFontSize,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1D3557),
                      fontFamily: 'Poppins',
                      fontFamilyFallback: _fontFallback,
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
              'Tekan butang di bawah untuk kembali ke menu utama.',
              style: TextStyle(
                color: Color(0xFF1D3557),
                fontSize: _bodyFontSize,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins',
                fontFamilyFallback: _fontFallback,
              ),
            ),
          ),
          const SizedBox(height: 12),
          AnimatedKidButton(
            label: 'Kembali ke Menu Utama',
            icon: Icons.home_rounded,
            onPressed: () => context.go(AppRoutes.s003MainMenu),
            backgroundColor: const Color(0xFF2A9D8F),
            labelFontSize: _buttonFontSize,
          ),
        ],
      ),
    );
  }

  Widget _buildStepBody(LearningStep step) {
    if (step.id == 'B11') {
      return _buildB11ImageHeadingStep(step);
    }
    switch (step.type) {
      case LearningStepType.equationExamples:
        return _buildEquationExamplesStep(step);
      case LearningStepType.arrowExamples:
        return _buildArrowExamplesStep(step);
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
          child: DefaultTextStyle.merge(
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontFamilyFallback: _fontFallback,
            ),
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.52),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildStepBody(step)),
                            if (step.type != LearningStepType.quizGateway) ...[
                              const SizedBox(height: 12),
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
                                                _pulseController.value *
                                                    math.pi,
                                              ) *
                                              0.02;
                                    return Transform.rotate(
                                      angle: angle,
                                      child: child,
                                    );
                                  },
                                  child: AnimatedKidButton(
                                    label: step.buttonText,
                                    icon: Icons.arrow_forward_rounded,
                                    onPressed: () {
                                      _goNext();
                                    },
                                    backgroundColor: const Color(0xFFFFC300),
                                    foregroundColor: const Color(0xFF1D3557),
                                    labelFontSize: _buttonFontSize,
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
      ),
    );
  }
}

List<LearningStep> _buildSteps() {
  return const [
    LearningStep(
      id: 'B01',
      title: 'Kenali imbuhan',
      type: LearningStepType.equationExamples,
      subtitle:
          'Imbuhan ialah bahagian yang ditambah pada kata dasar untuk membentuk perkataan baharu.',
      backgroundTop: Color(0xFFE9F6FF),
      backgroundBottom: Color(0xFFD5ECFF),
      exampleSubheading: 'Contoh',
      equationExamples: [
        LearningEquationExample(left: 'ber', middle: 'lari', right: 'berlari'),
        LearningEquationExample(
          left: 'men',
          middle: 'dengar',
          right: 'mendengar',
        ),
        LearningEquationExample(
          left: 'makan',
          middle: 'an',
          right: 'makanan',
          leftColor: Color(0xFF0EA5E9),
          middleColor: Color(0xFFFACC15),
        ),
        LearningEquationExample(
          left: 'minum',
          middle: 'an',
          right: 'minuman',
          leftColor: Color(0xFF0EA5E9),
          middleColor: Color(0xFFFACC15),
        ),
      ],
      colorLegends: [
        LearningColorLegend(
          color: Color(0xFFFACC15),
          name: 'Kuning',
          description: 'Imbuhan',
        ),
        LearningColorLegend(
          color: Color(0xFF0EA5E9),
          name: 'Biru',
          description: 'Kata dasar',
        ),
        LearningColorLegend(
          color: Color(0xFF4CAF50),
          name: 'Hijau',
          description: 'Perkataan baharu',
        ),
      ],
    ),
    LearningStep(
      id: 'B02',
      title: 'Kenali imbuhan awalan',
      type: LearningStepType.equationExamples,
      subtitle:
          'Imbuhan awalan ialah imbuhan yang ditambah di hadapan kata dasar.',
      backgroundTop: Color(0xFFFFF7E3),
      backgroundBottom: Color(0xFFFFECCB),
      exampleSubheading: 'Contoh',
      equationExamples: [
        LearningEquationExample(left: 'ber', middle: 'lari', right: 'berlari'),
        LearningEquationExample(left: 'di', middle: 'beli', right: 'dibeli'),
        LearningEquationExample(
          left: 'ter',
          middle: 'tidur',
          right: 'tertidur',
        ),
        LearningEquationExample(left: 'meN-', middle: 'baca', right: 'membaca'),
        LearningEquationExample(
          left: 'peN-',
          middle: 'tulis',
          right: 'penulis',
        ),
      ],
      colorLegends: [
        LearningColorLegend(
          color: Color(0xFFFACC15),
          name: 'Kuning',
          description: 'Imbuhan',
        ),
        LearningColorLegend(
          color: Color(0xFF0EA5E9),
          name: 'Biru',
          description: 'Kata dasar',
        ),
        LearningColorLegend(
          color: Color(0xFF4CAF50),
          name: 'Hijau',
          description: 'Perkataan baharu',
        ),
      ],
    ),
    LearningStep(
      id: 'B03',
      title: 'Kenali imbuhan meN-',
      type: LearningStepType.equationExamples,
      subtitle:
          'Imbuhan meN- digunakan untuk membentuk kata kerja.\n'
          'Kata kerja ialah perbuatan.',
      backgroundTop: Color(0xFFEAF2FF),
      backgroundBottom: Color(0xFFDCE9FF),
      exampleSubheading: 'Contoh',
      equationExamples: [
        LearningEquationExample(left: 'meN-', middle: 'tari', right: 'menari'),
        LearningEquationExample(
          left: 'meN-',
          middle: 'masak',
          right: 'memasak',
        ),
        LearningEquationExample(left: 'meN-', middle: 'cat', right: 'mengecat'),
        LearningEquationExample(
          left: 'meN-',
          middle: 'tulis',
          right: 'menulis',
        ),
        LearningEquationExample(left: 'meN-', middle: 'sapu', right: 'menyapu'),
      ],
      colorLegends: [
        LearningColorLegend(
          color: Color(0xFFFACC15),
          name: 'Kuning',
          description: 'Imbuhan',
        ),
        LearningColorLegend(
          color: Color(0xFF0EA5E9),
          name: 'Biru',
          description: 'Kata dasar',
        ),
        LearningColorLegend(
          color: Color(0xFF4CAF50),
          name: 'Hijau',
          description: 'Perkataan baharu',
        ),
      ],
    ),
    LearningStep(
      id: 'B04',
      title: 'Jenis imbuhan meN-',
      type: LearningStepType.table,
      subtitle:
          'Imbuhan meN- digunakan untuk membentuk kata kerja.\n'
          'Imbuhan ini berubah mengikut huruf awal kata dasar.',
      backgroundTop: Color(0xFFFFF8D2),
      backgroundBottom: Color(0xFFFFEBB1),
      exampleSubheading: 'Contoh',
      tableHeaders: ['Bentuk imbuhan', 'Gunakan apabila'],
      tableRows: [
        LearningRuleRow(cells: ['me-', 'l, m, n, r, w, y']),
        LearningRuleRow(cells: ['men-', 'd, j, z, sy']),
        LearningRuleRow(cells: ['mem-', 'b, f (p gugur)']),
        LearningRuleRow(cells: ['meng-', 'g, h, kh (k gugur)']),
        LearningRuleRow(cells: ['menge-', 'kata dasar satu suku kata']),
      ],
    ),
    LearningStep(
      id: 'B05',
      title: 'Penggunaan imbuhan me-',
      type: LearningStepType.arrowExamples,
      subtitle: 'Gunakan imbuhan me- apabila kata dasar bermula dengan huruf:',
      backgroundTop: Color(0xFFFFF8D2),
      backgroundBottom: Color(0xFFFFEBB1),
      highlightedLetters: ['l', 'm', 'n', 'r', 'w', 'y'],
      afterHighlightLine: 'Huruf awal tidak berubah.',
      exampleSubheading: 'Contoh',
      arrowRows: [
        LearningArrowRow(
          letter: 'l',
          baseWord: 'lukis',
          derivedWord: 'melukis',
        ),
        LearningArrowRow(
          letter: 'm',
          baseWord: 'masak',
          derivedWord: 'memasak',
        ),
        LearningArrowRow(
          letter: 'n',
          baseWord: 'nanti',
          derivedWord: 'menanti',
        ),
        LearningArrowRow(
          letter: 'r',
          baseWord: 'ronda',
          derivedWord: 'meronda',
        ),
        LearningArrowRow(
          letter: 'w',
          baseWord: 'warna',
          derivedWord: 'mewarna',
        ),
      ],
      footerNote:
          'Huruf lain seperti p, t, k dan s akan menyebabkan imbuhan meN- berubah.\n'
          'Ini akan diterangkan dalam skrin seterusnya.',
    ),
    LearningStep(
      id: 'B06',
      title: 'Kenapa imbuhan meN- berubah?',
      type: LearningStepType.changeCards,
      subtitle: 'Imbuhan meN- berubah untuk memudahkan sebutan.',
      backgroundTop: Color(0xFFFFF4CC),
      backgroundBottom: Color(0xFFFFE6A3),
      changeCards: [
        LearningChangeCard(
          letter: 'p',
          example: 'potong -> memotong',
          note: 'p berubah menjadi m',
          accentColor: Color(0xFFEF4444),
        ),
        LearningChangeCard(
          letter: 't',
          example: 'tulis -> menulis',
          note: 't berubah menjadi n',
          accentColor: Color(0xFF8B5CF6),
        ),
        LearningChangeCard(
          letter: 'k',
          example: 'kawal -> mengawal',
          note: 'k berubah menjadi ng',
          accentColor: Color(0xFF059669),
        ),
        LearningChangeCard(
          letter: 's',
          example: 'sapu -> menyapu',
          note: 's berubah menjadi ny',
          accentColor: Color(0xFF0EA5E9),
        ),
      ],
    ),
    LearningStep(
      id: 'B07',
      title: 'Penggunaan imbuhan mem-',
      type: LearningStepType.arrowExamples,
      subtitle: 'Gunakan imbuhan mem- apabila kata dasar bermula dengan huruf:',
      backgroundTop: Color(0xFFFFE5CD),
      backgroundBottom: Color(0xFFFFD0A6),
      highlightedLetters: ['b', 'f'],
      afterHighlightLine: 'Huruf awal tidak berubah.',
      exampleSubheading: 'Contoh:',
      arrowRows: [
        LearningArrowRow(letter: 'b', baseWord: 'beli', derivedWord: 'membeli'),
        LearningArrowRow(
          letter: 'b',
          baseWord: 'bantu',
          derivedWord: 'membantu',
        ),
        LearningArrowRow(
          letter: 'f',
          baseWord: 'fitnah',
          derivedWord: 'memfitnah',
        ),
        LearningArrowRow(
          letter: 'f',
          baseWord: 'fokus',
          derivedWord: 'memfokus',
        ),
      ],
      highlightedPrefix: 'mem',
    ),
    LearningStep(
      id: 'B08',
      title: 'Penggunaan imbuhan men-',
      type: LearningStepType.arrowExamples,
      subtitle: 'Gunakan imbuhan men- apabila kata dasar bermula dengan huruf:',
      backgroundTop: Color(0xFFFFF7D0),
      backgroundBottom: Color(0xFFE0F8EF),
      highlightedLetters: ['c', 'd', 'j', 'z', 'sy'],
      afterHighlightLine: 'Huruf awal tidak berubah.',
      exampleSubheading: 'Contoh:',
      arrowRows: [
        LearningArrowRow(
          letter: 'c',
          baseWord: 'cetak',
          derivedWord: 'mencetak',
        ),
        LearningArrowRow(
          letter: 'd',
          baseWord: 'dengar',
          derivedWord: 'mendengar',
        ),
        LearningArrowRow(
          letter: 'j',
          baseWord: 'jawab',
          derivedWord: 'menjawab',
        ),
        LearningArrowRow(
          letter: 'z',
          baseWord: 'ziarah',
          derivedWord: 'menziarah',
        ),
        LearningArrowRow(
          letter: 'sy',
          baseWord: 'syor',
          derivedWord: 'mensyor',
        ),
      ],
      highlightedPrefix: 'men',
    ),
    LearningStep(
      id: 'B09',
      title: 'Penggunaan imbuhan meng-',
      type: LearningStepType.arrowExamples,
      subtitle: 'Gunakan imbuhan meng- apabila kata dasar bermula dengan:',
      backgroundTop: Color(0xFFE3F0FF),
      backgroundBottom: Color(0xFFD2E6FF),
      highlightedLetters: ['a', 'e', 'i', 'o', 'u', 'g', 'h'],
      afterHighlightLine: 'Huruf awal tidak berubah.',
      exampleSubheading: 'Contoh',
      arrowRows: [
        LearningArrowRow(
          letter: 'a',
          baseWord: 'angkat',
          derivedWord: 'mengangkat',
        ),
        LearningArrowRow(
          letter: 'i',
          baseWord: 'ikat',
          derivedWord: 'mengikat',
        ),
        LearningArrowRow(
          letter: 'o',
          baseWord: 'otot',
          derivedWord: 'mengotot',
        ),
        LearningArrowRow(
          letter: 'g',
          baseWord: 'gali',
          derivedWord: 'menggali',
        ),
        LearningArrowRow(
          letter: 'h',
          baseWord: 'halang',
          derivedWord: 'menghalang',
        ),
      ],
      highlightedPrefix: 'meng',
    ),
    LearningStep(
      id: 'B10',
      title: 'Penggunaan imbuhan menge-',
      type: LearningStepType.arrowExamples,
      subtitle:
          'Gunakan imbuhan menge- apabila kata dasar terdiri daripada satu suku kata.',
      backgroundTop: Color(0xFFFFF3B7),
      backgroundBottom: Color(0xFFFFE490),
      exampleSubheading: 'Contoh',
      arrowRows: [
        LearningArrowRow(letter: '', baseWord: 'cat', derivedWord: 'mengecat'),
        LearningArrowRow(letter: '', baseWord: 'bom', derivedWord: 'mengebom'),
        LearningArrowRow(letter: '', baseWord: 'lap', derivedWord: 'mengelap'),
        LearningArrowRow(letter: '', baseWord: 'pam', derivedWord: 'mengepam'),
      ],
      highlightedPrefix: 'menge',
    ),
    LearningStep(
      id: 'B11',
      title: 'Mari kita belajar imbuhan awalan melalui situasi.',
      type: LearningStepType.changeCards,
      backgroundTop: Color(0xFFFFF8D2),
      backgroundBottom: Color(0xFFFFE7A7),
      subtitle:
          'Situasi ini membantu anda memilih imbuhan berdasarkan huruf awal kata dasar.',
    ),
    LearningStep(
      id: 'B12',
      title: 'Situasi: AmiN di dalam kelas',
      type: LearningStepType.situation,
      backgroundTop: Color(0xFFEAF5FF),
      backgroundBottom: Color(0xFFD2EAFF),
      sceneImageAsset: 'assets/Belajar/AmiN di dalam kelas.svg',
      instructionTitle: 'Situasi: AmiN di dalam kelas',
      instructionBody:
          'Arahan: Tekan ⭐ dan cuba fikir jawapan dahulu.\n'
          'Gunakan imbuhan yang betul berdasarkan huruf awal kata dasar.',
      hotspots: [
        LearningHotspot(
          label: 'membaca',
          baseWord: 'baca',
          derivedWord: 'membaca',
          alignment: Alignment(-0.62, -0.05),
          ruleNote: 'Tiada perubahan huruf',
        ),
        LearningHotspot(
          label: 'menulis',
          baseWord: 'tulis',
          derivedWord: 'menulis',
          alignment: Alignment(0.64, -0.24),
          ruleNote: 'Huruf t berubah menjadi n',
        ),
        LearningHotspot(
          label: 'mengajar',
          baseWord: 'ajar',
          derivedWord: 'mengajar',
          alignment: Alignment(0.30, -0.70),
          ruleNote: 'Huruf vokal "a" menggunakan imbuhan meng-',
        ),
        LearningHotspot(
          label: 'menjawab',
          baseWord: 'jawab',
          derivedWord: 'menjawab',
          alignment: Alignment(-0.06, -0.48),
          ruleNote: 'Tiada perubahan huruf',
        ),
      ],
    ),
    LearningStep(
      id: 'B13',
      title: 'Situasi: AmiN di padang sekolah',
      type: LearningStepType.situation,
      backgroundTop: Color(0xFFE5FFE8),
      backgroundBottom: Color(0xFFCFF4D7),
      sceneImageAsset: 'assets/Belajar/AmiN di padang sekolah.svg',
      instructionTitle: 'Situasi: AmiN di padang sekolah',
      instructionBody:
          'Arahan: Tekan ⭐ dan cuba fikir jawapan dahulu.\n'
          'Gunakan imbuhan yang betul berdasarkan huruf awal kata dasar.',
      hotspots: [
        LearningHotspot(
          label: 'mengangkat',
          baseWord: 'angkat',
          derivedWord: 'mengangkat',
          alignment: Alignment(-0.14, 0.0),
          ruleNote: 'Huruf vokal "a" menggunakan imbuhan meng-',
        ),
        LearningHotspot(
          label: 'menendang',
          baseWord: 'tendang',
          derivedWord: 'menendang',
          alignment: Alignment(-0.62, -0.28),
          ruleNote: 'Huruf t berubah menjadi n',
        ),
        LearningHotspot(
          label: 'mengejar',
          baseWord: 'kejar',
          derivedWord: 'mengejar',
          alignment: Alignment(0.03, -0.64),
          ruleNote: 'Huruf k digugurkan dan menggunakan imbuhan meng-',
        ),
        LearningHotspot(
          label: 'melompat',
          baseWord: 'lompat',
          derivedWord: 'melompat',
          alignment: Alignment(0.62, -0.20),
          ruleNote: 'Tiada perubahan huruf',
        ),
      ],
    ),
    LearningStep(
      id: 'B14',
      title: 'Situasi: AmiN di dapur',
      type: LearningStepType.situation,
      backgroundTop: Color(0xFFFFF0D8),
      backgroundBottom: Color(0xFFFFE3BF),
      sceneImageAsset: 'assets/Belajar/AmiN di dapur.svg',
      instructionTitle: 'Situasi: AmiN di dapur',
      instructionBody:
          'Arahan: Tekan ⭐ dan cuba fikir jawapan dahulu.\n'
          'Gunakan imbuhan yang betul berdasarkan huruf awal kata dasar.',
      hotspots: [
        LearningHotspot(
          label: 'memotong',
          baseWord: 'potong',
          derivedWord: 'memotong',
          alignment: Alignment(0.60, -0.16),
          ruleNote: 'Huruf p berubah menjadi m',
        ),
        LearningHotspot(
          label: 'memasak',
          baseWord: 'masak',
          derivedWord: 'memasak',
          alignment: Alignment(-0.60, -0.44),
          ruleNote: 'Tiada perubahan huruf',
        ),
        LearningHotspot(
          label: 'mengelap',
          baseWord: 'lap',
          derivedWord: 'mengelap',
          alignment: Alignment(-0.08, -0.64),
          ruleNote: 'Kata satu suku kata menggunakan imbuhan menge-',
        ),
        LearningHotspot(
          label: 'mencuci',
          baseWord: 'cuci',
          derivedWord: 'mencuci',
          alignment: Alignment(0.24, 0.02),
          ruleNote: 'Tiada perubahan huruf',
        ),
      ],
    ),
    LearningStep(
      id: 'B15',
      title: 'Situasi: AmiN dalam aktiviti seni',
      type: LearningStepType.situation,
      backgroundTop: Color(0xFFEAF2FF),
      backgroundBottom: Color(0xFFD4E4FF),
      sceneImageAsset: 'assets/Belajar/AmiN dalam aktiviti seni.svg',
      instructionTitle: 'Situasi: AmiN dalam aktiviti seni',
      instructionBody:
          'Arahan: Tekan ⭐ dan cuba fikir jawapan dahulu.\n'
          'Gunakan imbuhan yang betul berdasarkan huruf awal kata dasar.',
      hotspots: [
        LearningHotspot(
          label: 'melukis',
          baseWord: 'lukis',
          derivedWord: 'melukis',
          alignment: Alignment(-0.10, -0.16),
          ruleNote: 'Tiada perubahan huruf',
        ),
        LearningHotspot(
          label: 'mengecat',
          baseWord: 'cat',
          derivedWord: 'mengecat',
          alignment: Alignment(-0.62, -0.54),
          ruleNote: 'Kata satu suku kata menggunakan imbuhan menge-',
        ),
        LearningHotspot(
          label: 'menggunting',
          baseWord: 'gunting',
          derivedWord: 'menggunting',
          alignment: Alignment(0.36, 0.02),
          ruleNote: 'Kata bermula dengan huruf g menggunakan imbuhan meng-',
        ),
        LearningHotspot(
          label: 'mewarna',
          baseWord: 'warna',
          derivedWord: 'mewarna',
          alignment: Alignment(0.64, -0.38),
          ruleNote: 'Tiada perubahan huruf',
        ),
      ],
    ),
    LearningStep(
      id: 'B16',
      title: 'Situasi: AmiN dalam aktiviti gotong-royong',
      type: LearningStepType.situation,
      backgroundTop: Color(0xFFE6FFF1),
      backgroundBottom: Color(0xFFCDF4DF),
      sceneImageAsset: 'assets/Belajar/AmiN dalam aktiviti gotong-royong.svg',
      instructionTitle: 'Situasi: AmiN dalam aktiviti gotong-royong',
      instructionBody:
          'Arahan: Tekan ⭐ dan cuba fikir jawapan dahulu.\n'
          'Gunakan imbuhan yang betul berdasarkan huruf awal kata dasar.',
      hotspots: [
        LearningHotspot(
          label: 'mengutip',
          baseWord: 'kutip',
          derivedWord: 'mengutip',
          alignment: Alignment(-0.08, 0.03),
          ruleNote: 'Huruf k digugurkan, menggunakan imbuhan meng-',
        ),
        LearningHotspot(
          label: 'membuang',
          baseWord: 'buang',
          derivedWord: 'membuang',
          alignment: Alignment(0.62, -0.24),
          ruleNote: 'Tiada perubahan huruf',
        ),
        LearningHotspot(
          label: 'memangkas',
          baseWord: 'pangkas',
          derivedWord: 'memangkas',
          alignment: Alignment(0.22, -0.62),
          ruleNote: 'Huruf p berubah menjadi m',
        ),
        LearningHotspot(
          label: 'menyapu',
          baseWord: 'sapu',
          derivedWord: 'menyapu',
          alignment: Alignment(-0.64, -0.34),
          ruleNote: 'Huruf s berubah menjadi ny',
        ),
      ],
    ),
    LearningStep(
      id: 'B17',
      title: 'Ringkasan Imbuhan Awalan meN-',
      type: LearningStepType.summary,
      backgroundTop: Color(0xFFFFF8D5),
      backgroundBottom: Color(0xFFFFE9B1),
      subtitle: 'Perhatikan huruf awal untuk memilih imbuhan yang betul.',
      buttonText: 'Kembali ke Menu Utama',
      summaryCards: [
        LearningSummaryCard(
          prefix: 'me-',
          ruleText: 'Huruf: l, m, n, r, w, y',
          example: 'melukis',
        ),
        LearningSummaryCard(
          prefix: 'mem-',
          ruleText: 'Huruf: b, f, p\np -> m',
          example: 'memusing',
        ),
        LearningSummaryCard(
          prefix: 'men-',
          ruleText: 'Huruf: c, d, j, z, t\nt -> n',
          example: 'menulis',
        ),
        LearningSummaryCard(
          prefix: 'meng-',
          ruleText: 'Huruf: g, h, k, vokal\nk -> ng',
          example: 'mengarang',
        ),
        LearningSummaryCard(
          prefix: 'menge-',
          ruleText: 'Kata satu suku kata guna imbuhan menge-',
          example: 'mengecat',
        ),
      ],
    ),
  ];
}
