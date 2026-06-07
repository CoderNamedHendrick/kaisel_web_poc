import 'package:flutter/material.dart';
import 'package:kaisel/kaisel.dart';
import 'package:kaisel_router_poc/core/build_context_extensions.dart';
import 'package:kaisel_router_poc/data/mock_data.dart';
import 'package:kaisel_router_poc/routing/router_codec.dart';
import '../features/features.dart';

part 'routes.dart';

part 'home_routes.dart';

part 'messages_routes.dart';

part 'tests_routes.dart';

part 'profile_routes.dart';

part 'favorite_routes.dart';

part 'bookings_routes.dart';

part 'shell_branches.dart';

final class PocAppRouter {
  late final config = KaiselRouterConfig<PocAppRoute>(
    codec: const PocAppCodec(),
    initial: const NavigationShellRoute(),
    builder: (BuildContext context, PocAppRoute route) {
      return switch (route) {
        NavigationShellRoute() => const PocAppNavigationShellScreen(),
      };
    },
  );

  void dispose() {
    config.dispose();
  }
}

class AdaptiveModalPage<T> extends Page<T> {
  const AdaptiveModalPage({
    required LocalKey super.key,
    required this.child,
    this.maxWidth = 488,
    this.maxHeightFraction = 0.85,
  });

  final Widget child;
  final double maxHeightFraction;
  final double maxWidth;

  @override
  Route<T> createRoute(BuildContext context) {
    final wide = !context.isMobile;

    // Mobile → normal full-screen page.
    if (!wide) {
      return MaterialPageRoute<T>(settings: this, builder: (_) => child);
    }

    // Desktop → centered dialog, previous screen visible behind a scrim.
    return PageRouteBuilder<T>(
      fullscreenDialog: true,
      settings: this,
      opaque: false,
      // ← the page below stays visible
      barrierDismissible: true,
      // tap scrim to dismiss (pops the route)
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (_, _, _) {
        return Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
              maxHeight: MediaQuery.heightOf(context) * maxHeightFraction,
            ),
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
            child: child,
          ),
        );
      },
    );
  }
}
