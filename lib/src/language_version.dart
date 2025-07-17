import 'package:meta/meta.dart';

/// A Dart language version.
///
/// A Dart [language version](https://dart.dev/to/language-version) is
/// defined by the combination of a non-negative [major] and [minor] version.
@immutable
abstract final class LanguageVersion implements Comparable<LanguageVersion> {
  /// The minimum value that the [major] and [minor] version numbers can have.
  static const int minValue = 0;

  /// The maximum value that the [major] and [minor] version numbers can have.
  static const int maxValue = 0x7FFFFFFF;

  /// Creates a new [LanguageVersion] with
  /// the specified [major] and [minor] versions.
  ///
  /// The [major] and [minor] versions must be
  /// equal to or greater than [minValue] (`0`) and
  /// less than or equal to [maxValue] (`0x7FFFFFFF`).
  const factory LanguageVersion(int major, int minor) = _DartLanguageVersion;

  /// The major version (`x.0`) of this language version.
  ///
  /// Must be equal to or greater than [minValue] (`0`) and
  /// less than or equal to [maxValue] (`0x7FFFFFFF`).
  @useResult
  int get major;

  /// The minor version (`0.x`) of this language version.
  ///
  /// Must be equal to or greater than [minValue] (`0`) and
  /// less than or equal to [maxValue] (`0x7FFFFFFF`).
  @useResult
  int get minor;

  @mustBeOverridden
  @override
  @useResult
  String toString();

  /// Compares this language version to the [other] language version.
  ///
  /// Returns `0` if `this` language version should be
  /// considered equal to the [other] language version.
  ///
  /// Returns a negative integer if `this` language version should be
  /// considered as earlier than the [other] language version.
  ///
  /// Returns a positive integer if `this` language version should be
  /// considered as later than the [other] language version.
  ///
  /// ---
  ///
  /// Two languages versions are considered equal if they
  /// have the same major and minor version numbers.
  ///
  /// If they're not equal, a language version is considered as
  /// later or greater than another in the two following cases:
  ///
  /// - The former's major version number is greater than
  ///   the latter's major version number.
  /// - Both language versions have the same major version and
  ///   the former's minor version number is greater than
  ///   the latter's minor version number.
  @override
  @useResult
  int compareTo(LanguageVersion other);

  @mustBeOverridden
  @override
  @useResult
  int get hashCode;

  @mustBeOverridden
  @override
  @useResult
  bool operator ==(Object other);

  /// Whether this language version is
  /// less than the [other] language version.
  ///
  /// To learn how language versions are compared,
  /// reference the docs for [LanguageVersion.compareTo].
  @useResult
  bool operator <(LanguageVersion other);

  /// Whether this language version is
  /// less than or equal to the [other] language version.
  ///
  /// To learn how language versions are compared,
  /// reference the docs for [LanguageVersion.compareTo].
  @useResult
  bool operator <=(LanguageVersion other);

  /// Whether this language version is
  /// greater than the [other] language version.
  ///
  /// To learn how language versions are compared,
  /// reference the docs for [LanguageVersion.compareTo].
  @useResult
  bool operator >(LanguageVersion other);

  /// Whether this language version is
  /// greater than or equal to the [other] language version.
  ///
  /// To learn how language versions are compared,
  /// reference the docs for [LanguageVersion.compareTo].
  @useResult
  bool operator >=(LanguageVersion other);
}

final class _DartLanguageVersion implements LanguageVersion {
  @override
  final int major;

  @override
  final int minor;

  const _DartLanguageVersion(this.major, this.minor)
    : assert(major >= LanguageVersion.minValue),
      assert(major <= LanguageVersion.maxValue),
      assert(minor >= LanguageVersion.minValue),
      assert(minor <= LanguageVersion.maxValue);

  @override
  String toString() => '$major.$minor';

  @override
  int compareTo(LanguageVersion other) {
    final otherMajor = other.major;
    final majorComparisons = major.compareTo(otherMajor);
    if (majorComparisons != 0) {
      return majorComparisons;
    }

    final otherMinor = other.minor;
    final minorComparisons = minor.compareTo(otherMinor);

    return minorComparisons;
  }

  @override
  int get hashCode => Object.hash(major, minor);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LanguageVersion &&
          major == other.major &&
          minor == other.minor);

  @override
  bool operator <(LanguageVersion other) => compareTo(other) < 0;

  @override
  bool operator <=(LanguageVersion other) => compareTo(other) <= 0;

  @override
  bool operator >(LanguageVersion other) => compareTo(other) > 0;

  @override
  bool operator >=(LanguageVersion other) => compareTo(other) >= 0;
}
