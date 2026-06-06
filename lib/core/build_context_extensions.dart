import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  Locale get locale => Localizations.localeOf(this);

  TextTheme get textTheme => theme.textTheme;

  double get width => MediaQuery.sizeOf(this).width;

  double get height => MediaQuery.sizeOf(this).height;

  bool get _isMobile {
    return defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android || kIsWeb;
  }

  bool get _isTablet {
    final orientation = MediaQuery.of(this).orientation;
    return (orientation == Orientation.landscape && MediaQuery.sizeOf(this).width >= 600);
  }

  bool get _isDesktop {
    final orientation = MediaQuery.of(this).orientation;
    return (orientation == Orientation.landscape && MediaQuery.sizeOf(this).width >= 1200);
  }

  bool get isMobile {
    return _isMobile && !_isTablet;
  }

  bool get isTablet {
    return _isTablet;
  }

  bool get isDesktop {
    return _isDesktop;
  }
}
