part of 'router.dart';

final class PocShellAppRouter {
  late final homeRouter = KaiselRouter<HomeRoute>(initial: const HomeRoot());
  late final testsRouter = KaiselRouter<TestsRoute>(initial: const TestsRoot());
  late final notificationsRouter = KaiselRouter<MessagesRoute>(initial: const MessagesRoot());
  late final profileRouter = KaiselRouter<ProfileRoute>(initial: const ProfileRoot());
  late final favoritesRouter = KaiselRouter<FavoriteRoute>(initial: const FavoritesRoot());
  late final bookingsRouter = KaiselRouter<BookingsRoute>(initial: const BookingsRoot());

  late final router = BranchedShellRouter(
    branches: [homeRouter, favoritesRouter, testsRouter, notificationsRouter, bookingsRouter, profileRouter],
  );

  void dispose() {
    router.dispose();
    homeRouter.dispose();
    testsRouter.dispose();
    notificationsRouter.dispose();
    profileRouter.dispose();
    favoritesRouter.dispose();
    bookingsRouter.dispose();
  }

  late final branches = [
    KaiselBranch<HomeRoute>(
      router: homeRouter,
      pageBuilder: (context, route) {
        return switch (route) {
          HomeRoot() => const HomeScreen(),
        };
      },
    ),

    KaiselBranch<FavoriteRoute>(
      router: favoritesRouter,
      pageBuilder: (context, route) {
        return switch (route) {
          FavoritesRoot() => const FavoritesScreen(),
        };
      },
    ),

    KaiselBranch<TestsRoute>(
      router: testsRouter,
      pageBuilder: (context, route) {
        return switch (route) {
          TestsRoute() => const TestsScreen(),
        };
      },
    ),

    KaiselBranch<MessagesRoute>(
      router: notificationsRouter,
      pageBuilder: (context, route) {
        return switch (route) {
          MessagesRoute() => const NotificationsScreen(),
        };
      },
    ),

    KaiselBranch<BookingsRoute>(
      router: bookingsRouter,
      pageBuilder: (context, route) {
        return switch (route) {
          BookingsRoot() => const BookingsScreen(),
        };
      },
    ),

    KaiselBranch<ProfileRoute>(
      router: profileRouter,
      pageBuilder: (context, route) {
        return switch (route) {
          ProfileRoot() => const ProfileScreen(),
        };
      },
    ),
  ];
}
