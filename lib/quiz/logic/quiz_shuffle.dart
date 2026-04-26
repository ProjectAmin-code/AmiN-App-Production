import 'dart:math';

typedef QuizOrderValidator<T> = bool Function(List<T> items);
typedef QuizItemSelector<T> = bool Function(T item);

List<T> shuffleForLoad<T>({
  required List<T> items,
  required Random random,
  QuizOrderValidator<T>? validator,
  int maxAttempts = 6,
}) {
  final original = items.toList(growable: false);
  if (original.length < 2) {
    return original;
  }

  final jumbled = original.toList();
  var attempts = 0;
  do {
    jumbled.shuffle(random);
    attempts += 1;
  } while (attempts < maxAttempts &&
      (_isSameOrder(jumbled, original) ||
          !_passesValidator(jumbled, validator)));

  if (_isSameOrder(jumbled, original) ||
      !_passesValidator(jumbled, validator)) {
    final rotated = _rotateByOne(original);
    if (_passesValidator(rotated, validator)) {
      return List<T>.unmodifiable(rotated);
    }
  }

  return List<T>.unmodifiable(jumbled);
}

List<T> shuffleForLoadWithSeparatedGroup<T>({
  required List<T> items,
  required Random random,
  required QuizItemSelector<T> shouldBeSeparated,
  int maxAttempts = 200,
}) {
  return shuffleForLoad<T>(
    items: items,
    random: random,
    maxAttempts: maxAttempts,
    validator: (orderedItems) =>
        !hasAdjacentItems(orderedItems, shouldBeSeparated),
  );
}

bool hasAdjacentItems<T>(List<T> items, QuizItemSelector<T> selector) {
  for (var i = 1; i < items.length; i++) {
    if (selector(items[i - 1]) && selector(items[i])) {
      return true;
    }
  }
  return false;
}

bool _passesValidator<T>(List<T> items, QuizOrderValidator<T>? validator) {
  if (validator == null) {
    return true;
  }
  return validator(items);
}

List<T> _rotateByOne<T>(List<T> items) {
  if (items.length < 2) {
    return items;
  }
  final rotated = items.toList();
  final first = rotated.removeAt(0);
  rotated.add(first);
  return rotated;
}

bool _isSameOrder<T>(List<T> a, List<T> b) {
  if (a.length != b.length) {
    return false;
  }
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) {
      return false;
    }
  }
  return true;
}
