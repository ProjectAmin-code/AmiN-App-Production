import 'package:flutter/widgets.dart';

import 'gamification_controller.dart';

class GamificationScope extends InheritedNotifier<GamificationController> {
  const GamificationScope({
    super.key,
    required GamificationController controller,
    required super.child,
  }) : super(notifier: controller);

  static GamificationController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<GamificationScope>();
    assert(scope != null, 'GamificationScope not found in widget tree.');
    return scope!.notifier!;
  }
}
