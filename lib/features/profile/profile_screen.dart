import 'package:flutter/material.dart';
import 'package:kaisel_router_poc/core/ui.dart';
import 'package:kaisel_router_poc/data/mock_data.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final me = MockData.me;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            actions: [IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () {})],
            title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.w800)),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                children: [
                  PlayerAvatar(player: me, radius: 44),
                  const SizedBox(height: 12),
                  Text(
                    me.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.place_outlined, size: 16, color: scheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(me.location, style: TextStyle(color: scheme.onSurfaceVariant)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: [
                      Pill(
                        'NTRP ${me.ntrp}',
                        icon: Icons.military_tech,
                        color: scheme.onPrimaryContainer,
                        bg: scheme.primaryContainer,
                      ),
                      const Pill('Aggressive baseliner', icon: Icons.sports_tennis),
                      const Pill('Righty', icon: Icons.back_hand),
                    ],
                  ),
                  if (me.bio != null) ...[
                    const SizedBox(height: 14),
                    Text(
                      me.bio!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: scheme.onSurfaceVariant),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          label: const Text('Edit profile'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.share_outlined, size: 18),
                          label: const Text('Share'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: _StatsCard()),
          const SliverToBoxAdapter(child: SectionHeader('Achievements')),
          const SliverToBoxAdapter(child: _Achievements()),
          const SliverToBoxAdapter(child: SectionHeader('Account')),
          const SliverToBoxAdapter(child: _SettingsList()),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    const stats = [('52', 'Matches'), ('32', 'Wins'), ('62%', 'Win rate'), ('5', 'Streak')];
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

class _Achievements extends StatelessWidget {
  const _Achievements();

  @override
  Widget build(BuildContext context) {
    final items = MockData.achievements;
    return SizedBox(
      height: 104,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final a = items[i];
          return Container(
            width: 88,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: a.color.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(18)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: a.color.withValues(alpha: 0.18),
                  child: Icon(a.icon, color: a.color),
                ),
                const SizedBox(height: 8),
                Text(
                  a.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SettingsList extends StatelessWidget {
  const _SettingsList();

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.credit_card, 'Payment methods', 'Visa •••• 4242'),
      (Icons.notifications_outlined, 'Notifications', 'Match invites, reminders'),
      (Icons.shield_outlined, 'Privacy & safety', null),
      (Icons.help_outline, 'Help & support', null),
      (Icons.logout, 'Log out', null),
    ];
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        for (final (icon, title, subtitle) in items)
          ListTile(
            leading: Icon(icon, color: title == 'Log out' ? scheme.error : scheme.onSurfaceVariant),
            title: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w600, color: title == 'Log out' ? scheme.error : null),
            ),
            subtitle: subtitle == null ? null : Text(subtitle),
            trailing: title == 'Log out' ? null : Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
            onTap: () {},
          ),
      ],
    );
  }
}
