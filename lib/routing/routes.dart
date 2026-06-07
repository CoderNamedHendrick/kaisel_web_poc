part of 'router.dart';

sealed class PocAppRoute extends KaiselRoute {
  const PocAppRoute();
}

final class NavigationShellRoute extends PocAppRoute {
  const NavigationShellRoute();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NavigationShellRoute && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// Another player's profile, opened from within the Messages tab (e.g. by
/// tapping the header of a [ChatDetail]). Like [HomeUserProfile] it takes a
/// resolved [player] when available, otherwise a [userId] to fetch by.
final class ChatUserProfile extends PocAppRoute {
  const ChatUserProfile({required this.userId, this.player});

  final String userId;
  final Player? player;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatUserProfile &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          player == other.player;

  @override
  int get hashCode => Object.hash(userId, player);
}
