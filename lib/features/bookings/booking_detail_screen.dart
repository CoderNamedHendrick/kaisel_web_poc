import 'package:flutter/material.dart';
import 'package:kaisel_router_poc/core/ui.dart';
import 'package:kaisel_router_poc/data/mock_data.dart';

/// Detail page for a [Booking], opened from the Bookings tab.
///
/// Accepts a resolved [booking] when the caller has it, or a [bookingId] looked
/// up in [MockData] (the deep-link case).
class BookingDetailScreen extends StatelessWidget {
  const BookingDetailScreen({super.key, this.booking, this.bookingId})
    : assert(booking != null || bookingId != null, 'Provide a booking or a bookingId');

  final Booking? booking;
  final String? bookingId;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final resolved = booking ?? (bookingId != null ? MockData.bookingById(bookingId!) : null);

    if (resolved == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Booking')),
        body: Center(child: Text('No booking found for "$bookingId".')),
      );
    }

    final b = resolved;
    final statusColor = b.status.color(scheme);
    final isUpcoming = b.status == BookingStatus.upcoming;

    return Scaffold(
      appBar: AppBar(title: const Text('Booking', style: TextStyle(fontWeight: FontWeight.w800))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: scheme.primaryContainer, borderRadius: BorderRadius.circular(16)),
                child: Icon(b.kind.icon, color: scheme.onPrimaryContainer, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(b.court, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                    Text(b.location, style: TextStyle(color: scheme.onSurfaceVariant)),
                  ],
                ),
              ),
              Pill(b.status.label, color: statusColor, bg: statusColor.withValues(alpha: 0.12)),
            ],
          ),
          const SizedBox(height: 20),
          _InfoRow(icon: Icons.sports_tennis, label: 'Type', value: b.kind.label),
          _InfoRow(icon: Icons.event, label: 'Date', value: b.dateLabel),
          _InfoRow(icon: Icons.schedule, label: 'Time', value: b.timeLabel),
          _InfoRow(icon: Icons.attach_money, label: 'Price', value: '\$${b.price}'),
          const Divider(height: 32),
          Row(
            children: [
              PlayerAvatar(player: b.withPlayer, radius: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${b.withPlayer.isCoach ? 'Lesson with' : 'Playing'} ${b.withPlayer.name}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          if (isUpcoming) ...[
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reschedule — coming soon')),
                    ),
                    child: const Text('Reschedule'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Directions — coming soon')),
                    ),
                    icon: const Icon(Icons.directions, size: 18),
                    label: const Text('Directions'),
                  ),
                ),
              ],
            ),
          ],
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
            child: Text(value, textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
