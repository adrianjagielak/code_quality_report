// @dart=2.9

import 'dart:convert';
import 'dart:io';

import 'package:code_quality_report/code_quality_report.dart';

Future main() async {
  var lines = LineSplitter().bind(utf8.decoder.bind(stdin));

  stdout.write('[');

  int exitCode = 0;
  int lineCount = 0;

  await for (String line in lines) {
    if (lineCount > 0) {
      stdout.write(',');
    }

    try {
      stdout.write(Issue.fromAnalyzer(line));
    } catch (_) {
      stderr.writeln(line);
      exitCode = 1;
    }

    lineCount++;
  }

  stdout.write(']');

  exit(exitCode);
}
