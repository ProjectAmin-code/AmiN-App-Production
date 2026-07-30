import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
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

const Color _b01HeadingColor = Color(0xFF2C7A7B);
const Color _b01TitleBoxColor = Color(0xFFDFF4F1);
const Color _b01TitleBorderColor = Color(0xFFBFE7E1);
const Color _b01TitleTextColor = Color(0xFF1F4D4A);
const Color _b01ImbuhanColor = Color(0xFFFCE7F3);
const Color _b01ImbuhanTextColor = Color(0xFF9D174D);
const Color _b01KataDasarColor = Color(0xFFDBEAFE);
const Color _b01KataDasarTextColor = Color(0xFF1D4ED8);
const Color _b01KataTerbitanColor = Color(0xFFDCFCE7);
const Color _b01KataTerbitanTextColor = Color(0xFF166534);
const Color _b01MainTextColor = Color(0xFF1F2937);
const Color _b01CardColor = Color(0xFFFFFFFF);
const Color _b01ScreenBgColor = Color(0xFFFFFDF8);
const Color _b01ButtonColor = Color(0xFFE85D75);
const Color _b01WhiteColor = Color(0xFFFFFFFF);

const Color _b07TextColor = Color(0xFF1F2937);
const Color _b07ChangeFromColor = Color(0xFFE11D48);
const Color _b07ChangeToColor = Color(0xFF16A34A);

const Color _b04TableHeaderColor = Color(0xFF155E75);
const Color _b04ScreenBgColor = Color(0xFFFFFDF8);
const Color _b04WhiteColor = Color(0xFFFFFFFF);

const Color _b05MainColor = Color(0xFF2E8B57);
const Color _b05LightBackground = Color(0xFFEAF7EF);
const Color _b05AccentColor = Color(0xFF66BB8A);
const Color _b05DarkerAccentColor = Color(0xFF256F46);
const Color _b05TextOnColoredBox = Color(0xFFFFFFFF);
const Color _b05TextOnLightArea = Color(0xFF1F2937);

const Color _b15MainColor = Color(0xFF3B82F6);
const Color _b15LightBackground = Color(0xFFEAF3FF);
const Color _b15AccentColor = Color(0xFF93C5FD);
const Color _b15DarkerAccentColor = Color(0xFF2563EB);
const Color _b15TextOnColoredBox = Color(0xFFFFFFFF);
const Color _b15TextOnLightArea = Color(0xFF1F2937);

const Color _b16MainColor = Color(0xFFD4A017);
const Color _b16LightBackground = Color(0xFFFFF8E1);
const Color _b16AccentColor = Color(0xFFF6D365);
const Color _b16DarkerAccentColor = Color(0xFFA87C00);
const Color _b16TextOnColoredBox = Color(0xFF1F2937);
const Color _b16TextOnLightArea = Color(0xFF1F2937);

const Color _b17MainColor = Color(0xFFD65A8C);
const Color _b17LightBackground = Color(0xFFFDECF3);
const Color _b17AccentColor = Color(0xFFF3A8C5);
const Color _b17DarkerAccentColor = Color(0xFFB84472);
const Color _b17TextOnColoredBox = Color(0xFFFFFFFF);
const Color _b17TextOnLightArea = Color(0xFF1F2937);

const Color _b18MainColor = Color(0xFF7C4DCC);
const Color _b18LightBackground = Color(0xFFF1EBFF);
const Color _b18AccentColor = Color(0xFFB39DDB);
const Color _b18DarkerAccentColor = Color(0xFF5E35B1);
const Color _b18TextOnColoredBox = Color(0xFFFFFFFF);
const Color _b18TextOnLightArea = Color(0xFF1F2937);

const Color _b25PageBackground = Color(0xFFFFFDF8);
const Color _b25MainText = Color(0xFF1F2937);
const Color _b25SecondaryText = Color(0xFF4B5563);
const Color _b25Border = Color(0xFFD9E2EC);
const Color _b25HeadingStart = Color(0xFF155E75);
const Color _b25HeadingEnd = Color(0xFF0E7490);
const Color _b25HeadingSubtitle = Color(0xFFE0F2FE);
const Color _b25HeadingAccent = Color(0xFFFACC15);
const Color _b25Button = Color(0xFFFF6B6B);
const Color _b25ButtonPressed = Color(0xFFEF4444);
const Color _b25ButtonShadow = Color(0xFFFCA5A5);

class _SummaryCardPalette {
  const _SummaryCardPalette({
    required this.background,
    required this.main,
    required this.accent,
    required this.darkAccent,
    required this.textOnMain,
  });

  final Color background;
  final Color main;
  final Color accent;
  final Color darkAccent;
  final Color textOnMain;
}

class _AnimatedWordSpec {
  const _AnimatedWordSpec({
    required this.rootWord,
    required this.finalWord,
    required this.originalLetter,
    required this.replacementLetters,
    required this.remainingLetters,
  });

  final String rootWord;
  final String finalWord;
  final String originalLetter;
  final String replacementLetters;
  final String remainingLetters;
}

class LearningFlowScreen extends StatefulWidget {
  const LearningFlowScreen({super.key, required this.name});

  final String name;

  @override
  State<LearningFlowScreen> createState() => _LearningFlowScreenState();
}

