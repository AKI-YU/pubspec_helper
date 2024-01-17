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

  bool isStart = false;
  List<String> rtn = [];
  for (int i = 0; i < content.split("\n").length; i++) {
    if (content.split("\n")[i].trim().startsWith("dependencies")) {
      isStart = true;
      continue;
    }
    if (isStart &&
        content.split("\n")[i].trim().split(":").length == 2 &&
        content.split("\n")[i].trim().split(":")[1].contains(".")) {
      rtn.add(content.split("\n")[i].trim().split(":")[0].trim());
    }

    if (isStart &&
        content.split("\n")[i] != "" &&
        !content.split("\n")[i].startsWith("  ")) {
      isStart = false;
    }
  }

  if (rtn.isEmpty) {
    writeAnsi("Could not find dependencies in pubspec.yaml", c: AnsiColor.red);
    exit(0);
  }

  for (String e in rtn) {
    if (e.trim().startsWith("#") || e.trim().isEmpty) {
      continue;
    }
    await getHttp(e.split(":")[0].trim());
    print("\n");
  }
  exit(0);
}
