import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/landing_theme.dart';
import 'landing_buttons.dart';

/// Hero message and illustrative dashboard preview.
class HeroSection extends StatelessWidget {
  const HeroSection({required this.onGetStarted, super.key});

  final VoidCallback onGetStarted;

  @override
  Widget build(BuildContext context) {
    final desktop =
        MediaQuery.sizeOf(context).width >= AppSpacing.tabletBreakpoint;
    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'One record. Every branch.\nNo pet falls through the cracks.',
          style: LandingTheme.display.copyWith(fontSize: desktop ? 56 : 42),
        ),
        const SizedBox(height: 24),
        Text(
          'VetBridge connects every clinic branch around one living medical record, so every visit starts with the full story.',
          style: LandingTheme.body.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 30),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            LandingButton(
              label: 'Get Started',
              amber: true,
              onPressed: onGetStarted,
            ),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: LandingTheme.textPrimary,
                side: BorderSide(color: Colors.white.withValues(alpha: .18)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('See how it works'),
            ),
          ],
        ),
        const SizedBox(height: 34),
        Row(
          children: [
            _TrustStat(value: '1,200+', label: 'pets connected'),
            const SizedBox(width: 30),
            _TrustStat(value: '38%', label: 'fewer missed follow-ups'),
          ],
        ),
      ],
    );
    final preview = const _DashboardPreview();
    return desktop
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 4, child: copy),
              const SizedBox(width: 70),
              Expanded(flex: 6, child: preview),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [copy, const SizedBox(height: 54), preview],
          );
  }
}

class _TrustStat extends StatelessWidget {
  const _TrustStat({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        value,
        style: GoogleFonts.fraunces(
          color: LandingTheme.mint,
          fontSize: 21,
          fontWeight: FontWeight.w600,
        ),
      ),
      Text(label, style: LandingTheme.label),
    ],
  );
}

class _DashboardPreview extends StatelessWidget {
  const _DashboardPreview();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Positioned(
          top: -85,
          right: -45,
          child: GradientOrb(color: LandingTheme.mint, size: 270),
        ),
        const Positioned(
          bottom: -100,
          left: -60,
          child: GradientOrb(color: LandingTheme.amber, size: 250),
        ),
        GlassPanel(
          strong: true,
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning, Dr. Maya',
                style: GoogleFonts.fraunces(
                  color: LandingTheme.textPrimary,
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Here is what is happening across your branches.',
                style: LandingTheme.body.copyWith(fontSize: 12),
              ),
              const SizedBox(height: 24),
              const Row(
                children: [
                  Expanded(
                    child: _MiniStat(number: '24', label: 'Today\'s visits'),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _MiniStat(number: '08', label: 'Follow-ups'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Today at a glance',
                style: LandingTheme.label.copyWith(
                  color: LandingTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              const _StatusLine(
                dot: LandingTheme.mint,
                title: 'Scheduled',
                detail: '14 appointments',
              ),
              const _StatusLine(
                dot: LandingTheme.amber,
                title: 'Due soon',
                detail: '6 vaccinations',
              ),
              const _StatusLine(
                dot: LandingTheme.red,
                title: 'Overdue',
                detail: '2 follow-ups',
              ),
            ],
          ),
        ),
        Positioned(
          top: -18,
          right: -18,
          child: GlassPanel(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            borderRadius: 14,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: LandingTheme.mint,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Vaccination synced',
                  style: LandingTheme.label.copyWith(
                    color: LandingTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.number, required this.label});
  final String number;
  final String label;
  @override
  Widget build(BuildContext context) => GlassPanel(
    padding: const EdgeInsets.all(15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: GoogleFonts.fraunces(
            color: LandingTheme.mint,
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(label, style: LandingTheme.label),
      ],
    ),
  );
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({
    required this.dot,
    required this.title,
    required this.detail,
  });
  final Color dot;
  final String title;
  final String detail;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 11),
    child: Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: dot,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: dot.withValues(alpha: .4), blurRadius: 8),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.manrope(
            color: LandingTheme.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        Text(detail, style: LandingTheme.label),
      ],
    ),
  );
}
