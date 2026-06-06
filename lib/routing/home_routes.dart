part of 'router.dart';

/// [HomeScreen] routes
sealed class HomeRoute extends KaiselRoute {
  const HomeRoute();
}

final class HomeRoot extends HomeRoute {
  const HomeRoot();
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
  bool operator ==(Object other) => other is HomeUserProfile && other.userId == userId;

  @override
  int get hashCode => userId.hashCode;
}
