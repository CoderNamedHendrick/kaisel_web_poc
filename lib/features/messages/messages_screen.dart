import 'package:flutter/material.dart';
import 'package:kaisel/kaisel.dart';
import 'package:kaisel_router_poc/core/ui.dart';
import 'package:kaisel_router_poc/data/mock_data.dart';
import 'package:kaisel_router_poc/routing/routing.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key, this.selectedChatId});

  final String? selectedChatId;

  @override
  Widget build(BuildContext context) {
    final chats = MockData.chats;
    final totalUnread = chats.fold<int>(0, (sum, c) => sum + c.unread);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [IconButton(icon: const Icon(Icons.edit_square), onPressed: () {})],
      ),
      body: Column(
        children: [
          if (totalUnread > 0)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Pill('$totalUnread unread', icon: Icons.mark_chat_unread),
              ),
            ),
          Expanded(
            child: ListView.separated(
              itemCount: chats.length,
              separatorBuilder: (_, _) => const Divider(height: 1, indent: 84, endIndent: 16),
              itemBuilder: (context, i) => _ChatTile(chats[i], selectedChatId == chats[i].id),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.chat_bubble_outline)),
    );
  }
}

class _ChatTile extends StatelessWidget {
  const _ChatTile(this.chat, this.selected);

  final Chat chat;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hasUnread = chat.unread > 0;
    return ListTile(
      tileColor: selected ? scheme.onSecondaryContainer : null,
      onTap: () => context.router<MessagesRoute>().pushOrReplaceTop(ChatDetail(chat.id)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: PlayerAvatar(player: chat.player, radius: 26),
      title: Row(
        children: [
          Expanded(
            child: Text(
              chat.player.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Text(
            chat.time,
            style: TextStyle(
              fontSize: 12,
              color: hasUnread ? scheme.primary : scheme.onSurfaceVariant,
              fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                chat.lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: hasUnread ? scheme.onSurface : scheme.onSurfaceVariant,
                  fontWeight: hasUnread ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (hasUnread)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.all(6),
                constraints: const BoxConstraints(minWidth: 22),
                decoration: BoxDecoration(color: scheme.primary, shape: BoxShape.circle),
                child: Text(
                  '${chat.unread}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
