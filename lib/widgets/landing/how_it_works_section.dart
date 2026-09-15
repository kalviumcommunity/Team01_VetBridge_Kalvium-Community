import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/landing_theme.dart';

/// Three-step workflow explaining how a shared record moves through branches.
class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  static const steps = [
    'A pet visits any branch',
    'The visit is logged once',
    'Every branch sees it instantly',
  ];

  @override
  Widget build(BuildContext context) {
    final desktop =
        MediaQuery.sizeOf(context).width >= AppSpacing.tabletBreakpoint;
    final cards = List.generate(
      steps.length,
      (index) => GlassPanel(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${index + 1}',
              style: GoogleFonts.fraunces(
                color: LandingTheme.mint,
                fontSize: 48,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              steps[index],
              style: GoogleFonts.manrope(
                color: LandingTheme.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w800,
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How it works',
          style: LandingTheme.display.copyWith(fontSize: 44),
        ),
        const SizedBox(height: 30),
        desktop
            ? Row(
                children: [
                  Expanded(child: cards[0]),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: LandingTheme.mint,
                    ),
                  ),
                  Expanded(child: cards[1]),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: LandingTheme.mint,
                    ),
                  ),
                  Expanded(child: cards[2]),
                ],
              )
            : Column(
                children: [
                  cards[0],
                  const SizedBox(height: 12),
                  const Icon(
                    Icons.arrow_downward_rounded,
                    color: LandingTheme.mint,
                  ),
                  const SizedBox(height: 12),
                  cards[1],
                  const SizedBox(height: 12),
                  const Icon(
                    Icons.arrow_downward_rounded,
                    color: LandingTheme.mint,
                  ),
                  const SizedBox(height: 12),
                  cards[2],
                ],
              ),
      ],
    );
  }
}
