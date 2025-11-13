import 'package:flutter/material.dart';

/// ✅ Global class to handle responsive sizes for mobile, tablet, and web.
class Responsive {
  final BuildContext context;

  Responsive(this.context);

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;

  bool get isMobile => width < 600;
  bool get isTablet => width >= 600 && width < 1024;
  bool get isDesktop => width >= 1024;

  /// Get padding based on screen size
  double get defaultPadding {
    if (isMobile) return 16;
    if (isTablet) return 24;
    return 40; // web
  }

  /// Get default font size scale
  double get scaleFactor {
    if (isMobile) return 1.0;
    if (isTablet) return 1.15;
    return 1.3;
  }

  /// Get card/container width limit
  double get contentMaxWidth {
    if (isMobile) return width * 0.9;
    if (isTablet) return width * 0.7;
    return 600; // fixed for large web layouts
  }

  /// Scales a given size responsively
  double scale(double size) => size * scaleFactor;
}
