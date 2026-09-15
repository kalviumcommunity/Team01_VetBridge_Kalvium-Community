import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/landing_theme.dart';

/// Explains the scattered-record problem with a visual record metaphor.
class ProblemSection extends StatelessWidget {
  const ProblemSection({super.key});

  @override
  Widget build(BuildContext context) {
    final desktop =
        MediaQuery.sizeOf(context).width >= AppSpacing.tabletBreakpoint;
    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Right now, a pet's story is scattered.",
          style: LandingTheme.display.copyWith(fontSize: 42),
        ),
        const SizedBox(height: 20),
        Text(
          'When care is split across branches, the details that matter most become difficult to find at exactly the wrong moment.',
          style: LandingTheme.body,
        ),
        const SizedBox(height: 25),
        const _PainPoint(text: 'Vaccination history is hard to trace'),
        const _PainPoint(
          text: 'Treatments and medications get missed or repeated',
        ),
        const _PainPoint(text: 'Follow-ups are forgotten across branches'),
      ],
    );
    final visual = const _RecordFragments();
    return desktop
        ? Row(
            children: [
              Expanded(child: visual),
              const SizedBox(width: 80),
              Expanded(child: copy),
            ],
          )
        : Column(children: [visual, const SizedBox(height: 55), copy]);
  }
}

class _PainPoint extends StatelessWidget {
  const _PainPoint({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.close_rounded, color: LandingTheme.red, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: LandingTheme.body.copyWith(color: LandingTheme.textPrimary),
          ),
        ),
      ],
    ),
  );
}

class _RecordFragments extends StatelessWidget {
  const _RecordFragments();
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 360,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Transform.rotate(
          angle: -.12,
          child: const PositionedChip(label: 'North', color: LandingTheme.mint),
        ),
        Transform.translate(
          offset: const Offset(-125, -112),
          child: Transform.rotate(
            angle: -.16,
            child: const PositionedChip(
              label: 'Central',
              color: LandingTheme.amber,
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(125, 125),
          child: Transform.rotate(
            angle: .14,
            child: const PositionedChip(
              label: 'South',
              color: LandingTheme.red,
            ),
          ),
        ),
        GlassPanel(
          strong: true,
          padding: const EdgeInsets.all(23),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: LandingTheme.mint.withValues(alpha: .14),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.pets_rounded,
                      color: LandingTheme.mint,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Luna',
                        style: GoogleFonts.fraunces(
                          color: LandingTheme.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Golden retriever · #VB-2048',
                        style: LandingTheme.label,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Text(
                'Unified medical record',
                style: GoogleFonts.manrope(
                  color: LandingTheme.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              const _RecordLine(
                label: 'Vaccinations',
                value: 'Up to date',
                color: LandingTheme.mint,
              ),
              const _RecordLine(
                label: 'Last visit',
                value: 'Central · 12 May',
                color: LandingTheme.amber,
              ),
              const _RecordLine(
                label: 'Next follow-up',
                value: 'In 2 weeks',
                color: LandingTheme.mint,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class PositionedChip extends StatelessWidget {
  const PositionedChip({required this.label, required this.color, super.key});
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => GlassPanel(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: LandingTheme.label.copyWith(color: LandingTheme.textPrimary),
        ),
      ],
    ),
  );
}

class _RecordLine extends StatelessWidget {
  const _RecordLine({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final String value;
  final Color color;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        Icon(Icons.check_circle_rounded, color: color, size: 15),
        const SizedBox(width: 8),
        Text(
          label,
          style: LandingTheme.label.copyWith(color: LandingTheme.textSecondary),
        ),
        const Spacer(),
        Text(
          value,
          style: LandingTheme.label.copyWith(color: LandingTheme.textPrimary),
        ),
      ],
    ),
  );
}
