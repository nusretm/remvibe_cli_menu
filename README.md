# RemVibe CLI Menu

A minimal, reusable **Dart CLI menu** package for Windows, Linux and macOS terminal applications. No Flutter, GitHub, RemVibe Update Center or external terminal UI dependency.

> **Checkpoint CLI-1:** Feature branch implementation under review. Not yet squash-merged or validated on a user's Windows machine.

## What it does

- Builds menu entries **each time a menu is rendered** (sync or async).
- Assigns `1`, `2`, ... to visible items without a shortcut.
- Supports explicit case-insensitive letter shortcuts, such as `U`, `R`, `S`, and `A`. `B` is reserved for Back and `X` for Exit.
- Opens child menus, returns to their parent, or exits.
- Shows application-supplied status markers such as `*`, disabled/hidden items and optional detail lines.
- Runs asynchronous actions and provides simple free-form terminal prompting.
- Lets tests inject their own terminal without touching `stdin`/`stdout`; malformed choices, actions and builder errors are handled without a crash.

## Quick start

From the repository root:

```powershell
dart pub get
dart analyze
dart test
dart run example/bin/main.dart
```

The example **simulates** a RemVibe Update Center menu. It does not contact GitHub, package updates, persist added projects or publish releases.

Example navigation:

```text
=== RemVibe Update Center (CLI Menu Demo) ===
1. AvukatPro *
2. MTN Launcher
3. Proje Ekle
X. Çıkış
Seçim: 1

=== AvukatPro ===
Proje kodu : avukatpro
İşletim sistemleri : Windows, Linux, macOS
Yayınlanan son sürüm : demo veri (GitHub bağlantısı yok)
Yayın tarihi : demo veri (GitHub bağlantısı yok)

R. Güncelleme paketini yayınla
S. Sürüm geçmişi
B. Geri
X. Çıkış
```

## Consumer API

```dart
import 'package:remvibe_cli_menu/remvibe_cli_menu.dart';

Future<void> main() async {
  var ready = false;

  final menu = RemVibeCliMenu(
    title: 'Project',
    details: (_) => ['Code: sample'],
    items: (_) => [
      if (!ready)
        RemVibeCliMenuItem(
          id: 'prepare',
          label: 'Prepare update',
          shortcut: 'U',
          onSelected: (context) async {
            // Real application preparation goes here.
            ready = true;
          },
        ),
      if (ready)
        RemVibeCliMenuItem(
          id: 'publish',
          label: 'Publish',
          shortcut: 'R',
          marker: '*',
          onSelected: (context) => context.writeLine('Ready for publishing'),
        ),
    ],
  );

  await RemVibeCliRunner().run(menu);
}
```

An action may call `context.open(otherMenu)`, `context.back()`, `context.exit()`, `context.writeLine(message)` or `await context.ask(prompt)`. The runner redraws the current menu after each action.

## Source layout

```text
lib/remvibe_cli_menu.dart  public exports
lib/src/                menu, items, context, terminal and runner
example/bin/main.dart   manually runnable Update Center-like demo
test/                   scripted terminal navigation tests
docs/                   working rules and continuity
.github/workflows/      analyzer/test CI
```

Development process and live verification evidence: [current target](docs/continuity/CURRENT_TARGET.md), [working rules](docs/WORKING_RULES.md). This standalone menu package remains domain-agnostic; real Update Center functionality belongs in `nusretm/remvibe_update_center`.
