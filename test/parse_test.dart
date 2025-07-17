import 'package:language_version/language_version.dart';
import 'package:language_version/parse.dart';
import 'package:test/test.dart';

void main() {
  group('parseLanguageVersion', () {
    group('valid inputs', () {
      test('parses simple valid version', () {
        final version = parseLanguageVersion('2.19');
        expect(version.major, equals(2));
        expect(version.minor, equals(19));
      });

      test('parses version with single digits', () {
        final version = parseLanguageVersion('1.0');
        expect(version.major, equals(1));
        expect(version.minor, equals(0));
      });

      test('parses version with multiple digits', () {
        final version = parseLanguageVersion('123.456');
        expect(version.major, equals(123));
        expect(version.minor, equals(456));
      });

      test('parses version with zero values', () {
        final version = parseLanguageVersion('0.0');
        expect(version.major, equals(0));
        expect(version.minor, equals(0));
      });

      test('parses maximum allowed values', () {
        const maxValue = LanguageVersion.maxValue;
        final version = parseLanguageVersion('$maxValue.$maxValue');
        expect(version.major, equals(maxValue));
        expect(version.minor, equals(maxValue));
      });
    });

    group('empty string', () {
      test('throws exception for empty string', () {
        expect(
          () => parseLanguageVersion(''),
          throwsA(
            isA<LanguageVersionFormatException>()
                .having(
                  (e) => e.message,
                  'message',
                  equals('Language version can\'t be empty'),
                )
                .having((e) => e.source, 'source', equals(''))
                .having((e) => e.offset, 'offset', equals(0)),
          ),
        );
      });
    });

    group('major version errors', () {
      test('throws exception when major version missing', () {
        expect(
          () => parseLanguageVersion('.5'),
          throwsA(
            isA<LanguageVersionFormatException>()
                .having(
                  (e) => e.message,
                  'message',
                  equals('Expected digit at start of major version'),
                )
                .having((e) => e.source, 'source', equals('.5'))
                .having((e) => e.offset, 'offset', equals(0)),
          ),
        );
      });

      test('throws exception when major version starts with non-digit', () {
        expect(
          () => parseLanguageVersion('a.5'),
          throwsA(
            isA<LanguageVersionFormatException>()
                .having(
                  (e) => e.message,
                  'message',
                  equals('Expected digit at start of major version'),
                )
                .having((e) => e.source, 'source', equals('a.5'))
                .having((e) => e.offset, 'offset', equals(0)),
          ),
        );
      });

      test('throws exception for leading zeros in major version', () {
        expect(
          () => parseLanguageVersion('01.5'),
          throwsA(
            isA<LanguageVersionFormatException>()
                .having(
                  (e) => e.message,
                  'message',
                  equals('Major version has unnecessary leading zeros'),
                )
                .having((e) => e.source, 'source', equals('01.5'))
                .having((e) => e.offset, 'offset', equals(0)),
          ),
        );
      });

      test('throws exception for multiple leading zeros in major version', () {
        expect(
          () => parseLanguageVersion('001.5'),
          throwsA(
            isA<LanguageVersionFormatException>()
                .having(
                  (e) => e.message,
                  'message',
                  equals('Major version has unnecessary leading zeros'),
                )
                .having((e) => e.source, 'source', equals('001.5'))
                .having((e) => e.offset, 'offset', equals(0)),
          ),
        );
      });

      test('throws exception when major version above maximum', () {
        const aboveMax = LanguageVersion.maxValue + 1;
        expect(
          () => parseLanguageVersion('$aboveMax.0'),
          throwsA(
            isA<LanguageVersionFormatException>()
                .having(
                  (e) => e.message,
                  'message',
                  equals(
                    'Major version must be between '
                    '${LanguageVersion.minValue} and '
                    '${LanguageVersion.maxValue}',
                  ),
                )
                .having((e) => e.source, 'source', equals('$aboveMax.0'))
                .having((e) => e.offset, 'offset', equals(0)),
          ),
        );
      });
    });

    group('dot separator errors', () {
      test('throws exception when dot is missing', () {
        expect(
          () => parseLanguageVersion('25'),
          throwsA(
            isA<LanguageVersionFormatException>()
                .having(
                  (e) => e.message,
                  'message',
                  equals('Expected "." after major version'),
                )
                .having((e) => e.source, 'source', equals('25'))
                .having((e) => e.offset, 'offset', equals(2)),
          ),
        );
      });

      test('throws exception when dot is replaced with other character', () {
        expect(
          () => parseLanguageVersion('2,5'),
          throwsA(
            isA<LanguageVersionFormatException>()
                .having(
                  (e) => e.message,
                  'message',
                  equals('Expected "." after major version'),
                )
                .having((e) => e.source, 'source', equals('2,5'))
                .having((e) => e.offset, 'offset', equals(1)),
          ),
        );
      });

      test('throws exception when space instead of dot', () {
        expect(
          () => parseLanguageVersion('2 5'),
          throwsA(
            isA<LanguageVersionFormatException>()
                .having(
                  (e) => e.message,
                  'message',
                  equals('Expected "." after major version'),
                )
                .having((e) => e.source, 'source', equals('2 5'))
                .having((e) => e.offset, 'offset', equals(1)),
          ),
        );
      });
    });

    group('minor version errors', () {
      test('throws exception when minor version missing', () {
        expect(
          () => parseLanguageVersion('2.'),
          throwsA(
            isA<LanguageVersionFormatException>()
                .having(
                  (e) => e.message,
                  'message',
                  equals('Expected digit at start of minor version'),
                )
                .having((e) => e.source, 'source', equals('2.'))
                .having((e) => e.offset, 'offset', equals(2)),
          ),
        );
      });

      test('throws exception when minor version starts with non-digit', () {
        expect(
          () => parseLanguageVersion('2.a'),
          throwsA(
            isA<LanguageVersionFormatException>()
                .having(
                  (e) => e.message,
                  'message',
                  equals('Expected digit at start of minor version'),
                )
                .having((e) => e.source, 'source', equals('2.a'))
                .having((e) => e.offset, 'offset', equals(2)),
          ),
        );
      });

      test('throws exception for leading zeros in minor version', () {
        expect(
          () => parseLanguageVersion('2.01'),
          throwsA(
            isA<LanguageVersionFormatException>()
                .having(
                  (e) => e.message,
                  'message',
                  equals('Minor version has unnecessary leading zeros'),
                )
                .having((e) => e.source, 'source', equals('2.01'))
                .having((e) => e.offset, 'offset', equals(2)),
          ),
        );
      });

      test('throws exception for multiple leading zeros in minor version', () {
        expect(
          () => parseLanguageVersion('2.001'),
          throwsA(
            isA<LanguageVersionFormatException>()
                .having(
                  (e) => e.message,
                  'message',
                  equals('Minor version has unnecessary leading zeros'),
                )
                .having((e) => e.source, 'source', equals('2.001'))
                .having((e) => e.offset, 'offset', equals(2)),
          ),
        );
      });

      test('throws exception when minor version above maximum', () {
        const aboveMax = LanguageVersion.maxValue + 1;
        expect(
          () => parseLanguageVersion('0.$aboveMax'),
          throwsA(
            isA<LanguageVersionFormatException>()
                .having(
                  (e) => e.message,
                  'message',
                  equals(
                    'Minor version must be between '
                    '${LanguageVersion.minValue} and '
                    '${LanguageVersion.maxValue}',
                  ),
                )
                .having((e) => e.source, 'source', equals('0.$aboveMax'))
                .having((e) => e.offset, 'offset', equals(2)),
          ),
        );
      });
    });

    group('unexpected characters', () {
      test('throws exception for trailing characters', () {
        expect(
          () => parseLanguageVersion('2.5abc'),
          throwsA(
            isA<LanguageVersionFormatException>()
                .having(
                  (e) => e.message,
                  'message',
                  equals('Unexpected character after minor version'),
                )
                .having((e) => e.source, 'source', equals('2.5abc'))
                .having((e) => e.offset, 'offset', equals(3)),
          ),
        );
      });

      test('throws exception for trailing space', () {
        expect(
          () => parseLanguageVersion('2.5 '),
          throwsA(
            isA<LanguageVersionFormatException>()
                .having(
                  (e) => e.message,
                  'message',
                  equals('Unexpected character after minor version'),
                )
                .having((e) => e.source, 'source', equals('2.5 '))
                .having((e) => e.offset, 'offset', equals(3)),
          ),
        );
      });

      test('throws exception for leading space', () {
        expect(
          () => parseLanguageVersion(' 2.5'),
          throwsA(
            isA<LanguageVersionFormatException>()
                .having(
                  (e) => e.message,
                  'message',
                  equals('Expected digit at start of major version'),
                )
                .having((e) => e.source, 'source', equals(' 2.5'))
                .having((e) => e.offset, 'offset', equals(0)),
          ),
        );
      });

      test('throws exception for embedded spaces', () {
        expect(
          () => parseLanguageVersion('2 . 5'),
          throwsA(
            isA<LanguageVersionFormatException>()
                .having(
                  (e) => e.message,
                  'message',
                  equals('Expected "." after major version'),
                )
                .having((e) => e.source, 'source', equals('2 . 5'))
                .having((e) => e.offset, 'offset', equals(1)),
          ),
        );
      });

      test('throws exception for multiple dots', () {
        expect(
          () => parseLanguageVersion('2.5.1'),
          throwsA(
            isA<LanguageVersionFormatException>()
                .having(
                  (e) => e.message,
                  'message',
                  equals('Unexpected character after minor version'),
                )
                .having((e) => e.source, 'source', equals('2.5.1'))
                .having((e) => e.offset, 'offset', equals(3)),
          ),
        );
      });

      test('throws exception for special characters', () {
        expect(
          () => parseLanguageVersion('2.5-beta'),
          throwsA(
            isA<LanguageVersionFormatException>()
                .having(
                  (e) => e.message,
                  'message',
                  equals('Unexpected character after minor version'),
                )
                .having((e) => e.source, 'source', equals('2.5-beta'))
                .having((e) => e.offset, 'offset', equals(3)),
          ),
        );
      });
    });
  });

  group('tryParseLanguageVersion', () {
    test('returns LanguageVersion for valid input', () {
      final version = tryParseLanguageVersion('2.19');
      expect(version, isNotNull);
      expect(version!.major, equals(2));
      expect(version.minor, equals(19));
    });

    test('returns null for empty string', () {
      final version = tryParseLanguageVersion('');
      expect(version, isNull);
    });

    test('returns null for invalid major version', () {
      final version = tryParseLanguageVersion('a.5');
      expect(version, isNull);
    });

    test('returns null for missing dot', () {
      final version = tryParseLanguageVersion('25');
      expect(version, isNull);
    });

    test('returns null for invalid minor version', () {
      final version = tryParseLanguageVersion('2.a');
      expect(version, isNull);
    });

    test('returns null for leading zeros', () {
      final version1 = tryParseLanguageVersion('01.5');
      expect(version1, isNull);

      final version2 = tryParseLanguageVersion('1.05');
      expect(version2, isNull);
    });

    test('returns null for trailing characters', () {
      final version = tryParseLanguageVersion('2.5abc');
      expect(version, isNull);
    });

    test('returns null for version above maximum', () {
      const aboveMax = LanguageVersion.maxValue + 1;
      final version = tryParseLanguageVersion('$aboveMax.0');
      expect(version, isNull);
    });

    test('returns same result as parseLanguageVersion for valid inputs', () {
      final testCases = ['0.0', '1.0', '2.19', '123.456'];

      for (final testCase in testCases) {
        final parsed = parseLanguageVersion(testCase);
        final tryParsed = tryParseLanguageVersion(testCase);

        expect(tryParsed, isNotNull);
        expect(tryParsed!.major, equals(parsed.major));
        expect(tryParsed.minor, equals(parsed.minor));
      }
    });
  });

  group('LanguageVersionFormatException', () {
    test('implements FormatException', () {
      const exception = LanguageVersionFormatException(
        'Test message',
        source: 'test source',
        offset: 5,
      );

      expect(exception, isA<FormatException>());
    });

    test('stores message, source, and offset correctly', () {
      const exception = LanguageVersionFormatException(
        'Test message',
        source: 'test source',
        offset: 5,
      );

      expect(exception.message, equals('Test message'));
      expect(exception.source, equals('test source'));
      expect(exception.offset, equals(5));
    });

    test('toString formats correctly', () {
      const exception = LanguageVersionFormatException(
        'Test message',
        source: 'test source',
        offset: 5,
      );

      expect(
        exception.toString(),
        equals(
          'LanguageVersionFormatException: '
          'Test message (at character 6)',
        ),
      );
    });

    test('toString shows correct character position (1-indexed)', () {
      const exception1 = LanguageVersionFormatException(
        'Error at start',
        source: 'source',
        offset: 0,
      );
      expect(
        exception1.toString(),
        equals(
          'LanguageVersionFormatException: '
          'Error at start (at character 1)',
        ),
      );

      const exception2 = LanguageVersionFormatException(
        'Error at position 10',
        source: 'source',
        offset: 9,
      );
      expect(
        exception2.toString(),
        equals(
          'LanguageVersionFormatException: '
          'Error at position 10 (at character 10)',
        ),
      );
    });
  });
}
