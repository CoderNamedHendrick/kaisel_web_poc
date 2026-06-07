part of 'router.dart';

class ShellBranches {
  const ShellBranches();

  List<KaiselBranchSpec> get branches {
    return [
      KaiselBranchSpec<HomeRoute>(
        initial: const HomeRoot(),
        builder: (context, route) {
          return switch (route) {
            HomeRoot() => const HomeScreen(),
            HomeUserProfile(:final userId, :final player) => UserProfileScreen(userId: userId, player: player),
          };
        },
      ),

      KaiselBranchSpec<FavoriteRoute>(
        initial: const FavoritesRoot(),
        builder: (context, route) {
          return switch (route) {
            FavoritesRoot() => Offstage(offstage: context.isMobile, child: const FavoritesScreen()),
          };
        },
      ),

      KaiselBranchSpec<TestsRoute>(
        initial: const TestsRoot(),
        builder: (context, route) {
          return switch (route) {
            TestsRoute() => const TestsScreen(),
          };
        },
      ),

      KaiselBranchSpec<MessagesRoute>.adaptive(
        initial: const MessagesRoot(),
        builder: (context, route, stack) {
          //
          return switch ((stack.previous, route)) {
            (_, MessagesRoot()) => const KaiselStandalonePage(MessagesScreen()),
            (_, ChatDetail(:final chatId)) when !context.isMobile => KaiselAbsorbingPage(
              widget: KaiselMasterDetailScaffold(
                master: MessagesScreen(selectedChatId: chatId),
                masterFraction: 0.3,
                detail: ChatDetailScreen(chatId: chatId),
              ),
            ),
            (_, ChatDetail(:final chatId)) => KaiselStandalonePage(ChatDetailScreen(chatId: chatId)),
            (_, ChatUserProfile(:final userId, :final player)) => KaiselStandalonePage(
              UserProfileScreen(userId: userId, player: player),
            ),
          };
        },
        pageWrapper: (ctx) {
          return switch (ctx.route) {
            ChatUserProfile() => AdaptiveModalPage(key: ctx.key, child: ctx.child),
            _ => MaterialPage(child: ctx.child, key: ctx.key),
          };
        },
      ),

      KaiselBranchSpec<BookingsRoute>(
        initial: const BookingsRoot(),
        builder: (context, route) {
          return switch (route) {
            BookingsRoot() => Offstage(offstage: context.isMobile, child: const BookingsScreen()),
          };
        },
      ),

      KaiselBranchSpec<ProfileRoute>(
        initial: const ProfileRoot(),
        builder: (context, route) {
          return switch (route) {
            ProfileRoot() => const ProfileScreen(),
          };
        },
      ),
    ];
  }
}
