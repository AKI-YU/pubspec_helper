import 'dart:io';

bool get supportsAnsiColor => stdout.supportsAnsiEscapes;

enum AnsiColor { white, red, green, yellow }

writeAnsi(String msg, {AnsiColor c = AnsiColor.white}) {
  if (!supportsAnsiColor || c == AnsiColor.white) {
    print(msg);
    return;
  }
  final sb = StringBuffer();

  sb.write(
      '\x1B[38;5;${(c == AnsiColor.red ? "1" : (c == AnsiColor.green ? "2" : "3"))}m');
  sb.write(msg);
  sb.write("\x1B[39m");
  print(sb.toString());
}
