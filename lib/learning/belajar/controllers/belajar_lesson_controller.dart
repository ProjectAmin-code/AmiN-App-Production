import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/belajar_lesson_repository.dart';
import '../models/belajar_lesson_content.dart';

final belajarLessonRepositoryProvider = Provider<BelajarLessonRepository>(
  (ref) => const BelajarLessonRepository(),
);

final belajarLessonControllerProvider = ChangeNotifierProvider.autoDispose
    .family<BelajarLessonController, String>((ref, lessonId) {
      final repository = ref.watch(belajarLessonRepositoryProvider);
      return BelajarLessonController(
        repository: repository,
        lessonId: lessonId,
      );
    });

class BelajarLessonController extends ChangeNotifier {
  BelajarLessonController({
    required BelajarLessonRepository repository,
    required String lessonId,
  }) : _repository = repository {
    _lesson = _repository.byIdOrInitial(lessonId);
  }

  final BelajarLessonRepository _repository;
  late BelajarLessonContent _lesson;

  BelajarLessonContent get lesson => _lesson;
  int get totalLessons => _repository.lessons.length;

  int get currentLessonIndex {
    final index = _repository.indexOf(_lesson.id);
    return index < 0 ? 0 : index;
  }

  int get currentStep => currentLessonIndex + 1;
  double get progress => currentStep / totalLessons;

  BelajarLessonContent? get previousLesson =>
      _repository.previousOf(_lesson.id);
  BelajarLessonContent? get nextLesson => _repository.nextOf(_lesson.id);

  void setLesson(String lessonId) {
    final resolvedLesson = _repository.byIdOrInitial(lessonId);
    if (resolvedLesson.id == _lesson.id) {
      return;
    }
    _lesson = resolvedLesson;
    notifyListeners();
  }
}
