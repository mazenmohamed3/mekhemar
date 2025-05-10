import 'package:go_router/go_router.dart';

class LayoutController {
  void onDestinationSelected({
    required StatefulNavigationShell navigationShell,
    required int value,
  }) {
    navigationShell.goBranch(value);
  }
}