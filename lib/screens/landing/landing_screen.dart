import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/landing_theme.dart';
import '../../widgets/landing/cta_and_footer.dart';
import '../../widgets/landing/features_section.dart';
import '../../widgets/landing/hero_section.dart';
import '../../widgets/landing/how_it_works_section.dart';
import '../../widgets/landing/landing_navbar.dart';
import '../../widgets/landing/platform_preview_section.dart';
import '../../widgets/landing/problem_section.dart';

/// The only active product surface in Part 1: the VetBridge landing page.
class LandingScreen extends StatelessWidget {
  const LandingScreen({
    required this.onLogin,
    required this.onGetStarted,
    super.key,
  });

  final void Function(BuildContext context) onLogin;
  final void Function(BuildContext context) onGetStarted;

  @override
  Widget build(BuildContext context) {
    final horizontal =
        MediaQuery.sizeOf(context).width >= AppSpacing.mobileBreakpoint
        ? 56.0
        : 20.0;
    return Scaffold(
      body: LandingBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(horizontal, 18, horizontal, 0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1240),
                  child: LandingNavbar(
                    onLogin: () => onLogin(context),
                    onGetStarted: () => onGetStarted(context),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1240),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(horizontal, 105, horizontal, 45),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            HeroSection(onGetStarted: () => onGetStarted(context)),
                      const SizedBox(height: AppSpacing.sectionGap),
                      const ProblemSection(),
                      const SizedBox(height: AppSpacing.sectionGap),
                      const FeaturesSection(),
                      const SizedBox(height: AppSpacing.sectionGap),
                      const HowItWorksSection(),
                      const SizedBox(height: AppSpacing.sectionGap),
                      const PlatformPreviewSection(),
                      const SizedBox(height: AppSpacing.sectionGap),
                            CtaAndFooter(onGetStarted: () => onGetStarted(context)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
