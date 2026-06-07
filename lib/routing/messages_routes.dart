part of 'router.dart';

/// [MessagesScreen] routes
sealed class MessagesRoute extends KaiselRoute {
  const MessagesRoute();
}

final class MessagesRoot extends MessagesRoute {
  const MessagesRoot();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessagesRoot && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// A single conversation, addressed by its [chatId].
final class ChatDetail extends MessagesRoute {
  const ChatDetail(this.chatId);

  final String chatId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatDetail &&
          runtimeType == other.runtimeType &&
          chatId == other.chatId;

  @override
  int get hashCode => chatId.hashCode;
}
