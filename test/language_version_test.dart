import 'package:language_version/language_version.dart';
import 'package:test/test.dart';

void main() {
  group('LanguageVersion', () {
    group('constants', () {
      test('minValue is 0', () {
        expect(LanguageVersion.minValue, equals(0));
      });

      test('maxValue is 0x7FFFFFFF', () {
        expect(LanguageVersion.maxValue, equals(0x7FFFFFFF));
      });
    });

    group('constructor', () {
      test('creates instance with valid major and minor versions', () {
        const version = LanguageVersion(2, 19);
        expect(version.major, equals(2));
        expect(version.minor, equals(19));
      });

      test('creates instance with minimum values', () {
        const version = LanguageVersion(
          LanguageVersion.minValue,
          LanguageVersion.minValue,
        );
        expect(version.major, equals(0));
        expect(version.minor, equals(0));
      });

      test('creates instance with maximum values', () {
        const version = LanguageVersion(
          LanguageVersion.maxValue,
          LanguageVersion.maxValue,
        );
        expect(version.major, equals(0x7FFFFFFF));
        expect(version.minor, equals(0x7FFFFFFF));
      });

      test('creates instance with mixed min/max values', () {
        const version1 = LanguageVersion(
          LanguageVersion.minValue,
          LanguageVersion.maxValue,
        );
        expect(version1.major, equals(0));
        expect(version1.minor, equals(0x7FFFFFFF));

        const version2 = LanguageVersion(
          LanguageVersion.maxValue,
          LanguageVersion.minValue,
        );
        expect(version2.major, equals(0x7FFFFFFF));
        expect(version2.minor, equals(0));
      });

      test('errors with negative major version', () {
        expect(
          () => LanguageVersion(-1, 0),
          throwsA(isA<AssertionError>()),
        );
      });

      test('error with negative minor version', () {
        expect(
          () => LanguageVersion(0, -1),
          throwsA(isA<AssertionError>()),
        );
      });

      test('errors with major version exceeding maxValue', () {
        expect(
          () => LanguageVersion(LanguageVersion.maxValue + 1, 0),
          throwsA(isA<AssertionError>()),
        );
      });

      test('errors with minor version exceeding maxValue', () {
        expect(
          () => LanguageVersion(0, LanguageVersion.maxValue + 1),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    group('toString', () {
      test('formats version as major.minor', () {
        expect(const LanguageVersion(2, 19).toString(), equals('2.19'));
        expect(const LanguageVersion(3, 0).toString(), equals('3.0'));
        expect(const LanguageVersion(0, 0).toString(), equals('0.0'));
        expect(const LanguageVersion(10, 5).toString(), equals('10.5'));
      });

      test('formats edge case values correctly', () {
        expect(
          const LanguageVersion(
            LanguageVersion.maxValue,
            LanguageVersion.maxValue,
          ).toString(),
          equals('2147483647.2147483647'),
        );
      });
    });

    group('compareTo', () {
      test('returns 0 for equal versions', () {
        const v1 = LanguageVersion(2, 19);
        const v2 = LanguageVersion(2, 19);
        expect(v1.compareTo(v2), equals(0));
      });

      test('compares by major version first', () {
        const v1 = LanguageVersion(3, 0);
        const v2 = LanguageVersion(2, 19);
        expect(v1.compareTo(v2), isPositive);
        expect(v2.compareTo(v1), isNegative);
      });

      test('compares by minor version when major versions are equal', () {
        const v1 = LanguageVersion(2, 20);
        const v2 = LanguageVersion(2, 19);
        expect(v1.compareTo(v2), isPositive);
        expect(v2.compareTo(v1), isNegative);
      });

      test('handles edge cases correctly', () {
        const min = LanguageVersion(
          LanguageVersion.minValue,
          LanguageVersion.minValue,
        );
        const max = LanguageVersion(
          LanguageVersion.maxValue,
          LanguageVersion.maxValue,
        );
        expect(min.compareTo(max), isNegative);
        expect(max.compareTo(min), isPositive);
        expect(min.compareTo(min), isZero);
        expect(max.compareTo(max), isZero);
      });
    });

    group('equality and hashCode', () {
      test('equal versions are equal', () {
        const v1 = LanguageVersion(2, 19);
        const v2 = LanguageVersion(2, 19);
        expect(v1, equals(v2));
        expect(v1.hashCode, equals(v2.hashCode));
      });

      test('identical instances are equal', () {
        const v1 = LanguageVersion(2, 19);
        expect(v1, equals(v1));
      });

      test('versions with different major versions are not equal', () {
        const v1 = LanguageVersion(2, 19);
        const v2 = LanguageVersion(3, 19);
        expect(v1, isNot(equals(v2)));
        expect(v1.hashCode, isNot(equals(v2.hashCode)));
      });

      test('versions with different minor versions are not equal', () {
        const v1 = LanguageVersion(2, 19);
        const v2 = LanguageVersion(2, 20);
        expect(v1, isNot(equals(v2)));
        expect(v1.hashCode, isNot(equals(v2.hashCode)));
      });

      test('version is not equal to non-LanguageVersion objects', () {
        const version = LanguageVersion(2, 19);
        expect(version, isNot(equals('2.19')));
        expect(version, isNot(equals(219)));
        expect(version, isNot(equals(null)));
      });
    });

    group('comparison operators', () {
      const v1_0 = LanguageVersion(1, 0);
      const v1_5 = LanguageVersion(1, 5);
      const v2_0 = LanguageVersion(2, 0);
      const v2_5 = LanguageVersion(2, 5);

      group('< operator', () {
        test('returns true when less than', () {
          expect(v1_0 < v2_0, isTrue);
          expect(v1_0 < v1_5, isTrue);
          expect(v1_5 < v2_0, isTrue);
        });

        test('returns false when equal or greater', () {
          expect(v2_0 < v1_0, isFalse);
          expect(v1_0 < v1_0, isFalse);
          expect(v2_5 < v2_0, isFalse);
        });
      });

      group('<= operator', () {
        test('returns true when less than or equal', () {
          expect(v1_0 <= v2_0, isTrue);
          expect(v1_0 <= v1_5, isTrue);
          expect(v1_0 <= v1_0, isTrue);
        });

        test('returns false when greater', () {
          expect(v2_0 <= v1_0, isFalse);
          expect(v2_5 <= v2_0, isFalse);
        });
      });

      group('> operator', () {
        test('returns true when greater than', () {
          expect(v2_0 > v1_0, isTrue);
          expect(v1_5 > v1_0, isTrue);
          expect(v2_0 > v1_5, isTrue);
        });

        test('returns false when equal or less', () {
          expect(v1_0 > v2_0, isFalse);
          expect(v1_0 > v1_0, isFalse);
          expect(v2_0 > v2_5, isFalse);
        });
      });

      group('>= operator', () {
        test('returns true when greater than or equal', () {
          expect(v2_0 >= v1_0, isTrue);
          expect(v1_5 >= v1_0, isTrue);
          expect(v1_0 >= v1_0, isTrue);
        });

        test('returns false when less', () {
          expect(v1_0 >= v2_0, isFalse);
          expect(v2_0 >= v2_5, isFalse);
        });
      });

      test('operators work with edge values', () {
        const min = LanguageVersion(
          LanguageVersion.minValue,
          LanguageVersion.minValue,
        );
        const max = LanguageVersion(
          LanguageVersion.maxValue,
          LanguageVersion.maxValue,
        );

        expect(min < max, isTrue);
        expect(min <= max, isTrue);
        expect(max > min, isTrue);
        expect(max >= min, isTrue);

        expect(min >= min, isTrue);
        expect(min <= min, isTrue);
        expect(max >= max, isTrue);
        expect(max <= max, isTrue);
      });
    });
  });
}
