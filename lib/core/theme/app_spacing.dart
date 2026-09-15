/// Layout, spacing, and responsive constants shared by the app.
class AppSpacing {
  AppSpacing._();

  static const mobileBreakpoint = 600.0;
  static const tabletBreakpoint = 1024.0;
  static const pagePadding = 24.0;
  static const lg = 24.0;
  static const sectionGap = 120.0;
  static const radius = 20.0;
}

/// Breakpoint helpers for switching between rail and drawer layouts.
class AppBreakpoints {
  AppBreakpoints._();

  static const desktop = AppSpacing.tabletBreakpoint;

  static bool isDesktop(double width) => width >= desktop;
}
