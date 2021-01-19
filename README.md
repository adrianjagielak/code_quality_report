Code Quality Report
============

[![Pub](https://img.shields.io/pub/v/code_quality_report.svg)](https://pub.dev/packages/code_quality_report)

* [Introduction](#introduction)
* [Installation](#installation)
* [License and contributors](#license-and-contributors)

Introduction
------------

This application can be used to convert the results of dartanalyzer to Code Climate json reports. These JSON reports can then be used by other tools like GitLab CI.

By running

```Shell
dartanalyzer . --format=machine 2>&1 | tocodeclimate > code-quality-report.json
```

this program will generate 'code-quality-report.json' containing JSON containing list of Code Climate issues as in [specification](https://github.com/codeclimate/platform/blob/master/spec/analyzers/SPEC.md#issues).

Installation
------------

Run `pub global activate code_quality_report` to download the program and make a launch script available: `<dart-cache>/bin/tojunit`.

If the `<dart-cache>/bin` directory is not on your path, you will get a warning, including tips on how to fix it.

Once the directory is on your path you should be able to pipe dartanalyzer output to this program.

License and contributors
------------------------

* The MIT License, see [LICENSE](https://github.com/adrianjagielak/code_quality_report/raw/master/LICENSE).
* For contributors, see [AUTHORS](https://github.com/adrianjagielak/code_quality_report/raw/master/AUTHORS).