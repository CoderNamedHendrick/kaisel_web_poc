import 'package:flutter/material.dart';
import 'package:kaisel/kaisel.dart';
import 'package:kaisel_router_poc/core/ui.dart';
import 'package:kaisel_router_poc/data/mock_data.dart';
import 'package:kaisel_router_poc/routing/routing.dart';

/// A single conversation, resolved from its [chatId] via [MockData].
///
/// Tapping the header opens the other player's profile (pushed onto the
/// Messages branch as a [ChatUserProfile]).
class ChatDetailScreen extends StatelessWidget {
  const ChatDetailScreen({super.key, required this.chatId});

  final String chatId;

  @override
  Widget build(BuildContext context) {
    final chat = MockData.chatById(chatId);

    if (chat == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Conversation')),
        body: Center(child: Text('No conversation found for "$chatId".')),
      );
    }

    final player = chat.player;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(onPressed: context.pop, icon: const Icon(Icons.arrow_back)),
        automaticallyImplyLeading: false,
        title: InkWell(
          // Open the profile by id only — exercises the fetch-by-id path of
          // UserProfileScreen rather than passing the model through.
          onTap: () => context.push(ChatUserProfile(userId: player.id)),
          child: Row(
            children: [
              PlayerAvatar(player: player, radius: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      player.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    Text(
                      player.isOnline ? 'Online' : 'NTRP ${player.ntrp}',
                      style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [IconButton(icon: const Icon(Icons.videocam_outlined), onPressed: () {})],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
              itemCount: chat.messages.length,
              itemBuilder: (context, i) => _MessageBubble(chat.messages[i]),
            ),
          ),
          const _Composer(),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble(this.message);

  final Message message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fromMe = message.fromMe;
    final bg = fromMe ? scheme.primary : scheme.surfaceContainerHighest;
    final fg = fromMe ? scheme.onPrimary : scheme.onSurface;

    return Align(
      alignment: fromMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.72),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(fromMe ? 18 : 4),
            bottomRight: Radius.circular(fromMe ? 4 : 18),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.text, style: TextStyle(color: fg)),
            const SizedBox(height: 2),
            Text(message.time, style: TextStyle(fontSize: 10, color: fg.withValues(alpha: 0.7))),
          ],
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text('Message…', style: TextStyle(color: scheme.onSurfaceVariant)),
              ),
            ),
            const SizedBox(width: 8),
            FloatingActionButton.small(onPressed: () {}, elevation: 0, child: const Icon(Icons.send)),
          ],
        ),
      ),
    );
  }
}
