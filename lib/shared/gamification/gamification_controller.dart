import 'package:flutter/foundation.dart';

import 'gamification_event.dart';

class GamificationController extends ChangeNotifier {
  int _totalXp = 0;
  int _streak = 0;
  int _stars = 0;
  int _level = 1;

  final List<GamificationEvent> _queue = <GamificationEvent>[];

  int get totalXp => _totalXp;
  int get streak => _streak;
  int get stars => _stars;
  int get level => _level;

  bool get hasEvents => _queue.isNotEmpty;

  GamificationEvent? popNextEvent() {
    if (_queue.isEmpty) {
      return null;
    }
    return _queue.removeAt(0);
  }

  void awardXp(int amount, {String reason = '', bool showOverlay = true}) {
    if (amount <= 0) {
      return;
    }
    _totalXp += amount;
    if (showOverlay) {
      _queue.add(
        GamificationEvent(
          type: GamificationEventType.xp,
          amount: amount,
          title: '+$amount Mata',
          message: reason,
        ),
      );
    }
    _maybeUnlockLevel();
    notifyListeners();
  }

  void updateStreak({required bool success}) {
    _streak = success ? _streak + 1 : 0;
    _queue.add(
      GamificationEvent(
        type: GamificationEventType.streak,
        amount: _streak,
        title: 'Streak $_streak',
        message: success
            ? 'Hebat! Teruskan konsisten.'
            : 'Cuba lagi, anda boleh!',
      ),
    );
    notifyListeners();
  }

  void awardStars(int amount) {
    if (amount <= 0) {
      return;
    }
    _stars += amount;
    notifyListeners();
  }

  void unlockLevel({required String label}) {
    // Level popups are intentionally disabled for uninterrupted learning flow.
  }

  void grantReward({
    required String title,
    String message = '',
    int coins = 0,
  }) {
    // Reward popups are intentionally disabled for uninterrupted learning flow.
  }

  void _maybeUnlockLevel() {
    final nextLevel = (_totalXp ~/ 100) + 1;
    if (nextLevel <= _level) {
      return;
    }
    _level = nextLevel;
  }
}
