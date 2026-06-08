import 'package:flutter/material.dart';
import 'package:kaisel/kaisel.dart';
import 'package:kaisel_router_poc/core/ui.dart';
import 'package:kaisel_router_poc/data/mock_data.dart';
import 'package:kaisel_router_poc/routing/routing.dart';

/// Read-only profile of another player on the platform.
///
/// Accepts either a fully-resolved [player] (passed straight through when the
/// caller already has the model) or a [userId] that is looked up in
/// [MockData]. At least one must be provided; [player] wins when both are.
/// Pushed onto a branch stack, so the [AppBar] gets an automatic back button.
class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key, this.player, this.userId})
    : assert(player != null || userId != null, 'Provide a player or a userId');

  final Player? player;
  final String? userId;

  /// Cross-branch navigation: switch to the Messages tab and open the
  /// conversation with [person]. This profile can be shown from any branch, so
  /// the Messages branch's own `RouterScope` isn't an ancestor here — instead
  /// drive the shell directly. `switchTo` updates `current` synchronously, then
  /// `restoreStack` sets that branch's stack (the same path the URL delegate
  /// uses to restore deep links).
  void _openChat(BuildContext context, Player person) {
    final chat = MockData.chatForPlayer(person.id);
    if (chat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No conversation with ${person.name} yet')),
      );
      return;
    }
    final shell = context.shell();
    shell.switchTo(3);
    shell.current.restoreStack([const MessagesRoot(), ChatDetail(chat.id)]);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final resolved = player ?? (userId != null ? MockData.personByIdOrNull(userId!) : null);

    if (resolved == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Center(child: Text('No player found for "$userId".')),
      );
    }

    final person = resolved;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(person.name, style: const TextStyle(fontWeight: FontWeight.w800)),
            actions: [IconButton(icon: const Icon(Icons.more_horiz), onPressed: () {})],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                children: [
                  PlayerAvatar(player: person, radius: 44),
                  const SizedBox(height: 12),
                  Text(
                    person.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.place_outlined, size: 16, color: scheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(person.location, style: TextStyle(color: scheme.onSurfaceVariant)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      Pill(
                        'NTRP ${person.ntrp}',
                        icon: Icons.military_tech,
                        color: scheme.onPrimaryContainer,
                        bg: scheme.primaryContainer,
                      ),
                      if (person.isCoach) const Pill('Coach', icon: Icons.school_outlined),
                      if (person.isOnline) const Pill('Online now', icon: Icons.circle, color: Color(0xFF43A047)),
                    ],
                  ),
                  if (person.bio != null) ...[
                    const SizedBox(height: 14),
                    Text(
                      person.bio!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: scheme.onSurfaceVariant),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _openChat(context, person),
                          icon: const Icon(Icons.chat_bubble_outline, size: 18),
                          label: const Text('Message'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Invited ${person.name} to play — coming soon')),
                          ),
                          icon: const Icon(Icons.sports_tennis, size: 18),
                          label: const Text('Invite to play'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: _PlayerStats(person)),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

class _PlayerStats extends StatelessWidget {
  const _PlayerStats(this.player);

  final Player player;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final stats = <(String, String)>[
      ('NTRP', '${player.ntrp}'),
      if (player.winRate != null) ('${player.winRate}%', player.isCoach ? 'Rating' : 'Win rate'),
      (player.isOnline ? 'Online' : 'Offline', 'Status'),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Card(
        color: scheme.surfaceContainerHigh,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (final (value, label) in stats)
                Column(
                  children: [
                    Text(
                      value,
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, color: scheme.primary),
                    ),
                    const SizedBox(height: 2),
                    Text(label, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
