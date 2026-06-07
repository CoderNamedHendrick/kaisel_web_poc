import 'package:kaisel/kaisel.dart';
import 'package:kaisel_router_poc/routing/router.dart';

class PocAppCodec implements KaiselConfigCodec<PocAppRoute> {
  const PocAppCodec();

  @override
  KaiselConfig<PocAppRoute>? decode(Uri uri) {
    return switch (uri.pathSegments) {
      [] || [''] => KaiselConfig(mainStack: const [NavigationShellRoute()]),
      ['home'] => KaiselConfig(
        mainStack: const [NavigationShellRoute()],
        nestedState: KaiselShellConfig(activeBranch: 0, activeBranchStack: const [HomeRoot()]),
      ),
      ['home', 'user', final userId] => KaiselConfig(
        mainStack: const [NavigationShellRoute()],
        nestedState: KaiselShellConfig(
          activeBranch: 0,
          activeBranchStack: [
            const HomeRoot(),
            HomeUserProfile(userId: userId),
          ],
        ),
      ),
      ['favorites'] => KaiselConfig(
        mainStack: const [NavigationShellRoute()],
        nestedState: KaiselShellConfig(activeBranch: 1, activeBranchStack: const [FavoritesRoot()]),
      ),
      ['tests'] => KaiselConfig(
        mainStack: const [NavigationShellRoute()],
        nestedState: KaiselShellConfig(activeBranch: 2, activeBranchStack: const [TestsRoot()]),
      ),
      ['messages'] => KaiselConfig(
        mainStack: const [NavigationShellRoute()],
        nestedState: KaiselShellConfig(activeBranch: 3, activeBranchStack: const [MessagesRoot()]),
      ),
      ['messages', 'chat', final chatId] => KaiselConfig(
        mainStack: const [NavigationShellRoute()],
        nestedState: KaiselShellConfig(activeBranch: 3, activeBranchStack: [const MessagesRoot(), ChatDetail(chatId)]),
      ),
      ['messages', 'user', final userId] => KaiselConfig(
        mainStack: const [NavigationShellRoute()],
        nestedState: KaiselShellConfig(
          activeBranch: 3,
          activeBranchStack: [
            const MessagesRoot(),
            ChatUserProfile(userId: userId),
          ],
        ),
      ),
      ['bookings'] => KaiselConfig(
        mainStack: const [NavigationShellRoute()],
        nestedState: KaiselShellConfig(activeBranch: 4, activeBranchStack: const [BookingsRoot()]),
      ),
      ['profile'] => KaiselConfig(
        mainStack: const [NavigationShellRoute()],
        nestedState: KaiselShellConfig(activeBranch: 5, activeBranchStack: const [ProfileRoot()]),
      ),
      _ => null,
    };
  }

  @override
  Uri encode(KaiselConfig<PocAppRoute> config) {
    return switch ((config.mainStack.last, config.nestedState)) {
      (NavigationShellRoute(), final KaiselShellConfig shell) => _encodeShell(shell),
      (NavigationShellRoute(), _) => Uri(path: '/home'),
    };
  }

  Uri _encodeShell(KaiselShellConfig shell) {
    // The active branch's stack only ever goes one detail deep, so the top
    // route fully determines the URL.
    final top = shell.activeBranchStack.last;
    return switch (shell.activeBranch) {
      0 => switch (top) {
        HomeUserProfile(:final userId) => Uri(path: '/home/user/$userId'),
        _ => Uri(path: '/home'),
      },
      1 => Uri(path: '/favorites'),
      2 => Uri(path: '/tests'),
      3 => switch (top) {
        ChatDetail(:final chatId) => Uri(path: '/messages/chat/$chatId'),
        ChatUserProfile(:final userId) => Uri(path: '/messages/user/$userId'),
        _ => Uri(path: '/messages'),
      },
      4 => Uri(path: '/bookings'),
      5 => Uri(path: '/profile'),
      int() => throw UnimplementedError('Failed to implement encode shell for ${shell.activeBranch}'),
    };
  }
}
