import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kaisel_router_poc/app.dart';
import 'package:kaisel_router_poc/data/mock_data.dart';
import 'package:kaisel_router_poc/url_starategy/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    setStrategy();
  }

  // Parse the JSON seed data once, before the first frame, so screens can read
  // MockData synchronously.
  await MockData.load();

  runApp(const KaiselRouterPocApp());
}
