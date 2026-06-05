part of 'router.dart';

sealed class PocAppRoute extends KaiselRoute {
  const PocAppRoute();
}

final class NavigationShellRoute extends PocAppRoute {
  const NavigationShellRoute();
}
