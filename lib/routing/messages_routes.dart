part of 'router.dart';

/// [MessagesScreen] routes
sealed class MessagesRoute extends KaiselRoute {
  const MessagesRoute();
}

final class MessagesRoot extends MessagesRoute {
  const MessagesRoot();

  @override
  bool operator ==(Object other) => identical(this, other) || other is MessagesRoot && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// A single conversation, addressed by its [chatId].
final class ChatDetail extends MessagesRoute {
  const ChatDetail(this.chatId);

  final String chatId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ChatDetail && runtimeType == other.runtimeType && chatId == other.chatId;

  @override
  int get hashCode => chatId.hashCode;
}

/// Another player's profile, opened from within the Messages tab (e.g. by
/// tapping the header of a [ChatDetail]). Like [HomeUserProfile] it takes a
/// resolved [player] when available, otherwise a [userId] to fetch by.
final class ChatUserProfile extends MessagesRoute {
  const ChatUserProfile({required this.userId, this.player});

  final String userId;
  final Player? player;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatUserProfile && runtimeType == other.runtimeType && userId == other.userId && player == other.player;

  @override
  int get hashCode => Object.hash(userId, player);
}
