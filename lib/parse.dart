/// A library for parsing
/// Dart [language versions](https://dart.dev/to/language-version) in
/// string form.
///
/// Provides [parseLanguageVersion] and [tryParseLanguageVersion] to
/// parse Dart language version strings in to [LanguageVersion] objects.
///
/// @docImport 'language_version.dart';
library;

import 'src/parse.dart';

export 'src/parse.dart'
    show
        LanguageVersionFormatException,
        parseLanguageVersion,
        tryParseLanguageVersion;
