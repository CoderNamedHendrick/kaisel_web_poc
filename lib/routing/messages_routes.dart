part of 'router.dart';

/// [MessagesScreen] routes
sealed class MessagesRoute extends KaiselRoute {
  const MessagesRoute();
}

final class MessagesRoot extends MessagesRoute {
  const MessagesRoot();
}

/// A single conversation, addressed by its [chatId].
final class ChatDetail extends MessagesRoute {
  const ChatDetail(this.chatId);

  final String chatId;
}

/// Another player's profile, opened from within the Messages tab (e.g. by
/// tapping the header of a [ChatDetail]). Like [HomeUserProfile] it takes a
/// resolved [player] when available, otherwise a [userId] to fetch by.
final class ChatUserProfile extends MessagesRoute {
  const ChatUserProfile({required this.userId, this.player});

  final String userId;
  final Player? player;
}
