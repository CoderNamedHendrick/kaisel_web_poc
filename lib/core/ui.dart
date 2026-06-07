import 'package:flutter/material.dart';
import 'package:kaisel_router_poc/data/mock_data.dart';

/// Tennis-themed seed colour used across the app.
const kSeedColor = Color(0xFF2E7D32);

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(seedColor: kSeedColor, brightness: Brightness.light);
  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    scaffoldBackgroundColor: scheme.surface,
    cardTheme: CardThemeData(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    chipTheme: const ChipThemeData(side: BorderSide.none),
  );
}

/// Circular avatar built from a player's initials + seeded colour, with an
/// optional online dot. Offline-safe (no network images).
class PlayerAvatar extends StatelessWidget {
  const PlayerAvatar({super.key, required this.player, this.radius = 24});

  final Player player;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: player.color,
      child: Text(
        player.initials,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: radius * 0.7),
      ),
    );
    if (!player.isOnline) return avatar;
    return Stack(
      children: [
        avatar,
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: radius * 0.55,
            height: radius * 0.55,
            decoration: BoxDecoration(
              color: const Color(0xFF43A047),
              shape: BoxShape.circle,
              border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

/// A row title with an optional trailing "See all" action.
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.action, this.onAction});

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          ),
          if (action != null) TextButton(onPressed: onAction ?? () {}, child: Text(action!)),
        ],
      ),
    );
  }
}

/// Small pill/label used for surface, skill range, status, etc.
class Pill extends StatelessWidget {
  const Pill(this.label, {super.key, this.icon, this.color, this.bg});

  final String label;
  final IconData? icon;
  final Color? color;
  final Color? bg;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fg = color ?? scheme.onSecondaryContainer;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: icon == null ? 10 : 8, vertical: 4),
      decoration: BoxDecoration(color: bg ?? scheme.secondaryContainer, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 14, color: fg), const SizedBox(width: 4)],
          Text(
            label,
            style: TextStyle(color: fg, fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
