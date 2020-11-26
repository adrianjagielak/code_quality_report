// ignore_for_file: flutter_style_todos

import 'dart:convert';
import 'dart:io';

// ignore: import_of_legacy_library_into_null_safe
import 'package:crypto/crypto.dart' as crypto show md5;

/// A Code Climate issue represents a single instance of a real
/// or potential code problem, detected by a static analysis Engine.
/// Specification: https://github.com/codeclimate/platform/blob/master/spec/analyzers/SPEC.md#issues
class Issue {
  Issue({
    required this.checkName,
    required this.description,
    required this.location,
    required this.severity,
    required this.fingerprint,
  });

  /// Dart Analysis Server Specification tells us that dartanalyzer produces
  /// machine output in format `AnalysisErrorSeverity`|`AnalysisErrorType`|
  /// `code`|`path`|`line`|`column`|`length`|`description` where:
  ///
  /// * `AnalysisErrorSeverity` is an enumeration of the possible severities
  /// of analysis errors (INFO, WARNING, or ERROR)
  /// * `AnalysisErrorType` is an enumeration of the possible types
  /// of analysis errors (CHECKED_MODE_COMPILE_TIME_ERROR, COMPILE_TIME_ERROR,
  /// HINT, LINT, STATIC_TYPE_WARNING, STATIC_WARNING, SYNTACTIC_ERROR, or TODO)
  /// * `code` is the name, as string, of the error code associated with
  /// this error.
  /// * `path` is the file containing the analysis error.
  /// * `line` is the one-based index of the line containing the first character
  /// of the range.
  /// * `column` is the offset of the range.
  /// * `length` is the length of the range.
  /// * `description` is the message to be displayed for this error. The message
  /// should indicate what is wrong with the code and why it is wrong.
  ///
  /// Dart Analysis Server API Specification: https://htmlpreview.github.io/?https://github.com/dart-lang/sdk/blob/master/pkg/analysis_server/doc/api.html
  factory Issue.fromAnalyzer(String analyzerLine) {
    List<String> segments = analyzerLine.split('|');

    int line = int.parse(segments[4]);
    int beginColumn = int.parse(segments[5]);
    int endColumn = beginColumn + int.parse(segments[6]);

    return Issue(
      severity: parseSeverity(segments[0]),
      checkName: segments[2],
      location: {
        'path': relativizePath(segments[3]),
        'positions': {
          'begin': {
            'line': line,
            'column': beginColumn,
          },
          'end': {
            'line': line,
            'column': endColumn,
          },
        },
      },
      description: segments[7],
      fingerprint: md5(analyzerLine),
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'check_name': checkName,
        'description': description,
        'location': location,
        'severity': severity,
        'fingerprint': fingerprint,
      };

  @override
  String toString() => jsonEncode(toJson());

  /// Must always be "issue".
  static const String type = 'issue';

  /// A unique name representing the static analysis check
  /// that emitted this issue.
  String checkName;

  /// A string explaining the issue that was detected.
  String description;

  /// A Location object representing the place in the source code
  /// where the issue was discovered.
  Map<String, dynamic> location;

  /// A Severity string (info, minor, major, critical, or blocker)
  /// describing the potential impact of the issue found.
  String severity;

  /// A unique, deterministic identifier for the specific issue
  /// being reported to allow a user to exclude it from future analyses.
  String fingerprint;
}

/// Map dartanalyzer severities to proper Code Climate severities. It is highly
/// subjective but following solution presents the most balanced approach.
String parseSeverity(String analyzerSeverity) {
  switch (analyzerSeverity) {
    case 'INFO':
      return 'info';
    case 'WARNING':
      return 'minor';
    case 'ERROR':
      return 'blocker';
  }

  return 'blocker';
}

/// Simple md5 hash of inputted [String]
String md5(String input) => crypto.md5.convert(utf8.encode(input)).toString();

/// Dart Analysis Server returns paths in absolute form so
/// we must to relativize it
String relativizePath(String input) {
  if (input.startsWith(Directory.current.path)) {
    return input.replaceFirst('${Directory.current.path}/', '');
  }

  return input;
}
