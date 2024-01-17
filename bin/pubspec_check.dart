import 'dart:io';

import 'package:args/args.dart';
import 'package:pubspec_helper/pubspec_ansi_utils.dart';
import 'package:pubspec_helper/pubspec_http_utils.dart';

const lineNumber = 'line-number';

//
//warning:
//  1. without updates over 6 months
//  2. open more than 20
//error:
//  1. incompatible
//  2. open more than 50
//  3. without updates over 1 year

void main(List<String> arguments) async {
  exitCode = 0;

  final parser = ArgParser()
    ..addOption('path',
        abbr: 'p', defaultsTo: "pubspec.yaml", help: 'path of pubspec.yaml');

  var results = parser.parse(arguments);
  String filePath = results['path'];

  final file = File(filePath);
  final content = file.readAsStringSync();

  if (content.isEmpty) {
    writeAnsi("pubspec.yaml is empty", c: AnsiColor.red);
    exit(0);
  }
  //get dependencies including version and name
  RegExp exp = RegExp(
      r"(dependencies:(?:\n\s+(?:(?:#.*\n)?\s+(\w+):\s+(\^\d+\.\d+\.\d+)))+)");
  var rtn =
      exp.stringMatch(content).toString().replaceAll("dependencies:\n", "");

  if (rtn.isEmpty) {
    writeAnsi("Could not find dependencies in pubspec.yaml", c: AnsiColor.red);
    exit(0);
  }
  for (String e in rtn.split("\n")) {
    if (e.trim().startsWith("#")) {
      continue;
    }
    await getHttp(e.split(":")[0].trim());
    print("\n");
  }
  exit(0);
}
