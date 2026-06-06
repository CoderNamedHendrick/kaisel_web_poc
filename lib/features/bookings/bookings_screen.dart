import 'package:flutter/material.dart';
import 'package:kaisel_router_poc/core/ui.dart';
import 'package:kaisel_router_poc/data/mock_data.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookings = MockData.bookings;
    final upcoming = bookings.where((b) => b.status == BookingStatus.upcoming).toList();
    final past = bookings.where((b) => b.status != BookingStatus.upcoming).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bookings', style: TextStyle(fontWeight: FontWeight.w800)),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Upcoming (${upcoming.length})'),
              Tab(text: 'Past (${past.length})'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _BookingList(upcoming, emptyLabel: 'No upcoming bookings'),
            _BookingList(past, emptyLabel: 'No past bookings'),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('Book a court'),
        ),
      ),
    );
  }
}

class _BookingList extends StatelessWidget {
  const _BookingList(this.items, {required this.emptyLabel});
  final List<Booking> items;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(child: Text(emptyLabel, style: Theme.of(context).textTheme.bodyLarge));
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, i) => _BookingCard(items[i]),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard(this.booking);
  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final statusColor = booking.status.color(scheme);
    final isUpcoming = booking.status == BookingStatus.upcoming;

    return Card(
      color: scheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(booking.kind.icon, color: scheme.onPrimaryContainer),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(booking.court,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                      Text(booking.location,
                          style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13)),
                    ],
                  ),
                ),
                Pill(booking.status.label,
                    color: statusColor, bg: statusColor.withValues(alpha: 0.12)),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(Icons.event, size: 16, color: scheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(booking.dateLabel, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 14),
                Icon(Icons.schedule, size: 16, color: scheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(booking.timeLabel),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                PlayerAvatar(player: booking.withPlayer, radius: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${booking.withPlayer.isCoach ? 'Lesson with' : 'vs'} ${booking.withPlayer.name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text('\$${booking.price}',
                    style: TextStyle(fontWeight: FontWeight.w800, color: scheme.primary)),
              ],
            ),
            if (isUpcoming) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(onPressed: () {}, child: const Text('Reschedule')),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.directions, size: 18),
                      label: const Text('Directions'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
