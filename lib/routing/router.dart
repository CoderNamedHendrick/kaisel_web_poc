import 'package:flutter/material.dart';
import 'package:kaisel/kaisel.dart';
import 'package:kaisel_router_poc/routing/router_codec.dart';
import '../features/features.dart';

part 'routes.dart';

part 'home_routes.dart';

part 'messages_routes.dart';

part 'tests_routes.dart';

part 'profile_routes.dart';

part 'favorite_routes.dart';

part 'bookings_routes.dart';

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
