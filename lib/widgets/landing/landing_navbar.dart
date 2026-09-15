import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/landing_theme.dart';
import 'landing_buttons.dart';

/// Sticky-style translucent navigation bar for the landing page.
class LandingNavbar extends StatelessWidget {
  const LandingNavbar({
    required this.onLogin,
    required this.onGetStarted,
    super.key,
  });

  final VoidCallback onLogin;
  final VoidCallback onGetStarted;

  @override
  Widget build(BuildContext context) {
    final desktop =
        MediaQuery.sizeOf(context).width >= AppSpacing.tabletBreakpoint;
    return GlassPanel(
      strong: true,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      borderRadius: 16,
      child: Row(
        children: [
          const _BrandMark(),
          const SizedBox(width: 10),
          Text(
            'VetBridge',
            style: GoogleFonts.manrope(
              color: LandingTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          if (desktop) ...[
            LandingTextButton(label: 'Product', onPressed: () {}),
            LandingTextButton(label: 'Features', onPressed: () {}),
            LandingTextButton(label: 'How it works', onPressed: () {}),
            const SizedBox(width: 8),
          ],
          LandingTextButton(label: 'Log in', onPressed: onLogin),
          LandingButton(label: 'Get Started', onPressed: onGetStarted),
        ],
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          colors: [LandingTheme.mint, LandingTheme.deepTealAlt],
        ),
      ),
      child: Text(
        'V',
        style: GoogleFonts.fraunces(
          color: LandingTheme.inkTeal,
          fontSize: 21,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
