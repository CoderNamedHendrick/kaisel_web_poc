import 'package:flutter/material.dart';
import 'package:kaisel_router_poc/core/build_context_extensions.dart';
import 'package:kaisel_router_poc/core/ui.dart';
import 'package:kaisel_router_poc/data/mock_data.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final courts = MockData.courts.take(3).toList();
    const coaches = MockData.coaches;
    final players = MockData.players.where((p) => p.winRate != null && p.winRate! > 60).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [IconButton(icon: const Icon(Icons.sort), onPressed: () {})],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const SectionHeader('Saved courts'),
          for (final c in courts) _FavCourtTile(c),
          const SectionHeader('Saved coaches'),
          for (final p in coaches) _FavPersonTile(p),
          const SectionHeader('Favourite partners'),
          for (final p in players) _FavPersonTile(p),
        ],
      ),
    );
  }
}

class _FavCourtTile extends StatelessWidget {
  const _FavCourtTile(this.court);

  final Court court;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        color: scheme.surfaceContainerHigh,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(
                    colors: court.gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(court.surface.icon, color: Colors.white.withValues(alpha: 0.9)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      court.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(court.location, style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.star, size: 14, color: Colors.amber.shade700),
                        Text(' ${court.rating}', style: const TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(width: 10),
                        Text(
                          '\$${court.pricePerHour}/hr',
                          style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.favorite, color: scheme.error),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FavPersonTile extends StatelessWidget {
  const _FavPersonTile(this.player);

  final Player player;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: PlayerAvatar(player: player),
      title: Text(player.name, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        player.isCoach
            ? '${player.location} · ${player.winRate}% rating'
            : 'NTRP ${player.ntrp} · ${player.winRate}% win rate',
      ),
      trailing: IconButton(
        icon: Icon(Icons.favorite, color: scheme.error),
        onPressed: () {},
      ),
    );
  }
}
