import 'cli_menu.dart';

/// Navigation and output operations available to menu actions.
///
/// After an action completes, the active menu is rebuilt automatically.
abstract interface class RemVibeCliMenuContext {
  /// Opens a child menu, which can later return to the current menu.
  void open(RemVibeCliMenu menu);

  /// Returns to the parent menu, if one exists.
  void back();

  /// Ends the current CLI menu session.
  void exit();

  /// Prints a message to the current terminal.
  void writeLine(String text);
}
