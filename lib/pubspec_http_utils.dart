import 'dart:io';
import 'package:html/parser.dart';
import 'package:http/io_client.dart';
import 'package:pubspec_helper/pubspce_rule_check.dart';
import 'package:pubspec_helper/pubspec_ansi_utils.dart';

IOClient baseClient() {
  HttpClient httpClient = HttpClient();
  IOClient myClient = IOClient(httpClient);
  return myClient;
}

Future<void> getHttp(String libName) async {
  writeAnsi("----------------------------------------", c: AnsiColor.green);
  writeAnsi("Package: $libName");
  writeAnsi("----------------------------------------", c: AnsiColor.green);
  var myClient = baseClient();
  var resp = await myClient
      .get(Uri.parse("https://pub.dev/packages/$libName"))
      .timeout(const Duration(seconds: 10));

  if (resp.statusCode == 200) {
    final html = parse(resp.body.toString());

    var publisher =
        html.getElementsByClassName("-pub-publisher").first.text.toString();

    var timeAgo = html.getElementsByClassName("-x-ago").first.text;
    var likesCnt = html.getElementById("likes-count")?.text.toString();

    var badges =
        html.getElementsByClassName("package-badge").first.text.toString();

    var issuesLink = html
        .getElementsByTagName("a")
        .firstWhere((e) => e.innerHtml.toString() == "View/report issues")
        .attributes["href"];
    writeAnsi("publisher: $publisher");

    var update = updateCheck(timeAgo);

    writeAnsi(
        "$timeAgo ${update == RuleType.normal ? "✅" : update == RuleType.warning ? "⚠️" : "❌"}",
        c: update == RuleType.normal
            ? AnsiColor.green
            : update == RuleType.warning
                ? AnsiColor.yellow
                : AnsiColor.red);
    writeAnsi("$likesCnt likes");
    writeAnsi(badges,
        c: badges.startsWith("in") ? AnsiColor.red : AnsiColor.green);
    var issues = await getIssues(issuesLink.toString());

    var issueCheck = openIssueCheck(issues);
    writeAnsi(issues,
        c: issueCheck == RuleType.normal
            ? AnsiColor.green
            : issueCheck == RuleType.warning
                ? AnsiColor.yellow
                : AnsiColor.red);
  } else {
    writeAnsi(
        "pub.dev is not responding for $libName and status code is ${resp.statusCode}",
        c: AnsiColor.red);
  }
}

Future<String> getIssues(String link) async {
  var myClient = baseClient();
  var resp =
      await myClient.get(Uri.parse(link)).timeout(const Duration(seconds: 10));

  if (resp.statusCode == 200) {
    final html = parse(resp.body.toString());
    var issues = html
        .querySelectorAll(
            "#repo-content-pjax-container > div > div.d-block.d-lg-none.no-wrap > div")
        .first
        .text
        .trim()
        .replaceAll(" ", "")
        .replaceAll("\n", "")
        .replaceAll("Open", " Open, ")
        .replaceAll("Closed", " Closed");

    //
    return issues;
  } else {
    writeAnsi("Github is not responding", c: AnsiColor.red);
    return "";
  }
}
