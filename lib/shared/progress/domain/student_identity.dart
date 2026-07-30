import 'dart:math';

class StudentIdentity {
  static const _alphabet = '0123456789ABCDEFGHJKMNPQRSTVWXYZ';

  static String generate([Random? random]) {
    final source = random ?? Random.secure();
    final code = List.generate(
      10,
      (_) => _alphabet[source.nextInt(_alphabet.length)],
    ).join();
    return 'AMIN-${code.substring(0, 5)}-${code.substring(5)}';
  }

  static String normalize(String value) {
    final body = value
        .trim()
        .toUpperCase()
        .replaceAll(RegExp(r'[^A-Z0-9]'), '');
    final withoutPrefix = body.startsWith('AMIN') ? body.substring(4) : body;
    if (withoutPrefix.length != 10 ||
        withoutPrefix.split('').any((c) => !_alphabet.contains(c))) {
      throw const FormatException('Student ID tidak sah.');
    }
    return 'AMIN-${withoutPrefix.substring(0, 5)}-${withoutPrefix.substring(5)}';
  }

  static String internalEmail(String studentId) {
    final normalized = normalize(studentId).toLowerCase().replaceAll('-', '');
    return '$normalized@amin.local';
  }

  static bool isValidPin(String pin) => RegExp(r'^\d{6}$').hasMatch(pin);
}

