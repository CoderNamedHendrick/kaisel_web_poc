import 'package:flutter/material.dart';
import 'package:kaisel_router_poc/routing/routing.dart';

class KaiselRouterPocApp extends StatefulWidget {
  const KaiselRouterPocApp({super.key});

  @override
  State<KaiselRouterPocApp> createState() => _KaiselRouterPocAppState();
}

class _KaiselRouterPocAppState extends State<KaiselRouterPocApp> {
  late final pocRouter = PocAppRouter();

  @override
  void dispose() {
    pocRouter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: pocRouter.routerDelegate,
      routeInformationParser: pocRouter.routerInfoParser,
    );
  }
}
