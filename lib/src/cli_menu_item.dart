import 'dart:async';

import 'cli_menu_context.dart';

/// Work performed after selecting an available item.
typedef RemVibeCliMenuAction =
    FutureOr<void> Function(RemVibeCliMenuContext context);

/// One selectable command in a [RemVibeCliMenu].
///
/// Items without an explicit [shortcut] receive automatic numeric keys.
/// The optional [marker] is presentation data supplied by the application,
/// not a built-in concept of package readiness or update availability.
final class RemVibeCliMenuItem {
  const RemVibeCliMenuItem({
    required this.id,
    required this.label,
    required this.onSelected,
    this.shortcut,
    this.marker,
    this.enabled = true,
    this.visible = true,
  });

  final String id;
  final String label;
  final RemVibeCliMenuAction onSelected;

  /// A single letter, other than the reserved B (back) and X (exit).
  final String? shortcut;

  /// Optional trailing marker such as '*'.
  final String? marker;

  /// Disabled items are rendered but cannot run actions.
  final bool enabled;

  /// Hidden items are not rendered and do not consume numeric keys.
  final bool visible;
}
