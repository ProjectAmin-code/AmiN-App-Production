import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../core/responsive/responsive_utils.dart';
import '../../shared/gamification/gamification.dart';
import '../../shared/motion/app_motion_spec.dart';
import '../../shared/motion/app_motion_widgets.dart';
import '../../shared/navigation/app_screen_wiring.dart';
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
  // Set this to false to remove all B15-B18 mascot animations and gap tuning.
  static const bool _enableB15ToB18ArrowEnhancements = true;
  static const Set<String> _arrowEnhancedStepIds = {'B15', 'B16', 'B17', 'B18'};
  static const String _arrowMascotRightAsset =
      'assets/Action Figures/AmiN pointing right.svg';
  static const String _arrowMascotPointingAsset =
      'assets/Action Figures/AmiN Pointing.svg';

  late final AnimationController _pulseController;
  late final List<LearningStep> _steps;

  int _currentIndex = 0;
  int _b07AnimationStage = 0;
  bool _isB07StageAnimating = false;
  int _b08AnimationStage = 0;
  bool _isB08StageAnimating = false;
  int _b09AnimationStage = 0;
  bool _isB09StageAnimating = false;
  int _b10AnimationStage = 0;
  bool _isB10StageAnimating = false;
  int _b11AnimationStage = 0;
  bool _isB11StageAnimating = false;
  int _b12AnimationStage = 0;
  bool _isB12StageAnimating = false;
  int _b13AnimationStage = 0;
  bool _isB13StageAnimating = false;
  int _b14AnimationStage = 0;
  bool _isB14StageAnimating = false;
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
    unawaited(AminTtsService.instance.stop());
    super.dispose();
  }

  Future<void> _speakCurrentStep() async {
    if (!mounted) {
      return;
    }
    final script = _currentStep.voiceScript.trim();
    if (!_voiceEnabled || script.isEmpty) {
      return;
    }
    await AminTtsService.instance.speak(script);
  }

  Future<void> _toggleVoice() async {
    if (!mounted) {
      return;
    }
    setState(() {
      _voiceEnabled = !_voiceEnabled;
    });
    await AppSettingsService.instance.setVoiceOverEnabled(_voiceEnabled);
    if (!mounted) {
      return;
    }
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
      goToMainMenu(context);
      return;
    }
    setState(() {
      _currentIndex -= 1;
      _resetB07AnimationIfNeeded();
      _resetB08AnimationIfNeeded();
      _resetB09AnimationIfNeeded();
      _resetB10AnimationIfNeeded();
      _resetB11ToB14AnimationIfNeeded();
    });
    await _speakCurrentStep();
  }

  Future<void> _goNext() async {
    final gamification = _tryGetGamificationController();
    if (_isLastStep) {
      await AminTtsService.instance.stop();
      if (!mounted) {
        return;
      }
      goToMainMenu(context);
      return;
    }
    await AminTtsService.instance.stop();
    if (!mounted) {
      return;
    }
    setState(() {
      _currentIndex += 1;
      _resetB07AnimationIfNeeded();
      _resetB08AnimationIfNeeded();
      _resetB09AnimationIfNeeded();
      _resetB10AnimationIfNeeded();
      _resetB11ToB14AnimationIfNeeded();
    });
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

  Future<void> _advanceB07AnimationStage() async {
    if (_isB07StageAnimating || _b07AnimationStage >= 3) {
      return;
    }
    final reduceMotion = AppMotionSpec.reduceMotion(context);
    final nextStage = _b07AnimationStage + 1;
    final duration = _b07StageDuration(nextStage);
    setState(() {
      _b07AnimationStage = nextStage;
      _isB07StageAnimating = !reduceMotion;
    });
    if (reduceMotion) {
      return;
    }
    await Future<void>.delayed(duration);
    if (!mounted || _currentStep.id != 'B07') {
      return;
    }
    setState(() => _isB07StageAnimating = false);
  }

  Duration _b07StageDuration(int stage) {
    return AppMotionSpec.chooseDuration(
      context,
      stage == 2
          ? const Duration(milliseconds: 2800)
          : const Duration(milliseconds: 650),
      const Duration(milliseconds: 1),
    );
  }

  void _resetB07AnimationIfNeeded() {
    if (_currentStep.id != 'B07') {
      _isB07StageAnimating = false;
      return;
    }
    _b07AnimationStage = 0;
    _isB07StageAnimating = false;
  }

  Future<void> _advanceB08AnimationStage() async {
    if (_isB08StageAnimating || _b08AnimationStage >= 3) {
      return;
    }
    final reduceMotion = AppMotionSpec.reduceMotion(context);
    final nextStage = _b08AnimationStage + 1;
    final duration = _b08StageDuration(nextStage);
    setState(() {
      _b08AnimationStage = nextStage;
      _isB08StageAnimating = !reduceMotion;
    });
    if (reduceMotion) {
      return;
    }
    await Future<void>.delayed(duration);
    if (!mounted || _currentStep.id != 'B08') {
      return;
    }
    setState(() => _isB08StageAnimating = false);
  }

  Duration _b08StageDuration(int stage) {
    return AppMotionSpec.chooseDuration(
      context,
      stage == 2
          ? const Duration(milliseconds: 2800)
          : const Duration(milliseconds: 650),
      const Duration(milliseconds: 1),
    );
  }

  void _resetB08AnimationIfNeeded() {
    if (_currentStep.id != 'B08') {
      _isB08StageAnimating = false;
      return;
    }
    _b08AnimationStage = 0;
    _isB08StageAnimating = false;
  }

  Future<void> _advanceB09AnimationStage() async {
    if (_isB09StageAnimating || _b09AnimationStage >= 3) {
      return;
    }
    final reduceMotion = AppMotionSpec.reduceMotion(context);
    final nextStage = _b09AnimationStage + 1;
    final duration = _b09StageDuration(nextStage);
    setState(() {
      _b09AnimationStage = nextStage;
      _isB09StageAnimating = !reduceMotion;
    });
    if (reduceMotion) {
      return;
    }
    await Future<void>.delayed(duration);
    if (!mounted || _currentStep.id != 'B09') {
      return;
    }
    setState(() => _isB09StageAnimating = false);
  }

  Duration _b09StageDuration(int stage) {
    return AppMotionSpec.chooseDuration(
      context,
      stage == 2
          ? const Duration(milliseconds: 2800)
          : const Duration(milliseconds: 650),
      const Duration(milliseconds: 1),
    );
  }

  void _resetB09AnimationIfNeeded() {
    if (_currentStep.id != 'B09') {
      _isB09StageAnimating = false;
      return;
    }
    _b09AnimationStage = 0;
    _isB09StageAnimating = false;
  }

  Future<void> _advanceB10AnimationStage() async {
    if (_isB10StageAnimating || _b10AnimationStage >= 3) {
      return;
    }
    final reduceMotion = AppMotionSpec.reduceMotion(context);
    final nextStage = _b10AnimationStage + 1;
    final duration = _b10StageDuration(nextStage);
    setState(() {
      _b10AnimationStage = nextStage;
      _isB10StageAnimating = !reduceMotion;
    });
    if (reduceMotion) {
      return;
    }
    await Future<void>.delayed(duration);
    if (!mounted || _currentStep.id != 'B10') {
      return;
    }
    setState(() => _isB10StageAnimating = false);
  }

  Duration _b10StageDuration(int stage) {
    return AppMotionSpec.chooseDuration(
      context,
      stage == 2
          ? const Duration(milliseconds: 2800)
          : const Duration(milliseconds: 650),
      const Duration(milliseconds: 1),
    );
  }

  void _resetB10AnimationIfNeeded() {
    if (_currentStep.id != 'B10') {
      _isB10StageAnimating = false;
      return;
    }
    _b10AnimationStage = 0;
    _isB10StageAnimating = false;
  }

  Future<void> _advanceB11ToB14AnimationStage(String stepId) async {
    final currentStage = _animationStageForSpecialStep(stepId);
    if (_isAnimationRunningForSpecialStep(stepId) || currentStage >= 3) {
      return;
    }
    final reduceMotion = AppMotionSpec.reduceMotion(context);
    final nextStage = currentStage + 1;
    final duration = _wordAnimationStageDuration(nextStage);
    setState(() {
      _setAnimationStageForSpecialStep(stepId, nextStage);
      _setAnimationRunningForSpecialStep(stepId, !reduceMotion);
    });
    if (reduceMotion) {
      return;
    }
    await Future<void>.delayed(duration);
    if (!mounted || _currentStep.id != stepId) {
      return;
    }
    setState(() => _setAnimationRunningForSpecialStep(stepId, false));
  }

  Duration _wordAnimationStageDuration(int stage) {
    return AppMotionSpec.chooseDuration(
      context,
      stage == 2
          ? const Duration(milliseconds: 2800)
          : const Duration(milliseconds: 650),
      const Duration(milliseconds: 1),
    );
  }

  int _animationStageForSpecialStep(String stepId) {
    switch (stepId) {
      case 'B11':
        return _b11AnimationStage;
      case 'B12':
        return _b12AnimationStage;
      case 'B13':
        return _b13AnimationStage;
      case 'B14':
        return _b14AnimationStage;
      default:
        return 0;
    }
  }

  bool _isAnimationRunningForSpecialStep(String stepId) {
    switch (stepId) {
      case 'B11':
        return _isB11StageAnimating;
      case 'B12':
        return _isB12StageAnimating;
      case 'B13':
        return _isB13StageAnimating;
      case 'B14':
        return _isB14StageAnimating;
      default:
        return false;
    }
  }

  void _setAnimationStageForSpecialStep(String stepId, int stage) {
    switch (stepId) {
      case 'B11':
        _b11AnimationStage = stage;
        break;
      case 'B12':
        _b12AnimationStage = stage;
        break;
      case 'B13':
        _b13AnimationStage = stage;
        break;
      case 'B14':
        _b14AnimationStage = stage;
        break;
    }
  }

  void _setAnimationRunningForSpecialStep(String stepId, bool isAnimating) {
    switch (stepId) {
      case 'B11':
        _isB11StageAnimating = isAnimating;
        break;
      case 'B12':
        _isB12StageAnimating = isAnimating;
        break;
      case 'B13':
        _isB13StageAnimating = isAnimating;
        break;
      case 'B14':
        _isB14StageAnimating = isAnimating;
        break;
    }
  }

  void _resetB11ToB14AnimationIfNeeded() {
    if (_currentStep.id != 'B11') {
      _isB11StageAnimating = false;
    } else {
      _b11AnimationStage = 0;
      _isB11StageAnimating = false;
    }
    if (_currentStep.id != 'B12') {
      _isB12StageAnimating = false;
    } else {
      _b12AnimationStage = 0;
      _isB12StageAnimating = false;
    }
    if (_currentStep.id != 'B13') {
      _isB13StageAnimating = false;
    } else {
      _b13AnimationStage = 0;
      _isB13StageAnimating = false;
    }
    if (_currentStep.id != 'B14') {
      _isB14StageAnimating = false;
    } else {
      _b14AnimationStage = 0;
      _isB14StageAnimating = false;
    }
  }

  Future<void> _openHotspot(LearningHotspot hotspot) async {
    var revealAnswer = false;
    if (!mounted) {
      return;
    }
    final modalFuture = showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        final mediaSize = MediaQuery.sizeOf(context);
        final isLandscape = mediaSize.width > mediaSize.height;
        final reducedFont = _useReducedFontForStep(_currentStep);
        final horizontalInset = responsiveClamp(context, 12, 24, 56);
        final verticalInset = math
            .min(mediaSize.height * (isLandscape ? 0.06 : 0.10), 120)
            .clamp(10.0, 120.0)
            .toDouble();
        final maxDialogWidth = math
            .min(320.0, mediaSize.width - (horizontalInset * 2))
            .clamp(240.0, 320.0)
            .toDouble();
        final maxDialogHeight = math
            .max(220.0, mediaSize.height - (verticalInset * 2))
            .toDouble();
        final baseWordFontSize = responsiveClamp(
          context,
          22,
          reducedFont ? 28 : 30,
          reducedFont ? 28 : 30,
        );
        final derivedWordFontSize = responsiveClamp(
          context,
          24,
          reducedFont ? 30 : 32,
          reducedFont ? 32 : 34,
        );
        final noteFontSize = responsiveClamp(
          context,
          12,
          reducedFont ? 14 : 16,
          16,
        );

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
              insetPadding: EdgeInsets.symmetric(
                horizontal: horizontalInset,
                vertical: verticalInset,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: revealAnswerInSameBox,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: maxDialogWidth,
                    maxHeight: maxDialogHeight,
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      responsiveClamp(context, 12, 16, 16),
                      responsiveClamp(context, 12, 14, 14),
                      responsiveClamp(context, 12, 16, 16),
                      responsiveClamp(context, 12, 16, 16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          hotspot.baseWord,
                          textAlign: TextAlign.center,
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
    if (stepId == 'B21' && normalizedBaseWord == 'kejar') {
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
    if (stepId == 'B21' &&
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
    if (stepId == 'B22' &&
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
    if (stepId == 'B20' &&
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
    if (step.id == 'B20') {
      const b12PreciseAlignments = <String, Alignment>{
        'membaca': Alignment(-0.47, 0.08),
        'menulis': Alignment(0.45, 0.25),
        'mengajar': Alignment(-0.06, -0.52),
        'menjawab': Alignment(0.37, -0.21),
      };
      return b12PreciseAlignments[hotspot.label] ?? hotspot.alignment;
    }
    if (step.id == 'B21') {
      final normalizedBaseWord = hotspot.baseWord.trim().toLowerCase();
      if (normalizedBaseWord == 'angkat' || normalizedBaseWord == 'angat') {
        return const Alignment(0.42, 0.45);
      }
      if (normalizedBaseWord == 'kejar') {
        return Alignment(hotspot.alignment.x + 0.15, 0.10);
      }
      if (normalizedBaseWord == 'tendang') {
        return Alignment(hotspot.alignment.x + 0.04, 0.48);
      }
      if (normalizedBaseWord == 'lompat') {
        return Alignment(-0.41, -0.42);
      }
    }
    if (step.id == 'B22') {
      final normalizedBaseWord = hotspot.baseWord.trim().toLowerCase();
      if (normalizedBaseWord == 'lap') {
        return Alignment(hotspot.alignment.x + 0.20, 0.64);
      }
      if (normalizedBaseWord == 'potong') {
        return const Alignment(-0.30, 0.47);
      }
      if (normalizedBaseWord == 'cuci') {
        return const Alignment(0.78, 0.29);
      }
      if (normalizedBaseWord == 'masak') {
        return const Alignment(-0.90, -0.10);
      }
    }
    if (step.id == 'B23' && hotspot.baseWord.trim().toLowerCase() == 'cat') {
      return Alignment(hotspot.alignment.x + 0.04, hotspot.alignment.y + 0.10);
    }
    if (step.id == 'B23' && hotspot.baseWord.trim().toLowerCase() == 'lukis') {
      return Alignment(hotspot.alignment.x + 0.04, 0.62);
    }
    if (step.id == 'B23' && hotspot.baseWord.trim().toLowerCase() == 'warna') {
      return const Alignment(-0.39, 0.36);
    }
    if (step.id == 'B23' &&
        hotspot.baseWord.trim().toLowerCase() == 'gunting') {
      return const Alignment(0.68, 0.55);
    }
    if (step.id == 'B24' &&
        hotspot.baseWord.trim().toLowerCase() == 'pangkas') {
      return Alignment(hotspot.alignment.x + 0.22, 0.26);
    }
    if (step.id == 'B24' && hotspot.baseWord.trim().toLowerCase() == 'buang') {
      return const Alignment(-0.27, -0.35);
    }
    if (step.id == 'B24' && hotspot.baseWord.trim().toLowerCase() == 'kutip') {
      return const Alignment(0.64, 0.70);
    }
    if (step.id == 'B24' && hotspot.baseWord.trim().toLowerCase() == 'sapu') {
      return const Alignment(-0.70, 0.20);
    }
    return hotspot.alignment;
  }

  bool _usesRoundedHotspotStyle(LearningStep step) {
    return const {'B20', 'B21', 'B22', 'B23', 'B24', 'B25'}.contains(step.id);
  }

  Widget _buildHotspotStarButton({
    required LearningStep step,
    required VoidCallback onPressed,
    required double size,
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
        minimumSize: Size.square(size),
        fixedSize: Size.square(size),
        padding: useRoundedStyle
            ? EdgeInsets.fromLTRB(
                size * 0.13,
                size * 0.10,
                size * 0.13,
                size * 0.16,
              )
            : EdgeInsets.all(size * 0.16),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: useRoundedStyle
            ? const BorderSide(color: Color(0xFFF59E0B), width: 1.2)
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            size * (useRoundedStyle ? 0.36 : 0.5),
          ),
        ),
        elevation: useRoundedStyle ? 2 : 0,
        shadowColor: useRoundedStyle ? const Color(0x55A16207) : null,
      ),
      icon: Icon(
        useRoundedStyle ? Icons.star : Icons.star_rounded,
        size: size * (useRoundedStyle ? 0.54 : 0.56),
      ),
    );
    if (!useRoundedStyle) {
      return button;
    }
    return Padding(padding: const EdgeInsets.only(bottom: 2), child: button);
  }

  Rect _containedImageRect(Size boxSize, double imageAspectRatio) {
    if (boxSize.width <= 0 || boxSize.height <= 0) {
      return Rect.zero;
    }

    final boxAspectRatio = boxSize.width / boxSize.height;
    if (boxAspectRatio > imageAspectRatio) {
      final height = boxSize.height;
      final width = height * imageAspectRatio;
      return Rect.fromLTWH((boxSize.width - width) / 2, 0, width, height);
    }

    final width = boxSize.width;
    final height = width / imageAspectRatio;
    return Rect.fromLTWH(0, (boxSize.height - height) / 2, width, height);
  }

  Offset _pointInRectForAlignment(Rect rect, Alignment alignment) {
    final dx = rect.left + ((alignment.x + 1) / 2) * rect.width;
    final dy = rect.top + ((alignment.y + 1) / 2) * rect.height;
    return Offset(dx, dy);
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
    return Builder(
      builder: (context) {
        final effectiveFontSize = responsiveClamp(context, 20, fontSize, 26);
        return Text(
          text,
          style: TextStyle(
            fontSize: effectiveFontSize,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1D3557),
            fontFamily: 'Poppins',
            fontFamilyFallback: _fontFallback,
          ),
        );
      },
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

  Widget _scrollableStepContent({
    required Widget child,
    Alignment alignment = Alignment.topLeft,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
              minHeight: constraints.maxHeight,
            ),
            child: Align(
              alignment: alignment,
              child: SizedBox(width: constraints.maxWidth, child: child),
            ),
          ),
        );
      },
    );
  }

  bool _useReducedFontForStep(LearningStep step) {
    return const {'B20', 'B21', 'B22', 'B23', 'B24', 'B25'}.contains(step.id);
  }

  bool _useLeftAlignedParagraphs(LearningStep step) {
    return const {'B20', 'B21', 'B22', 'B23', 'B24'}.contains(step.id);
  }

  double _stepHeadingFontSize(LearningStep step) {
    return _useReducedFontForStep(step)
        ? _headingFontSize - 2
        : _headingFontSize;
  }

  double _stepBodyFontSize(LearningStep step) {
    return _useReducedFontForStep(step) ? _bodyFontSize - 2 : _bodyFontSize;
  }

  double _responsiveHeadingFontSize(BuildContext context, LearningStep step) {
    return responsiveClamp(context, 20, _stepHeadingFontSize(step), 26);
  }

  double _responsiveBodyFontSize(BuildContext context, LearningStep step) {
    return responsiveClamp(context, 15, _stepBodyFontSize(step), 20);
  }

  double _responsiveButtonFontSize(BuildContext context) {
    return responsiveClamp(context, 16, _buttonFontSize, 20);
  }

  double _responsiveLabelFontSize(
    BuildContext context,
    double ideal, {
    double min = 13,
    double max = 22,
  }) {
    return responsiveClamp(context, min, ideal, max);
  }

  bool _isArrowEnhancedStep(LearningStep step) {
    return _enableB15ToB18ArrowEnhancements &&
        _arrowEnhancedStepIds.contains(step.id);
  }

  double _extraBottomSpacingForArrowEnhancedStep(LearningStep step) {
    if (!_isArrowEnhancedStep(step)) {
      return 0;
    }
    switch (step.id) {
      case 'B15':
        return 44;
      case 'B16':
        return 18;
      case 'B18':
        return 72;
      case 'B17':
      default:
        return 0;
    }
  }

  String _arrowMascotAssetForStep(LearningStep step) {
    switch (step.id) {
      case 'B16':
      case 'B18':
        return _arrowMascotPointingAsset;
      case 'B15':
      case 'B17':
      default:
        return _arrowMascotRightAsset;
    }
  }

  double _arrowMascotSizeForStep(LearningStep step) {
    switch (step.id) {
      case 'B18':
        return 148;
      case 'B16':
        return 126;
      case 'B15':
        return 118;
      case 'B17':
      default:
        return 96;
    }
  }

  Alignment _arrowMascotAlignmentForStep(LearningStep step) {
    return Alignment.bottomRight;
  }

  Widget _buildB15ToB18MascotOverlay(LearningStep step) {
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
    final bodySize = _responsiveBodyFontSize(context, step);
    final subheadingSize = _responsiveLabelFontSize(
      context,
      _bodyFontSize + 2,
      min: 17,
      max: 22,
    );
    final legendSize = _responsiveLabelFontSize(context, 17, min: 13, max: 17);
    return _scrollableStepContent(
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
                style: TextStyle(
                  fontSize: bodySize,
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
                style: TextStyle(
                  fontSize: subheadingSize,
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
                            style: TextStyle(
                              fontSize: legendSize,
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
              style: TextStyle(
                fontSize: legendSize,
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
    final extraBottomSpacing = _extraBottomSpacingForArrowEnhancedStep(step);
    final bodySize = _responsiveBodyFontSize(context, step);
    final subheadingSize = _responsiveLabelFontSize(
      context,
      _bodyFontSize + 2,
      min: 17,
      max: 22,
    );
    final highlightSize = _responsiveLabelFontSize(
      context,
      20,
      min: 15,
      max: 20,
    );
    final footerSize = _responsiveLabelFontSize(context, 17, min: 13, max: 17);
    final arrowTextSize = _responsiveLabelFontSize(
      context,
      20,
      min: 15,
      max: 20,
    );
    final arrowSymbolSize = _responsiveLabelFontSize(
      context,
      22,
      min: 17,
      max: 22,
    );
    final letterChipFontSize = _responsiveLabelFontSize(
      context,
      18,
      min: 14,
      max: 18,
    );
    final content = _scrollableStepContent(
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
                    style: TextStyle(
                      fontSize: bodySize,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      fontFamilyFallback: _fontFallback,
                    ),
                  ),
                  if (step.highlightedLetters.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text.rich(
                      _highlightedLettersSpan(context, step),
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: highlightSize,
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
                      style: TextStyle(
                        fontSize: bodySize,
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
              style: TextStyle(
                fontSize: subheadingSize,
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
                                    style: TextStyle(
                                      fontSize: letterChipFontSize,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                      fontFamilyFallback: _fontFallback,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '\u2192',
                                  style: TextStyle(
                                    fontSize: arrowSymbolSize,
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
                                style: TextStyle(
                                  fontSize: arrowTextSize,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1D3557),
                                  fontFamily: 'Poppins',
                                  fontFamilyFallback: _fontFallback,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '\u2192',
                                style: TextStyle(
                                  fontSize: arrowSymbolSize,
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
              style: TextStyle(
                fontSize: footerSize,
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
      children: [content, _buildB15ToB18MascotOverlay(step)],
    );
  }

  TextSpan _highlightedLettersSpan(BuildContext context, LearningStep step) {
    if (step.id == 'B17' && step.highlightedLetters.length >= 7) {
      final letters = step.highlightedLetters;
      return TextSpan(
        children: [
          const TextSpan(text: 'huruf vokal ('),
          _coloredLetterSpan(context, letters[0], 0),
          const TextSpan(text: ', '),
          _coloredLetterSpan(context, letters[1], 1),
          const TextSpan(text: ', '),
          _coloredLetterSpan(context, letters[2], 2),
          const TextSpan(text: ', '),
          _coloredLetterSpan(context, letters[3], 3),
          const TextSpan(text: ', '),
          _coloredLetterSpan(context, letters[4], 4),
          const TextSpan(text: ') dan huruf konsonan ('),
          _coloredLetterSpan(context, letters[5], 5),
          const TextSpan(text: ','),
          _coloredLetterSpan(context, letters[6], 6),
          const TextSpan(text: ')'),
        ],
      );
    }
    return _commaSeparatedHighlightedLetters(context, step.highlightedLetters);
  }

  TextSpan _commaSeparatedHighlightedLetters(
    BuildContext context,
    List<String> letters,
  ) {
    final children = <InlineSpan>[];
    for (var i = 0; i < letters.length; i++) {
      children.add(_coloredLetterSpan(context, letters[i], i));
      if (i < letters.length - 1) {
        children.add(const TextSpan(text: ', '));
      } else {
        children.add(const TextSpan(text: '.'));
      }
    }
    return TextSpan(children: children);
  }

  TextSpan _coloredLetterSpan(BuildContext context, String text, int index) {
    return TextSpan(
      text: text,
      style: TextStyle(
        color: _highlightColorForIndex(index),
        fontWeight: FontWeight.w900,
        fontSize: _responsiveLabelFontSize(context, 22, min: 17, max: 22),
      ),
    );
  }

  Color _highlightColorForIndex(int index) {
    return _highlightPalette[index % _highlightPalette.length];
  }

  Color _arrowLetterColor(LearningStep step, LearningArrowRow row, int index) {
    if (step.id == 'B15') {
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
    final fontSize = _responsiveLabelFontSize(context, 20, min: 15, max: 20);
    if (prefix.isEmpty || !word.startsWith(prefix)) {
      return Text(
        word,
        style: TextStyle(
          fontSize: fontSize,
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
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1D3557),
        fontFamily: 'Poppins',
        fontFamilyFallback: _fontFallback,
      ),
    );
  }

  Widget _equationChip(String text, Color color) {
    final fontSize = _responsiveLabelFontSize(context, 18, min: 14, max: 18);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          fontFamily: 'Poppins',
          fontFamilyFallback: _fontFallback,
        ),
      ),
    );
  }

  Widget _equationSymbol(String symbol) {
    final fontSize = _responsiveLabelFontSize(context, 23, min: 17, max: 23);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        symbol,
        style: TextStyle(
          color: Color(0xFF1D3557),
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          fontFamily: 'Poppins',
          fontFamilyFallback: _fontFallback,
        ),
      ),
    );
  }

  Widget _buildTableStep(LearningStep step) {
    final bodySize = _responsiveBodyFontSize(context, step);
    final subheadingSize = _responsiveLabelFontSize(
      context,
      _bodyFontSize + 2,
      min: 17,
      max: 22,
    );
    return _scrollableStepContent(
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
                style: TextStyle(
                  fontSize: bodySize,
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
              style: TextStyle(
                fontSize: subheadingSize,
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
              style: TextStyle(
                fontSize: bodySize,
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
    final tableFontSize = _responsiveBodyFontSize(context, step);
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
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: tableFontSize,
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
                color:
                    row.backgroundColor ??
                    (rowIndex.isEven
                        ? const Color(0xFFF6FCFF)
                        : const Color(0xFFEFF8FF)),
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
                      style: TextStyle(
                        fontSize: tableFontSize,
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
    final bodySize = _responsiveBodyFontSize(context, step);
    final letterSize = _responsiveLabelFontSize(context, 24, min: 18, max: 24);
    return _scrollableStepContent(
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
                style: TextStyle(
                  fontSize: bodySize,
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
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: letterSize,
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
                              fontSize: bodySize,
                              fontWeight: FontWeight.w900,
                              color: accentColor,
                              fontFamily: 'Poppins',
                              fontFamilyFallback: _fontFallback,
                            ),
                          ),
                          Text(
                            card.note,
                            style: TextStyle(
                              fontSize: bodySize,
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
              style: TextStyle(
                fontSize: bodySize,
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

  Widget _buildB19ImageHeadingStep(LearningStep step) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final imageSize = math.min(constraints.maxWidth * 0.72, 280.0);
        final headingSize = _responsiveHeadingFontSize(context, step);
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: TweenAnimationBuilder<double>(
                key: ValueKey('b19-image-heading-${step.id}'),
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
                      style: TextStyle(
                        fontSize: headingSize,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1D3557),
                        fontFamily: 'Poppins',
                        fontFamilyFallback: _fontFallback,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSituationStep(LearningStep step) {
    final paragraphAlign = _useLeftAlignedParagraphs(step)
        ? TextAlign.left
        : TextAlign.justify;
    return LayoutBuilder(
      builder: (context, constraints) {
        final shortScreen = constraints.maxHeight < 560;
        final headingSize = responsiveClamp(
          context,
          17,
          _stepHeadingFontSize(step) - (shortScreen ? 2 : 0),
          _stepHeadingFontSize(step),
        );
        final bodySize = responsiveClamp(
          context,
          14,
          _stepBodyFontSize(step) - (shortScreen ? 2 : 0),
          _stepBodyFontSize(step),
        );
        final instructionPadding = responsiveClamp(
          context,
          8,
          shortScreen ? 10 : 12,
          12,
        );
        final instructionMaxHeight =
            constraints.maxHeight * (shortScreen ? 0.32 : 0.40);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (step.instructionTitle.isNotEmpty ||
                step.instructionBody.isNotEmpty)
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: shortScreen ? 8 : 10),
                padding: EdgeInsets.all(instructionPadding),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5D6),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFF4D47D)),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: instructionMaxHeight),
                  child: SingleChildScrollView(
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
                          SizedBox(height: shortScreen ? 6 : 8),
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
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      const sceneAspectRatio = 1024 / 1536;
                      final imageRect = _containedImageRect(
                        Size(constraints.maxWidth, constraints.maxHeight),
                        sceneAspectRatio,
                      );
                      final hotspotSize = (imageRect.width * 0.085)
                          .clamp(24.0, 38.0)
                          .toDouble();

                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          if (step.sceneImageAsset.isNotEmpty)
                            Positioned.fromRect(
                              rect: imageRect,
                              child: AdaptiveAssetImage(
                                assetPath: step.sceneImageAsset,
                                fit: BoxFit.cover,
                              ),
                            ),
                          Positioned.fromRect(
                            rect: imageRect,
                            child: Container(
                              color: Colors.black.withValues(alpha: 0.08),
                            ),
                          ),
                          ...step.hotspots.asMap().entries.map((entry) {
                            final index = entry.key;
                            final hotspot = entry.value;
                            final point = _pointInRectForAlignment(
                              imageRect,
                              _hotspotAlignmentForStep(step, hotspot),
                            );
                            return Positioned(
                              left: point.dx - hotspotSize / 2,
                              top: point.dy - hotspotSize / 2,
                              width: hotspotSize,
                              height: hotspotSize,
                              child: TweenAnimationBuilder<double>(
                                key: ValueKey(
                                  '${_currentStep.id}-hotspot-$index',
                                ),
                                tween: Tween(begin: 0, end: 1),
                                duration: Duration(
                                  milliseconds: 280 + (index * 100),
                                ),
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
                                    final reduceMotion =
                                        AppMotionSpec.reduceMotion(context);
                                    final scaleAnimation = reduceMotion
                                        ? const AlwaysStoppedAnimation(1.0)
                                        : Tween<double>(
                                            begin: 0.95,
                                            end: 1.08,
                                          ).animate(
                                            CurvedAnimation(
                                              parent: _pulseController,
                                              curve: Curves.easeInOut,
                                            ),
                                          );
                                    return ScaleTransition(
                                      scale: scaleAnimation,
                                      child: _buildHotspotStarButton(
                                        step: step,
                                        size: hotspotSize,
                                        onPressed: () => _openHotspot(hotspot),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryStep(LearningStep step) {
    final isB25 = step.id == 'B25';
    final headingSize = isB25
        ? responsiveClamp(context, 20, _headingFontSize + 1, 26)
        : _responsiveHeadingFontSize(context, step);
    final bodySize = isB25
        ? responsiveClamp(context, 15, _bodyFontSize, 20)
        : _responsiveBodyFontSize(context, step);
    Widget summaryContent(BoxConstraints constraints) {
      final contentWidth = isB25
          ? constraints.maxWidth * 0.9
          : constraints.maxWidth;
      final cardWidth = isB25 || constraints.maxWidth < 360
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
                          useDarkerBackground: isB25,
                        ),
                      ),
                    )
                    .toList(),
              ),
              if (!isB25) ...[
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

    if (isB25) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(child: summaryContent(constraints));
        },
      );
    }

    return _scrollableStepContent(
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
    required bool useDarkerBackground,
  }) {
    final accentColor = _summaryCardAccentColor(card.prefix);
    final backgroundAlpha = useDarkerBackground ? 0.3 : 0.14;
    final borderAlpha = useDarkerBackground ? 0.72 : 0.5;
    final boxColor = Color.alphaBlend(
      accentColor.withValues(alpha: backgroundAlpha),
      Colors.white,
    );
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accentColor.withValues(alpha: borderAlpha)),
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

  Widget _buildLevelTransitionStep(LearningStep step) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final titleSize = responsiveClamp(context, 22, 28, 30);
        final bodySize = responsiveClamp(context, 14, 18, 20);
        final backgroundImage = step.backgroundImage;

        return SizedBox.expand(
          child: Stack(
            fit: StackFit.expand,
            children: [
              backgroundImage == null || backgroundImage.isEmpty
                  ? const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                        ),
                      ),
                    )
                  : Image.asset(
                      backgroundImage,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                            ),
                          ),
                        );
                      },
                    ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsiveClamp(context, 18, 24, 28),
                        vertical: responsiveClamp(context, 18, 24, 28),
                      ),
                      child: TweenAnimationBuilder<double>(
                        key: ValueKey('level-transition-${step.id}'),
                        tween: Tween(begin: 0, end: 1),
                        duration: AppMotionSpec.chooseDuration(
                          context,
                          const Duration(milliseconds: 420),
                          const Duration(milliseconds: 180),
                        ),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          if (AppMotionSpec.reduceMotion(context)) {
                            return child ?? const SizedBox.shrink();
                          }
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, (1 - value) * 18),
                              child: child,
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              step.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: titleSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontFamilyFallback: _fontFallback,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              step.subtitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: bodySize,
                                color: Colors.white70,
                                height: 1.35,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins',
                                fontFamilyFallback: _fontFallback,
                              ),
                            ),
                            const SizedBox(height: 40),
                            SizedBox(
                              width: math.min(constraints.maxWidth * 0.72, 220),
                              child: AnimatedKidButton(
                                label: step.buttonText,
                                icon: Icons.arrow_forward_rounded,
                                onPressed: _goNext,
                                backgroundColor: const Color(0xFFFFC300),
                                foregroundColor: const Color(0xFF1D3557),
                                labelFontSize: _responsiveButtonFontSize(
                                  context,
                                ),
                              ),
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
        );
      },
    );
  }

  Widget _buildTapHintLayer({required bool show, required VoidCallback onTap}) {
    if (!show) {
      return const SizedBox.shrink();
    }
    final reduceMotion = AppMotionSpec.reduceMotion(context);
    return Positioned.fill(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: ClipRect(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 2.8, sigmaY: 2.8),
            child: Container(
              color: Colors.black.withValues(alpha: 0.28),
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: responsiveClamp(context, 96, 116, 136),
                ),
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    final value = reduceMotion ? 1.0 : _pulseController.value;
                    final wave = math.sin(value * math.pi);
                    final outerSize = responsiveClamp(context, 82, 104, 122);
                    final innerSize = responsiveClamp(context, 58, 72, 84);
                    return SizedBox(
                      width: outerSize,
                      height: outerSize,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Transform.scale(
                            scale: reduceMotion ? 1 : 0.82 + (wave * 0.22),
                            child: Opacity(
                              opacity: reduceMotion ? 0.45 : 0.20 + wave * 0.30,
                              child: Container(
                                width: outerSize,
                                height: outerSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFFFC300),
                                    width: 4,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Transform.scale(
                            scale: reduceMotion ? 1 : 0.92 + (wave * 0.08),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.92),
                                shape: BoxShape.circle,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x44000000),
                                    blurRadius: 18,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: SizedBox(
                                width: innerSize,
                                height: innerSize,
                                child: Icon(
                                  Icons.touch_app_rounded,
                                  color: const Color(0xFF1D3557),
                                  size: responsiveClamp(context, 32, 40, 48),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildB07SalinAnimationStep(LearningStep step) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final reduceMotion = AppMotionSpec.reduceMotion(context);
        final switchDuration = reduceMotion
            ? Duration.zero
            : AppMotionSpec.chooseDuration(
                context,
                const Duration(milliseconds: 650),
                const Duration(milliseconds: 1),
              );
        final horizontalPadding = responsiveClamp(context, 16, 24, 28);
        final contentTop = constraints.maxHeight * 0.22;
        final contentPaddingX = responsiveClamp(context, 18, 24, 30);
        final contentPaddingY = responsiveClamp(context, 12, 18, 24);
        final stageHeight = responsiveClamp(context, 86, 118, 142);
        final stageAlignmentX = constraints.maxWidth < 360
            ? 0.18
            : constraints.maxWidth < 400
            ? 0.26
            : 0.34;
        final showContinue = _b07AnimationStage >= 3 && !_isB07StageAnimating;
        final backgroundImage = step.backgroundImage;

        return SizedBox.expand(
          child: Stack(
            fit: StackFit.expand,
            children: [
              backgroundImage == null || backgroundImage.isEmpty
                  ? const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                        ),
                      ),
                    )
                  : Image.asset(
                      backgroundImage,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                            ),
                          ),
                        );
                      },
                    ),
              _buildTapHintLayer(
                show: _b07AnimationStage == 0 && !_isB07StageAnimating,
                onTap: _advanceB07AnimationStage,
              ),
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: horizontalPadding,
                      right: horizontalPadding,
                      top: contentTop,
                      bottom: responsiveClamp(context, 90, 104, 118),
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: showContinue
                              ? null
                              : _advanceB07AnimationStage,
                          child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: contentPaddingX,
                                vertical: contentPaddingY,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: stageHeight,
                                    child: Align(
                                      alignment: Alignment(stageAlignmentX, 0),
                                      child: AnimatedSwitcher(
                                        duration: switchDuration,
                                        switchInCurve: Curves.easeOutCubic,
                                        switchOutCurve: Curves.easeInCubic,
                                        transitionBuilder: (child, animation) {
                                          if (reduceMotion) {
                                            return child;
                                          }
                                          return FadeTransition(
                                            opacity: animation,
                                            child: ScaleTransition(
                                              scale: Tween<double>(
                                                begin: 0.96,
                                                end: 1,
                                              ).animate(animation),
                                              child: child,
                                            ),
                                          );
                                        },
                                        child: _buildB07SalinStageContent(
                                          context,
                                          stage: _b07AnimationStage,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: responsiveClamp(context, 16, 20, 24),
                right: responsiveClamp(context, 16, 20, 24),
                bottom: responsiveClamp(context, 14, 18, 22),
                child: AnimatedSwitcher(
                  duration: switchDuration,
                  child: showContinue
                      ? AnimatedKidButton(
                          key: const ValueKey('b07-continue-visible'),
                          label: step.buttonText,
                          icon: Icons.arrow_forward_rounded,
                          onPressed: _goNext,
                          backgroundColor: const Color(0xFFFFC300),
                          foregroundColor: const Color(0xFF1D3557),
                          labelFontSize: _responsiveButtonFontSize(context),
                        )
                      : const SizedBox(
                          key: ValueKey('b07-continue-hidden'),
                          height: 0,
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildB07SalinStageContent(
    BuildContext context, {
    required int stage,
  }) {
    final textSize = responsiveClamp(context, 28, 36, 44);
    final wordSize = textSize;
    final formulaSize = textSize;
    final finalSize = textSize;
    const black = Color(0xFF111827);
    const red = Color(0xFFE63946);
    const green = Color(0xFF16A34A);

    TextStyle style(double size, Color color) {
      return TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w900,
        color: color,
        height: 1.05,
        fontFamily: 'Poppins',
        fontFamilyFallback: _fontFallback,
      );
    }

    Widget scaled(Widget child) {
      return FittedBox(fit: BoxFit.scaleDown, child: child);
    }

    Widget transformStage() {
      final circleSize = responsiveClamp(context, 38, 50, 60);
      final slotWidth = responsiveClamp(context, 46, 62, 74);
      final slotHeight = responsiveClamp(context, 78, 100, 120);
      final arrowSize = responsiveClamp(context, 24, 34, 42);
      final lift = responsiveClamp(context, 28, 38, 46);
      const nyLift = 0.0;
      final reduceMotion = AppMotionSpec.reduceMotion(context);

      Widget content(double value) {
        final circleProgress = Curves.easeOutCubic.transform(
          ((value - 0.18) / 0.24).clamp(0.0, 1.0),
        );
        final removeProgress = Curves.easeIn.transform(
          ((value - 0.58) / 0.22).clamp(0.0, 1.0),
        );
        final addProgress = Curves.easeOut.transform(
          ((value - 0.70) / 0.30).clamp(0.0, 1.0),
        );
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('me- + ', style: style(formulaSize, black)),
            SizedBox(
              width: slotWidth,
              height: slotHeight,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: 1 - removeProgress,
                    child: Transform.translate(
                      offset: Offset(0, -lift * removeProgress),
                      child: CustomPaint(
                        painter: _CircleProgressPainter(
                          color: red,
                          progress: circleProgress,
                          strokeWidth: 3,
                        ),
                        child: SizedBox(
                          width: circleSize,
                          height: circleSize,
                          child: Center(
                            child: Text('S', style: style(formulaSize, red)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: addProgress,
                    child: Transform.translate(
                      offset: Offset(0, (1 - addProgress) * 18),
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Transform.translate(
                            offset: Offset(0, -nyLift),
                            child: Text('ny', style: style(formulaSize, green)),
                          ),
                          Positioned(
                            top:
                                slotHeight / 2 +
                                responsiveClamp(context, 8, 12, 16),
                            child: Icon(
                              Icons.arrow_upward_rounded,
                              color: green,
                              size: arrowSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text('alin', style: style(formulaSize, black)),
          ],
        );
      }

      if (reduceMotion) {
        return content(1);
      }
      return TweenAnimationBuilder<double>(
        key: const ValueKey('b07-stage-2-transform'),
        tween: Tween(begin: 0, end: 1),
        duration: _b07StageDuration(2),
        curve: Curves.linear,
        builder: (context, value, child) => content(value),
      );
    }

    switch (stage) {
      case 0:
        return scaled(
          Text(
            'Salin',
            key: const ValueKey('b07-stage-0'),
            maxLines: 1,
            style: style(wordSize, black),
          ),
        );
      case 1:
        return scaled(
          Text(
            'me -',
            key: const ValueKey('b07-stage-1'),
            maxLines: 1,
            style: style(formulaSize, black),
          ),
        );
      case 2:
        return scaled(transformStage());
      default:
        return scaled(
          Text(
            'menyalin',
            key: const ValueKey('b07-stage-3'),
            maxLines: 1,
            style: style(finalSize, black),
          ),
        );
    }
  }

  Widget _buildB08SimpanAnimationStep(LearningStep step) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final reduceMotion = AppMotionSpec.reduceMotion(context);
        final switchDuration = reduceMotion
            ? Duration.zero
            : AppMotionSpec.chooseDuration(
                context,
                const Duration(milliseconds: 650),
                const Duration(milliseconds: 1),
              );
        final horizontalPadding = responsiveClamp(context, 16, 24, 28);
        final contentTop = constraints.maxHeight * 0.22;
        final contentPaddingX = responsiveClamp(context, 18, 24, 30);
        final contentPaddingY = responsiveClamp(context, 12, 18, 24);
        final stageHeight = responsiveClamp(context, 86, 118, 142);
        final stageAlignmentX = constraints.maxWidth < 360
            ? 0.18
            : constraints.maxWidth < 400
            ? 0.26
            : 0.34;
        final showContinue = _b08AnimationStage >= 3 && !_isB08StageAnimating;
        final backgroundImage = step.backgroundImage;

        return SizedBox.expand(
          child: Stack(
            fit: StackFit.expand,
            children: [
              backgroundImage == null || backgroundImage.isEmpty
                  ? const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                        ),
                      ),
                    )
                  : Image.asset(
                      backgroundImage,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                            ),
                          ),
                        );
                      },
                    ),
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: horizontalPadding,
                      right: horizontalPadding,
                      top: contentTop,
                      bottom: responsiveClamp(context, 90, 104, 118),
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: showContinue
                              ? null
                              : _advanceB08AnimationStage,
                          child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: contentPaddingX,
                                vertical: contentPaddingY,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: stageHeight,
                                    child: Align(
                                      alignment: Alignment(stageAlignmentX, 0),
                                      child: AnimatedSwitcher(
                                        duration: switchDuration,
                                        switchInCurve: Curves.easeOutCubic,
                                        switchOutCurve: Curves.easeInCubic,
                                        transitionBuilder: (child, animation) {
                                          if (reduceMotion) {
                                            return child;
                                          }
                                          return FadeTransition(
                                            opacity: animation,
                                            child: ScaleTransition(
                                              scale: Tween<double>(
                                                begin: 0.96,
                                                end: 1,
                                              ).animate(animation),
                                              child: child,
                                            ),
                                          );
                                        },
                                        child: _buildB08SimpanStageContent(
                                          context,
                                          stage: _b08AnimationStage,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: responsiveClamp(context, 16, 20, 24),
                right: responsiveClamp(context, 16, 20, 24),
                bottom: responsiveClamp(context, 14, 18, 22),
                child: AnimatedSwitcher(
                  duration: switchDuration,
                  child: showContinue
                      ? AnimatedKidButton(
                          key: const ValueKey('b08-continue-visible'),
                          label: step.buttonText,
                          icon: Icons.arrow_forward_rounded,
                          onPressed: _goNext,
                          backgroundColor: const Color(0xFFFFC300),
                          foregroundColor: const Color(0xFF1D3557),
                          labelFontSize: _responsiveButtonFontSize(context),
                        )
                      : const SizedBox(
                          key: ValueKey('b08-continue-hidden'),
                          height: 0,
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildB08SimpanStageContent(
    BuildContext context, {
    required int stage,
  }) {
    final textSize = responsiveClamp(context, 28, 36, 44);
    final wordSize = textSize;
    final formulaSize = textSize;
    final finalSize = textSize;
    const black = Color(0xFF111827);
    const red = Color(0xFFE63946);
    const green = Color(0xFF16A34A);

    TextStyle style(double size, Color color) {
      return TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w900,
        color: color,
        height: 1.05,
        fontFamily: 'Poppins',
        fontFamilyFallback: _fontFallback,
      );
    }

    Widget scaled(Widget child) {
      return FittedBox(fit: BoxFit.scaleDown, child: child);
    }

    Widget transformStage() {
      final circleSize = responsiveClamp(context, 38, 50, 60);
      final slotWidth = responsiveClamp(context, 46, 62, 74);
      final slotHeight = responsiveClamp(context, 78, 100, 120);
      final arrowSize = responsiveClamp(context, 24, 34, 42);
      final lift = responsiveClamp(context, 28, 38, 46);
      const nyLift = 0.0;
      final reduceMotion = AppMotionSpec.reduceMotion(context);

      Widget content(double value) {
        final circleProgress = Curves.easeOutCubic.transform(
          ((value - 0.18) / 0.24).clamp(0.0, 1.0),
        );
        final removeProgress = Curves.easeIn.transform(
          ((value - 0.58) / 0.22).clamp(0.0, 1.0),
        );
        final addProgress = Curves.easeOut.transform(
          ((value - 0.70) / 0.30).clamp(0.0, 1.0),
        );
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('me- + ', style: style(formulaSize, black)),
            SizedBox(
              width: slotWidth,
              height: slotHeight,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: 1 - removeProgress,
                    child: Transform.translate(
                      offset: Offset(0, -lift * removeProgress),
                      child: CustomPaint(
                        painter: _CircleProgressPainter(
                          color: red,
                          progress: circleProgress,
                          strokeWidth: 3,
                        ),
                        child: SizedBox(
                          width: circleSize,
                          height: circleSize,
                          child: Center(
                            child: Text('s', style: style(formulaSize, red)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: addProgress,
                    child: Transform.translate(
                      offset: Offset(0, (1 - addProgress) * 18),
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Transform.translate(
                            offset: Offset(0, -nyLift),
                            child: Text('ny', style: style(formulaSize, green)),
                          ),
                          Positioned(
                            top:
                                slotHeight / 2 +
                                responsiveClamp(context, 8, 12, 16),
                            child: Icon(
                              Icons.arrow_upward_rounded,
                              color: green,
                              size: arrowSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text('impan', style: style(formulaSize, black)),
          ],
        );
      }

      if (reduceMotion) {
        return content(1);
      }
      return TweenAnimationBuilder<double>(
        key: const ValueKey('b08-stage-2-transform'),
        tween: Tween(begin: 0, end: 1),
        duration: _b08StageDuration(2),
        curve: Curves.linear,
        builder: (context, value, child) => content(value),
      );
    }

    switch (stage) {
      case 0:
        return scaled(
          Text(
            'simpan',
            key: const ValueKey('b08-stage-0'),
            maxLines: 1,
            style: style(wordSize, black),
          ),
        );
      case 1:
        return scaled(
          Text(
            'me-',
            key: const ValueKey('b08-stage-1'),
            maxLines: 1,
            style: style(formulaSize, black),
          ),
        );
      case 2:
        return scaled(transformStage());
      default:
        return scaled(
          Text(
            'menyimpan',
            key: const ValueKey('b08-stage-3'),
            maxLines: 1,
            style: style(finalSize, black),
          ),
        );
    }
  }

  Widget _buildB09PilihAnimationStep(LearningStep step) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final reduceMotion = AppMotionSpec.reduceMotion(context);
        final switchDuration = reduceMotion
            ? Duration.zero
            : AppMotionSpec.chooseDuration(
                context,
                const Duration(milliseconds: 650),
                const Duration(milliseconds: 1),
              );
        final horizontalPadding = responsiveClamp(context, 16, 24, 28);
        final contentTop = constraints.maxHeight * 0.22;
        final contentPaddingX = responsiveClamp(context, 18, 24, 30);
        final contentPaddingY = responsiveClamp(context, 12, 18, 24);
        final stageHeight = responsiveClamp(context, 86, 118, 142);
        final stageAlignmentX = constraints.maxWidth < 360
            ? 0.18
            : constraints.maxWidth < 400
            ? 0.26
            : 0.34;
        final showContinue = _b09AnimationStage >= 3 && !_isB09StageAnimating;
        final backgroundImage = step.backgroundImage;

        return SizedBox.expand(
          child: Stack(
            fit: StackFit.expand,
            children: [
              backgroundImage == null || backgroundImage.isEmpty
                  ? const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                        ),
                      ),
                    )
                  : Image.asset(
                      backgroundImage,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                            ),
                          ),
                        );
                      },
                    ),
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: horizontalPadding,
                      right: horizontalPadding,
                      top: contentTop,
                      bottom: responsiveClamp(context, 90, 104, 118),
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: showContinue
                              ? null
                              : _advanceB09AnimationStage,
                          child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: contentPaddingX,
                                vertical: contentPaddingY,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: stageHeight,
                                    child: Align(
                                      alignment: Alignment(stageAlignmentX, 0),
                                      child: AnimatedSwitcher(
                                        duration: switchDuration,
                                        switchInCurve: Curves.easeOutCubic,
                                        switchOutCurve: Curves.easeInCubic,
                                        transitionBuilder: (child, animation) {
                                          if (reduceMotion) {
                                            return child;
                                          }
                                          return FadeTransition(
                                            opacity: animation,
                                            child: ScaleTransition(
                                              scale: Tween<double>(
                                                begin: 0.96,
                                                end: 1,
                                              ).animate(animation),
                                              child: child,
                                            ),
                                          );
                                        },
                                        child: _buildB09PilihStageContent(
                                          context,
                                          stage: _b09AnimationStage,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: responsiveClamp(context, 16, 20, 24),
                right: responsiveClamp(context, 16, 20, 24),
                bottom: responsiveClamp(context, 14, 18, 22),
                child: AnimatedSwitcher(
                  duration: switchDuration,
                  child: showContinue
                      ? AnimatedKidButton(
                          key: const ValueKey('b09-continue-visible'),
                          label: step.buttonText,
                          icon: Icons.arrow_forward_rounded,
                          onPressed: _goNext,
                          backgroundColor: const Color(0xFFFFC300),
                          foregroundColor: const Color(0xFF1D3557),
                          labelFontSize: _responsiveButtonFontSize(context),
                        )
                      : const SizedBox(
                          key: ValueKey('b09-continue-hidden'),
                          height: 0,
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildB09PilihStageContent(
    BuildContext context, {
    required int stage,
  }) {
    final textSize = responsiveClamp(context, 28, 36, 44);
    final wordSize = textSize;
    final formulaSize = textSize;
    final finalSize = textSize;
    const black = Color(0xFF111827);
    const red = Color(0xFFE63946);
    const green = Color(0xFF16A34A);

    TextStyle style(double size, Color color) {
      return TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w900,
        color: color,
        height: 1.05,
        fontFamily: 'Poppins',
        fontFamilyFallback: _fontFallback,
      );
    }

    Widget scaled(Widget child) {
      return FittedBox(fit: BoxFit.scaleDown, child: child);
    }

    Widget transformStage() {
      final circleSize = responsiveClamp(context, 38, 50, 60);
      final slotWidth = responsiveClamp(context, 46, 62, 74);
      final slotHeight = responsiveClamp(context, 78, 100, 120);
      final arrowSize = responsiveClamp(context, 24, 34, 42);
      final lift = responsiveClamp(context, 28, 38, 46);
      const replacementLift = 0.0;
      final reduceMotion = AppMotionSpec.reduceMotion(context);

      Widget content(double value) {
        final circleProgress = Curves.easeOutCubic.transform(
          ((value - 0.18) / 0.24).clamp(0.0, 1.0),
        );
        final removeProgress = Curves.easeIn.transform(
          ((value - 0.58) / 0.22).clamp(0.0, 1.0),
        );
        final addProgress = Curves.easeOut.transform(
          ((value - 0.70) / 0.30).clamp(0.0, 1.0),
        );
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('me- + ', style: style(formulaSize, black)),
            SizedBox(
              width: slotWidth,
              height: slotHeight,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: 1 - removeProgress,
                    child: Transform.translate(
                      offset: Offset(0, -lift * removeProgress),
                      child: CustomPaint(
                        painter: _CircleProgressPainter(
                          color: red,
                          progress: circleProgress,
                          strokeWidth: 3,
                        ),
                        child: SizedBox(
                          width: circleSize,
                          height: circleSize,
                          child: Center(
                            child: Text('p', style: style(formulaSize, red)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: addProgress,
                    child: Transform.translate(
                      offset: Offset(0, (1 - addProgress) * 18),
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Transform.translate(
                            offset: Offset(0, -replacementLift),
                            child: Text('m', style: style(formulaSize, green)),
                          ),
                          Positioned(
                            top:
                                slotHeight / 2 +
                                responsiveClamp(context, 8, 12, 16),
                            child: Icon(
                              Icons.arrow_upward_rounded,
                              color: green,
                              size: arrowSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text('ilih', style: style(formulaSize, black)),
          ],
        );
      }

      if (reduceMotion) {
        return content(1);
      }
      return TweenAnimationBuilder<double>(
        key: const ValueKey('b09-stage-2-transform'),
        tween: Tween(begin: 0, end: 1),
        duration: _b09StageDuration(2),
        curve: Curves.linear,
        builder: (context, value, child) => content(value),
      );
    }

    switch (stage) {
      case 0:
        return scaled(
          Text(
            'pilih',
            key: const ValueKey('b09-stage-0'),
            maxLines: 1,
            style: style(wordSize, black),
          ),
        );
      case 1:
        return scaled(
          Text(
            'me-',
            key: const ValueKey('b09-stage-1'),
            maxLines: 1,
            style: style(formulaSize, black),
          ),
        );
      case 2:
        return scaled(transformStage());
      default:
        return scaled(
          Text(
            'memilih',
            key: const ValueKey('b09-stage-3'),
            maxLines: 1,
            style: style(finalSize, black),
          ),
        );
    }
  }

  Widget _buildB10PakaiAnimationStep(LearningStep step) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final reduceMotion = AppMotionSpec.reduceMotion(context);
        final switchDuration = reduceMotion
            ? Duration.zero
            : AppMotionSpec.chooseDuration(
                context,
                const Duration(milliseconds: 650),
                const Duration(milliseconds: 1),
              );
        final horizontalPadding = responsiveClamp(context, 16, 24, 28);
        final contentTop = constraints.maxHeight * 0.22;
        final contentPaddingX = responsiveClamp(context, 18, 24, 30);
        final contentPaddingY = responsiveClamp(context, 12, 18, 24);
        final stageHeight = responsiveClamp(context, 86, 118, 142);
        final stageAlignmentX = constraints.maxWidth < 360
            ? 0.18
            : constraints.maxWidth < 400
            ? 0.26
            : 0.34;
        final showContinue = _b10AnimationStage >= 3 && !_isB10StageAnimating;
        final backgroundImage = step.backgroundImage;

        return SizedBox.expand(
          child: Stack(
            fit: StackFit.expand,
            children: [
              backgroundImage == null || backgroundImage.isEmpty
                  ? const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                        ),
                      ),
                    )
                  : Image.asset(
                      backgroundImage,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                            ),
                          ),
                        );
                      },
                    ),
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: horizontalPadding,
                      right: horizontalPadding,
                      top: contentTop,
                      bottom: responsiveClamp(context, 90, 104, 118),
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: showContinue
                              ? null
                              : _advanceB10AnimationStage,
                          child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: contentPaddingX,
                                vertical: contentPaddingY,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: stageHeight,
                                    child: Align(
                                      alignment: Alignment(stageAlignmentX, 0),
                                      child: AnimatedSwitcher(
                                        duration: switchDuration,
                                        switchInCurve: Curves.easeOutCubic,
                                        switchOutCurve: Curves.easeInCubic,
                                        transitionBuilder: (child, animation) {
                                          if (reduceMotion) {
                                            return child;
                                          }
                                          return FadeTransition(
                                            opacity: animation,
                                            child: ScaleTransition(
                                              scale: Tween<double>(
                                                begin: 0.96,
                                                end: 1,
                                              ).animate(animation),
                                              child: child,
                                            ),
                                          );
                                        },
                                        child: _buildB10PakaiStageContent(
                                          context,
                                          stage: _b10AnimationStage,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: responsiveClamp(context, 16, 20, 24),
                right: responsiveClamp(context, 16, 20, 24),
                bottom: responsiveClamp(context, 14, 18, 22),
                child: AnimatedSwitcher(
                  duration: switchDuration,
                  child: showContinue
                      ? AnimatedKidButton(
                          key: const ValueKey('b10-continue-visible'),
                          label: step.buttonText,
                          icon: Icons.arrow_forward_rounded,
                          onPressed: _goNext,
                          backgroundColor: const Color(0xFFFFC300),
                          foregroundColor: const Color(0xFF1D3557),
                          labelFontSize: _responsiveButtonFontSize(context),
                        )
                      : const SizedBox(
                          key: ValueKey('b10-continue-hidden'),
                          height: 0,
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildB10PakaiStageContent(
    BuildContext context, {
    required int stage,
  }) {
    final textSize = responsiveClamp(context, 28, 36, 44);
    final wordSize = textSize;
    final formulaSize = textSize;
    final finalSize = textSize;
    const black = Color(0xFF111827);
    const red = Color(0xFFE63946);
    const green = Color(0xFF16A34A);

    TextStyle style(double size, Color color) {
      return TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w900,
        color: color,
        height: 1.05,
        fontFamily: 'Poppins',
        fontFamilyFallback: _fontFallback,
      );
    }

    Widget scaled(Widget child) {
      return FittedBox(fit: BoxFit.scaleDown, child: child);
    }

    Widget transformStage() {
      final circleSize = responsiveClamp(context, 38, 50, 60);
      final slotWidth = responsiveClamp(context, 46, 62, 74);
      final slotHeight = responsiveClamp(context, 78, 100, 120);
      final arrowSize = responsiveClamp(context, 24, 34, 42);
      final lift = responsiveClamp(context, 28, 38, 46);
      const replacementLift = 0.0;
      final reduceMotion = AppMotionSpec.reduceMotion(context);

      Widget content(double value) {
        final circleProgress = Curves.easeOutCubic.transform(
          ((value - 0.18) / 0.24).clamp(0.0, 1.0),
        );
        final removeProgress = Curves.easeIn.transform(
          ((value - 0.58) / 0.22).clamp(0.0, 1.0),
        );
        final addProgress = Curves.easeOut.transform(
          ((value - 0.70) / 0.30).clamp(0.0, 1.0),
        );
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('me- + ', style: style(formulaSize, black)),
            SizedBox(
              width: slotWidth,
              height: slotHeight,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: 1 - removeProgress,
                    child: Transform.translate(
                      offset: Offset(0, -lift * removeProgress),
                      child: CustomPaint(
                        painter: _CircleProgressPainter(
                          color: red,
                          progress: circleProgress,
                          strokeWidth: 3,
                        ),
                        child: SizedBox(
                          width: circleSize,
                          height: circleSize,
                          child: Center(
                            child: Text('p', style: style(formulaSize, red)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: addProgress,
                    child: Transform.translate(
                      offset: Offset(0, (1 - addProgress) * 18),
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Transform.translate(
                            offset: Offset(0, -replacementLift),
                            child: Text('m', style: style(formulaSize, green)),
                          ),
                          Positioned(
                            top:
                                slotHeight / 2 +
                                responsiveClamp(context, 8, 12, 16),
                            child: Icon(
                              Icons.arrow_upward_rounded,
                              color: green,
                              size: arrowSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text('akai', style: style(formulaSize, black)),
          ],
        );
      }

      if (reduceMotion) {
        return content(1);
      }
      return TweenAnimationBuilder<double>(
        key: const ValueKey('b10-stage-2-transform'),
        tween: Tween(begin: 0, end: 1),
        duration: _b10StageDuration(2),
        curve: Curves.linear,
        builder: (context, value, child) => content(value),
      );
    }

    switch (stage) {
      case 0:
        return scaled(
          Text(
            'pakai',
            key: const ValueKey('b10-stage-0'),
            maxLines: 1,
            style: style(wordSize, black),
          ),
        );
      case 1:
        return scaled(
          Text(
            'me-',
            key: const ValueKey('b10-stage-1'),
            maxLines: 1,
            style: style(formulaSize, black),
          ),
        );
      case 2:
        return scaled(transformStage());
      default:
        return scaled(
          Text(
            'memakai',
            key: const ValueKey('b10-stage-3'),
            maxLines: 1,
            style: style(finalSize, black),
          ),
        );
    }
  }

  Widget _buildGenericWordAnimationStep({
    required LearningStep step,
    required String rootWord,
    required String finalWord,
    required String circledLetter,
    required String remainingLetters,
    required String replacementLetters,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final reduceMotion = AppMotionSpec.reduceMotion(context);
        final switchDuration = reduceMotion
            ? Duration.zero
            : AppMotionSpec.chooseDuration(
                context,
                const Duration(milliseconds: 650),
                const Duration(milliseconds: 1),
              );
        final horizontalPadding = responsiveClamp(context, 16, 24, 28);
        final contentTop = constraints.maxHeight * 0.22;
        final contentPaddingX = responsiveClamp(context, 18, 24, 30);
        final contentPaddingY = responsiveClamp(context, 12, 18, 24);
        final stageHeight = responsiveClamp(context, 86, 118, 142);
        final stageAlignmentX = constraints.maxWidth < 360
            ? 0.18
            : constraints.maxWidth < 400
            ? 0.26
            : 0.34;
        final stage = _animationStageForSpecialStep(step.id);
        final showContinue =
            stage >= 3 && !_isAnimationRunningForSpecialStep(step.id);
        final backgroundImage = step.backgroundImage;

        return SizedBox.expand(
          child: Stack(
            fit: StackFit.expand,
            children: [
              backgroundImage == null || backgroundImage.isEmpty
                  ? const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                        ),
                      ),
                    )
                  : Image.asset(
                      backgroundImage,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                            ),
                          ),
                        );
                      },
                    ),
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: horizontalPadding,
                      right: horizontalPadding,
                      top: contentTop,
                      bottom: responsiveClamp(context, 90, 104, 118),
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: showContinue
                              ? null
                              : () => _advanceB11ToB14AnimationStage(step.id),
                          child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: contentPaddingX,
                                vertical: contentPaddingY,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: stageHeight,
                                    child: Align(
                                      alignment: Alignment(stageAlignmentX, 0),
                                      child: AnimatedSwitcher(
                                        duration: switchDuration,
                                        switchInCurve: Curves.easeOutCubic,
                                        switchOutCurve: Curves.easeInCubic,
                                        transitionBuilder: (child, animation) {
                                          if (reduceMotion) {
                                            return child;
                                          }
                                          return FadeTransition(
                                            opacity: animation,
                                            child: ScaleTransition(
                                              scale: Tween<double>(
                                                begin: 0.96,
                                                end: 1,
                                              ).animate(animation),
                                              child: child,
                                            ),
                                          );
                                        },
                                        child: _buildGenericWordStageContent(
                                          context,
                                          stepId: step.id,
                                          stage: stage,
                                          rootWord: rootWord,
                                          finalWord: finalWord,
                                          circledLetter: circledLetter,
                                          remainingLetters: remainingLetters,
                                          replacementLetters:
                                              replacementLetters,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: responsiveClamp(context, 16, 20, 24),
                right: responsiveClamp(context, 16, 20, 24),
                bottom: responsiveClamp(context, 14, 18, 22),
                child: AnimatedSwitcher(
                  duration: switchDuration,
                  child: showContinue
                      ? AnimatedKidButton(
                          key: ValueKey('${step.id}-continue-visible'),
                          label: step.buttonText,
                          icon: Icons.arrow_forward_rounded,
                          onPressed: _goNext,
                          backgroundColor: const Color(0xFFFFC300),
                          foregroundColor: const Color(0xFF1D3557),
                          labelFontSize: _responsiveButtonFontSize(context),
                        )
                      : SizedBox(
                          key: ValueKey('${step.id}-continue-hidden'),
                          height: 0,
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGenericWordStageContent(
    BuildContext context, {
    required String stepId,
    required int stage,
    required String rootWord,
    required String finalWord,
    required String circledLetter,
    required String remainingLetters,
    required String replacementLetters,
  }) {
    final textSize = responsiveClamp(context, 28, 36, 44);
    final wordSize = textSize;
    final formulaSize = textSize;
    final finalSize = textSize;
    const black = Color(0xFF111827);
    const red = Color(0xFFE63946);
    const green = Color(0xFF16A34A);

    TextStyle style(double size, Color color) {
      return TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w900,
        color: color,
        height: 1.05,
        fontFamily: 'Poppins',
        fontFamilyFallback: _fontFallback,
      );
    }

    Widget scaled(Widget child) {
      return FittedBox(fit: BoxFit.scaleDown, child: child);
    }

    Widget transformStage() {
      final circleSize = responsiveClamp(context, 38, 50, 60);
      final slotWidth = responsiveClamp(
        context,
        replacementLetters.length > 1 ? 54 : 46,
        replacementLetters.length > 1 ? 72 : 62,
        replacementLetters.length > 1 ? 86 : 74,
      );
      final slotHeight = responsiveClamp(context, 78, 100, 120);
      final arrowSize = responsiveClamp(context, 24, 34, 42);
      final lift = responsiveClamp(context, 28, 38, 46);
      const replacementLift = 0.0;
      final reduceMotion = AppMotionSpec.reduceMotion(context);

      Widget content(double value) {
        final circleProgress = Curves.easeOutCubic.transform(
          ((value - 0.18) / 0.24).clamp(0.0, 1.0),
        );
        final removeProgress = Curves.easeIn.transform(
          ((value - 0.58) / 0.22).clamp(0.0, 1.0),
        );
        final addProgress = Curves.easeOut.transform(
          ((value - 0.70) / 0.30).clamp(0.0, 1.0),
        );
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('me- + ', style: style(formulaSize, black)),
            SizedBox(
              width: slotWidth,
              height: slotHeight,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: 1 - removeProgress,
                    child: Transform.translate(
                      offset: Offset(0, -lift * removeProgress),
                      child: CustomPaint(
                        painter: _CircleProgressPainter(
                          color: red,
                          progress: circleProgress,
                          strokeWidth: 3,
                        ),
                        child: SizedBox(
                          width: circleSize,
                          height: circleSize,
                          child: Center(
                            child: Text(
                              circledLetter,
                              style: style(formulaSize, red),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: addProgress,
                    child: Transform.translate(
                      offset: Offset(0, (1 - addProgress) * 18),
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Transform.translate(
                            offset: Offset(0, -replacementLift),
                            child: Text(
                              replacementLetters,
                              style: style(formulaSize, green),
                            ),
                          ),
                          Positioned(
                            top:
                                slotHeight / 2 +
                                responsiveClamp(context, 8, 12, 16),
                            child: Icon(
                              Icons.arrow_upward_rounded,
                              color: green,
                              size: arrowSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(remainingLetters, style: style(formulaSize, black)),
          ],
        );
      }

      if (reduceMotion) {
        return content(1);
      }
      return TweenAnimationBuilder<double>(
        key: ValueKey('$stepId-stage-2-transform'),
        tween: Tween(begin: 0, end: 1),
        duration: _wordAnimationStageDuration(2),
        curve: Curves.linear,
        builder: (context, value, child) => content(value),
      );
    }

    switch (stage) {
      case 0:
        return scaled(
          Text(
            rootWord,
            key: ValueKey('$stepId-stage-0'),
            maxLines: 1,
            style: style(wordSize, black),
          ),
        );
      case 1:
        return scaled(
          Text(
            'me-',
            key: ValueKey('$stepId-stage-1'),
            maxLines: 1,
            style: style(formulaSize, black),
          ),
        );
      case 2:
        return scaled(transformStage());
      default:
        return scaled(
          Text(
            finalWord,
            key: ValueKey('$stepId-stage-3'),
            maxLines: 1,
            style: style(finalSize, black),
          ),
        );
    }
  }

  Widget _buildCompletionStep() {
    final bodySize = responsiveClamp(context, 15, _bodyFontSize, 20);
    return _scrollableStepContent(
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
                  child: Text(
                    'Anda telah menyelesaikan pembelajaran imbuhan meN-.',
                    style: TextStyle(
                      fontSize: bodySize,
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
            child: Text(
              'Tekan butang di bawah untuk kembali ke menu utama.',
              style: TextStyle(
                color: Color(0xFF1D3557),
                fontSize: bodySize,
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
            onPressed: () => goToMainMenu(context),
            backgroundColor: const Color(0xFF2A9D8F),
            labelFontSize: _responsiveButtonFontSize(context),
          ),
        ],
      ),
    );
  }

  Widget _buildStepBody(LearningStep step) {
    if (step.id == 'B07') {
      return _buildB07SalinAnimationStep(step);
    }
    if (step.id == 'B08') {
      return _buildB08SimpanAnimationStep(step);
    }
    if (step.id == 'B09') {
      return _buildB09PilihAnimationStep(step);
    }
    if (step.id == 'B10') {
      return _buildB10PakaiAnimationStep(step);
    }
    if (step.id == 'B11') {
      return _buildGenericWordAnimationStep(
        step: step,
        rootWord: 'tarik',
        finalWord: 'menarik',
        circledLetter: 't',
        remainingLetters: 'arik',
        replacementLetters: 'n',
      );
    }
    if (step.id == 'B12') {
      return _buildGenericWordAnimationStep(
        step: step,
        rootWord: 'tanam',
        finalWord: 'menanam',
        circledLetter: 't',
        remainingLetters: 'anam',
        replacementLetters: 'n',
      );
    }
    if (step.id == 'B13') {
      return _buildGenericWordAnimationStep(
        step: step,
        rootWord: 'kumpul',
        finalWord: 'mengumpul',
        circledLetter: 'k',
        remainingLetters: 'umpul',
        replacementLetters: 'ng',
      );
    }
    if (step.id == 'B14') {
      return _buildGenericWordAnimationStep(
        step: step,
        rootWord: 'kunci',
        finalWord: 'mengunci',
        circledLetter: 'k',
        remainingLetters: 'unci',
        replacementLetters: 'ng',
      );
    }
    if (step.id == 'B19') {
      return _buildB19ImageHeadingStep(step);
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
      case LearningStepType.levelTransition:
        return _buildLevelTransitionStep(step);
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
    final mediaQuery = MediaQuery.of(context);
    final isLevelTransition = step.type == LearningStepType.levelTransition;
    return MediaQuery(
      data: mediaQuery.copyWith(textScaler: responsiveTextScaler(context)),
      child: Scaffold(
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
                      padding: isLevelTransition
                          ? EdgeInsets.zero
                          : const EdgeInsets.fromLTRB(16, 8, 16, 16),
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
                          padding: isLevelTransition
                              ? EdgeInsets.zero
                              : const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isLevelTransition
                                ? Colors.transparent
                                : Colors.white.withValues(alpha: 0.52),
                            borderRadius: BorderRadius.circular(
                              isLevelTransition ? 0 : 18,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _buildStepBody(step)),
                              if (step.type != LearningStepType.quizGateway &&
                                  !isLevelTransition) ...[
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
                                      labelFontSize: _responsiveButtonFontSize(
                                        context,
                                      ),
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
      ),
    );
  }
}

class _CircleProgressPainter extends CustomPainter {
  const _CircleProgressPainter({
    required this.color,
    required this.progress,
    required this.strokeWidth,
  });

  final Color color;
  final double progress;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) {
      return;
    }
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final inset = strokeWidth / 2;
    final rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    canvas.drawArc(rect, -math.pi / 2, math.pi * 2 * progress, false, paint);
  }

  @override
  bool shouldRepaint(covariant _CircleProgressPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth;
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
      tableHeaders: ['Awalan meN-', 'Huruf awal'],
      tableRows: [
        LearningRuleRow(
          cells: [
            'me-',
            'l, m, n, ng, ny, r, w \np (menjadi m) \nt (menjadi n) \nk (menjadi ng) \ns (menjadi ny)',
          ],
          backgroundColor: Color(0xFFA5D6A7),
        ),
        LearningRuleRow(
          cells: ['mem-', 'b, f'],
          backgroundColor: Color(0xFF90CAF9),
        ),
        LearningRuleRow(
          cells: ['men-', 'c, d, j, z, sy'],
          backgroundColor: Color(0xFFFFB74D),
        ),
        LearningRuleRow(
          cells: ['meng-', 'a, e, i, o, u (vokal) \ng, h'],
          backgroundColor: Color(0xFFEF9A9A),
        ),
        LearningRuleRow(
          cells: ['menge-', 'kata dasar satu suku kata'],
          backgroundColor: Color(0xFFFFF176),
        ),
      ],
    ),
    LearningStep(
      id: 'B05',
      title: 'Penggunaan imbuhan me-',
      type: LearningStepType.arrowExamples,
      subtitle: 'Gunakan imbuhan me- apabila kata dasar bermula dengan huruf:',
      backgroundTop: Color(0xFFFFF8D2),
      backgroundBottom: Color(0xFFFFEBB1),
      highlightedLetters: ['l', 'm', 'n', 'ng', 'ny', 'r', 'w'],
      afterHighlightLine: 'Huruf awal tidak berubah.',
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
      title: 'salin',
      subtitle: 'menyalin',
      type: LearningStepType.levelTransition,
      buttonText: 'Teruskan',
      voiceScript: 'salin… tambah imbuhan me-… menjadi… menyalin',
      backgroundImage: 'assets/background/animaBgGirl.jpg',
    ),
    LearningStep(
      id: 'B08',
      title: 'simpan',
      subtitle: 'menyimpan',
      type: LearningStepType.levelTransition,
      buttonText: 'Teruskan',
      voiceScript: 'simpan… tambah imbuhan me-… menjadi… menyimpan',
      backgroundImage: 'assets/background/animaBgGirl.jpg',
    ),
    LearningStep(
      id: 'B09',
      title: 'pilih',
      subtitle: 'memilih',
      type: LearningStepType.levelTransition,
      buttonText: 'Teruskan',
      voiceScript: 'pilih… tambah imbuhan me-… menjadi… memilih',
      backgroundImage: 'assets/background/animaBgBoy.jpg',
    ),
    LearningStep(
      id: 'B10',
      title: 'pakai',
      subtitle: 'memakai',
      type: LearningStepType.levelTransition,
      buttonText: 'Teruskan',
      voiceScript: 'pakai… tambah imbuhan me-… menjadi… memakai',
      backgroundImage: 'assets/background/animaBgBoy.jpg',
    ),
    LearningStep(
      id: 'B11',
      title: 'tarik',
      subtitle: 'menarik',
      type: LearningStepType.levelTransition,
      buttonText: 'Teruskan',
      voiceScript: 'tarik… tambah imbuhan me-… menjadi… menarik',
      backgroundImage: 'assets/background/animaBgGirl.jpg',
    ),
    LearningStep(
      id: 'B12',
      title: 'tanam',
      subtitle: 'menanam',
      type: LearningStepType.levelTransition,
      buttonText: 'Teruskan',
      voiceScript: 'tanam… tambah imbuhan me-… menjadi… menanam',
      backgroundImage: 'assets/background/animaBgGirl.jpg',
    ),
    LearningStep(
      id: 'B13',
      title: 'kumpul',
      subtitle: 'mengumpul',
      type: LearningStepType.levelTransition,
      buttonText: 'Teruskan',
      voiceScript: 'kumpul… tambah imbuhan me-… menjadi… mengumpul',
      backgroundImage: 'assets/background/animaBgBoy.jpg',
    ),
    LearningStep(
      id: 'B14',
      title: 'kunci',
      subtitle: 'mengunci',
      type: LearningStepType.levelTransition,
      buttonText: 'Teruskan',
      voiceScript: 'kunci… tambah imbuhan me-… menjadi… mengunci',
      backgroundImage: 'assets/background/animaBgBoy.jpg',
    ),
    LearningStep(
      id: 'B15',
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
      id: 'B16',
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
      id: 'B17',
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
      id: 'B18',
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
      id: 'B19',
      title: 'Mari kita belajar imbuhan awalan melalui situasi.',
      type: LearningStepType.changeCards,
      backgroundTop: Color(0xFFFFF8D2),
      backgroundBottom: Color(0xFFFFE7A7),
      subtitle:
          'Situasi ini membantu anda memilih imbuhan berdasarkan huruf awal kata dasar.',
    ),
    LearningStep(
      id: 'B20',
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
          alignment: Alignment(0.06, -0.72),
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
      id: 'B21',
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
      id: 'B22',
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
      id: 'B23',
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
      id: 'B24',
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
      id: 'B25',
      title: 'Ringkasan Imbuhan Awalan meN-',
      type: LearningStepType.summary,
      backgroundTop: Color(0xFFFFF8D5),
      backgroundBottom: Color(0xFFFFE9B1),
      subtitle: 'Perhatikan huruf awal untuk memilih imbuhan yang betul.',
      buttonText: 'Kembali ke Menu Utama',
      summaryCards: [
        LearningSummaryCard(
          prefix: 'me-',
          ruleText: 'Huruf: l, m, n, ng, ny, r, w  \np (menjadi m) \nt (menjadi n) \nk (menjadi ng) \ns (menjadi ny)',
        ),
        LearningSummaryCard(
          prefix: 'mem-',
          ruleText:
              'Huruf: b, f',
        ),
        LearningSummaryCard(
          prefix: 'men-',
          ruleText: 'Huruf: c, d, j, z, sy',
        ),
        LearningSummaryCard(
          prefix: 'meng-',
          ruleText: 'Huruf: a, e, i, o, u (vokal) \ng, h',
        ),
        LearningSummaryCard(
          prefix: 'menge-',
          ruleText: 'Kata satu suku kata guna imbuhan menge-',
        ),
      ],
    ),
  ];
}
