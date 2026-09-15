import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/landing_theme.dart';
import 'landing_buttons.dart';

/// Final conversion band and compact footer for the landing page.
class CtaAndFooter extends StatelessWidget {
  const CtaAndFooter({required this.onGetStarted, super.key});
  final VoidCallback onGetStarted;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Stack(
        alignment: Alignment.center,
        children: [
          const Positioned(
            child: GradientOrb(color: LandingTheme.mint, size: 330),
          ),
          GlassPanel(
            strong: true,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 48),
            child: Column(
              children: [
                Text(
                  'Make every visit count.',
                  textAlign: TextAlign.center,
                  style: LandingTheme.display.copyWith(fontSize: 42),
                ),
                const SizedBox(height: 14),
                Text(
                  'Give your team the complete story and every pet a clearer path to care.',
                  textAlign: TextAlign.center,
                  style: LandingTheme.body,
                ),
                const SizedBox(height: 28),
                LandingButton(
                  label: 'Get Started Free',
                  amber: true,
                  onPressed: onGetStarted,
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 55),
      Container(height: 1, color: Colors.white.withValues(alpha: .12)),
      const SizedBox(height: 22),
      LayoutBuilder(
        builder: (context, constraints) => constraints.maxWidth >= 600
            ? Row(
                children: [
                  _FooterBrand(),
                  const Spacer(),
                  _FooterLinks(),
                  const SizedBox(width: 30),
                  Text('© 2024 VetBridge', style: LandingTheme.label),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FooterBrand(),
                  const SizedBox(height: 18),
                  _FooterLinks(),
                  const SizedBox(height: 16),
                  Text('© 2024 VetBridge', style: LandingTheme.label),
                ],
              ),
      ),
    ],
  );
}

class _FooterBrand extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: LandingTheme.mint,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Text(
          'V',
          style: GoogleFonts.fraunces(
            color: LandingTheme.inkTeal,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      const SizedBox(width: 9),
      Text(
        'VetBridge',
        style: GoogleFonts.manrope(
          color: LandingTheme.textPrimary,
          fontWeight: FontWeight.w800,
        ),
      ),
    ],
  );
}

class _FooterLinks extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 20,
    children: ['Product', 'Features', 'Privacy']
        .map(
          (link) => Text(
            link,
            style: LandingTheme.label.copyWith(
              color: LandingTheme.textSecondary,
            ),
          ),
        )
        .toList(),
  );
}
