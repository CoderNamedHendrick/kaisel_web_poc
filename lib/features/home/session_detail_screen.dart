import 'package:flutter/material.dart';
import 'package:kaisel/kaisel.dart';
import 'package:kaisel_router_poc/core/ui.dart';
import 'package:kaisel_router_poc/data/mock_data.dart';
import 'package:kaisel_router_poc/routing/routing.dart';

/// Detail page for an [OpenSession], opened from the Home tab.
///
/// Accepts a resolved [session] when the caller has it, or a [sessionId] looked
/// up in [MockData] (the deep-link case).
class SessionDetailScreen extends StatelessWidget {
  const SessionDetailScreen({super.key, this.session, this.sessionId})
    : assert(session != null || sessionId != null, 'Provide a session or a sessionId');

  final OpenSession? session;
  final String? sessionId;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final resolved = session ?? (sessionId != null ? MockData.sessionById(sessionId!) : null);

    if (resolved == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Session')),
        body: Center(child: Text('No session found for "$sessionId".')),
      );
    }

    final s = resolved;
    return Scaffold(
      appBar: AppBar(title: Text(s.kind.label, style: const TextStyle(fontWeight: FontWeight.w800))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: scheme.surfaceContainerHigh,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              onTap: () => context.push(HomeUserProfile(userId: s.host.id, player: s.host)),
              leading: PlayerAvatar(player: s.host),
              title: Text(s.host.name, style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text('Host · NTRP ${s.host.ntrp}'),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
          const SizedBox(height: 16),
          _InfoRow(icon: Icons.place_outlined, label: 'Court', value: s.court),
          _InfoRow(icon: Icons.schedule, label: 'When', value: s.when),
          _InfoRow(icon: Icons.bar_chart, label: 'Skill range', value: s.skillRange),
          _InfoRow(
            icon: Icons.event_seat_outlined,
            label: 'Availability',
            value: '${s.spotsLeft} ${s.spotsLeft == 1 ? 'spot' : 'spots'} left',
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Joined ${s.kind.label} — coming soon')),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Join session'),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: scheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: scheme.onSurfaceVariant)),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
