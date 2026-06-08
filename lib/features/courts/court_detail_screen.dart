import 'package:flutter/material.dart';
import 'package:kaisel_router_poc/core/ui.dart';
import 'package:kaisel_router_poc/data/mock_data.dart';

/// Detail page for a [Court]. Reused from both the Home and Favorites tabs.
///
/// Accepts a fully-resolved [court] when the caller already has the model, or
/// a [courtId] looked up in [MockData] — the case that also backs deep links,
/// where only the id survives in the URL.
class CourtDetailScreen extends StatelessWidget {
  const CourtDetailScreen({super.key, this.court, this.courtId})
    : assert(court != null || courtId != null, 'Provide a court or a courtId');

  final Court? court;
  final String? courtId;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final resolved = court ?? (courtId != null ? MockData.courtById(courtId!) : null);

    if (resolved == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Court')),
        body: Center(child: Text('No court found for "$courtId".')),
      );
    }

    final c = resolved;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 180,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.w800)),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: c.gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -16,
                      bottom: -16,
                      child: Icon(Icons.sports_tennis, size: 140, color: Colors.white.withValues(alpha: 0.18)),
                    ),
                    Positioned(
                      left: 16,
                      top: 56,
                      child: Pill(
                        c.surface.label,
                        icon: c.surface.icon,
                        color: Colors.white,
                        bg: Colors.black.withValues(alpha: 0.25),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.place_outlined, size: 18, color: scheme.onSurfaceVariant),
                      const SizedBox(width: 6),
                      Expanded(child: Text(c.location, style: Theme.of(context).textTheme.titleMedium)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _Stat(icon: Icons.star, label: 'Rating', value: '${c.rating}', color: Colors.amber.shade700),
                      _Stat(icon: Icons.attach_money, label: 'Per hour', value: '\$${c.pricePerHour}', color: scheme.primary),
                      _Stat(icon: Icons.near_me_outlined, label: 'Distance', value: '${c.distanceKm} km', color: scheme.primary),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Pill('${c.courts} ${c.courts == 1 ? 'court' : 'courts'}', icon: Icons.grid_view),
                      Pill(c.lit ? 'Floodlit' : 'Daytime only', icon: c.lit ? Icons.light_mode : Icons.dark_mode),
                      Pill(c.surface.label, icon: c.surface.icon),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Booking ${c.name} — coming soon')),
                      ),
                      icon: const Icon(Icons.event_available),
                      label: const Text('Book this court'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.label, required this.value, required this.color});

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: scheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(18)),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
            Text(label, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
