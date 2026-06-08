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
      ['home', 'court', final courtId] => KaiselConfig(
        mainStack: const [NavigationShellRoute()],
        nestedState: KaiselShellConfig(
          activeBranch: 0,
          activeBranchStack: [
            const HomeRoot(),
            HomeCourtDetail(courtId: courtId),
          ],
        ),
      ),
      ['home', 'session', final sessionId] => KaiselConfig(
        mainStack: const [NavigationShellRoute()],
        nestedState: KaiselShellConfig(
          activeBranch: 0,
          activeBranchStack: [
            const HomeRoot(),
            HomeSessionDetail(sessionId: sessionId),
          ],
        ),
      ),
      ['favorites'] => KaiselConfig(
        mainStack: const [NavigationShellRoute()],
        nestedState: KaiselShellConfig(activeBranch: 1, activeBranchStack: const [FavoritesRoot()]),
      ),
      ['favorites', 'court', final courtId] => KaiselConfig(
        mainStack: const [NavigationShellRoute()],
        nestedState: KaiselShellConfig(
          activeBranch: 1,
          activeBranchStack: [
            const FavoritesRoot(),
            FavoriteCourtDetail(courtId: courtId),
          ],
        ),
      ),
      ['favorites', 'user', final userId] => KaiselConfig(
        mainStack: const [NavigationShellRoute()],
        nestedState: KaiselShellConfig(
          activeBranch: 1,
          activeBranchStack: [
            const FavoritesRoot(),
            FavoriteUserProfile(userId: userId),
          ],
        ),
      ),
      ['tests'] => KaiselConfig(
        mainStack: const [NavigationShellRoute()],
        nestedState: KaiselShellConfig(activeBranch: 2, activeBranchStack: const [TestsRoot()]),
      ),
      ['tests', final testId] => KaiselConfig(
        mainStack: const [NavigationShellRoute()],
        nestedState: KaiselShellConfig(
          activeBranch: 2,
          activeBranchStack: [
            const TestsRoot(),
            TestDetail(testId: testId),
          ],
        ),
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
      ['bookings', final bookingId] => KaiselConfig(
        mainStack: const [NavigationShellRoute()],
        nestedState: KaiselShellConfig(
          activeBranch: 4,
          activeBranchStack: [
            const BookingsRoot(),
            BookingDetail(bookingId: bookingId),
          ],
        ),
      ),
      ['profile'] => KaiselConfig(
        mainStack: const [NavigationShellRoute()],
        nestedState: KaiselShellConfig(activeBranch: 5, activeBranchStack: const [ProfileRoot()]),
      ),
      ['profile', 'settings'] => KaiselConfig(
        mainStack: const [NavigationShellRoute()],
        nestedState: KaiselShellConfig(activeBranch: 5, activeBranchStack: const [ProfileRoot(), ProfileSettings()]),
      ),
      ['profile', 'edit'] => KaiselConfig(
        mainStack: const [NavigationShellRoute()],
        nestedState: KaiselShellConfig(activeBranch: 5, activeBranchStack: const [ProfileRoot(), ProfileEdit()]),
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
        HomeCourtDetail(:final courtId) => Uri(path: '/home/court/$courtId'),
        HomeSessionDetail(:final sessionId) => Uri(path: '/home/session/$sessionId'),
        _ => Uri(path: '/home'),
      },
      1 => switch (top) {
        FavoriteCourtDetail(:final courtId) => Uri(path: '/favorites/court/$courtId'),
        FavoriteUserProfile(:final userId) => Uri(path: '/favorites/user/$userId'),
        _ => Uri(path: '/favorites'),
      },
      2 => switch (top) {
        TestDetail(:final testId) => Uri(path: '/tests/$testId'),
        _ => Uri(path: '/tests'),
      },
      3 => switch (top) {
        ChatDetail(:final chatId) => Uri(path: '/messages/chat/$chatId'),
        ChatUserProfile(:final userId) => Uri(path: '/messages/user/$userId'),
        _ => Uri(path: '/messages'),
      },
      4 => switch (top) {
        BookingDetail(:final bookingId) => Uri(path: '/bookings/$bookingId'),
        _ => Uri(path: '/bookings'),
      },
      5 => switch (top) {
        ProfileSettings() => Uri(path: '/profile/settings'),
        ProfileEdit() => Uri(path: '/profile/edit'),
        _ => Uri(path: '/profile'),
      },
      int() => throw UnimplementedError('Failed to implement encode shell for ${shell.activeBranch}'),
    };
  }
}
