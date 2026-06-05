import 'package:kaisel/kaisel.dart';
import 'package:kaisel_router_poc/routing/router_codec.dart';
import '../features/features.dart';

part 'routes.dart';

part 'home_routes.dart';

part 'messages_routes.dart';

part 'tests_routes.dart';

part 'profile_routes.dart';

part 'shell_router.dart';

part 'favorite_routes.dart';

part 'bookings_routes.dart';

final class PocAppRouter {
  late final router = KaiselRouter<PocAppRoute>(initial: const NavigationShellRoute());

  late final routerDelegate = KaiselRouterDelegate(
    router: router,
    builder: (context, route) {
      return switch (route) {
        NavigationShellRoute() => const PocAppNavigationShellScreen(),
      };
    },
  );

  late final routerInfoParser = KaiselRouteInformationParser(
    codec: const PocAppCodec(),
    fallback: [const NavigationShellRoute()],
  );

  void dispose() {
    router.dispose();
    routerDelegate.dispose();
  }
}
