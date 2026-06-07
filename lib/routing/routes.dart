part of 'router.dart';

sealed class PocAppRoute extends KaiselRoute {
  const PocAppRoute();
}

final class NavigationShellRoute extends PocAppRoute {
  const NavigationShellRoute();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is NavigationShellRoute && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}


