import 'dart:math';

import 'package:aminapp/shared/progress/domain/student_identity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('generated Student ID is normalized and child-friendly', () {
    final id = StudentIdentity.generate(Random(7));

    expect(id, matches(RegExp(r'^AMIN-[0-9A-HJKMNP-TV-Z]{5}-[0-9A-HJKMNP-TV-Z]{5}$')));
    expect(StudentIdentity.normalize(id.toLowerCase()), id);
    expect(StudentIdentity.internalEmail(id), endsWith('@amin.local'));
  });

  test('Student ID normalization rejects ambiguous and malformed IDs', () {
    expect(() => StudentIdentity.normalize('AMIN-ILOU0-12345'), throwsFormatException);
    expect(() => StudentIdentity.normalize('AMIN-123'), throwsFormatException);
  });

  test('Recovery PIN is exactly six digits', () {
    expect(StudentIdentity.isValidPin('123456'), isTrue);
    expect(StudentIdentity.isValidPin('12345'), isFalse);
    expect(StudentIdentity.isValidPin('12345A'), isFalse);
  });
}
