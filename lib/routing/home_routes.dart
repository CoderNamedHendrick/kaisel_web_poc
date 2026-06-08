part of 'router.dart';

/// [HomeScreen] routes
sealed class HomeRoute extends KaiselRoute {
  const HomeRoute();
}

final class HomeRoot extends HomeRoute {
  const HomeRoot();

  @override
  bool operator ==(Object other) => identical(this, other) || other is HomeRoot && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// Another player's profile, opened from the Home tab.
///
/// Accepts a fully-resolved [player] when the caller already has the model
/// (avoids a redundant lookup), or just a [userId] to fetch it by — the case
/// that also backs deep links, where only the id survives in the URL.
final class HomeUserProfile extends HomeRoute {
  const HomeUserProfile({required this.userId, this.player});

  final String userId;
  final Player? player;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeUserProfile && runtimeType == other.runtimeType && userId == other.userId && player == other.player;

  @override
  int get hashCode => Object.hash(userId, player);
}

/// A court's detail page, opened from the Home tab. Carries a resolved [court]
/// when the caller has it, or just a [courtId] to fetch by (the deep-link case).
final class HomeCourtDetail extends HomeRoute {
  const HomeCourtDetail({required this.courtId, this.court});

  final String courtId;
  final Court? court;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeCourtDetail &&
          runtimeType == other.runtimeType &&
          courtId == other.courtId &&
          court == other.court;

  @override
  int get hashCode => Object.hash(courtId, court);
}

/// An open session's detail page, opened from the Home tab. Carries a resolved
/// [session] when available, or just a [sessionId] to fetch by (deep links).
final class HomeSessionDetail extends HomeRoute {
  const HomeSessionDetail({required this.sessionId, this.session});

  final String sessionId;
  final OpenSession? session;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeSessionDetail &&
          runtimeType == other.runtimeType &&
          sessionId == other.sessionId &&
          session == other.session;

  @override
  int get hashCode => Object.hash(sessionId, session);
}
