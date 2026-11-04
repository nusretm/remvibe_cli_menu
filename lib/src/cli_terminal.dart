import 'dart:io';

/// Input/output boundary for terminal menus.
///
/// Inject a fake implementation to test navigation without interactive stdin.
abstract interface class RemVibeCliTerminal {
  Future<String?> readLine(String prompt);
  void writeLine(String text);
}

/// Standard terminal backed by stdin and stdout.
final class RemVibeCliStdTerminal implements RemVibeCliTerminal {
  const RemVibeCliStdTerminal();

  @override
  Future<String?> readLine(String prompt) async {
    stdout.write(prompt);
    return stdin.readLineSync();
  }

  @override
  void writeLine(String text) => stdout.writeln(text);
}
