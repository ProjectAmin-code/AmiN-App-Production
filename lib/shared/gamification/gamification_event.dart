enum GamificationEventType {
  xp,
  streak,
  stars,
  levelUnlock,
  reward,
}

class GamificationEvent {
  const GamificationEvent({
    required this.type,
    this.amount = 0,
    this.label = '',
    this.title = '',
    this.message = '',
  });

  final GamificationEventType type;
  final int amount;
  final String label;
  final String title;
  final String message;
}
