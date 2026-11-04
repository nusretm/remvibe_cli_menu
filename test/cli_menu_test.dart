import 'dart:collection';

import 'package:remvibe_cli_menu/remvibe_cli_menu.dart';
import 'package:test/test.dart';

void main() {
  group('RemVibeCliRunner', () {
    test('opens a submenu, runs an action, returns, and exits', () async {
      final terminal = _ScriptedTerminal(['1', '1', 'B', 'X']);
      var selected = 0;

      final child = RemVibeCliMenu(
        title: 'AvukatPro',
        details: (_) => ['Proje kodu: avukatpro'],
        items: (_) => [
          RemVibeCliMenuItem(
            id: 'history',
            label: 'Sürüm geçmişi',
            onSelected: (_) => selected++,
          ),
        ],
      );
      final root = RemVibeCliMenu(
        title: 'Ana Menü',
        items: (_) => [
          RemVibeCliMenuItem(
            id: 'avukatpro',
            label: 'AvukatPro',
            marker: '*',
            onSelected: (context) => context.open(child),
          ),
        ],
      );

      await RemVibeCliRunner(terminal: terminal).run(root);

      expect(selected, 1);
      expect(terminal.output, contains('1. AvukatPro *'));
      expect(terminal.output, contains('Proje kodu: avukatpro'));
      expect(terminal.output, contains('B. Geri'));
      expect(terminal.output, contains('X. Çıkış'));
    });

    test('rebuilds dynamic entries after an asynchronous action', () async {
      final terminal = _ScriptedTerminal(['R', 'U', 'R', 'X']);
      var ready = false;
      var published = false;
      var builds = 0;

      final menu = RemVibeCliMenu(
        title: 'Proje',
        items: (_) async {
          builds++;
          return [
            if (!ready)
              RemVibeCliMenuItem(
                id: 'prepare',
                label: 'Hazırla',
                shortcut: 'U',
                onSelected: (context) async {
                  await Future<void>.delayed(Duration.zero);
                  ready = true;
                },
              ),
            if (ready)
              RemVibeCliMenuItem(
                id: 'publish',
                label: 'Yayınla',
                shortcut: 'R',
                marker: '*',
                onSelected: (context) => published = true,
              ),
          ];
        },
      );

      await RemVibeCliRunner(terminal: terminal).run(menu);

      expect(published, isTrue);
      expect(builds, greaterThanOrEqualTo(3));
      expect(terminal.output, contains('Geçersiz seçim.'));
      expect(terminal.output, contains('R. Yayınla *'));
    });

    test('hidden items do not consume numbers and disabled items are inert',
        () async {
      final terminal = _ScriptedTerminal(['1', '2', 'S', 'X']);
      var disabledCalls = 0;
      var numberCalls = 0;
      var shortcutCalls = 0;

      final menu = RemVibeCliMenu(
        title: 'Options',
        items: (_) => [
          RemVibeCliMenuItem(
            id: 'hidden',
            label: 'Hidden',
            visible: false,
            onSelected: (_) => fail('Hidden item selected'),
          ),
          RemVibeCliMenuItem(
            id: 'shortcut',
            label: 'Shortcut',
            shortcut: 's',
            onSelected: (_) => shortcutCalls++,
          ),
          RemVibeCliMenuItem(
            id: 'disabled',
            label: 'Disabled',
            enabled: false,
            onSelected: (_) => disabledCalls++,
          ),
          RemVibeCliMenuItem(
            id: 'number',
            label: 'Number',
            onSelected: (_) => numberCalls++,
          ),
        ],
      );

      await RemVibeCliRunner(terminal: terminal).run(menu);

      expect(disabledCalls, 0);
      expect(numberCalls, 1);
      expect(shortcutCalls, 1);
      expect(terminal.output, contains('1. Disabled (kullanılamıyor)'));
      expect(terminal.output, contains('2. Number'));
      expect(terminal.output, isNot(contains('Hidden')));
    });

    test('rejects duplicate and reserved shortcuts instead of dispatching',
        () async {
      final duplicate = _ScriptedTerminal([]);
      final duplicateMenu = RemVibeCliMenu(
        title: 'Duplicate',
        items: (_) => [
          RemVibeCliMenuItem(
            id: 'one',
            label: 'One',
            shortcut: 'U',
            onSelected: (_) {},
          ),
          RemVibeCliMenuItem(
            id: 'two',
            label: 'Two',
            shortcut: 'u',
            onSelected: (_) {},
          ),
        ],
      );
      await RemVibeCliRunner(terminal: duplicate).run(duplicateMenu);
      expect(duplicate.output, contains('Tekrar eden kısayol'));

      final reserved = _ScriptedTerminal([]);
      final reservedMenu = RemVibeCliMenu(
        title: 'Reserved',
        items: (_) => [
          RemVibeCliMenuItem(
            id: 'exit-override',
            label: 'Cannot override exit',
            shortcut: 'X',
            onSelected: (_) {},
          ),
        ],
      );
      await RemVibeCliRunner(terminal: reserved).run(reservedMenu);
      expect(reserved.output, contains('ayrılmış kısayol'));
    });

    test('shows action errors and keeps the menu alive', () async {
      final terminal = _ScriptedTerminal(['1', 'X']);
      var renders = 0;
      final menu = RemVibeCliMenu(
        title: 'Errors',
        items: (_) {
          renders++;
          return [
            RemVibeCliMenuItem(
              id: 'fail',
              label: 'Failure',
              onSelected: (_) => throw StateError('demo failure'),
            ),
          ];
        },
      );

      await RemVibeCliRunner(terminal: terminal).run(menu);

      expect(renders, 2);
      expect(terminal.output, contains('İşlem başarısız:'));
      expect(terminal.output, contains('demo failure'));
    });

    test('reports a failing builder without crashing', () async {
      final terminal = _ScriptedTerminal([]);
      final menu = RemVibeCliMenu(
        title: 'Failure',
        items: (_) => throw StateError('bad builder'),
      );

      await RemVibeCliRunner(terminal: terminal).run(menu);

      expect(terminal.output, contains('Menü yüklenemedi:'));
      expect(terminal.output, contains('bad builder'));
    });

    test('supports project name input and exits cleanly on EOF', () async {
      final terminal = _ScriptedTerminal(['1', 'Project Alpha', null]);
      String? projectName;
      final menu = RemVibeCliMenu(
        title: 'Add project',
        items: (_) => [
          RemVibeCliMenuItem(
            id: 'add',
            label: 'Proje Ekle',
            onSelected: (context) async {
              projectName = await context.ask('Proje adı: ');
            },
          ),
        ],
      );

      await RemVibeCliRunner(terminal: terminal).run(menu);

      expect(projectName, 'Project Alpha');
      expect(terminal.output, contains('Proje adı: '));
    });
  });
}

final class _ScriptedTerminal implements RemVibeCliTerminal {
  _ScriptedTerminal(List<String?> answers)
      : _answers = Queue<String?>.of(answers);

  final Queue<String?> _answers;
  final List<String> _lines = <String>[];

  String get output => _lines.join('\n');

  @override
  Future<String?> readLine(String prompt) async {
    _lines.add(prompt);
    return _answers.isEmpty ? null : _answers.removeFirst();
  }

  @override
  void writeLine(String text) => _lines.add(text);
}
