part of 'router.dart';

/// [TestsScreen] routes
final class TestsRoute extends KaiselRoute {
  const TestsRoute();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestsRoute && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

final class TestsRoot extends TestsRoute {
  const TestsRoot();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestsRoot && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}
