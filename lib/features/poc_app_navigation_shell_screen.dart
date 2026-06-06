import 'package:flutter/material.dart';
import 'package:kaisel/kaisel.dart';
import 'package:kaisel_router_poc/core/build_context_extensions.dart';
import 'package:kaisel_router_poc/routing/routing.dart';

class PocAppNavigationShellScreen extends StatelessWidget {
  const PocAppNavigationShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isPastMobile = !context.isMobile;

    const shell = ShellBranches();
    return KaiselBranchedShell.specs(
      branches: shell.branches,

      branchContentBuilder: isPastMobile
          ? (context, active, children, switchTo) => children[active]
          : (context, active, children, switchTo) =>
                _BranchContent(active: active, switchTo: switchTo, children: children),
      chromeBuilder: (context, active, branchContent, switchBranch) {
        if (!isPastMobile) {
          if (active == 1 || active == 4) {
            WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
              context.shell().switchTo(0);
            });
          }
        }

        return Scaffold(
          body: Row(
            children: [
              if (isPastMobile)
                Flexible(
                  flex: 2,
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
              Expanded(flex: !isPastMobile ? 1 : 10, child: branchContent),
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

class _BranchContent extends StatefulWidget {
  const _BranchContent({required this.active, required this.children, required this.switchTo});

  final int active;
  final List<Widget> children;
  final void Function(int branch) switchTo;

  @override
  State<_BranchContent> createState() => _BranchContentState();
}

class _BranchContentState extends State<_BranchContent> {
  late final _controller = PageController(initialPage: widget.active);

  @override
  void didUpdateWidget(covariant _BranchContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.active != widget.active) {
      _controller.animateToPage(widget.active, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView(controller: _controller, physics: const NeverScrollableScrollPhysics(), children: widget.children);
  }
}
