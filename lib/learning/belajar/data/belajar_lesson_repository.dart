import '../models/belajar_lesson_content.dart';
import 'belajar_lessons_data.dart';

class BelajarLessonRepository {
  const BelajarLessonRepository();

  List<BelajarLessonContent> get lessons =>
      List<BelajarLessonContent>.unmodifiable(BelajarLessonsData.lessons);

  BelajarLessonContent get initialLesson => BelajarLessonsData.lessons.first;

  BelajarLessonContent byIdOrInitial(String id) {
    return BelajarLessonsData.lessons.firstWhere(
      (lesson) => lesson.id == id,
      orElse: () => initialLesson,
    );
  }

  int indexOf(String id) {
    return BelajarLessonsData.lessons.indexWhere((lesson) => lesson.id == id);
  }

  BelajarLessonContent? nextOf(String id) {
    final currentIndex = indexOf(id);
    if (currentIndex < 0 ||
        currentIndex >= BelajarLessonsData.lessons.length - 1) {
      return null;
    }
    return BelajarLessonsData.lessons[currentIndex + 1];
  }

  BelajarLessonContent? previousOf(String id) {
    final currentIndex = indexOf(id);
    if (currentIndex <= 0) {
      return null;
    }
    return BelajarLessonsData.lessons[currentIndex - 1];
  }
}
