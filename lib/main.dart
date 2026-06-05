import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kaisel_router_poc/app.dart';
import 'package:kaisel_router_poc/url_starategy/url_strategy.dart';

void main() {
  if (kIsWeb) {
    setStrategy();
  }

  runApp(const KaiselRouterPocApp());
}
