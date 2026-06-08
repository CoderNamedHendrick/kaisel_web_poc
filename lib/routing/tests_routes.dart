part of 'router.dart';

/// [TestsScreen] routes
sealed class TestsRoute extends KaiselRoute {
  const TestsRoute();
}

final class TestsRoot extends TestsRoute {
  const TestsRoot();

  @override
  bool operator ==(Object other) => identical(this, other) || other is TestsRoot && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// A single skill test's detail page, addressed by its [testId]. Carries a
/// resolved [test] when the caller has it (deep links pass id only).
final class TestDetail extends TestsRoute {
  const TestDetail({required this.testId, this.test});

  final String testId;
  final SkillTest? test;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestDetail && runtimeType == other.runtimeType && testId == other.testId && test == other.test;

  @override
  int get hashCode => Object.hash(testId, test);
}
