import 'package:meta/meta.dart';

import 'language_version.dart';

/// Parses and returns a [LanguageVersion] from
/// the specified [source] language version string.
///
/// Throws an [LanguageVersionFormatException] exception if
/// [source] isn't able to be parsed as a valid language version.
///
/// A language version string contains a major version number and
/// a minor version number separated by a full stop character (`.`):
///
/// ```none
/// <majorVersionNumber>.<minorVersionNumber>
/// ```
///
/// To be considered valid and parse successfully:
///
/// - Each version number must be a non-negative, decimal integer.
/// - Each version number must be within the range of
///   [LanguageVersion.minValue] and [LanguageVersion.maxValue].
/// - Each version number must not have unnecessary leading zeroes (`0`),
///   besides the singular value of `0`.
/// - There must not be spaces or other characters in the string.
@useResult
LanguageVersion parseLanguageVersion(String source) {
  if (source.isEmpty) {
    throw LanguageVersionFormatException(
      'Language version can\'t be empty',
      source: source,
      offset: 0,
    );
  }

  var sourceIndex = 0;
  final majorStart = sourceIndex;

  // Verify that the first character of the major version is a digit.
  if (sourceIndex >= source.length ||
      _isNotDigit(source.codeUnitAt(sourceIndex))) {
    throw LanguageVersionFormatException(
      'Expected digit at start of major version',
      source: source,
      offset: sourceIndex,
    );
  }

  // Check if the first major version digit is a 0.
  final hasLeadingZero = source.codeUnitAt(sourceIndex) == _digit0;
  sourceIndex++;

  // Continue reading while there are digits.
  while (sourceIndex < source.length &&
      _isDigit(source.codeUnitAt(sourceIndex))) {
    sourceIndex++;
  }

  final majorVersionString = source.substring(majorStart, sourceIndex);

  // Verify that the major version doesn't have unnecessary leading zeroes.
  if (hasLeadingZero && majorVersionString.length > 1) {
    throw LanguageVersionFormatException(
      'Major version has unnecessary leading zeros',
      source: source,
      offset: majorStart,
    );
  }

  // Verify that the first character after the
  // major version number is a dot (`.`).
  if (sourceIndex >= source.length || source.codeUnitAt(sourceIndex) != _dot) {
    throw LanguageVersionFormatException(
      'Expected "." after major version',
      source: source,
      offset: sourceIndex,
    );
  }

  // Skip past the dot.
  sourceIndex++;

  final minorVersionStartIndex = sourceIndex;

  // Verify that the first character of the minor version is a digit.
  if (sourceIndex >= source.length ||
      _isNotDigit(source.codeUnitAt(sourceIndex))) {
    throw LanguageVersionFormatException(
      'Expected digit at start of minor version',
      source: source,
      offset: sourceIndex,
    );
  }

  // Check if the first minor version digit is a 0.
  final minorVersionHasLeadingZero = source.codeUnitAt(sourceIndex) == _digit0;
  sourceIndex++;

  // Continue reading while there are digits.
  while (sourceIndex < source.length &&
      _isDigit(source.codeUnitAt(sourceIndex))) {
    sourceIndex++;
  }

  final minorVersionString = source.substring(
    minorVersionStartIndex,
    sourceIndex,
  );

  // Verify that the minor version doesn't have unnecessary leading zeroes.
  if (minorVersionHasLeadingZero && minorVersionString.length > 1) {
    throw LanguageVersionFormatException(
      'Minor version has unnecessary leading zeros',
      source: source,
      offset: minorVersionStartIndex,
    );
  }

  // Verify that the minor version isn't followed by
  // any extra non-digit characters.
  if (sourceIndex < source.length) {
    throw LanguageVersionFormatException(
      'Unexpected character after minor version',
      source: source,
      offset: sourceIndex,
    );
  }

  // We can assume these parse without error as we would have
  // already thrown an error if they weren't integers.
  final majorVersion = int.parse(majorVersionString);
  final minorVersion = int.parse(minorVersionString);

  // Verify that the major version is within the allowed range.
  if (majorVersion < LanguageVersion.minValue ||
      majorVersion > LanguageVersion.maxValue) {
    throw LanguageVersionFormatException(
      'Major version must be '
      'between ${LanguageVersion.minValue} and ${LanguageVersion.maxValue}',
      source: source,
      offset: majorStart,
    );
  }

  // Verify that the minor version is within the allowed range.
  if (minorVersion < LanguageVersion.minValue ||
      minorVersion > LanguageVersion.maxValue) {
    throw LanguageVersionFormatException(
      'Minor version must be '
      'between ${LanguageVersion.minValue} and ${LanguageVersion.maxValue}',
      source: source,
      offset: minorVersionStartIndex,
    );
  }

  return LanguageVersion(majorVersion, minorVersion);
}

/// Parses and returns a [LanguageVersion] from
/// the specified [source] language version string.
///
/// Returns `null` if [source] isn't able to be
/// parsed as a valid language version.
///
/// To learn what constitutes a valid language version string,
/// reference the docs for [parseLanguageVersion].
///
/// If you need more information about why [source] isn't valid,
/// consider using [parseLanguageVersion] instead.
@useResult
LanguageVersion? tryParseLanguageVersion(String source) {
  try {
    return parseLanguageVersion(source);
  } on LanguageVersionFormatException {
    // Purposefully ignore LanguageVersionFormatException.
    return null;
  }
}

/// Exception thrown when a string didn't have the
/// expected format of a [LanguageVersion] string and
/// therefore can't be successfully parsed or created.
final class LanguageVersionFormatException implements FormatException {
  /// A message describing the cause of the exception.
  @override
  final String message;

  /// The entire input string that failed to be parsed.
  @override
  final String source;

  /// The offset in [source] where the error occurred.
  @override
  final int offset;

  /// Creates a new [LanguageVersionFormatException] with
  /// the specified [message] reported at the specified [offset] in [source].
  @visibleForTesting
  const LanguageVersionFormatException(
    this.message, {
    required this.source,
    required this.offset,
  });

  /// Returns a description of this exception
  @override
  String toString() =>
      'LanguageVersionFormatException: $message (at character ${offset + 1})';
}

/// The code unit of the digit '0'.
const int _digit0 = 0x30; // '0'

/// The code unit of the digit '9'.
const int _digit9 = 0x39; // '9'

/// The code unit of the full stop character (`.`).
const int _dot = 0x2E; // '.'

/// Returns `true` if the specified [codeUnit] is a digit (`0` - `9`).
bool _isDigit(int codeUnit) => codeUnit >= _digit0 && codeUnit <= _digit9;

/// Returns `true` if the specified [codeUnit] is **not** a digit (`0` - `9`).
bool _isNotDigit(int codeUnit) => !_isDigit(codeUnit);
