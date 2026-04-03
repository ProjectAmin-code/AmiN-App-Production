import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'amin_character.dart';

class AminCharacterController extends StateNotifier<Set<AminMotion>> {
  AminCharacterController()
    : super(const <AminMotion>{AminMotion.idleBreathing, AminMotion.blink});

  void setMotions(Set<AminMotion> motions) {
    state = Set<AminMotion>.from(motions);
  }

  void addMotion(AminMotion motion) {
    final next = Set<AminMotion>.from(state)..add(motion);
    state = next;
  }

  void removeMotion(AminMotion motion) {
    final next = Set<AminMotion>.from(state)..remove(motion);
    state = next;
  }

  void resetIdle() {
    state = const <AminMotion>{AminMotion.idleBreathing, AminMotion.blink};
  }
}

final aminCharacterMotionsProvider =
    StateNotifierProvider<AminCharacterController, Set<AminMotion>>(
      (ref) => AminCharacterController(),
    );
