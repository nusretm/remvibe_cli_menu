import 'cli_menu.dart';
import 'cli_menu_context.dart';
import 'cli_menu_item.dart';
import 'cli_terminal.dart';

/// Executes nested CLI menus until the user exits or stdin closes.
///
/// No terminal clearing or raw keyboard mode is required. Actions and menu
/// builders can be asynchronous. Each completed action triggers a fresh render.
final class RemVibeCliRunner {
  RemVibeCliRunner({RemVibeCliTerminal? terminal})
      : _terminal = terminal ?? const RemVibeCliStdTerminal();

  final RemVibeCliTerminal _terminal;

  Future<void> run(RemVibeCliMenu root) async {
    final session = _MenuSession(_terminal, root);
    while (!session._exited) {
      final menu = session._current;
      List<RemVibeCliMenuItem> items;
      List<String> details;

      try {
        details = menu.details == null
            ? const <String>[]
            : await menu.details!(session);
        items = await menu.items(session);
      } catch (error) {
        _terminal.writeLine('Menü yüklenemedi: $error');
        if (session._hasParent) {
          session.back();
        } else {
          session.exit();
        }
        continue;
      }

      if (session._exited || !identical(menu, session._current)) {
        continue;
      }

      late final Map<String, RemVibeCliMenuItem> commands;
      try {
        commands = _commandsFor(items);
      } on ArgumentError catch (error) {
        _terminal.writeLine('Geçersiz menü tanımı: $error');
        if (session._hasParent) {
          session.back();
        } else {
          session.exit();
        }
        continue;
      }

      _terminal.writeLine('');
      _terminal.writeLine('=== ${menu.title} ===');
      for (final line in details) {
        _terminal.writeLine(line);
      }
      if (details.isNotEmpty) {
        _terminal.writeLine('');
      }

      for (final entry in commands.entries) {
        final item = entry.value;
        final marker = (item.marker?.isNotEmpty ?? false)
            ? ' ${item.marker}'
            : '';
        final unavailable = item.enabled ? '' : ' (kullanılamıyor)';
        _terminal.writeLine(
          '${entry.key}. ${item.label}$marker$unavailable',
        );
      }
      if (session._hasParent) {
        _terminal.writeLine('B. Geri');
      }
      _terminal.writeLine('X. Çıkış');

      final answer = await _terminal.readLine('Seçim: ');
      if (answer == null) {
        session.exit();
        continue;
      }

      final key = answer.trim().toUpperCase();
      if (key == 'X') {
        session.exit();
        continue;
      }
      if (key == 'B' && session._hasParent) {
        session.back();
        continue;
      }

      final selected = commands[key];
      if (selected == null) {
        _terminal.writeLine('Geçersiz seçim.');
        continue;
      }
      if (!selected.enabled) {
        _terminal.writeLine('Bu seçenek şu anda kullanılamıyor.');
        continue;
      }
      try {
        await selected.onSelected(session);
      } catch (error) {
        _terminal.writeLine('İşlem başarısız: $error');
      }
    }
  }

  static Map<String, RemVibeCliMenuItem> _commandsFor(
    List<RemVibeCliMenuItem> items,
  ) {
    final result = <String, RemVibeCliMenuItem>{};
    final ids = <String>{};
    var nextNumber = 1;

    for (final item in items.where((entry) => entry.visible)) {
      if (item.id.trim().isEmpty || !ids.add(item.id)) {
        throw ArgumentError('Öğe kimliği boş veya tekrar ediyor: ${item.id}');
      }
      if (item.label.trim().isEmpty) {
        throw ArgumentError('Öğe başlığı boş: ${item.id}');
      }
      final shortcut = item.shortcut;
      final key = shortcut == null
          ? '${nextNumber++}'
          : shortcut.toUpperCase();
      if (shortcut != null &&
          (!RegExp(r'^[A-Za-z]$').hasMatch(shortcut) ||
              key == 'B' ||
              key == 'X')) {
        throw ArgumentError('Geçersiz veya ayrılmış kısayol: $shortcut');
      }
      if (result.containsKey(key)) {
        throw ArgumentError('Tekrar eden kısayol: $key');
      }
      result[key] = item;
    }
    return result;
  }
}

final class _MenuSession implements RemVibeCliMenuContext {
  _MenuSession(this._terminal, RemVibeCliMenu root)
      : _stack = <RemVibeCliMenu>[root];

  final RemVibeCliTerminal _terminal;
  final List<RemVibeCliMenu> _stack;
  bool _exited = false;

  RemVibeCliMenu get _current => _stack.last;
  bool get _hasParent => _stack.length > 1;

  @override
  void open(RemVibeCliMenu menu) => _stack.add(menu);

  @override
  void back() {
    if (_hasParent) {
      _stack.removeLast();
    }
  }

  @override
  void exit() => _exited = true;

  @override
  void writeLine(String text) => _terminal.writeLine(text);
}
