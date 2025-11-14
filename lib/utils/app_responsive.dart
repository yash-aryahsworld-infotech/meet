import 'package:flutter/material.dart';

/// ------------------------------------------------------------
/// GLOBAL RESPONSIVE + SPACING + NAVBAR + SIDEBAR SYSTEM
/// ------------------------------------------------------------
class AppResponsive {
  // ------------------------------------------------------------
  // BREAKPOINTS
  // ------------------------------------------------------------
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1440;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobile;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobile &&
          MediaQuery.of(context).size.width < tablet;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tablet;

  static bool isLargeDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktop;

  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static const double maxWidth = 1600;

  // ------------------------------------------------------------
  // SAFE AREA HELPERS
  // ------------------------------------------------------------
  static double safeTop(BuildContext ctx) =>
      MediaQuery.of(ctx).padding.top;

  static double safeBottom(BuildContext ctx) =>
      MediaQuery.of(ctx).padding.bottom;

  // ------------------------------------------------------------
  // NAVBAR SIZES + PADDING
  // ------------------------------------------------------------
  static const double navbarHeight = 70;

  /// AUTO PAD NAVBAR BASED ON DEVICE
  static EdgeInsets navbarPadding(BuildContext ctx) {
    return EdgeInsets.only(
      top: isDesktop(ctx) ? 0 : safeTop(ctx) + 4,
      left: horizontalPadding(ctx),
      right: horizontalPadding(ctx),
    );
  }

  /// Global horizontal padding for navbar & page sections
  static double horizontalPadding(BuildContext ctx) {
    if (isDesktop(ctx)) return 24;
    if (isTablet(ctx)) return 20;
    return 16; // mobile
  }

  // ------------------------------------------------------------
  // SIDEBAR GLOBAL WIDTHS (expand/collapse)
  // ------------------------------------------------------------
  static const double sidebarCollapsed = 90;
  static const double sidebarExpanded = 260;


  // ------------------------------------------------------------
  // FONT SIZES
  // ------------------------------------------------------------
  static double fontXS(BuildContext ctx) => isDesktop(ctx) ? 13 : 12;
  static double fontSM(BuildContext ctx) => isDesktop(ctx) ? 15 : 14;
  static double fontMD(BuildContext ctx) => isDesktop(ctx) ? 17 : 16;
  static double fontLG(BuildContext ctx) => isDesktop(ctx) ? 20 : 18;
  static double fontXL(BuildContext ctx) => isDesktop(ctx) ? 26 : 22;
  static double fontXXL(BuildContext ctx) => isDesktop(ctx) ? 34 : 28;

  // ------------------------------------------------------------
  // FONT WEIGHTS
  // ------------------------------------------------------------
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // ------------------------------------------------------------
  // SPACING SYSTEM
  // ------------------------------------------------------------
  static const double spaceXS = 4;
  static const double spaceSM = 8;
  static const double spaceMD = 16;
  static const double spaceLG = 24;
  static const double spaceXL = 32;
  static const double spaceXXL = 48;

  // ------------------------------------------------------------
  // RADIUSES
  // ------------------------------------------------------------
  static const double radiusSM = 8;
  static const double radiusMD = 14;
  static const double radiusLG = 22;

  // ------------------------------------------------------------
  // PAGE GLOBAL PADDING
  // ------------------------------------------------------------
  static EdgeInsets pagePadding(BuildContext ctx) => EdgeInsets.symmetric(
    horizontal: horizontalPadding(ctx),
    vertical: 16,
  );
}

/// ------------------------------------------------------------
/// RESPONSIVE BUILDER (Mobile / Tablet / Web)
/// ------------------------------------------------------------
class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (AppResponsive.isDesktop(context)) {
      return desktop;
    } else if (AppResponsive.isTablet(context)) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }
}

/// ------------------------------------------------------------
/// Web Max Width Container (Centering content)
/// ------------------------------------------------------------
class MaxWidthContainer extends StatelessWidget {
  final Widget child;

  const MaxWidthContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppResponsive.maxWidth),
        child: child,
      ),
    );
  }
}