class _LearningFlowScreenState extends State<LearningFlowScreen>
    with SingleTickerProviderStateMixin {
  // Debug-only lesson jump control. Set to false to hide it without removing code.
  static const bool _enableLessonBypasser = kDebugMode;
  static const double _headingFontSize = 25;
  static const double _bodyFontSize = 20;
  static const double _buttonFontSize = 20;
  static const List<String> _fontFallback = [
    'Century Gothic',
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
  // Keep B15-B18 free of the extra mascot overlay and spacing tuning.
  static const bool _enableB15ToB18ArrowEnhancements = false;
  static const Set<String> _arrowEnhancedStepIds = {'B15', 'B16', 'B17', 'B18'};
  static const String _arrowMascotRightAsset =
      'assets/Action Figures/AmiN pointing right.svg';
  static const String _arrowMascotPointingAsset =
      'assets/Action Figures/AmiN Pointing.svg';
  static const Map<String, _AnimatedWordSpec> _animatedWordSpecs = {
    'B07': _AnimatedWordSpec(
      rootWord: 'pilih',
      finalWord: 'memilih',
      originalLetter: 'p',
      replacementLetters: 'm',
      remainingLetters: 'ilih',
    ),
    'B08': _AnimatedWordSpec(
      rootWord: 'simpan',
      finalWord: 'menyimpan',
      originalLetter: 's',
      replacementLetters: 'ny',
      remainingLetters: 'impan',
    ),
    'B09': _AnimatedWordSpec(
      rootWord: 'pilih',
      finalWord: 'memilih',
      originalLetter: 'p',
      replacementLetters: 'm',
      remainingLetters: 'ilih',
    ),
    'B10': _AnimatedWordSpec(
      rootWord: 'pakai',
      finalWord: 'memakai',
      originalLetter: 'p',
      replacementLetters: 'm',
      remainingLetters: 'akai',
    ),
    'B11': _AnimatedWordSpec(
      rootWord: 'tarik',
      finalWord: 'menarik',
      originalLetter: 't',
      replacementLetters: 'n',
      remainingLetters: 'arik',
    ),
    'B12': _AnimatedWordSpec(
      rootWord: 'tanam',
      finalWord: 'menanam',
      originalLetter: 't',
      replacementLetters: 'n',
      remainingLetters: 'anam',
    ),
    'B13': _AnimatedWordSpec(
      rootWord: 'kumpul',
      finalWord: 'mengumpul',
      originalLetter: 'k',
      replacementLetters: 'ng',
      remainingLetters: 'umpul',
    ),
    'B14': _AnimatedWordSpec(
      rootWord: 'kunci',
      finalWord: 'mengunci',
      originalLetter: 'k',
      replacementLetters: 'ng',
      remainingLetters: 'unci',
    ),
  };

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
      ProgressTracker.instance.recordLessonStarted(_currentStep.id);
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
    ProgressTracker.instance.recordLessonStarted(_currentStep.id);
    await _speakCurrentStep();
  }

  Future<void> _jumpToStep(int stepIndex) async {
    if (stepIndex < 0 ||
        stepIndex >= _steps.length ||
        stepIndex == _currentIndex) {
      return;
    }
    await AminTtsService.instance.stop();
    if (!mounted) {
      return;
    }
    setState(() {
      _currentIndex = stepIndex;
      _resetB07AnimationIfNeeded();
      _resetB08AnimationIfNeeded();
      _resetB09AnimationIfNeeded();
      _resetB10AnimationIfNeeded();
      _resetB11ToB14AnimationIfNeeded();
    });
    ProgressTracker.instance.updateLearningStep(
      reachedStep: _currentIndex + 1,
      totalSteps: _steps.length,
    );
    ProgressTracker.instance.recordLessonStarted(_currentStep.id);
    await _speakCurrentStep();
  }

  Future<void> _openLessonBypasser() async {
    final selectedIndex = await showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Jump to lesson screen'),
          content: SizedBox(
            width: 360,
            height: 420,
            child: ListView.builder(
              itemCount: _steps.length,
              itemBuilder: (context, index) {
                final step = _steps[index];
                final isCurrentStep = index == _currentIndex;
                return ListTile(
                  dense: true,
                  selected: isCurrentStep,
                  leading: CircleAvatar(
                    radius: 16,
                    child: Text(step.id.replaceFirst('B', '')),
                  ),
                  title: Text(step.id),
                  subtitle: Text(
                    step.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: isCurrentStep ? const Icon(Icons.check) : null,
                  onTap: () => Navigator.of(dialogContext).pop(index),
                );
              },
            ),
          ),
        );
      },
    );
    if (selectedIndex != null) {
      await _jumpToStep(selectedIndex);
    }
  }

  Widget _buildLessonBypasser() {
    return Positioned(
      right: 16,
      bottom: 16,
      child: FloatingActionButton.small(
        heroTag: 'learning-flow-bypasser',
        tooltip: 'Jump to lesson screen',
        onPressed: _openLessonBypasser,
        child: const Icon(Icons.skip_next_rounded),
      ),
    );
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
    if (_isB07StageAnimating || _b07AnimationStage >= 2) {
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
    if (_isB08StageAnimating || _b08AnimationStage >= 2) {
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
    if (_isB09StageAnimating || _b09AnimationStage >= 2) {
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
    if (_isB10StageAnimating || _b10AnimationStage >= 2) {
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
    if (_isAnimationRunningForSpecialStep(stepId) || currentStage >= 2) {
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
                        ),
                        if (revealAnswer &&
                            hotspot.ruleNote.trim().isNotEmpty) ...[
                          const SizedBox(height: 10),
                          _buildHotspotRuleNote(
                            hotspot: hotspot,
                            fontSize: noteFontSize,
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
    final prefix = _derivedPrefixForBaseWord(hotspot.baseWord);
    final prefixLength = math.min(prefix.length, derivedWord.length);
    final highlightedPrefix = derivedWord.substring(0, prefixLength);
    final suffix = derivedWord.substring(prefixLength);
    final replacementSound = _replacementSoundForBaseWord(hotspot.baseWord);
    final underlineLength =
        replacementSound != null && suffix.startsWith(replacementSound)
        ? replacementSound.length
        : 0;

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: highlightedPrefix,
            style: TextStyle(
              color: _prefixHighlightColor(prefix),
              fontWeight: FontWeight.w900,
            ),
          ),
          if (underlineLength > 0)
            TextSpan(
              text: suffix.substring(0, underlineLength),
              style: const TextStyle(decoration: TextDecoration.underline),
            ),
          TextSpan(text: suffix.substring(underlineLength)),
        ],
      ),
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w900,
        // Keep the non-highlighted part of the derived word consistent with
        // the base word shown above it.
        color: const Color(0xFF1D3557),
      ),
    );
  }

  String? _replacementSoundForBaseWord(String baseWord) {
    final normalizedBaseWord = baseWord.trim().toLowerCase();
    return switch (normalizedBaseWord.isEmpty ? '' : normalizedBaseWord[0]) {
      't' => 'n',
      'k' => 'ng',
      'p' => 'm',
      's' => 'ny',
      _ => null,
    };
  }

  Widget _buildHotspotRuleNote({
    required LearningHotspot hotspot,
    required double fontSize,
  }) {
    return Text(
      hotspot.ruleNote,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF334155),
      ),
    );
  }

  String _derivedPrefixForBaseWord(String baseWord) {
    final word = baseWord.trim().toLowerCase();
    if (word.startsWith('p') ||
        word.startsWith('t') ||
        word.startsWith('k') ||
        word.startsWith('s')) {
      return 'me';
    }
    if (word == 'cat' || word == 'lap') {
      return 'menge';
    }
    if (word.startsWith('b') || word.startsWith('f')) {
      return 'mem';
    }
    if (word.startsWith('c') ||
        word.startsWith('d') ||
        word.startsWith('j') ||
        word.startsWith('z') ||
        word.startsWith('sy')) {
      return 'men';
    }
    if (word.startsWith('a') ||
        word.startsWith('e') ||
        word.startsWith('i') ||
        word.startsWith('o') ||
        word.startsWith('u') ||
        word.startsWith('g') ||
        word.startsWith('h')) {
      return 'meng';
    }
    return 'me';
  }

  Color _prefixHighlightColor(String prefix) {
    if (prefix == 'mem') {
      return _b15DarkerAccentColor;
    }
    if (prefix == 'men' || prefix == 'meny') {
      return _b16DarkerAccentColor;
    }
    if (prefix == 'meng') {
      return _b17DarkerAccentColor;
    }
    if (prefix == 'menge') {
      return _b18DarkerAccentColor;
    }
    return _b05DarkerAccentColor;
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
    final isB04 = _currentStep.id == 'B04';
    final isB25 = _currentStep.id == 'B25';
    final usesB25Palette = isB04 || isB25;
    final iconColor = usesB25Palette ? _b25MainText : null;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 6),
      child: Row(
        children: [
          IconButton(
            onPressed: _goBack,
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: iconColor),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                valueColor: AlwaysStoppedAnimation<Color>(
                  usesB25Palette ? _b05MainColor : const Color(0xFF10B981),
                ),
                backgroundColor: usesB25Palette
                    ? const Color(0xFFE5E7EB)
                    : const Color(0xFFE6EEF8),
              ),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: _speakCurrentStep,
            icon: Icon(Icons.volume_up_rounded, color: iconColor),
          ),
          IconButton(
            onPressed: _toggleVoice,
            icon: Icon(
              _voiceEnabled
                  ? Icons.hearing_rounded
                  : Icons.hearing_disabled_rounded,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _titleBubble(
    String text, {
    double fontSize = _headingFontSize,
    Color backgroundColor = const Color(0xFFD97706),
    Color textColor = Colors.white,
    Color? borderColor,
    bool showBackground = true,
    bool italicizeMeN = false,
  }) {
    return Builder(
      builder: (context) {
        final effectiveFontSize =
            responsiveClamp(context, 20, fontSize, 26) *
            _narrowWidthTextScale(context);
        final textStyle = TextStyle(
          fontSize: effectiveFontSize,
          fontWeight: textColor == _b01TitleTextColor
              ? FontWeight.w900
              : FontWeight.w800,
          color: textColor,
          fontFamily: 'Century Gothic',
          fontFamilyFallback: _fontFallback,
        );
        final titleText = italicizeMeN
            ? Text.rich(_meNItalicTextSpan(text, textStyle))
            : Text(text, style: textStyle);
        if (!showBackground) {
          return titleText;
        }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: borderColor == null
                ? null
                : Border.all(color: borderColor, width: 2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: titleText,
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

  TextAlign _subtitleTextAlign(String text) {
    final hasBulletLine = text
        .split('\n')
        .any((line) => line.trimLeft().startsWith('•'));
    return hasBulletLine ? TextAlign.start : TextAlign.justify;
  }

  bool _isBulletLine(String line) {
    final trimmed = line.trimLeft();
    return trimmed.startsWith('•') || trimmed.startsWith('â€¢');
  }

  String _stripBulletMarker(String line) {
    final trimmed = line.trimLeft();
    if (trimmed.startsWith('•')) {
      return trimmed.substring(1).trimLeft();
    }
    if (trimmed.startsWith('â€¢')) {
      return trimmed.substring(3).trimLeft();
    }
    return trimmed;
  }

  Widget _subtitleContent(
    String text,
    TextStyle style, {
    TextAlign? textAlign,
  }) {
    final lines = text.split('\n');
    final hasBullets = lines.any(_isBulletLine);
    if (!hasBullets) {
      return Text(
        text,
        textAlign: textAlign ?? _subtitleTextAlign(text),
        style: style,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final line in lines)
          if (line.trim().isEmpty)
            SizedBox(height: (style.fontSize ?? _bodyFontSize) * 0.35)
          else if (_isBulletLine(line))
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 18,
                    child: Text('•', style: style, textAlign: TextAlign.left),
                  ),
                  Expanded(
                    child: Text(
                      _stripBulletMarker(line),
                      textAlign: TextAlign.start,
                      style: style,
                    ),
                  ),
                ],
              ),
            )
          else
            Text(line, textAlign: TextAlign.start, style: style),
      ],
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

  double _scenarioSmallPhoneScale(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width < 360 ? 0.8 : 1.0;
  }

  double _narrowWidthTextScale(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 340) {
      return 0.82;
    }
    if (width < 380) {
      return 0.9;
    }
    return 1.0;
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
    final usesB01Style = _usesB01Style(step);
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
            child: _titleBubble(
              step.title,
              backgroundColor: usesB01Style
                  ? _b01TitleBoxColor
                  : const Color(0xFFD97706),
              textColor: usesB01Style ? _b01TitleTextColor : Colors.white,
              borderColor: usesB01Style ? _b01TitleBorderColor : null,
            ),
          ),
          if (step.subtitle.isNotEmpty) ...[
            SizedBox(height: usesB01Style ? 16 : 12),
            _contentCard(
              color: usesB01Style ? _b01CardColor : Colors.white,
              child: _subtitleContent(
                step.subtitle,
                TextStyle(
                  fontSize: bodySize,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                  color: usesB01Style ? _b01MainTextColor : null,
                  fontFamily: 'Century Gothic',
                  fontFamilyFallback: _fontFallback,
                ),
                textAlign: usesB01Style
                    ? TextAlign.start
                    : _subtitleTextAlign(step.subtitle),
              ),
            ),
          ],
          if (step.equationExamples.isNotEmpty) ...[
            SizedBox(height: usesB01Style ? 24 : 14),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                step.exampleSubheading,
                style: TextStyle(
                  fontSize: subheadingSize,
                  fontWeight: FontWeight.w800,
                  color: usesB01Style
                      ? _b01HeadingColor
                      : const Color(0xFF0B7285),
                  fontFamily: 'Century Gothic',
                  fontFamilyFallback: _fontFallback,
                ),
              ),
            ),
            SizedBox(height: usesB01Style ? 14 : 10),
            ...step.equationExamples.asMap().entries.map((entry) {
              final index = entry.key;
              final row = entry.value;
              final baseChipWidth = usesB01Style ? 126.0 : null;
              final resultChipWidth = usesB01Style ? 184.0 : null;
              final chipHeight = usesB01Style ? 62.0 : null;
              final chipFontSize = usesB01Style ? 23.0 : null;
              final equationRow = Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _equationChip(
                    row.left,
                    row.leftColor,
                    width: baseChipWidth,
                    height: chipHeight,
                    fontSize: chipFontSize,
                    textColor: usesB01Style
                        ? _b01EquationTextColor(row.leftColor)
                        : Colors.white,
                  ),
                  _equationSymbol(
                    '+',
                    color: usesB01Style ? _b01MainTextColor : null,
                  ),
                  _equationChip(
                    row.middle,
                    row.middleColor,
                    width: baseChipWidth,
                    height: chipHeight,
                    fontSize: chipFontSize,
                    textColor: usesB01Style
                        ? _b01EquationTextColor(row.middleColor)
                        : Colors.white,
                  ),
                  _equationSymbol(
                    '=',
                    color: usesB01Style ? _b01MainTextColor : null,
                  ),
                  _equationChip(
                    row.right,
                    row.rightColor,
                    width: resultChipWidth,
                    height: chipHeight,
                    fontSize: chipFontSize,
                    textColor: usesB01Style
                        ? _b01EquationTextColor(row.rightColor)
                        : Colors.white,
                  ),
                ],
              );
              final shouldNumberRow = _shouldNumberEquationExamples(step);
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
                  padding: EdgeInsets.only(bottom: usesB01Style ? 14 : 8),
                  child: shouldNumberRow
                      ? Row(
                          children: [
                            _exampleNumberBadge(
                              index + 1,
                              backgroundColor: usesB01Style
                                  ? _b01HeadingColor
                                  : const Color(0xFFD97706),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: FittedBox(
                                alignment: Alignment.centerLeft,
                                fit: BoxFit.scaleDown,
                                child: equationRow,
                              ),
                            ),
                          ],
                        )
                      : FittedBox(fit: BoxFit.scaleDown, child: equationRow),
                ),
              );
            }),
          ],
          if (step.colorLegends.isNotEmpty) ...[
            SizedBox(height: usesB01Style ? 18 : 10),
            _contentCard(
              color: usesB01Style ? _b01CardColor : const Color(0xFFFCFFFC),
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
                              color: usesB01Style
                                  ? _b01MainTextColor
                                  : const Color(0xFF334155),
                              fontFamily: 'Century Gothic',
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
                fontFamily: 'Century Gothic',
                fontFamilyFallback: _fontFallback,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildArrowExamplesStep(LearningStep step) {
    final isB05 = step.id == 'B05';
    final isB15 = step.id == 'B15';
    final isB16 = step.id == 'B16';
    final isB17 = step.id == 'B17';
    final isB18 = step.id == 'B18';
    final usesTitleSubtitleStyle = _usesB01TitleSubtitleStyle(step);
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
            child: isB05
                ? _b05TitleBubble(step.title)
                : isB15
                ? _b15TitleBubble(step.title)
                : isB16
                ? _b16TitleBubble(step.title)
                : isB17
                ? _b17TitleBubble(step.title)
                : isB18
                ? _b18TitleBubble(step.title)
                : _titleBubble(
                    step.title,
                    backgroundColor: usesTitleSubtitleStyle
                        ? _b01TitleBoxColor
                        : const Color(0xFFD97706),
                    textColor: usesTitleSubtitleStyle
                        ? _b01TitleTextColor
                        : Colors.white,
                    borderColor: usesTitleSubtitleStyle
                        ? _b01TitleBorderColor
                        : null,
                  ),
          ),
          if (step.subtitle.isNotEmpty) ...[
            const SizedBox(height: 12),
            _contentCard(
              color: isB05
                  ? _b05LightBackground
                  : isB15
                  ? _b15LightBackground
                  : isB16
                  ? _b16LightBackground
                  : isB17
                  ? _b17LightBackground
                  : isB18
                  ? _b18LightBackground
                  : usesTitleSubtitleStyle
                  ? _b01CardColor
                  : Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isB05)
                    _b05CleanBulletTermContent(
                      step.subtitle,
                      TextStyle(
                        fontSize: bodySize,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        color: _b05TextOnLightArea,
                        fontFamily: 'Century Gothic',
                        fontFamilyFallback: _fontFallback,
                      ),
                    )
                  else if (isB15)
                    _b15CleanBulletTermContent(
                      step.subtitle,
                      TextStyle(
                        fontSize: bodySize,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        color: _b15TextOnLightArea,
                        fontFamily: 'Century Gothic',
                        fontFamilyFallback: _fontFallback,
                      ),
                    )
                  else if (isB16)
                    _b16CleanBulletTermContent(
                      step.subtitle,
                      TextStyle(
                        fontSize: bodySize,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        color: _b16TextOnLightArea,
                        fontFamily: 'Century Gothic',
                        fontFamilyFallback: _fontFallback,
                      ),
                    )
                  else if (isB17)
                    _b17CleanBulletTermContent(
                      step.subtitle,
                      TextStyle(
                        fontSize: bodySize,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        color: _b17TextOnLightArea,
                        fontFamily: 'Century Gothic',
                        fontFamilyFallback: _fontFallback,
                      ),
                    )
                  else if (isB18)
                    _b18TermStyledContent(
                      step.subtitle,
                      TextStyle(
                        fontSize: bodySize,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        color: _b18TextOnLightArea,
                        fontFamily: 'Century Gothic',
                        fontFamilyFallback: _fontFallback,
                      ),
                    )
                  else
                    _subtitleContent(
                      step.subtitle,
                      TextStyle(
                        fontSize: bodySize,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        color: usesTitleSubtitleStyle
                            ? _b01MainTextColor
                            : null,
                        fontFamily: 'Century Gothic',
                        fontFamilyFallback: _fontFallback,
                      ),
                      textAlign: usesTitleSubtitleStyle
                          ? TextAlign.start
                          : _subtitleTextAlign(step.subtitle),
                    ),
                  if (step.highlightedLetters.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.only(left: isB17 ? 18 : 0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Text.rich(
                          _highlightedLettersSpan(context, step),
                          textAlign: (isB05 || isB15 || isB16)
                              ? TextAlign.center
                              : isB17
                              ? TextAlign.start
                              : TextAlign.justify,
                          style: TextStyle(
                            fontSize: highlightSize,
                            fontWeight: FontWeight.w700,
                            color: isB05
                                ? _b05TextOnLightArea
                                : isB15
                                ? _b15TextOnLightArea
                                : isB16
                                ? _b16TextOnLightArea
                                : isB17
                                ? _b17TextOnLightArea
                                : const Color(0xFF334155),
                            height: 1.35,
                            fontFamily: 'Century Gothic',
                            fontFamilyFallback: _fontFallback,
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (step.afterHighlightLine.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    if (isB05)
                      _b05CleanBulletTermContent(
                        step.afterHighlightLine,
                        TextStyle(
                          fontSize: bodySize,
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                          color: _b05TextOnLightArea,
                          fontFamily: 'Century Gothic',
                          fontFamilyFallback: _fontFallback,
                        ),
                      )
                    else if (isB15)
                      _b15CleanBulletTermContent(
                        step.afterHighlightLine,
                        TextStyle(
                          fontSize: bodySize,
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                          color: _b15TextOnLightArea,
                          fontFamily: 'Century Gothic',
                          fontFamilyFallback: _fontFallback,
                        ),
                      )
                    else if (isB16)
                      _b16CleanBulletTermContent(
                        step.afterHighlightLine,
                        TextStyle(
                          fontSize: bodySize,
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                          color: _b16TextOnLightArea,
                          fontFamily: 'Century Gothic',
                          fontFamilyFallback: _fontFallback,
                        ),
                      )
                    else if (isB17)
                      _b17CleanBulletTermContent(
                        step.afterHighlightLine,
                        TextStyle(
                          fontSize: bodySize,
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                          color: _b17TextOnLightArea,
                          fontFamily: 'Century Gothic',
                          fontFamilyFallback: _fontFallback,
                        ),
                      )
                    else
                      _subtitleContent(
                        step.afterHighlightLine,
                        TextStyle(
                          fontSize: bodySize,
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Century Gothic',
                          fontFamilyFallback: _fontFallback,
                        ),
                        textAlign: TextAlign.justify,
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
                color: isB15
                    ? _b15DarkerAccentColor
                    : isB16
                    ? _b16DarkerAccentColor
                    : isB17
                    ? _b17DarkerAccentColor
                    : isB18
                    ? _b18DarkerAccentColor
                    : Color(0xFF0B7285),
                fontFamily: 'Century Gothic',
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
                      final arrowRow = isB05
                          ? _buildB05AlignedArrowRow(
                              row,
                              arrowTextSize: arrowTextSize,
                              arrowSymbolSize: arrowSymbolSize,
                              letterChipFontSize: letterChipFontSize,
                            )
                          : isB15
                          ? _buildB15AlignedArrowRow(
                              row,
                              arrowTextSize: arrowTextSize,
                              arrowSymbolSize: arrowSymbolSize,
                              letterChipFontSize: letterChipFontSize,
                            )
                          : isB16
                          ? _buildB16AlignedArrowRow(
                              row,
                              arrowTextSize: arrowTextSize,
                              arrowSymbolSize: arrowSymbolSize,
                              letterChipFontSize: letterChipFontSize,
                            )
                          : isB17
                          ? _buildB17AlignedArrowRow(
                              row,
                              arrowTextSize: arrowTextSize,
                              arrowSymbolSize: arrowSymbolSize,
                              letterChipFontSize: letterChipFontSize,
                            )
                          : isB18
                          ? _buildB18AlignedArrowRow(
                              row,
                              arrowTextSize: arrowTextSize,
                              arrowSymbolSize: arrowSymbolSize,
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (showLetterChip) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 9,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _arrowLetterColor(
                                        step,
                                        row,
                                        index,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      row.letter,
                                      style: TextStyle(
                                        fontSize: letterChipFontSize,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        fontFamily: 'Century Gothic',
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
                                      color: const Color(0xFF1D3557),
                                      fontFamily: 'Century Gothic',
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
                                    color: const Color(0xFF1D3557),
                                    fontFamily: 'Century Gothic',
                                    fontFamilyFallback: _fontFallback,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '\u2192',
                                  style: TextStyle(
                                    fontSize: arrowSymbolSize,
                                    fontWeight: FontWeight.w900,
                                    color: const Color(0xFF1D3557),
                                    fontFamily: 'Century Gothic',
                                    fontFamilyFallback: _fontFallback,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                _highlightPrefixOnly(
                                  row.derivedWord,
                                  step.highlightedPrefix,
                                  prefixColor: isB15
                                      ? _b15DarkerAccentColor
                                      : isB16
                                      ? _b16DarkerAccentColor
                                      : isB17
                                      ? _b17DarkerAccentColor
                                      : isB18
                                      ? _b18DarkerAccentColor
                                      : const Color(0xFFEC4899),
                                ),
                              ],
                            );
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
                          child: arrowRow,
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
            if (isB05)
              _b05CleanBulletTermContent(
                step.footerNote,
                TextStyle(
                  fontSize: footerSize,
                  fontWeight: FontWeight.w700,
                  color: _b05TextOnLightArea,
                  height: 1.35,
                  fontFamily: 'Century Gothic',
                  fontFamilyFallback: _fontFallback,
                ),
              )
            else if (isB15)
              _b15CleanBulletTermContent(
                step.footerNote,
                TextStyle(
                  fontSize: footerSize,
                  fontWeight: FontWeight.w700,
                  color: _b15TextOnLightArea,
                  height: 1.35,
                  fontFamily: 'Century Gothic',
                  fontFamilyFallback: _fontFallback,
                ),
              )
            else if (isB16)
              _b16CleanBulletTermContent(
                step.footerNote,
                TextStyle(
                  fontSize: footerSize,
                  fontWeight: FontWeight.w700,
                  color: _b16TextOnLightArea,
                  height: 1.35,
                  fontFamily: 'Century Gothic',
                  fontFamilyFallback: _fontFallback,
                ),
              )
            else if (isB17)
              _b17CleanBulletTermContent(
                step.footerNote,
                TextStyle(
                  fontSize: footerSize,
                  fontWeight: FontWeight.w700,
                  color: _b17TextOnLightArea,
                  height: 1.35,
                  fontFamily: 'Century Gothic',
                  fontFamilyFallback: _fontFallback,
                ),
              )
            else if (isB18)
              _b18TermStyledContent(
                step.footerNote,
                TextStyle(
                  fontSize: footerSize,
                  fontWeight: FontWeight.w700,
                  color: _b18TextOnLightArea,
                  height: 1.35,
                  fontFamily: 'Century Gothic',
                  fontFamilyFallback: _fontFallback,
                ),
              )
            else
              Text(
                step.footerNote,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: footerSize,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF334155),
                  height: 1.35,
                  fontFamily: 'Century Gothic',
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

  Widget _b05TitleBubble(String text) {
    return Builder(
      builder: (context) {
        final effectiveFontSize =
            responsiveClamp(context, 20, _headingFontSize, 26) *
            _narrowWidthTextScale(context);
        final titleStyle = TextStyle(
          fontSize: effectiveFontSize,
          fontWeight: FontWeight.w800,
          color: _b05TextOnColoredBox,
          fontFamily: 'Century Gothic',
          fontFamilyFallback: _fontFallback,
        );

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: _b05MainColor,
            border: Border.all(color: _b05DarkerAccentColor, width: 2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text.rich(_b05TermTextSpan(text, titleStyle)),
        );
      },
    );
  }

  Widget _b15TitleBubble(String text) {
    return Builder(
      builder: (context) {
        final effectiveFontSize =
            responsiveClamp(context, 20, _headingFontSize, 26) *
            _narrowWidthTextScale(context);
        final titleStyle = TextStyle(
          fontSize: effectiveFontSize,
          fontWeight: FontWeight.w800,
          color: _b15TextOnColoredBox,
          fontFamily: 'Century Gothic',
          fontFamilyFallback: _fontFallback,
        );

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: _b15MainColor,
            border: Border.all(color: _b15DarkerAccentColor, width: 2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text.rich(_b15TermTextSpan(text, titleStyle)),
        );
      },
    );
  }

  Widget _b16TitleBubble(String text) {
    return Builder(
      builder: (context) {
        final effectiveFontSize =
            responsiveClamp(context, 20, _headingFontSize, 26) *
            _narrowWidthTextScale(context);
        final titleStyle = TextStyle(
          fontSize: effectiveFontSize,
          fontWeight: FontWeight.w800,
          color: _b16TextOnColoredBox,
          fontFamily: 'Century Gothic',
          fontFamilyFallback: _fontFallback,
        );

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: _b16MainColor,
            border: Border.all(color: _b16DarkerAccentColor, width: 2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text.rich(_b16TermTextSpan(text, titleStyle)),
        );
      },
    );
  }

  Widget _b17TitleBubble(String text) {
    return Builder(
      builder: (context) {
        final effectiveFontSize =
            responsiveClamp(context, 20, _headingFontSize, 26) *
            _narrowWidthTextScale(context);
        final titleStyle = TextStyle(
          fontSize: effectiveFontSize,
          fontWeight: FontWeight.w800,
          color: _b17TextOnColoredBox,
          fontFamily: 'Century Gothic',
          fontFamilyFallback: _fontFallback,
        );

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: _b17MainColor,
            border: Border.all(color: _b17DarkerAccentColor, width: 2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text.rich(_b17TermTextSpan(text, titleStyle)),
        );
      },
    );
  }

  Widget _b18TitleBubble(String text) {
    return Builder(
      builder: (context) {
        final effectiveFontSize =
            responsiveClamp(context, 20, _headingFontSize, 26) *
            _narrowWidthTextScale(context);
        final titleStyle = TextStyle(
          fontSize: effectiveFontSize,
          fontWeight: FontWeight.w800,
          color: _b18TextOnColoredBox,
          fontFamily: 'Century Gothic',
          fontFamilyFallback: _fontFallback,
        );

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: _b18MainColor,
            border: Border.all(color: _b18DarkerAccentColor, width: 2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text.rich(_b18TermTextSpan(text, titleStyle)),
        );
      },
    );
  }

  Widget b05TermStyledContent(String text, TextStyle style) {
    final lines = text.split('\n');
    final hasBullets = lines.any(_isBulletLine);
    if (!hasBullets) {
      return Text.rich(
        _b05TermTextSpan(text, style),
        textAlign: TextAlign.start,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final line in lines)
          if (line.trim().isEmpty)
            SizedBox(height: (style.fontSize ?? _bodyFontSize) * 0.35)
          else if (_isBulletLine(line))
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 18,
                    child: Text('â€¢', style: style, textAlign: TextAlign.left),
                  ),
                  Expanded(
                    child: Text.rich(
                      _b05TermTextSpan(_stripBulletMarker(line), style),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            )
          else
            Text.rich(
              _b05TermTextSpan(line, style),
              textAlign: TextAlign.start,
            ),
      ],
    );
  }

  Widget _b05CleanBulletTermContent(String text, TextStyle style) {
    final lines = text.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final line in lines)
          if (line.trim().isEmpty)
            SizedBox(height: (style.fontSize ?? _bodyFontSize) * 0.35)
          else
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isBulletLine(line)) ...[
                    SizedBox(
                      width: 18,
                      child: Text(
                        '\u2022',
                        style: style,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                  Expanded(
                    child: Text.rich(
                      _b05TermTextSpan(_stripBulletMarker(line), style),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
      ],
    );
  }

  TextSpan _b05TermTextSpan(String text, TextStyle style) {
    final spans = <InlineSpan>[];
    final matches = RegExp(r'meN-|me-').allMatches(text);
    var start = 0;
    for (final match in matches) {
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start)));
      }
      spans.add(
        TextSpan(
          text: match.group(0),
          style: style.copyWith(fontStyle: FontStyle.italic),
        ),
      );
      start = match.end;
    }
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }
    return TextSpan(style: style, children: spans);
  }

  Widget _b15CleanBulletTermContent(String text, TextStyle style) {
    final lines = text.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final line in lines)
          if (line.trim().isEmpty)
            SizedBox(height: (style.fontSize ?? _bodyFontSize) * 0.35)
          else
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isBulletLine(line)) ...[
                    SizedBox(
                      width: 18,
                      child: Text(
                        '\u2022',
                        style: style,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                  Expanded(
                    child: Text.rich(
                      _b15TermTextSpan(_stripBulletMarker(line), style),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
      ],
    );
  }

  TextSpan _b15TermTextSpan(String text, TextStyle style) {
    final spans = <InlineSpan>[];
    final matches = RegExp(r'mem-').allMatches(text);
    var start = 0;
    for (final match in matches) {
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start)));
      }
      spans.add(
        TextSpan(
          text: match.group(0),
          style: style.copyWith(fontStyle: FontStyle.italic),
        ),
      );
      start = match.end;
    }
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }
    return TextSpan(style: style, children: spans);
  }

  Widget _b16CleanBulletTermContent(String text, TextStyle style) {
    final lines = text.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final line in lines)
          if (line.trim().isEmpty)
            SizedBox(height: (style.fontSize ?? _bodyFontSize) * 0.35)
          else
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isBulletLine(line)) ...[
                    SizedBox(
                      width: 18,
                      child: Text(
                        '\u2022',
                        style: style,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                  Expanded(
                    child: Text.rich(
                      _b16TermTextSpan(_stripBulletMarker(line), style),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
      ],
    );
  }

  TextSpan _b16TermTextSpan(String text, TextStyle style) {
    final spans = <InlineSpan>[];
    final matches = RegExp(r'men-').allMatches(text);
    var start = 0;
    for (final match in matches) {
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start)));
      }
      spans.add(
        TextSpan(
          text: match.group(0),
          style: style.copyWith(fontStyle: FontStyle.italic),
        ),
      );
      start = match.end;
    }
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }
    return TextSpan(style: style, children: spans);
  }

  Widget _b17CleanBulletTermContent(String text, TextStyle style) {
    final lines = text.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final line in lines)
          if (line.trim().isEmpty)
            SizedBox(height: (style.fontSize ?? _bodyFontSize) * 0.35)
          else
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isBulletLine(line)) ...[
                    SizedBox(
                      width: 18,
                      child: Text(
                        '\u2022',
                        style: style,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                  Expanded(
                    child: Text.rich(
                      _b17TermTextSpan(_stripBulletMarker(line), style),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
      ],
    );
  }

  TextSpan _b17TermTextSpan(String text, TextStyle style) {
    final spans = <InlineSpan>[];
    final matches = RegExp(r'meng-').allMatches(text);
    var start = 0;
    for (final match in matches) {
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start)));
      }
      spans.add(
        TextSpan(
          text: match.group(0),
          style: style.copyWith(fontStyle: FontStyle.italic),
        ),
      );
      start = match.end;
    }
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }
    return TextSpan(style: style, children: spans);
  }

  Widget _b18TermStyledContent(String text, TextStyle style) {
    return Text.rich(_b18TermTextSpan(text, style), textAlign: TextAlign.start);
  }

  TextSpan _b18TermTextSpan(String text, TextStyle style) {
    final spans = <InlineSpan>[];
    final matches = RegExp(r'menge-').allMatches(text);
    var start = 0;
    for (final match in matches) {
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start)));
      }
      spans.add(
        TextSpan(
          text: match.group(0),
          style: style.copyWith(fontStyle: FontStyle.italic),
        ),
      );
      start = match.end;
    }
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }
    return TextSpan(style: style, children: spans);
  }

  Widget _buildB05AlignedArrowRow(
    LearningArrowRow row, {
    required double arrowTextSize,
    required double arrowSymbolSize,
    required double letterChipFontSize,
  }) {
    TextStyle wordStyle({Color color = _b05TextOnLightArea}) {
      return TextStyle(
        fontSize: arrowTextSize,
        fontWeight: FontWeight.w800,
        color: color,
        fontFamily: 'Century Gothic',
        fontFamilyFallback: _fontFallback,
      );
    }

    final arrowStyle = TextStyle(
      fontSize: arrowSymbolSize,
      fontWeight: FontWeight.w900,
      color: _b05DarkerAccentColor,
      fontFamily: 'Century Gothic',
      fontFamilyFallback: _fontFallback,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 42,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(minWidth: 34),
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _b05MainColor,
                border: Border.all(color: _b05DarkerAccentColor, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                row.letter,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: letterChipFontSize,
                  fontWeight: FontWeight.w900,
                  color: _b05TextOnColoredBox,
                  fontFamily: 'Century Gothic',
                  fontFamilyFallback: _fontFallback,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 34,
          child: Text('\u2192', textAlign: TextAlign.center, style: arrowStyle),
        ),
        SizedBox(
          width: 86,
          child: Text(
            row.baseWord,
            textAlign: TextAlign.center,
            style: wordStyle(),
          ),
        ),
        SizedBox(
          width: 34,
          child: Text('\u2192', textAlign: TextAlign.center, style: arrowStyle),
        ),
        SizedBox(
          width: 118,
          child: Text.rich(
            TextSpan(
              children: [
                if (row.derivedWord.startsWith('me'))
                  TextSpan(
                    text: 'me',
                    style: wordStyle(color: _b05DarkerAccentColor).copyWith(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                TextSpan(
                  text: row.derivedWord.startsWith('me')
                      ? row.derivedWord.substring(2)
                      : row.derivedWord,
                ),
              ],
            ),
            textAlign: TextAlign.center,
            style: wordStyle(),
          ),
        ),
      ],
    );
  }

  Widget _buildB15AlignedArrowRow(
    LearningArrowRow row, {
    required double arrowTextSize,
    required double arrowSymbolSize,
    required double letterChipFontSize,
  }) {
    TextStyle wordStyle({Color color = _b15TextOnLightArea}) {
      return TextStyle(
        fontSize: arrowTextSize,
        fontWeight: FontWeight.w800,
        color: color,
        fontFamily: 'Century Gothic',
        fontFamilyFallback: _fontFallback,
      );
    }

    final arrowStyle = TextStyle(
      fontSize: arrowSymbolSize,
      fontWeight: FontWeight.w900,
      color: _b15DarkerAccentColor,
      fontFamily: 'Century Gothic',
      fontFamilyFallback: _fontFallback,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 42,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(minWidth: 34),
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _b15MainColor,
                border: Border.all(color: _b15DarkerAccentColor, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                row.letter,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: letterChipFontSize,
                  fontWeight: FontWeight.w900,
                  color: _b15TextOnColoredBox,
                  fontFamily: 'Century Gothic',
                  fontFamilyFallback: _fontFallback,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 34,
          child: Text('\u2192', textAlign: TextAlign.center, style: arrowStyle),
        ),
        SizedBox(
          width: 86,
          child: Text(
            row.baseWord,
            textAlign: TextAlign.center,
            style: wordStyle(),
          ),
        ),
        SizedBox(
          width: 34,
          child: Text('\u2192', textAlign: TextAlign.center, style: arrowStyle),
        ),
        SizedBox(
          width: 118,
          child: Text.rich(
            TextSpan(
              children: [
                if (row.derivedWord.startsWith('mem'))
                  TextSpan(
                    text: 'mem',
                    style: wordStyle(
                      color: _b15DarkerAccentColor,
                    ).copyWith(fontWeight: FontWeight.w900),
                  ),
                TextSpan(
                  text: row.derivedWord.startsWith('mem')
                      ? row.derivedWord.substring(3)
                      : row.derivedWord,
                ),
              ],
            ),
            textAlign: TextAlign.center,
            style: wordStyle(),
          ),
        ),
      ],
    );
  }

  Widget _buildB16AlignedArrowRow(
    LearningArrowRow row, {
    required double arrowTextSize,
    required double arrowSymbolSize,
    required double letterChipFontSize,
  }) {
    TextStyle wordStyle({Color color = _b16TextOnLightArea}) {
      return TextStyle(
        fontSize: arrowTextSize,
        fontWeight: FontWeight.w800,
        color: color,
        fontFamily: 'Century Gothic',
        fontFamilyFallback: _fontFallback,
      );
    }

    final arrowStyle = TextStyle(
      fontSize: arrowSymbolSize,
      fontWeight: FontWeight.w900,
      color: _b16DarkerAccentColor,
      fontFamily: 'Century Gothic',
      fontFamilyFallback: _fontFallback,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 42,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(minWidth: 34),
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _b16MainColor,
                border: Border.all(color: _b16DarkerAccentColor, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                row.letter,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: letterChipFontSize,
                  fontWeight: FontWeight.w900,
                  color: _b16TextOnColoredBox,
                  fontFamily: 'Century Gothic',
                  fontFamilyFallback: _fontFallback,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 34,
          child: Text('\u2192', textAlign: TextAlign.center, style: arrowStyle),
        ),
        SizedBox(
          width: 86,
          child: Text(
            row.baseWord,
            textAlign: TextAlign.center,
            style: wordStyle(),
          ),
        ),
        SizedBox(
          width: 34,
          child: Text('\u2192', textAlign: TextAlign.center, style: arrowStyle),
        ),
        SizedBox(
          width: 118,
          child: Text.rich(
            TextSpan(
              children: [
                if (row.derivedWord.startsWith('men'))
                  TextSpan(
                    text: 'men',
                    style: wordStyle(
                      color: _b16DarkerAccentColor,
                    ).copyWith(fontWeight: FontWeight.w900),
                  ),
                TextSpan(
                  text: row.derivedWord.startsWith('men')
                      ? row.derivedWord.substring(3)
                      : row.derivedWord,
                ),
              ],
            ),
            textAlign: TextAlign.center,
            style: wordStyle(),
          ),
        ),
      ],
    );
  }

  Widget _buildB17AlignedArrowRow(
    LearningArrowRow row, {
    required double arrowTextSize,
    required double arrowSymbolSize,
    required double letterChipFontSize,
  }) {
    TextStyle wordStyle({Color color = _b17TextOnLightArea}) {
      return TextStyle(
        fontSize: arrowTextSize,
        fontWeight: FontWeight.w800,
        color: color,
        fontFamily: 'Century Gothic',
        fontFamilyFallback: _fontFallback,
      );
    }

    final arrowStyle = TextStyle(
      fontSize: arrowSymbolSize,
      fontWeight: FontWeight.w900,
      color: _b17DarkerAccentColor,
      fontFamily: 'Century Gothic',
      fontFamilyFallback: _fontFallback,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 42,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(minWidth: 34),
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _b17MainColor,
                border: Border.all(color: _b17DarkerAccentColor, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                row.letter,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: letterChipFontSize,
                  fontWeight: FontWeight.w900,
                  color: _b17TextOnColoredBox,
                  fontFamily: 'Century Gothic',
                  fontFamilyFallback: _fontFallback,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 34,
          child: Text('\u2192', textAlign: TextAlign.center, style: arrowStyle),
        ),
        SizedBox(
          width: 86,
          child: Text(
            row.baseWord,
            textAlign: TextAlign.center,
            style: wordStyle(),
          ),
        ),
        SizedBox(
          width: 34,
          child: Text('\u2192', textAlign: TextAlign.center, style: arrowStyle),
        ),
        SizedBox(
          width: 132,
          child: Text.rich(
            TextSpan(
              children: [
                if (row.derivedWord.startsWith('meng'))
                  TextSpan(
                    text: 'meng',
                    style: wordStyle(
                      color: _b17DarkerAccentColor,
                    ).copyWith(fontWeight: FontWeight.w900),
                  ),
                TextSpan(
                  text: row.derivedWord.startsWith('meng')
                      ? row.derivedWord.substring(4)
                      : row.derivedWord,
                ),
              ],
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.visible,
            style: wordStyle(),
          ),
        ),
      ],
    );
  }

  Widget _buildB18AlignedArrowRow(
    LearningArrowRow row, {
    required double arrowTextSize,
    required double arrowSymbolSize,
  }) {
    TextStyle wordStyle({Color color = _b18TextOnLightArea}) {
      return TextStyle(
        fontSize: arrowTextSize,
        fontWeight: FontWeight.w800,
        color: color,
        fontFamily: 'Century Gothic',
        fontFamilyFallback: _fontFallback,
      );
    }

    final arrowStyle = TextStyle(
      fontSize: arrowSymbolSize,
      fontWeight: FontWeight.w900,
      color: _b18DarkerAccentColor,
      fontFamily: 'Century Gothic',
      fontFamilyFallback: _fontFallback,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 86,
          child: Text(
            row.baseWord,
            textAlign: TextAlign.center,
            style: wordStyle(),
          ),
        ),
        SizedBox(
          width: 34,
          child: Text('\u2192', textAlign: TextAlign.center, style: arrowStyle),
        ),
        SizedBox(
          width: 118,
          child: Text.rich(
            TextSpan(
              children: [
                if (row.derivedWord.startsWith('menge'))
                  TextSpan(
                    text: 'menge',
                    style: wordStyle(
                      color: _b18DarkerAccentColor,
                    ).copyWith(fontWeight: FontWeight.w900),
                  ),
                TextSpan(
                  text: row.derivedWord.startsWith('menge')
                      ? row.derivedWord.substring(5)
                      : row.derivedWord,
                ),
              ],
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.visible,
            style: wordStyle(),
          ),
        ),
      ],
    );
  }

  TextSpan _highlightedLettersSpan(BuildContext context, LearningStep step) {
    if (step.id == 'B05') {
      return _commaSeparatedHighlightedLetters(
        context,
        step.highlightedLetters,
        color: _b05DarkerAccentColor,
      );
    }
    if (step.id == 'B15') {
      return _commaSeparatedHighlightedLetters(
        context,
        step.highlightedLetters,
        color: _b15DarkerAccentColor,
      );
    }
    if (step.id == 'B16') {
      return _commaSeparatedHighlightedLetters(
        context,
        step.highlightedLetters,
        color: _b16DarkerAccentColor,
      );
    }
    if (step.id == 'B17' && step.highlightedLetters.length >= 7) {
      final letters = step.highlightedLetters;
      return TextSpan(
        children: [
          const TextSpan(text: 'huruf vokal ('),
          _coloredLetterSpan(
            context,
            letters[0],
            0,
            color: _b17DarkerAccentColor,
          ),
          const TextSpan(text: ', '),
          _coloredLetterSpan(
            context,
            letters[1],
            1,
            color: _b17DarkerAccentColor,
          ),
          const TextSpan(text: ', '),
          _coloredLetterSpan(
            context,
            letters[2],
            2,
            color: _b17DarkerAccentColor,
          ),
          const TextSpan(text: ', '),
          _coloredLetterSpan(
            context,
            letters[3],
            3,
            color: _b17DarkerAccentColor,
          ),
          const TextSpan(text: ', '),
          _coloredLetterSpan(
            context,
            letters[4],
            4,
            color: _b17DarkerAccentColor,
          ),
          const TextSpan(text: ') dan huruf konsonan ('),
          _coloredLetterSpan(
            context,
            letters[5],
            5,
            color: _b17DarkerAccentColor,
          ),
          const TextSpan(text: ','),
          _coloredLetterSpan(
            context,
            letters[6],
            6,
            color: _b17DarkerAccentColor,
          ),
          const TextSpan(text: ')'),
        ],
      );
    }
    return _commaSeparatedHighlightedLetters(context, step.highlightedLetters);
  }

  TextSpan _commaSeparatedHighlightedLetters(
    BuildContext context,
    List<String> letters, {
    Color? color,
  }) {
    final children = <InlineSpan>[];
    for (var i = 0; i < letters.length; i++) {
      children.add(_coloredLetterSpan(context, letters[i], i, color: color));
      if (i < letters.length - 1) {
        children.add(const TextSpan(text: ', '));
      } else {
        children.add(const TextSpan(text: '.'));
      }
    }
    return TextSpan(children: children);
  }

  TextSpan _coloredLetterSpan(
    BuildContext context,
    String text,
    int index, {
    Color? color,
  }) {
    return TextSpan(
      text: text,
      style: TextStyle(
        color: color ?? _highlightColorForIndex(index),
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
          fontFamily: 'Century Gothic',
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
        fontFamily: 'Century Gothic',
        fontFamilyFallback: _fontFallback,
      ),
    );
  }

  Widget _equationChip(
    String text,
    Color color, {
    double? width,
    double? height,
    double? fontSize,
    Color textColor = Colors.white,
  }) {
    final effectiveFontSize = fontSize == null
        ? _responsiveLabelFontSize(context, 18, min: 14, max: 18)
        : _responsiveLabelFontSize(context, fontSize, min: 16, max: fontSize);
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: effectiveFontSize,
          fontWeight: FontWeight.w800,
          fontFamily: 'Century Gothic',
          fontFamilyFallback: _fontFallback,
        ),
      ),
    );
  }

  Color _b01EquationTextColor(Color backgroundColor) {
    if (backgroundColor == _b01ImbuhanColor) {
      return _b01ImbuhanTextColor;
    }
    if (backgroundColor == _b01KataDasarColor) {
      return _b01KataDasarTextColor;
    }
    return _b01KataTerbitanTextColor;
  }

  bool _shouldNumberEquationExamples(LearningStep step) {
    return const {'B01', 'B02', 'B03'}.contains(step.id);
  }

  bool _usesB01Style(LearningStep step) {
    return const {'B01', 'B02', 'B03'}.contains(step.id);
  }

  bool _usesB01TitleSubtitleStyle(LearningStep step) {
    return const {'B01', 'B02', 'B03', 'B04', 'B05', 'B06'}.contains(step.id);
  }

  Widget _exampleNumberBadge(
    int number, {
    Color backgroundColor = const Color(0xFFD97706),
  }) {
    final fontSize = _responsiveLabelFontSize(context, 14, min: 12, max: 14);
    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        '$number',
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          fontFamily: 'Century Gothic',
          fontFamilyFallback: _fontFallback,
        ),
      ),
    );
  }

  Widget _equationSymbol(String symbol, {Color? color}) {
    final fontSize = _responsiveLabelFontSize(context, 23, min: 17, max: 23);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        symbol,
        style: TextStyle(
          color: color ?? const Color(0xFF1D3557),
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          fontFamily: 'Century Gothic',
          fontFamilyFallback: _fontFallback,
        ),
      ),
    );
  }

  Widget _buildLearningContinueButton({
    Key? key,
    required String label,
    required VoidCallback onPressed,
    IconData icon = Icons.arrow_forward_rounded,
  }) {
    return AnimatedKidButton(
      key: key,
      label: label,
      icon: icon,
      onPressed: onPressed,
      backgroundColor: _b01ButtonColor,
      foregroundColor: _b01WhiteColor,
      height: 54,
      labelFontSize: _responsiveButtonFontSize(context),
    );
  }

  Widget _buildPulsingLearningContinueButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final reduceMotion = AppMotionSpec.reduceMotion(context);
        final angle = reduceMotion
            ? 0.0
            : math.sin(_pulseController.value * math.pi) * 0.02;
        return Transform.rotate(angle: angle, child: child);
      },
      child: _buildLearningContinueButton(label: label, onPressed: onPressed),
    );
  }

  Widget _buildTableStep(LearningStep step) {
    final isB04 = step.id == 'B04';
    final usesTitleSubtitleStyle = _usesB01TitleSubtitleStyle(step);
    final scale = _scenarioSmallPhoneScale(context);
    final bodySize = _responsiveBodyFontSize(context, step) * scale;
    final subheadingSize =
        _responsiveLabelFontSize(context, _bodyFontSize + 2, min: 17, max: 22) *
        scale;
    return _scrollableStepContent(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleBubble(
            step.title,
            backgroundColor: isB04
                ? _b25HeadingStart
                : usesTitleSubtitleStyle
                ? _b01TitleBoxColor
                : const Color(0xFFD97706),
            textColor: isB04
                ? Colors.white
                : usesTitleSubtitleStyle
                ? _b01TitleTextColor
                : Colors.white,
            borderColor: isB04
                ? _b25Border
                : usesTitleSubtitleStyle
                ? _b01TitleBorderColor
                : null,
            italicizeMeN: isB04,
          ),
          const SizedBox(height: 12),
          if (step.subtitle.isNotEmpty)
            _contentCard(
              color: usesTitleSubtitleStyle ? _b01CardColor : Colors.white,
              child: isB04
                  ? _buildB04Subtitle(
                      step.subtitle,
                      TextStyle(
                        fontSize: bodySize,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        color: _b25MainText,
                        fontFamily: 'Century Gothic',
                        fontFamilyFallback: _fontFallback,
                      ),
                    )
                  : _subtitleContent(
                      step.subtitle,
                      TextStyle(
                        fontSize: bodySize,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        color: usesTitleSubtitleStyle
                            ? _b01MainTextColor
                            : null,
                        fontFamily: 'Century Gothic',
                        fontFamilyFallback: _fontFallback,
                      ),
                      textAlign: usesTitleSubtitleStyle
                          ? TextAlign.start
                          : _subtitleTextAlign(step.subtitle),
                    ),
            ),
          if (!isB04 && step.exampleSubheading.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              step.exampleSubheading,
              style: TextStyle(
                fontSize: subheadingSize,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0B7285),
                fontFamily: 'Century Gothic',
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
                fontFamily: 'Century Gothic',
                fontFamilyFallback: _fontFallback,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildB04Subtitle(String text, TextStyle style) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final line in text.split('\n'))
          if (_isBulletLine(line))
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 18, child: Text('\u2022', style: style)),
                  Expanded(
                    child: Text.rich(
                      _meNItalicTextSpan(_stripBulletMarker(line), style),
                    ),
                  ),
                ],
              ),
            )
          else
            Text.rich(_meNItalicTextSpan(line, style)),
      ],
    );
  }

  Color _darkenColor(Color color, [double amount = 0.42]) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness * (1 - amount)).clamp(0.0, 1.0))
        .withSaturation((hsl.saturation * 1.12).clamp(0.0, 1.0))
        .toColor();
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
    final isB04 = step.id == 'B04';
    final columnWidths = _tableColumnWidths(step.tableHeaders.length);
    final tableFontSize = isB04
        ? _responsiveLabelFontSize(context, 22, min: 16, max: 22)
        : _responsiveBodyFontSize(context, step) *
              _scenarioSmallPhoneScale(context);
    if (isB04) {
      return _b04TableCard(step, tableFontSize);
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isB04 ? 24 : 16),
        border: Border.all(color: isB04 ? _b04WhiteColor : Colors.black),
        boxShadow: isB04
            ? const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 14,
                  offset: Offset(0, 6),
                ),
              ]
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: double.infinity,
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          defaultColumnWidth: const FlexColumnWidth(),
          columnWidths: columnWidths,
          border: TableBorder(
            horizontalInside: BorderSide(
              color: isB04 ? _b04WhiteColor : Colors.black,
              width: isB04 ? 2 : 1,
            ),
            verticalInside: BorderSide(
              color: isB04 ? _b04WhiteColor : Colors.black,
              width: isB04 ? 2 : 1,
            ),
          ),
          children: [
            TableRow(
              decoration: const BoxDecoration(color: _b04TableHeaderColor),
              children: step.tableHeaders
                  .map(
                    (header) => _tableCell(
                      header,
                      backgroundColor: isB04
                          ? _b04TableHeaderColor
                          : const Color(0xFF0B7285),
                      textColor: Colors.white,
                      fontSize: tableFontSize,
                      fontWeight: FontWeight.w900,
                      verticalPadding: isB04 ? 22 : 12,
                    ),
                  )
                  .toList(),
            ),
            ...step.tableRows.asMap().entries.map((rowEntry) {
              final rowIndex = rowEntry.key;
              final row = rowEntry.value;
              return TableRow(
                children: row.cells.asMap().entries.map((cellEntry) {
                  final cellIndex = cellEntry.key;
                  final cell = cellEntry.value;
                  final palette = _b04TablePalette(rowIndex);
                  final backgroundColor = isB04
                      ? (cellIndex == 0
                            ? palette.leftColor
                            : palette.rightBackgroundColor)
                      : Colors.white;
                  final textColor = isB04
                      ? (cellIndex == 0 ? Colors.white : palette.rightTextColor)
                      : _darkenColor(
                          row.backgroundColor ?? const Color(0xFF1D3557),
                        );
                  return _tableCell(
                    cell,
                    backgroundColor: backgroundColor,
                    textColor: textColor,
                    fontSize: tableFontSize,
                    fontWeight: isB04 ? FontWeight.w900 : FontWeight.w600,
                    verticalPadding: isB04 ? (rowIndex == 0 ? 28 : 25) : 12,
                    textAlign: cellIndex == 0
                        ? TextAlign.center
                        : TextAlign.start,
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _b04TableCard(LearningStep step, double tableFontSize) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _b25Border,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _b25Border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _b04TableRow(
            rowIndex: -1,
            leftText: step.tableHeaders[0],
            rightText: step.tableHeaders[1],
            leftBackgroundColor: _b04TableHeaderColor,
            rightBackgroundColor: _b04TableHeaderColor,
            leftTextColor: _b04WhiteColor,
            rightTextColor: _b04WhiteColor,
            fontSize: tableFontSize,
            fontWeight: FontWeight.w900,
            verticalPadding: 22,
          ),
          ...step.tableRows.asMap().entries.map((entry) {
            final palette = _b04TablePalette(entry.key);
            final cells = entry.value.cells;
            return _b04TableRow(
              rowIndex: entry.key,
              leftText: cells[0],
              rightText: cells[1],
              leftBackgroundColor: palette.leftColor,
              rightBackgroundColor: palette.rightBackgroundColor,
              leftTextColor: palette.leftTextColor,
              rightTextColor: palette.rightTextColor,
              fontSize: tableFontSize,
              fontWeight: FontWeight.w900,
              verticalPadding: entry.key == 0 ? 28 : 25,
            );
          }),
        ],
      ),
    );
  }

  Widget _b04TableRow({
    required int rowIndex,
    required String leftText,
    required String rightText,
    required Color leftBackgroundColor,
    required Color rightBackgroundColor,
    required Color leftTextColor,
    required Color rightTextColor,
    required double fontSize,
    required FontWeight fontWeight,
    required double verticalPadding,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 11,
            child: _filledTableCell(
              leftText,
              backgroundColor: leftBackgroundColor,
              textColor: leftTextColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
              verticalPadding: verticalPadding,
              textAlign: TextAlign.center,
              child: _singleLineTableText(
                leftText,
                color: leftTextColor,
                fontSize: fontSize,
                fontWeight: fontWeight,
                textAlign: TextAlign.center,
                italicizeMeN: rowIndex == -1,
              ),
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            flex: 21,
            child: _filledTableCell(
              rightText,
              backgroundColor: rightBackgroundColor,
              textColor: rightTextColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
              verticalPadding: verticalPadding,
              textAlign: TextAlign.start,
              child: rowIndex == -1
                  ? _singleLineTableText(
                      rightText,
                      color: rightTextColor,
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                      textAlign: TextAlign.start,
                      italicizeMeN: true,
                    )
                  : _b04RightCellContent(
                      rightText,
                      rowIndex: rowIndex,
                      textColor: rightTextColor,
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filledTableCell(
    String text, {
    required Color backgroundColor,
    required Color textColor,
    required double fontSize,
    required FontWeight fontWeight,
    required double verticalPadding,
    required TextAlign textAlign,
    Widget? child,
  }) {
    return Container(
      alignment: textAlign == TextAlign.center
          ? Alignment.center
          : Alignment.centerLeft,
      color: backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: verticalPadding),
      child:
          child ??
          Text(
            text,
            textAlign: textAlign,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
              height: 1.32,
              fontFamily: 'Century Gothic',
              fontFamilyFallback: _fontFallback,
            ),
          ),
    );
  }

  Widget _singleLineTableText(
    String text, {
    required Color color,
    required double fontSize,
    required FontWeight fontWeight,
    required TextAlign textAlign,
    bool italicizeMeN = false,
  }) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: textAlign == TextAlign.center
          ? Alignment.center
          : Alignment.centerLeft,
      child: Text.rich(
        italicizeMeN
            ? _meNItalicTextSpan(
                text,
                TextStyle(
                  color: color,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                  height: 1.32,
                  fontFamily: 'Century Gothic',
                  fontFamilyFallback: _fontFallback,
                ),
              )
            : TextSpan(
                text: text,
                style: TextStyle(
                  color: color,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                  height: 1.32,
                  fontFamily: 'Century Gothic',
                  fontFamilyFallback: _fontFallback,
                ),
              ),
        maxLines: 1,
        softWrap: false,
        textAlign: textAlign,
      ),
    );
  }

  Widget _b04RightCellContent(
    String text, {
    required int rowIndex,
    required Color textColor,
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    final baseStyle = TextStyle(
      color: textColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: 1.32,
      fontFamily: 'Century Gothic',
      fontFamilyFallback: _fontFallback,
    );
    final blackStyle = TextStyle(
      color: _b25SecondaryText,
      fontSize: fontSize,
      fontWeight: FontWeight.w900,
      fontFamily: 'Century Gothic',
      fontFamilyFallback: _fontFallback,
      height: 1.32,
    );

    if (rowIndex == 0) {
      final lines = text.split('\n');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (lines.isNotEmpty) Text(lines.first, style: baseStyle),
          _b04MeRuleTable(lines.skip(1), baseStyle, blackStyle),
        ],
      );
    }

    if (rowIndex == 3) {
      return RichText(
        text: TextSpan(
          style: baseStyle,
          children: [
            const TextSpan(text: 'a, e, i, o, u '),
            TextSpan(text: '(vokal)', style: blackStyle),
            const TextSpan(text: ',\ng, h (konsonan)'),
          ],
        ),
      );
    }

    return Text(text, style: baseStyle);
  }

  Widget _b04MeRuleTable(
    Iterable<String> lines,
    TextStyle baseStyle,
    TextStyle blackStyle,
  ) {
    final pattern = RegExp(r'^(\S+)\s+\(?menjadi\s+([^)]+)\)?$');
    final menjadiPainter = TextPainter(
      text: TextSpan(text: 'menjadi', style: blackStyle),
      maxLines: 1,
      textDirection: Directionality.of(context),
    )..layout();
    final menjadiWidth =
        menjadiPainter.width + responsiveClamp(context, 4, 6, 8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        final match = pattern.firstMatch(line.trim());
        if (match == null) {
          return Text(line, style: baseStyle);
        }

        return FittedBox(
          alignment: Alignment.centerLeft,
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 24,
                child: Text(
                  match.group(1)!,
                  style: baseStyle,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
              SizedBox(
                width: menjadiWidth,
                child: Text(
                  'menjadi',
                  style: blackStyle,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
              Text(
                match.group(2)!,
                style: baseStyle,
                maxLines: 1,
                softWrap: false,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  ({
    Color leftColor,
    Color leftTextColor,
    Color rightBackgroundColor,
    Color rightTextColor,
  })
  _b04TablePalette(int rowIndex) {
    const palettes = [
      (
        leftColor: _b05MainColor,
        leftTextColor: _b05TextOnColoredBox,
        rightBackgroundColor: _b05LightBackground,
        rightTextColor: _b25MainText,
      ),
      (
        leftColor: _b15MainColor,
        leftTextColor: _b15TextOnColoredBox,
        rightBackgroundColor: _b15LightBackground,
        rightTextColor: _b25MainText,
      ),
      (
        leftColor: _b16MainColor,
        leftTextColor: Colors.white,
        rightBackgroundColor: _b16LightBackground,
        rightTextColor: _b25MainText,
      ),
      (
        leftColor: _b17MainColor,
        leftTextColor: _b17TextOnColoredBox,
        rightBackgroundColor: _b17LightBackground,
        rightTextColor: _b25MainText,
      ),
      (
        leftColor: _b18MainColor,
        leftTextColor: _b18TextOnColoredBox,
        rightBackgroundColor: _b18LightBackground,
        rightTextColor: _b25MainText,
      ),
    ];
    return palettes[rowIndex % palettes.length];
  }

  Widget _tableCell(
    String text, {
    required Color backgroundColor,
    required Color textColor,
    required double fontSize,
    required FontWeight fontWeight,
    required double verticalPadding,
    TextAlign textAlign = TextAlign.center,
  }) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.fill,
      child: Container(
        alignment: textAlign == TextAlign.center
            ? Alignment.center
            : Alignment.centerLeft,
        color: backgroundColor,
        padding: EdgeInsets.symmetric(
          horizontal: 18,
          vertical: verticalPadding,
        ),
        child: Text(
          text,
          textAlign: textAlign,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
            height: 1.32,
            fontFamily: 'Century Gothic',
            fontFamilyFallback: _fontFallback,
          ),
        ),
      ),
    );
  }

  Widget _buildChangeCardsStep(LearningStep step) {
    final isB06 = step.id == 'B06';
    final usesTitleSubtitleStyle = _usesB01TitleSubtitleStyle(step);
    final bodySize = _responsiveBodyFontSize(context, step);
    final letterSize = _responsiveLabelFontSize(context, 24, min: 18, max: 24);
    return _scrollableStepContent(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isB06)
            _b06TitleBubble(step.title)
          else
            _titleBubble(
              step.title,
              backgroundColor: usesTitleSubtitleStyle
                  ? _b01TitleBoxColor
                  : const Color(0xFFD97706),
              textColor: usesTitleSubtitleStyle
                  ? _b01TitleTextColor
                  : Colors.white,
              borderColor: usesTitleSubtitleStyle ? _b01TitleBorderColor : null,
            ),
          if (step.subtitle.isNotEmpty) ...[
            const SizedBox(height: 12),
            _contentCard(
              color: usesTitleSubtitleStyle
                  ? _b01CardColor
                  : const Color(0xFFFFF5E0),
              child: isB06
                  ? _b06TermStyledText(
                      step.subtitle,
                      TextStyle(
                        fontSize: bodySize,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        color: _b01MainTextColor,
                        fontFamily: 'Century Gothic',
                        fontFamilyFallback: _fontFallback,
                      ),
                    )
                  : _subtitleContent(
                      step.subtitle,
                      TextStyle(
                        fontSize: bodySize,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        color: usesTitleSubtitleStyle
                            ? _b01MainTextColor
                            : null,
                        fontFamily: 'Century Gothic',
                        fontFamilyFallback: _fontFallback,
                      ),
                      textAlign: usesTitleSubtitleStyle
                          ? TextAlign.start
                          : _subtitleTextAlign(step.subtitle),
                    ),
            ),
          ],
          const SizedBox(height: 12),
          ...step.changeCards.asMap().entries.map((entry) {
            final index = entry.key;
            final card = entry.value;
            final accentColor = card.accentColor;
            final exampleText = card.example;
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
                          Text.rich(
                            _highlightBracketedText(
                              exampleText,
                              accentColor: accentColor,
                            ),
                            style: TextStyle(
                              fontSize: bodySize,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                              fontFamily: 'Century Gothic',
                              fontFamilyFallback: _fontFallback,
                            ),
                          ),
                          Text.rich(
                            _highlightBracketedText(
                              card.note,
                              accentColor: accentColor,
                            ),
                            style: TextStyle(
                              fontSize: bodySize,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                              fontFamily: 'Century Gothic',
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
                fontFamily: 'Century Gothic',
                fontFamilyFallback: _fontFallback,
              ),
            ),
        ],
      ),
    );
  }

  Widget _b06TitleBubble(String text) {
    return Builder(
      builder: (context) {
        final effectiveFontSize =
            responsiveClamp(context, 20, _headingFontSize, 26) *
            _narrowWidthTextScale(context);
        final titleStyle = TextStyle(
          fontSize: effectiveFontSize,
          fontWeight: FontWeight.w900,
          color: _b01TitleTextColor,
          fontFamily: 'Century Gothic',
          fontFamilyFallback: _fontFallback,
        );

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: _b01TitleBoxColor,
            border: Border.all(color: _b01TitleBorderColor, width: 2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text.rich(_b06TermTextSpan(text, titleStyle)),
        );
      },
    );
  }

  Widget _b06TermStyledText(String text, TextStyle style) {
    return Text.rich(_b06TermTextSpan(text, style), textAlign: TextAlign.start);
  }

  TextSpan _b06TermTextSpan(String text, TextStyle style) {
    final spans = <InlineSpan>[];
    final matches = RegExp(r'meN-').allMatches(text);
    var start = 0;
    for (final match in matches) {
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start)));
      }
      spans.add(
        TextSpan(
          text: match.group(0),
          style: style.copyWith(fontStyle: FontStyle.italic),
        ),
      );
      start = match.end;
    }
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }
    return TextSpan(style: style, children: spans);
  }

  TextSpan _highlightBracketedText(String text, {required Color accentColor}) {
    final spans = <TextSpan>[];
    final pattern = RegExp(r'\[([^\]]+)\]');
    var currentIndex = 0;

    for (final match in pattern.allMatches(text)) {
      if (match.start > currentIndex) {
        spans.add(TextSpan(text: text.substring(currentIndex, match.start)));
      }
      spans.add(
        TextSpan(
          text: match.group(1),
          style: TextStyle(color: accentColor, fontWeight: FontWeight.w900),
        ),
      );
      currentIndex = match.end;
    }

    if (currentIndex < text.length) {
      spans.add(TextSpan(text: text.substring(currentIndex)));
    }

    return TextSpan(children: spans);
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
                    Text.rich(
                      _meNItalicTextSpan(
                        step.title,
                        TextStyle(
                          fontSize: headingSize,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1D3557),
                          fontFamily: 'Century Gothic',
                          fontFamilyFallback: _fontFallback,
                        ),
                      ),
                      textAlign: TextAlign.center,
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

  TextSpan _meNItalicTextSpan(String text, TextStyle style) {
    final matches = RegExp(r'meN-').allMatches(text);
    if (matches.isEmpty) {
      return TextSpan(text: text, style: style);
    }

    final spans = <InlineSpan>[];
    var start = 0;
    for (final match in matches) {
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start)));
      }
      spans.add(
        TextSpan(
          text: match.group(0),
          style: style.copyWith(fontStyle: FontStyle.italic),
        ),
      );
      start = match.end;
    }
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }
    return TextSpan(style: style, children: spans);
  }

  Widget _buildSituationStep(LearningStep step) {
    final paragraphAlign = _useLeftAlignedParagraphs(step)
        ? TextAlign.left
        : TextAlign.justify;
    final separateTapStarInstruction = const {
      'B20',
      'B21',
      'B22',
      'B23',
      'B24',
    }.contains(step.id);
    return LayoutBuilder(
      builder: (context, constraints) {
        final shortScreen = constraints.maxHeight < 560;
        final scale = _scenarioSmallPhoneScale(context);
        final headingSize =
            responsiveClamp(
              context,
              17,
              _stepHeadingFontSize(step) - (shortScreen ? 2 : 0),
              _stepHeadingFontSize(step),
            ) *
            scale;
        final bodySize =
            responsiveClamp(
              context,
              14,
              _stepBodyFontSize(step) - (shortScreen ? 2 : 0),
              _stepBodyFontSize(step),
            ) *
            scale;
        final instructionPadding = responsiveClamp(
          context,
          8,
          shortScreen ? 10 : 12,
          12,
        );
        final instructionMaxHeight =
            constraints.maxHeight * (shortScreen ? 0.32 : 0.40);
        final instructionTextStyle = TextStyle(
          fontSize: bodySize,
          height: 1.4,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF334155),
          fontFamily: 'Century Gothic',
          fontFamilyFallback: _fontFallback,
        );
        final instructionLines = step.instructionBody.split('\n');
        final tapIndex = instructionLines.isEmpty
            ? -1
            : instructionLines.first.indexOf('Tekan');
        final displayInstructionBody =
            separateTapStarInstruction && tapIndex >= 0
            ? [
                instructionLines.first.substring(0, tapIndex).trimRight(),
                instructionLines.first.substring(tapIndex),
                ...instructionLines.skip(1),
              ].join('\n')
            : step.instructionBody;

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
                              fontFamily: 'Century Gothic',
                              fontFamilyFallback: _fontFallback,
                            ),
                          ),
                        if (step.instructionBody.isNotEmpty) ...[
                          SizedBox(height: shortScreen ? 6 : 8),
                          Text.rich(
                            _meNItalicTextSpan(
                              displayInstructionBody,
                              instructionTextStyle,
                            ),
                            textAlign: paragraphAlign,
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
              if (isB25)
                _buildB25HeadingBox(
                  title: step.title,
                  subtitle: step.subtitle,
                  headingSize: headingSize,
                  bodySize: bodySize,
                )
              else
                _titleBubble(step.title, fontSize: headingSize),
              if (!isB25 && step.subtitle.isNotEmpty) ...[
                const SizedBox(height: 10),
                _contentCard(
                  child: Text(
                    step.subtitle,
                    textAlign: _subtitleTextAlign(step.subtitle),
                    style: TextStyle(
                      fontSize: bodySize,
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                      color: Color(0xFF334155),
                      fontFamily: 'Century Gothic',
                      fontFamilyFallback: _fontFallback,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
              if (isB25) const SizedBox(height: 10),
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

  Widget _buildB25HeadingBox({
    required String title,
    required String subtitle,
    required double headingSize,
    required double bodySize,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_b25HeadingStart, _b25HeadingEnd],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _b25Border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: headingSize,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    fontFamily: 'Century Gothic',
                    fontFamilyFallback: _fontFallback,
                  ),
                ),
              ),
              const Icon(Icons.star_rounded, color: _b25HeadingAccent),
            ],
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 8),
            for (final line in subtitle.split('\n'))
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\u2022',
                      style: TextStyle(
                        fontSize: bodySize,
                        height: 1.35,
                        fontWeight: FontWeight.w700,
                        color: _b25HeadingSubtitle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text.rich(
                        _meNItalicTextSpan(
                          line.replaceFirst('\u2022', '').trim(),
                          TextStyle(
                            fontSize: bodySize,
                            height: 1.35,
                            fontWeight: FontWeight.w700,
                            color: _b25HeadingSubtitle,
                            fontFamily: 'Century Gothic',
                            fontFamilyFallback: _fontFallback,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildB25ContinueButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return AnimatedKidButton(
      label: label,
      icon: Icons.home_rounded,
      onPressed: onPressed,
      backgroundColor: _b25Button,
      hoverBackgroundColor: _b25ButtonPressed,
      pressedBackgroundColor: _b25ButtonPressed,
      shadowColor: _b25ButtonShadow,
      foregroundColor: Colors.white,
      height: 54,
      labelFontSize: _responsiveButtonFontSize(context),
    );
  }

  Widget _summaryCard(
    LearningSummaryCard card, {
    required double headingSize,
    required double bodySize,
    required bool useDarkerBackground,
  }) {
    final b25Palette = useDarkerBackground
        ? _b25SummaryCardPalette(card.prefix)
        : null;
    final accentColor =
        b25Palette?.darkAccent ?? _summaryCardAccentColor(card.prefix);
    final boxColor =
        b25Palette?.background ??
        Color.alphaBlend(accentColor.withValues(alpha: 0.14), Colors.white);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: b25Palette?.accent ?? accentColor.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (b25Palette != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: b25Palette.main,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: b25Palette.darkAccent),
              ),
              child: Text(
                card.prefix,
                style: TextStyle(
                  fontSize: headingSize,
                  fontWeight: FontWeight.w900,
                  color: b25Palette.textOnMain,
                  fontFamily: 'Century Gothic',
                  fontFamilyFallback: _fontFallback,
                ),
              ),
            )
          else
            Text(
              card.prefix,
              style: TextStyle(
                fontSize: headingSize,
                fontWeight: FontWeight.w900,
                color: accentColor,
                fontFamily: 'Century Gothic',
                fontFamilyFallback: _fontFallback,
              ),
            ),
          const SizedBox(height: 8),
          if (useDarkerBackground && card.prefix.trim().toLowerCase() == 'me-')
            _buildB25MeRuleText(card.ruleText, bodySize)
          else if (useDarkerBackground &&
              card.prefix.trim().toLowerCase() == 'meng-')
            _buildB25MengRuleText(card.ruleText, bodySize)
          else
            Text(
              card.ruleText,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: bodySize,
                fontWeight: FontWeight.w700,
                height: 1.35,
                color: useDarkerBackground
                    ? _b25MainText
                    : const Color(0xFF1D3557),
                fontFamily: 'Century Gothic',
                fontFamilyFallback: _fontFallback,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildB25MeRuleText(String ruleText, double bodySize) {
    final baseStyle = TextStyle(
      fontSize: bodySize,
      fontWeight: FontWeight.w700,
      height: 1.35,
      color: _b25MainText,
      fontFamily: 'Century Gothic',
      fontFamilyFallback: _fontFallback,
    );
    final secondaryStyle = baseStyle.copyWith(color: _b25SecondaryText);
    final lines = ruleText.split('\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (lines.isNotEmpty)
          Text(lines.first, textAlign: TextAlign.start, style: baseStyle),
        _buildB25MeRuleTable(lines.skip(1), baseStyle, secondaryStyle),
      ],
    );
  }

  Widget _buildB25MeRuleTable(
    Iterable<String> lines,
    TextStyle baseStyle,
    TextStyle secondaryStyle,
  ) {
    final pattern = RegExp(r'^(\S+)\s+\(?menjadi\s+([^)]+)\)?$');
    final becomingPainter = TextPainter(
      text: TextSpan(text: 'menjadi', style: secondaryStyle),
      maxLines: 1,
      textDirection: Directionality.of(context),
    )..layout();
    final becomingWidth =
        becomingPainter.width + responsiveClamp(context, 4, 6, 8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        final match = pattern.firstMatch(line.trim());
        if (match == null) {
          return Text(line, textAlign: TextAlign.start, style: baseStyle);
        }

        return FittedBox(
          alignment: Alignment.centerLeft,
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 24,
                child: Text(
                  match.group(1)!,
                  style: baseStyle,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
              SizedBox(
                width: becomingWidth,
                child: Text(
                  'menjadi',
                  style: secondaryStyle,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
              Text(
                match.group(2)!,
                style: baseStyle,
                maxLines: 1,
                softWrap: false,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildB25MengRuleText(String ruleText, double bodySize) {
    final textStyle = TextStyle(
      fontSize: bodySize,
      fontWeight: FontWeight.w700,
      height: 1.35,
      color: _b25MainText,
      fontFamily: 'Century Gothic',
      fontFamilyFallback: _fontFallback,
    );
    final lines = ruleText.split('\n');
    final firstLine = lines.first;
    final secondLine = lines.length > 1 ? lines.skip(1).join('\n') : '';
    final firstVowelIndex = firstLine.indexOf('a');
    final leadingText = firstVowelIndex < 0
        ? ''
        : firstLine.substring(0, firstVowelIndex);
    final leadingTextPainter = TextPainter(
      text: TextSpan(text: leadingText, style: textStyle),
      maxLines: 1,
      textDirection: Directionality.of(context),
    )..layout();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(firstLine, textAlign: TextAlign.start, style: textStyle),
        if (secondLine.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(left: leadingTextPainter.width),
            child: Text(
              secondLine,
              textAlign: TextAlign.start,
              style: textStyle,
            ),
          ),
      ],
    );
  }

  _SummaryCardPalette _b25SummaryCardPalette(String prefix) {
    switch (prefix.trim().toLowerCase()) {
      case 'me-':
        return const _SummaryCardPalette(
          background: _b05LightBackground,
          main: _b05MainColor,
          accent: _b05AccentColor,
          darkAccent: _b05DarkerAccentColor,
          textOnMain: _b05TextOnColoredBox,
        );
      case 'mem-':
        return const _SummaryCardPalette(
          background: _b15LightBackground,
          main: _b15MainColor,
          accent: _b15AccentColor,
          darkAccent: _b15DarkerAccentColor,
          textOnMain: _b15TextOnColoredBox,
        );
      case 'men-':
        return const _SummaryCardPalette(
          background: _b16LightBackground,
          main: _b16MainColor,
          accent: _b16AccentColor,
          darkAccent: _b16DarkerAccentColor,
          textOnMain: _b16TextOnColoredBox,
        );
      case 'meng-':
        return const _SummaryCardPalette(
          background: _b17LightBackground,
          main: _b17MainColor,
          accent: _b17AccentColor,
          darkAccent: _b17DarkerAccentColor,
          textOnMain: _b17TextOnColoredBox,
        );
      case 'menge-':
        return const _SummaryCardPalette(
          background: _b18LightBackground,
          main: _b18MainColor,
          accent: _b18AccentColor,
          darkAccent: _b18DarkerAccentColor,
          textOnMain: _b18TextOnColoredBox,
        );
      default:
        return const _SummaryCardPalette(
          background: Colors.white,
          main: _b25HeadingStart,
          accent: _b25Border,
          darkAccent: _b25HeadingEnd,
          textOnMain: Colors.white,
        );
    }
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
                                fontFamily: 'Century Gothic',
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
                                fontFamily: 'Century Gothic',
                                fontFamilyFallback: _fontFallback,
                              ),
                            ),
                            const SizedBox(height: 40),
                            SizedBox(
                              width: math.min(constraints.maxWidth * 0.72, 220),
                              child: _buildLearningContinueButton(
                                label: step.buttonText,
                                onPressed: _goNext,
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

  double _animatedWordTextScale(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    if (size.width > size.height) {
      return 0.72;
    }
    if (size.width < 340 || size.height < 570) {
      return 0.78;
    }
    if (size.height < 640) {
      return 0.86;
    }
    if (size.width < 380) {
      return 0.92;
    }
    return 1.0;
  }

  Widget _buildResponsiveWordAnimationStep({
    required LearningStep step,
    required int stage,
    required bool isAnimating,
    required VoidCallback onAdvance,
    required Key continueVisibleKey,
    required Key continueHiddenKey,
    required Widget Function(
      BuildContext context,
      int stage,
      bool animationComplete,
    )
    stageBuilder,
    bool showTapHint = false,
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
        final isLandscape = constraints.maxWidth > constraints.maxHeight;
        final isShort = constraints.maxHeight < 620;
        final animationComplete = stage >= 2 && !isAnimating;
        final horizontalPadding = responsiveClamp(
          context,
          12,
          isLandscape ? 18 : 20,
          24,
        );
        final hasTransformStage = stage >= 2;
        final stageHeight = hasTransformStage
            ? responsiveClamp(
                context,
                isLandscape ? 164 : 184,
                isLandscape
                    ? 196
                    : isShort
                    ? 214
                    : 258,
                isLandscape
                    ? 232
                    : isShort
                    ? 252
                    : 316,
              )
            : responsiveClamp(
                context,
                isLandscape ? 74 : 82,
                isShort ? 96 : 114,
                isShort ? 118 : 142,
              );
        final baseSafeTop = isLandscape
            ? responsiveClamp(context, 10, 14, 18)
            : math.max(
                constraints.maxHeight * (isShort ? 0.18 : 0.21),
                responsiveClamp(context, 74, 96, 124),
              );
        final bottomReserve = responsiveClamp(
          context,
          isLandscape ? 62 : 82,
          isShort ? 88 : 104,
          isShort ? 102 : 118,
        );
        final maxSafeTop = math.max(
          0.0,
          constraints.maxHeight - bottomReserve - stageHeight,
        );
        final safeTop = math.min(baseSafeTop, maxSafeTop);
        final availableHeight = math.max(
          stageHeight,
          constraints.maxHeight - safeTop - bottomReserve,
        );
        final safeZoneHeight = math.min(stageHeight, availableHeight);
        final stageAlignmentX = constraints.maxWidth < 360
            ? 0.16
            : constraints.maxWidth < 400
            ? 0.24
            : 0.32;
        final showContinue = animationComplete;
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
                show: showTapHint && stage == 0 && !isAnimating,
                onTap: onAdvance,
              ),
              Positioned(
                left: horizontalPadding,
                right: horizontalPadding,
                top: safeTop,
                height: safeZoneHeight,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: showContinue ? null : onAdvance,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsiveClamp(context, 10, 16, 22),
                          vertical: responsiveClamp(context, 8, 10, 14),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
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
                              child: stageBuilder(
                                context,
                                stage,
                                animationComplete,
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
                      ? _buildLearningContinueButton(
                          key: continueVisibleKey,
                          label: step.buttonText,
                          onPressed: _goNext,
                        )
                      : SizedBox(key: continueHiddenKey, height: 0),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  int _wordAnimationStageForStep(String stepId) {
    switch (stepId) {
      case 'B07':
        return _b07AnimationStage;
      case 'B08':
        return _b08AnimationStage;
      case 'B09':
        return _b09AnimationStage;
      case 'B10':
        return _b10AnimationStage;
      default:
        return _animationStageForSpecialStep(stepId);
    }
  }

  bool _isWordAnimationRunningForStep(String stepId) {
    switch (stepId) {
      case 'B07':
        return _isB07StageAnimating;
      case 'B08':
        return _isB08StageAnimating;
      case 'B09':
        return _isB09StageAnimating;
      case 'B10':
        return _isB10StageAnimating;
      default:
        return _isAnimationRunningForSpecialStep(stepId);
    }
  }

  VoidCallback _wordAnimationAdvanceForStep(String stepId) {
    switch (stepId) {
      case 'B07':
        return _advanceB07AnimationStage;
      case 'B08':
        return _advanceB08AnimationStage;
      case 'B09':
        return _advanceB09AnimationStage;
      case 'B10':
        return _advanceB10AnimationStage;
      default:
        return () => _advanceB11ToB14AnimationStage(stepId);
    }
  }

  Widget _buildAnimatedWordStep(LearningStep step, _AnimatedWordSpec spec) {
    return _buildResponsiveWordAnimationStep(
      step: step,
      stage: _wordAnimationStageForStep(step.id),
      isAnimating: _isWordAnimationRunningForStep(step.id),
      onAdvance: _wordAnimationAdvanceForStep(step.id),
      continueVisibleKey: ValueKey('${step.id}-continue-visible'),
      continueHiddenKey: ValueKey('${step.id}-continue-hidden'),
      showTapHint: step.id == 'B07',
      stageBuilder: (context, stage, animationComplete) {
        return _buildAnimatedWordStageContent(
          context,
          stepId: step.id,
          spec: spec,
          stage: stage,
          animationComplete: animationComplete,
        );
      },
    );
  }

  // Retained temporarily while the B07 whiteboard prototype is phased out.
  // ignore: unused_element
  Widget _buildPtksTutorialStep(LearningStep step, _AnimatedWordSpec spec) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stage = _wordAnimationStageForStep(step.id);
        final isAnimating = _isWordAnimationRunningForStep(step.id);
        final onAdvance = _wordAnimationAdvanceForStep(step.id);
        final animationComplete = stage >= 6 && !isAnimating;

        return Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/background/backgroundImg1.jpg',
              fit: BoxFit.cover,
            ),
            Positioned(
              left: constraints.maxWidth * 0.15,
              right: constraints.maxWidth * 0.15,
              top: constraints.maxHeight * 0.15,
              height: constraints.maxHeight * 0.42,
              child: _buildPtksBoardContent(step.id, spec, stage),
            ),
            Positioned(
              left: responsiveClamp(context, 18, 24, 30),
              right: responsiveClamp(context, 18, 24, 30),
              bottom: responsiveClamp(context, 16, 20, 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: isAnimating
                        ? SizedBox(
                            key: ValueKey('${step.id}-animation-running'),
                            height: 54,
                          )
                        : _buildLearningContinueButton(
                            key: ValueKey(
                              animationComplete
                                  ? '${step.id}-finished-button'
                                  : '${step.id}-tap-$stage',
                            ),
                            label: step.buttonText,
                            onPressed: animationComplete
                                ? _goNext
                                : onAdvance,
                          ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPtksBoardContent(
    String stepId,
    _AnimatedWordSpec spec,
    int stage,
  ) {
    final size = responsiveClamp(context, 27, 38, 48);
    final style = TextStyle(
      color: _b07TextColor,
      fontSize: size,
      fontWeight: FontWeight.w900,
      height: 1,
      fontFamily: 'Century Gothic',
      fontFamilyFallback: _fontFallback,
    );

    Widget formula(String letter, Color letterColor, {bool checked = false}) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: Text.rich(
          TextSpan(
            children: [
              if (checked) const TextSpan(text: 'me'),
              if (!checked) const TextSpan(text: 'me-  +  '),
              TextSpan(text: letter, style: TextStyle(color: letterColor)),
              TextSpan(
                text: checked
                    ? '${spec.remainingLetters}  ✓'
                    : '  ${spec.remainingLetters}',
              ),
            ],
          ),
          maxLines: 1,
          style: style,
        ),
      );
    }

    Widget rootWord() {
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(size * 0.10),
              decoration: stage >= 2
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: _b07ChangeFromColor, width: 3),
                    )
                  : null,
              child: Text(spec.originalLetter, style: style),
            ),
            Text(spec.remainingLetters, style: style),
          ],
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: size * 1.25,
          child: stage >= 6
              ? formula(
                  spec.replacementLetters,
                  _b07ChangeToColor,
                  checked: true,
                )
              : stage >= 1 && stage <= 3
              ? rootWord()
              : null,
        ),
        SizedBox(
          height: size * 1.35,
          child: stage >= 5
              ? formula(spec.replacementLetters, _b07ChangeToColor)
              : null,
        ),
        SizedBox(
          height: size * 1.25,
          child: stage == 4
              ? _buildPtksLetterChangeAnimation(stepId, spec, style, size)
              : stage >= 3
              ? formula(spec.originalLetter, _b07ChangeFromColor)
              : null,
        ),
      ],
    );
  }

  Widget _buildPtksLetterChangeAnimation(
    String stepId,
    _AnimatedWordSpec spec,
    TextStyle style,
    double size,
  ) {
    if (AppMotionSpec.reduceMotion(context)) {
      return Text.rich(
        TextSpan(
          children: [
            const TextSpan(text: 'me-  +  '),
            TextSpan(
              text: spec.replacementLetters,
              style: const TextStyle(color: _b07ChangeToColor),
            ),
            TextSpan(text: '  ${spec.remainingLetters}'),
          ],
        ),
        style: style,
      );
    }
    return TweenAnimationBuilder<double>(
      key: ValueKey('$stepId-letter-change-upward'),
      tween: Tween(begin: 0, end: 1),
      duration: _ptksStageDuration(stepId),
      curve: Curves.easeInOutCubic,
      builder: (context, value, child) {
        final showM = value >= 0.58;
        return FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('me-  +  ', style: style),
              SizedBox(
                width: size * 1.15,
                height: size,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      bottom: size * 0.52,
                      child: Icon(
                        Icons.arrow_upward_rounded,
                        size: size * 0.90,
                        color: _b07TextColor.withValues(alpha: 0.75),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(0, -value * size * 1.25),
                      child: Text(
                        showM
                            ? spec.replacementLetters
                            : spec.originalLetter,
                        style: style.copyWith(
                          color: showM
                              ? _b07ChangeToColor
                              : _b07ChangeFromColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text('  ${spec.remainingLetters}', style: style),
            ],
          ),
        );
      },
    );
  }

  Duration _ptksStageDuration(String stepId) {
    return switch (stepId) {
      'B07' => _b07StageDuration(4),
      'B08' => _b08StageDuration(4),
      'B09' => _b09StageDuration(4),
      'B10' => _b10StageDuration(4),
      _ => _wordAnimationStageDuration(4),
    };
  }

  Widget _buildAnimatedWordStageContent(
    BuildContext context, {
    required String stepId,
    required _AnimatedWordSpec spec,
    required int stage,
    required bool animationComplete,
  }) {
    const black = Color(0xFF111827);
    final baseSize =
        responsiveClamp(context, 26, 34, 42) *
        _narrowWidthTextScale(context) *
        _animatedWordTextScale(context);

    TextStyle wordStyle(double size, Color color) {
      return TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w900,
        color: color,
        height: 1.05,
        fontFamily: 'Century Gothic',
        fontFamilyFallback: _fontFallback,
      );
    }

    Widget fit(Widget child) {
      return FittedBox(fit: BoxFit.scaleDown, child: child);
    }

    switch (stage) {
      case 0:
        return fit(
          Text(
            spec.rootWord,
            key: ValueKey('$stepId-word'),
            maxLines: 1,
            style: wordStyle(baseSize, black),
          ),
        );
      case 1:
        return fit(
          Text(
            'me-',
            key: ValueKey('$stepId-prefix'),
            maxLines: 1,
            style: wordStyle(baseSize, black),
          ),
        );
      default:
        return fit(
          _buildWordTransformSequence(
            context: context,
            stepId: stepId,
            spec: spec,
            animationComplete: animationComplete,
            baseSize: baseSize,
            style: wordStyle,
          ),
        );
    }
  }

  Widget _buildWordTransformSequence({
    required BuildContext context,
    required String stepId,
    required _AnimatedWordSpec spec,
    required bool animationComplete,
    required double baseSize,
    required TextStyle Function(double size, Color color) style,
  }) {
    Widget content(double rawValue) {
      final value = animationComplete ? 1.0 : rawValue;
      return _buildAnimatedFormulaLayout(
        context: context,
        spec: spec,
        progress: value,
        baseSize: baseSize,
        style: style,
      );
    }

    if (AppMotionSpec.reduceMotion(context)) {
      return content(1);
    }

    return TweenAnimationBuilder<double>(
      key: ValueKey('$stepId-transform-sequence'),
      tween: Tween(begin: 0, end: 1),
      duration: stepId == 'B07'
          ? _b07StageDuration(2)
          : stepId == 'B08'
          ? _b08StageDuration(2)
          : stepId == 'B09'
          ? _b09StageDuration(2)
          : stepId == 'B10'
          ? _b10StageDuration(2)
          : _wordAnimationStageDuration(2),
      curve: Curves.linear,
      builder: (context, value, child) => content(value),
    );
  }

  Widget _buildAnimatedFormulaLayout({
    required BuildContext context,
    required _AnimatedWordSpec spec,
    required double progress,
    required double baseSize,
    required TextStyle Function(double size, Color color) style,
  }) {
    const black = Color(0xFF111827);
    const red = Color(0xFFE63946);
    const green = Color(0xFF16A34A);
    final mediaSize = MediaQuery.sizeOf(context);
    final isLandscape = mediaSize.width > mediaSize.height;
    final formulaSize = baseSize * 1.42;
    final finalWordSize = baseSize;
    final maxWidth = math.min(mediaSize.width * 0.88, 560.0);
    final sequenceHeight = responsiveClamp(
      context,
      isLandscape ? 170 : 190,
      isLandscape ? 210 : 250,
      isLandscape ? 240 : 300,
    );
    final downDistance = sequenceHeight * (isLandscape ? 0.22 : 0.25);

    final circleProgress = Curves.easeOutCubic.transform(
      ((progress - 0.10) / 0.18).clamp(0.0, 1.0),
    );
    final arrowProgress = Curves.easeOutCubic.transform(
      ((progress - 0.28) / 0.18).clamp(0.0, 1.0),
    );
    final originalMoveProgress = Curves.easeInOutCubic.transform(
      ((progress - 0.46) / 0.20).clamp(0.0, 1.0),
    );
    final replacementProgress = Curves.easeOutCubic.transform(
      ((progress - 0.62) / 0.18).clamp(0.0, 1.0),
    );
    final downProgress = Curves.easeInOutCubic.transform(
      ((progress - 0.80) / 0.10).clamp(0.0, 1.0),
    );
    final finalRevealProgress = Curves.easeOutCubic.transform(
      ((progress - 0.91) / 0.09).clamp(0.0, 1.0),
    );

    Widget sideText(String text, double rowHeight) {
      return SizedBox(
        height: rowHeight,
        child: Align(
          alignment: Alignment.center,
          child: Text(text, style: style(formulaSize, black)),
        ),
      );
    }

    Widget formulaRow() {
      final circleSize = math.max(
        formulaSize * 1.34,
        responsiveClamp(context, 48, 62, 74),
      );
      final slotWidth = math.max(
        circleSize + responsiveClamp(context, 10, 16, 20),
        responsiveClamp(
          context,
          spec.replacementLetters.length > 1 ? 76 : 64,
          spec.replacementLetters.length > 1 ? 98 : 84,
          spec.replacementLetters.length > 1 ? 118 : 100,
        ),
      );
      final slotHeight = math.max(
        circleSize * 2.7,
        responsiveClamp(context, 148, 184, 214),
      );
      final arrowSize = responsiveClamp(context, 22, 30, 38);
      final arrowTop = (slotHeight / 2 - circleSize / 2 - arrowSize - 2).clamp(
        0.0,
        slotHeight,
      );
      final originalDrop =
          (slotHeight / 2 + circleSize * 0.04) * originalMoveProgress;

      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          sideText('me- + ', slotHeight),
          SizedBox(
            width: slotWidth,
            height: slotHeight,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: arrowTop,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: arrowProgress,
                    child: Icon(
                      Icons.arrow_downward_rounded,
                      color: green,
                      size: arrowSize,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Transform.translate(
                    offset: Offset(0, originalDrop),
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
                            spec.originalLetter,
                            style: style(formulaSize, red),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Opacity(
                    opacity: replacementProgress,
                    child: Transform.scale(
                      scale: 0.92 + replacementProgress * 0.08,
                      child: Text(
                        spec.replacementLetters,
                        textAlign: TextAlign.center,
                        style: style(formulaSize, green),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          sideText(spec.remainingLetters, slotHeight),
        ],
      );
    }

    final formula = Transform.translate(
      offset: Offset(0, downDistance * downProgress),
      child: FittedBox(fit: BoxFit.scaleDown, child: formulaRow()),
    );
    final finalWord = Opacity(
      opacity: finalRevealProgress,
      child: Transform.translate(
        offset: Offset(0, (1 - finalRevealProgress) * 12),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(spec.finalWord, style: style(finalWordSize, black)),
              SizedBox(width: responsiveClamp(context, 6, 8, 10)),
              Icon(
                Icons.check_circle_rounded,
                color: green,
                size: finalWordSize * 0.82,
              ),
            ],
          ),
        ),
      ),
    );

    return SizedBox(
      width: maxWidth,
      height: sequenceHeight,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Align(alignment: const Alignment(0, -0.68), child: finalWord),
          Align(alignment: Alignment.center, child: formula),
        ],
      ),
    );
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
                      fontFamily: 'Century Gothic',
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
                fontFamily: 'Century Gothic',
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
    final animatedWordSpec = _animatedWordSpecs[step.id];
    if (animatedWordSpec != null) {
      return _buildAnimatedWordStep(step, animatedWordSpec);
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
    final usesB01Style = _usesB01Style(step);
    final isB04 = step.id == 'B04';
    final isB25 = step.id == 'B25';
    return MediaQuery(
      data: mediaQuery.copyWith(textScaler: responsiveTextScaler(context)),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: usesB01Style
                      ? const [_b01ScreenBgColor, _b01ScreenBgColor]
                      : isB04
                      ? const [_b04ScreenBgColor, _b04ScreenBgColor]
                      : isB25
                      ? const [_b25PageBackground, _b25PageBackground]
                      : [step.backgroundTop, step.backgroundBottom],
                ),
              ),
              child: SafeArea(
                child: DefaultTextStyle.merge(
                  style: const TextStyle(
                    fontFamily: 'Century Gothic',
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
                                  : usesB01Style
                                  ? const EdgeInsets.all(20)
                                  : const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isLevelTransition
                                    ? Colors.transparent
                                    : isB25
                                    ? _b25PageBackground
                                    : Colors.white.withValues(alpha: 0.52),
                                borderRadius: BorderRadius.circular(
                                  isLevelTransition ? 0 : 18,
                                ),
                                border: isB25
                                    ? Border.all(color: _b25Border)
                                    : null,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: _buildStepBody(step)),
                                  if (step.type !=
                                          LearningStepType.quizGateway &&
                                      !isLevelTransition) ...[
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      child: isB25
                                          ? _buildB25ContinueButton(
                                              label: step.buttonText,
                                              onPressed: _goNext,
                                            )
                                          : _buildPulsingLearningContinueButton(
                                              label: step.buttonText,
                                              onPressed: _goNext,
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
            // Remove this line to delete the bypasser entirely.
            if (_enableLessonBypasser) _buildLessonBypasser(),
          ],
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
      backgroundTop: _b01ScreenBgColor,
      backgroundBottom: _b01ScreenBgColor,
      exampleSubheading: 'Contoh',
      equationExamples: [
        LearningEquationExample(
          left: 'ber',
          middle: 'lari',
          right: 'berlari',
          leftColor: _b01ImbuhanColor,
          middleColor: _b01KataDasarColor,
          rightColor: _b01KataTerbitanColor,
        ),
        LearningEquationExample(
          left: 'men',
          middle: 'dengar',
          right: 'mendengar',
          leftColor: _b01ImbuhanColor,
          middleColor: _b01KataDasarColor,
          rightColor: _b01KataTerbitanColor,
        ),
        LearningEquationExample(
          left: 'makan',
          middle: 'an',
          right: 'makanan',
          leftColor: _b01KataDasarColor,
          middleColor: _b01ImbuhanColor,
          rightColor: _b01KataTerbitanColor,
        ),
      ],
      colorLegends: [
        LearningColorLegend(
          color: _b01ImbuhanColor,
          name: 'Merah jambu',
          description: 'Imbuhan',
        ),
        LearningColorLegend(
          color: _b01KataDasarColor,
          name: 'Biru',
          description: 'Kata dasar',
        ),
        LearningColorLegend(
          color: _b01KataTerbitanColor,
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
      backgroundTop: _b01ScreenBgColor,
      backgroundBottom: _b01ScreenBgColor,
      exampleSubheading: 'Contoh',
      equationExamples: [
        LearningEquationExample(
          left: 'ber',
          middle: 'lari',
          right: 'berlari',
          leftColor: _b01ImbuhanColor,
          middleColor: _b01KataDasarColor,
          rightColor: _b01KataTerbitanColor,
        ),
        LearningEquationExample(
          left: 'di',
          middle: 'beli',
          right: 'dibeli',
          leftColor: _b01ImbuhanColor,
          middleColor: _b01KataDasarColor,
          rightColor: _b01KataTerbitanColor,
        ),
        LearningEquationExample(
          left: 'ter',
          middle: 'tidur',
          right: 'tertidur',
          leftColor: _b01ImbuhanColor,
          middleColor: _b01KataDasarColor,
          rightColor: _b01KataTerbitanColor,
        ),
      ],
      colorLegends: [
        LearningColorLegend(
          color: _b01ImbuhanColor,
          name: 'Merah jambu',
          description: 'Imbuhan',
        ),
        LearningColorLegend(
          color: _b01KataDasarColor,
          name: 'Biru',
          description: 'Kata dasar',
        ),
        LearningColorLegend(
          color: _b01KataTerbitanColor,
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
          '• Imbuhan meN- digunakan untuk membentuk kata kerja.\n'
          '• Kata kerja ialah perbuatan.',
      backgroundTop: _b01ScreenBgColor,
      backgroundBottom: _b01ScreenBgColor,
      exampleSubheading: 'Contoh',
      equationExamples: [
        LearningEquationExample(
          left: 'meN-',
          middle: 'tari',
          right: 'menari',
          leftColor: _b01ImbuhanColor,
          middleColor: _b01KataDasarColor,
          rightColor: _b01KataTerbitanColor,
        ),
        LearningEquationExample(
          left: 'meN-',
          middle: 'masak',
          right: 'memasak',
          leftColor: _b01ImbuhanColor,
          middleColor: _b01KataDasarColor,
          rightColor: _b01KataTerbitanColor,
        ),
        LearningEquationExample(
          left: 'meN-',
          middle: 'cat',
          right: 'mengecat',
          leftColor: _b01ImbuhanColor,
          middleColor: _b01KataDasarColor,
          rightColor: _b01KataTerbitanColor,
        ),
      ],
      colorLegends: [
        LearningColorLegend(
          color: _b01ImbuhanColor,
          name: 'Merah jambu',
          description: 'Imbuhan',
        ),
        LearningColorLegend(
          color: _b01KataDasarColor,
          name: 'Biru',
          description: 'Kata dasar',
        ),
        LearningColorLegend(
          color: _b01KataTerbitanColor,
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
          '• Imbuhan meN- digunakan untuk membentuk kata kerja.\n'
          '• Imbuhan ini berubah mengikut huruf awal kata dasar.',
      backgroundTop: Color(0xFFFFF8D2),
      backgroundBottom: Color(0xFFFFEBB1),
      exampleSubheading: 'Contoh',
      tableHeaders: ['meN-', 'Huruf selepas meN-'],
      tableRows: [
        LearningRuleRow(
          cells: [
            'me-',
            'l, m, n, ng, ny, r, w \np menjadi m \nt menjadi n \nk menjadi ng \ns menjadi ny',
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
          cells: ['meng-', 'a, e, i, o, u (vokal) \ng, h (konsonan)'],
          backgroundColor: Color(0xFFEF9A9A),
        ),
        LearningRuleRow(
          cells: ['menge-', 'satu suku kata'],
          backgroundColor: Color(0xFFFFF176),
        ),
      ],
    ),
    LearningStep(
      id: 'B05',
      title: 'Penggunaan imbuhan me-',
      type: LearningStepType.arrowExamples,
      subtitle:
          'â€¢ Gunakan imbuhan me- apabila kata dasar bermula dengan huruf:',
      backgroundTop: _b05LightBackground,
      backgroundBottom: _b05AccentColor,
      highlightedLetters: ['l', 'm', 'n', 'ng', 'ny', 'r', 'w'],
      afterHighlightLine: 'â€¢ Huruf awal tidak berubah.',
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
          'â€¢ Huruf lain seperti p, t, k dan s akan menyebabkan imbuhan meN- berubah.\n'
          'â€¢ Ini akan diterangkan dalam skrin seterusnya.',
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
          example: '[p]otong -> me[m]otong',
          note: '[p] berubah menjadi [m]',
          accentColor: Color(0xFFEF4444),
        ),
        LearningChangeCard(
          letter: 't',
          example: '[t]ulis -> me[n]ulis',
          note: '[t] berubah menjadi [n]',
          accentColor: Color(0xFF8B5CF6),
        ),
        LearningChangeCard(
          letter: 'k',
          example: '[k]awal -> me[ng]awal',
          note: '[k] berubah menjadi [ng]',
          accentColor: Color(0xFF059669),
        ),
        LearningChangeCard(
          letter: 's',
          example: '[s]apu -> me[ny]apu',
          note: '[s] berubah menjadi [ny]',
          accentColor: Color(0xFF0EA5E9),
        ),
      ],
    ),
    LearningStep(
      id: 'B07',
      title: 'pilih',
      subtitle: 'memilih',
      type: LearningStepType.levelTransition,
      buttonText: 'Teruskan',
      voiceScript: 'pilih… tambah imbuhan me-… p berubah menjadi m… memilih',
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
      subtitle:
          '\u2022 Gunakan imbuhan mem- apabila kata dasar bermula dengan huruf:',
      backgroundTop: _b15LightBackground,
      backgroundBottom: _b15AccentColor,
      highlightedLetters: ['b', 'f'],
      afterHighlightLine: '\u2022 Huruf awal tidak berubah.',
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
      subtitle:
          '\u2022 Gunakan imbuhan men- apabila kata dasar bermula dengan huruf:',
      backgroundTop: _b16LightBackground,
      backgroundBottom: _b16AccentColor,
      highlightedLetters: ['c', 'd', 'j', 'z', 'sy'],
      afterHighlightLine: '\u2022 Huruf awal tidak berubah.',
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
      subtitle:
          '\u2022 Gunakan imbuhan meng- apabila kata dasar bermula dengan:',
      backgroundTop: _b17LightBackground,
      backgroundBottom: _b17AccentColor,
      highlightedLetters: ['a', 'e', 'i', 'o', 'u', 'g', 'h'],
      afterHighlightLine: '\u2022 Huruf awal tidak berubah.',
      exampleSubheading: 'Contoh',
      arrowRows: [
        LearningArrowRow(
          letter: 'a',
          baseWord: 'angkat',
          derivedWord: 'mengangkat',
        ),
        LearningArrowRow(
          letter: 'e',
          baseWord: 'elak',
          derivedWord: 'mengelak',
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
          letter: 'u',
          baseWord: 'ukur',
          derivedWord: 'mengukur',
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
      backgroundTop: _b18LightBackground,
      backgroundBottom: _b18AccentColor,
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
      title: 'Mari kita belajar imbuhan awalan meN- melalui situasi',
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
          'Arahan: Tekan ⭐\n'
          'Dengar kata dasar.\n'
          'Sebut imbuhan awalan meN- yang sesuai.\n'
          'Tekan lagi untuk semak jawapan.',
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
          ruleNote: 'Huruf t gugur, bunyi "n" hadir',
        ),
        LearningHotspot(
          label: 'mengajar',
          baseWord: 'ajar',
          derivedWord: 'mengajar',
          alignment: Alignment(0.06, -0.72),
          ruleNote: 'Tiada perubahan huruf',
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
          'Arahan: Tekan ⭐\n'
          'Dengar kata dasar.\n'
          'Sebut imbuhan awalan meN- yang sesuai.\n'
          'Tekan lagi untuk semak jawapan.',
      hotspots: [
        LearningHotspot(
          label: 'mengangkat',
          baseWord: 'angkat',
          derivedWord: 'mengangkat',
          alignment: Alignment(-0.14, 0.0),
          ruleNote: 'Tiada perubahan huruf',
        ),
        LearningHotspot(
          label: 'menendang',
          baseWord: 'tendang',
          derivedWord: 'menendang',
          alignment: Alignment(-0.62, -0.28),
          ruleNote: 'Huruf t gugur, bunyi "n" hadir',
        ),
        LearningHotspot(
          label: 'mengejar',
          baseWord: 'kejar',
          derivedWord: 'mengejar',
          alignment: Alignment(0.03, -0.64),
          ruleNote: 'Huruf k gugur, bunyi "ng" hadir',
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
          'Arahan: Tekan ⭐\n'
          'Dengar kata dasar.\n'
          'Sebut imbuhan awalan meN- yang sesuai.\n'
          'Tekan lagi untuk semak jawapan.',
      hotspots: [
        LearningHotspot(
          label: 'memotong',
          baseWord: 'potong',
          derivedWord: 'memotong',
          alignment: Alignment(0.60, -0.16),
          ruleNote: 'Huruf p gugur, bunyi "m" hadir',
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
          ruleNote: 'Tiada perubahan huruf',
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
          'Arahan: Tekan ⭐\n'
          'Dengar kata dasar.\n'
          'Sebut imbuhan awalan meN- yang sesuai.\n'
          'Tekan lagi untuk semak jawapan.',
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
          ruleNote: 'Tiada perubahan huruf',
        ),
        LearningHotspot(
          label: 'menggunting',
          baseWord: 'gunting',
          derivedWord: 'menggunting',
          alignment: Alignment(0.36, 0.02),
          ruleNote: 'Tiada perubahan huruf',
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
          'Arahan: Tekan ⭐\n'
          'Dengar kata dasar.\n'
          'Sebut imbuhan awalan meN- yang sesuai.\n'
          'Tekan lagi untuk semak jawapan.',
      hotspots: [
        LearningHotspot(
          label: 'mengutip',
          baseWord: 'kutip',
          derivedWord: 'mengutip',
          alignment: Alignment(-0.08, 0.03),
          ruleNote: 'Huruf k gugur, bunyi "ng" hadir',
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
          ruleNote: 'Huruf p gugur, bunyi "m" hadir',
        ),
        LearningHotspot(
          label: 'menyapu',
          baseWord: 'sapu',
          derivedWord: 'menyapu',
          alignment: Alignment(-0.64, -0.34),
          ruleNote: 'Huruf s gugur, bunyi "ny" hadir',
        ),
      ],
    ),
    LearningStep(
      id: 'B25',
      title: 'Jom Ingat Semula!',
      type: LearningStepType.summary,
      backgroundTop: _b25PageBackground,
      backgroundBottom: _b25PageBackground,
      subtitle:
          '\u2022 Lihat huruf awal kata dasar.\n'
          '\u2022 Ingat semula imbuhan meN- yang sesuai.',
      buttonText: 'Kembali ke Menu Utama',
      summaryCards: [
        LearningSummaryCard(
          prefix: 'me-',
          ruleText:
              'Huruf: l, m, n, ng, ny, r, w  \np (menjadi m) \nt (menjadi n) \nk (menjadi ng) \ns (menjadi ny)',
        ),
        LearningSummaryCard(prefix: 'mem-', ruleText: 'Huruf: b, f'),
        LearningSummaryCard(prefix: 'men-', ruleText: 'Huruf: c, d, j, z, sy'),
        LearningSummaryCard(
          prefix: 'meng-',
          ruleText: 'Huruf: a, e, i, o, u (vokal)\ng, h (konsonan)',
        ),
        LearningSummaryCard(prefix: 'menge-', ruleText: 'Satu suku kata'),
      ],
    ),
  ];
}
