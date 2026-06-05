import 'package:flutter/material.dart';
import 'package:kaisel/kaisel.dart';
import 'package:kaisel_router_poc/core/build_context_extensions.dart';
import 'package:kaisel_router_poc/routing/routing.dart';

class PocAppNavigationShellScreen extends StatefulWidget {
  const PocAppNavigationShellScreen({super.key});

  @override
  State<PocAppNavigationShellScreen> createState() => _PocAppNavigationShellScreenState();
}

class _PocAppNavigationShellScreenState extends State<PocAppNavigationShellScreen> {
  late final _shellRouter = PocShellAppRouter();

  @override
  void dispose() {
    _shellRouter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPastMobile = !context.isMobile;
    return KaiselBranchedShell(
      shell: _shellRouter.router,
      branches: _shellRouter.branches,
      chromeBuilder: (context, active, branchContent, switchBranch) {
        if (!isPastMobile) {
          if (active == 1 || active == 4) {
            WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
              context.branchedShell().switchTo(0);
            });
          }
        }

        return Scaffold(
          body: Row(
            children: [
              if (isPastMobile)
                Flexible(
                  child: NavigationRail(
                    backgroundColor: Theme.of(context).colorScheme.secondaryFixedDim,
                    destinations: const [
                      NavigationRailDestination(icon: Icon(Icons.home), label: Text('home')),
                      NavigationRailDestination(icon: Icon(Icons.favorite), label: Text('favorites')),
                      NavigationRailDestination(icon: Icon(Icons.sports_tennis_sharp), label: Text('tests')),
                      NavigationRailDestination(icon: Icon(Icons.notifications_active_sharp), label: Text('messages')),
                      NavigationRailDestination(icon: Icon(Icons.book_rounded), label: Text('bookings')),
                      NavigationRailDestination(icon: Icon(Icons.person), label: Text('profile')),
                    ],
                    selectedIndex: active,
                    onDestinationSelected: switchBranch,
                    extended: true,
                  ),
                ),
              Expanded(flex: !isPastMobile ? 1 : 6, child: branchContent),
            ],
          ),
          bottomNavigationBar: isPastMobile
              ? null
              : NavigationBar(
                  selectedIndex: switch (active) {
                    0 => 0,
                    >= 2 && < 4 => active - 1,
                    5 => 3,
                    int() => 0,
                  },
                  onDestinationSelected: (index) {
                    final page = switch (index) {
                      0 => 0,
                      >= 1 && < 3 => index + 1,
                      3 => 5,
                      int() => throw UnimplementedError(),
                    };

                    switchBranch(page);
                  },
                  destinations: const [
                    NavigationDestination(icon: Icon(Icons.home), label: 'home'),
                    NavigationDestination(icon: Icon(Icons.sports_tennis_sharp), label: 'tests'),
                    NavigationDestination(icon: Icon(Icons.notifications_active_sharp), label: 'messages'),
                    NavigationDestination(icon: Icon(Icons.person), label: 'profile'),
                  ],
                ),
        );
      },
    );
  }
}
