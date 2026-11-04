import 'dart:async';

import 'cli_menu_context.dart';
import 'cli_menu_item.dart';

/// Returns the currently available menu items.
///
/// The builder runs each time the menu is displayed. The application owns all
/// domain state and decides which items, markers and actions are available.
typedef RemVibeCliMenuItemsBuilder =
    FutureOr<List<RemVibeCliMenuItem>> Function(RemVibeCliMenuContext context);

/// Optional lines displayed below the menu title.
typedef RemVibeCliMenuDetailsBuilder =
    FutureOr<List<String>> Function(RemVibeCliMenuContext context);

/// A dynamically rendered menu with optional project/application details.
final class RemVibeCliMenu {
  const RemVibeCliMenu({
    required this.title,
    required this.items,
    this.details,
  });

  final String title;
  final RemVibeCliMenuItemsBuilder items;
  final RemVibeCliMenuDetailsBuilder? details;
}
