import 'dart:io' show Platform;

import 'package:language_version/language_version.dart';
import 'package:language_version/parse.dart';

void main() {
  final currentSdkVersion = Platform.version;
  final extractedLanguageVersion = currentSdkVersion
      .split('.')
      .map((part) => part.trim())
      .take(2)
      .join('.');

  if (tryParseLanguageVersion(extractedLanguageVersion)
      case final languageVersion?) {
    final LanguageVersion(:major, :minor) = languageVersion;
    print(
      'The latest language version supported by the current SDK has '
      'major version $major and minor version $minor.',
    );

    if (languageVersion.supportsNullSafety) {
      print('It supports null safety.');
    } else {
      print('It does not support null safety.');
    }
  } else {
    print(
      'Failed to extract a valid language version from '
      "the SDK version '$currentSdkVersion'.",
    );
  }
}

extension on LanguageVersion {
  /// Whether this Dart [LanguageVersion] supports null safety.
  bool get supportsNullSafety => this >= const LanguageVersion(2, 12);
}
