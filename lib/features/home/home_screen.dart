import 'package:flutter/material.dart';
import 'package:kaisel/kaisel.dart';
import 'package:kaisel_router_poc/core/ui.dart';
import 'package:kaisel_router_poc/data/mock_data.dart';
import 'package:kaisel_router_poc/routing/routing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 132,
            backgroundColor: scheme.surface,
            actions: [
              IconButton(icon: const Icon(Icons.tune), onPressed: () {}),
              const SizedBox(width: 4),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.sports_tennis, color: scheme.primary, size: 22),
                  const SizedBox(width: 8),
                  const Text('RallyUp', style: TextStyle(fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: _Greeting()),
          const SliverToBoxAdapter(child: _SearchBar()),
          const SliverToBoxAdapter(child: _StatsRow()),
          const SliverToBoxAdapter(child: SectionHeader('Open sessions near you', action: 'See all')),
          SliverToBoxAdapter(child: _OpenSessions()),
          const SliverToBoxAdapter(child: SectionHeader('Top courts nearby', action: 'Map')),
          SliverToBoxAdapter(child: _CourtsList()),
          const SliverToBoxAdapter(child: SectionHeader('Players looking for a match')),
          _PlayersSliver(),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Row(
        children: [
          PlayerAvatar(player: MockData.me, radius: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Good morning,', style: t.bodyMedium?.copyWith(color: Theme.of(context).hintColor)),
                Text(MockData.me.name.split(' ').first, style: t.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          Pill('NTRP ${MockData.me.ntrp}', icon: Icons.military_tech),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: scheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Icon(Icons.search, color: scheme.onSurfaceVariant),
            const SizedBox(width: 12),
            Text('Search courts, players, coaches…', style: TextStyle(color: scheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    const stats = [
      ('Matches', '52', Icons.sports_tennis),
      ('Win rate', '62%', Icons.trending_up),
      ('Streak', '5', Icons.local_fire_department),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          for (final (label, value, icon) in stats)
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: label == 'Streak' ? 0 : 12),
                child: _StatCard(label: label, value: value, icon: icon),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value, required this.icon});
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(color: scheme.primaryContainer, borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          Icon(icon, color: scheme.onPrimaryContainer, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, color: scheme.onPrimaryContainer),
          ),
          Text(label, style: TextStyle(fontSize: 12, color: scheme.onPrimaryContainer)),
        ],
      ),
    );
  }
}

class _OpenSessions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sessions = MockData.openSessions;
    return SizedBox(
      height: 168,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: sessions.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, i) => _SessionCard(sessions[i]),
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard(this.session);
  final OpenSession session;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: scheme.primaryContainer,
                child: Icon(session.kind.icon, size: 18, color: scheme.onPrimaryContainer),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(session.kind.label, style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.place_outlined, size: 15, color: scheme.onSurfaceVariant),
              const SizedBox(width: 4),
              Expanded(child: Text(session.court, maxLines: 1, overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.schedule, size: 15, color: scheme.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(session.when),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Pill(session.skillRange),
              const Spacer(),
              Text(
                '${session.spotsLeft} spot left',
                style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w700, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CourtsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final courts = MockData.courts;
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: courts.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, i) => _CourtCard(courts[i]),
      ),
    );
  }
}

class _CourtCard extends StatelessWidget {
  const _CourtCard(this.court);
  final Court court;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 220,
      child: Card(
        color: scheme.surfaceContainerHigh,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 96,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: court.gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -10,
                    bottom: -10,
                    child: Icon(Icons.sports_tennis, size: 80, color: Colors.white.withValues(alpha: 0.18)),
                  ),
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Pill(
                      court.surface.label,
                      icon: court.surface.icon,
                      color: Colors.white,
                      bg: Colors.black.withValues(alpha: 0.25),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    court.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, size: 14, color: Colors.amber.shade700),
                      const SizedBox(width: 2),
                      Text('${court.rating}', style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      Icon(Icons.place_outlined, size: 13, color: scheme.onSurfaceVariant),
                      Expanded(
                        child: Text(
                          ' ${court.distanceKm} km',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${court.pricePerHour}/hr',
                    style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayersSliver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final players = MockData.players;
    return SliverList.builder(itemCount: players.length, itemBuilder: (context, i) => _PlayerTile(players[i]));
  }
}

class _PlayerTile extends StatelessWidget {
  const _PlayerTile(this.player);
  final Player player;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      // Pass the resolved model straight through — no id lookup needed.
      onTap: () => context.push(HomeUserProfile(userId: player.id, player: player)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: PlayerAvatar(player: player),
      title: Text(player.name, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text('NTRP ${player.ntrp} · ${player.location}'),
      trailing: FilledButton.tonal(
        style: FilledButton.styleFrom(visualDensity: VisualDensity.compact, backgroundColor: scheme.primaryContainer),
        onPressed: () {},
        child: const Text('Invite'),
      ),
    );
  }
}
