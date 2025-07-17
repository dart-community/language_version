A package for creating, parsing, comparing, and sharing
Dart [language versions](https://dart.dev/to/language-version).

## Installation

To use `package:language_version` and access its language version support,
first add it as a dependency in your `pubspec.yaml` file:

```shell
dart pub add language_version
```

## Usage

The package contains two built-in libraries:

- `package:language_version/language_version.dart`

  Provides the `LanguageVersion` type for
  creating and comparing language versions,
  as well as for sharing between libraries and packages.

- `package:language_version/parse.dart`

  Provides the `parseLanguageVersion` and `tryParseLanguageVersion` functions
  for parsing language version strings into `LanguageVersion` objects.

### Create language versions

You can manually create a `LanguageVersion` by
specifying a `major` and `minor` version number pair.

```dart
import 'package:language_version/language_version.dart';

// Create a language version for Dart 3.5:
final version = LanguageVersion(3, 5);

// Access the major and minor version numbers and the string representation:
print('Major version number: ${version.major}'); // Major version number: 3
print('Minor version number: ${version.minor}'); // Minor version number: 5
print('Language version: $version'); // Language version: 3.5
```

### Compare language versions

Language versions can be compared using the standard
equality and comparison operators:

```dart
final version2_12 = LanguageVersion(2, 12);
final version3_0 = LanguageVersion(3, 0);
final version3_5 = LanguageVersion(3, 5);

// Check for equality:
if (version2_12 != currentLanguageVersion) {
  print('$version2_12 is not the current language version.');
} else if (version2_12 == previousLanguageVersion) {
  print('$version2_12 was the previous language version.');
}

// Compare different language versions:
if (version3_0 > version2_12) {
  print('Language version $version3_0 is newer than $version2_12.');
}

if (version3_5 >= version3_0) {
  print('Language version $version3_5 is at least as new as $version3_0.');
}

// Check if a language version meets a minimum requirement:
final nullAwareElementsLanguageVersion = LanguageVersion(3, 8);
final currentLanguageVersion = LanguageVersion(3, 9);

if (currentLanguageVersion >= nullAwareElementsLanguageVersion) {
  print('Null-aware collection elements are supported!');
}

// Sort language versions with the compareTo function:
final versions = [version3_5, version2_12, version3_0];
versions.sort((a, b) => a.compareTo(b));
print(versions); // [2.12, 3.0, 3.5]
```

### Parse language version strings

To parse a language version from a string,
use the `parseLanguageVersion` function:

```dart
import 'package:language_version/parse.dart';

// Parse a valid version string.
final version = parseLanguageVersion('3.5');
print('Parsed language version: $version'); // Parsed version: 3.5

// An invalid format or invalid version numbers results
// in an exception being throw.
try {
  final invalidVersion = parseLanguageVersion('3.5.1');
} on LanguageVersionFormatException catch (e) {
  print('Invalid format: ${e.message}');
}
```

If you don't care about the reason for a parse failure,
you can use `tryParseLanguageVersion` which instead
returns `null` if the input is invalid:

```dart
import 'package:language_version/parse.dart';

final validVersionString = '2.19';
final validVersion = tryParseLanguageVersion(validVersionString);
if (validVersion != null) {
  print('Successfully parsed language version: "$validVersion".');
}

final invalidVersionString = 'invalid';
final invalidVersion = tryParseLanguageVersion(invalidVersionString);
if (invalidVersion == null) {
  print('Failed to parse language version from "$invalidVersionString".');
}

if (tryParseLanguageVersion('3.0') case final languageVersion?) {
  print('Parsed language version: $languageVersion');
} else {
  print('Failed to parse language version.');
}
```

### Combined example

Here's a larger example that demonstrates
extracting a language version from the current SDK,
then parsing and checking for language feature support:

```dart
import 'dart:io' show Platform;

import 'package:language_version/language_version.dart';
import 'package:language_version/parse.dart';

void main() {
  // Extract language version from the current SDK.
  final currentSdkVersion = Platform.version;
  final extractedLanguageVersion = currentSdkVersion
      .split('.')
      .take(2)
      .join('.');

  if (tryParseLanguageVersion(extractedLanguageVersion)
      case final languageVersion?) {
    print('Latest supported language version by this SDK: $languageVersion');

    // Check for null safety support.
    const nullSafetyVersion = LanguageVersion(2, 12);
    if (languageVersion >= nullSafetyVersion) {
      print('This SDK supports Dart code with null safety!');
    }

    // Check for other features.
    const wildcardsVersion = LanguageVersion(3, 7);
    if (languageVersion < wildcardsVersion) {
      print('This SDK does not support Dart code with wildcard variables.');
    }
  }
}
```


