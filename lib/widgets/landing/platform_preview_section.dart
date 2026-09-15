import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/landing_theme.dart';

/// Product preview showing a unified medical-record timeline.
class PlatformPreviewSection extends StatelessWidget {
  const PlatformPreviewSection({super.key});

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      const Positioned(
        right: -100,
        top: -100,
        child: GradientOrb(color: LandingTheme.mint, size: 370),
      ),
      GlassPanel(
        strong: true,
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Medical Records',
                  style: GoogleFonts.fraunces(
                    color: LandingTheme.textPrimary,
                    fontSize: 27,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.tune_rounded, color: LandingTheme.textMuted),
              ],
            ),
            const SizedBox(height: 24),
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                BranchChip(label: 'Central', color: LandingTheme.amber),
                BranchChip(label: 'North', color: LandingTheme.mint),
                BranchChip(label: 'South', color: LandingTheme.red),
              ],
            ),
            const SizedBox(height: 20),
            const _RecordRow(
              tag: 'Vaccination',
              title: 'Annual wellness & rabies booster',
              subtitle: 'Luna · Dr. Maya Chen',
              date: '12 May 2024',
              color: LandingTheme.mint,
            ),
            const _RecordRow(
              tag: 'Treatment',
              title: 'Seasonal allergy consultation',
              subtitle: 'Milo · Dr. Arun Patel',
              date: '08 May 2024',
              color: LandingTheme.amber,
            ),
            const _RecordRow(
              tag: 'Follow-up',
              title: 'Post-surgery check-in',
              subtitle: 'Cleo · Dr. Maya Chen',
              date: '02 May 2024',
              color: LandingTheme.red,
            ),
          ],
        ),
      ),
    ],
  );
}

/// Branch identifier used by the record preview.
class BranchChip extends StatelessWidget {
  const BranchChip({required this.label, required this.color, super.key});
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .12),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: color.withValues(alpha: .28)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: GoogleFonts.manrope(
            color: LandingTheme.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

class _RecordRow extends StatelessWidget {
  const _RecordRow({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.color,
  });
  final String tag;
  final String title;
  final String subtitle;
  final String date;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 18),
    decoration: BoxDecoration(
      border: Border(
        top: BorderSide(color: Colors.white.withValues(alpha: .10)),
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 9,
          height: 9,
          margin: const EdgeInsets.only(top: 5),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tag, style: LandingTheme.label.copyWith(color: color)),
              const SizedBox(height: 5),
              Text(
                title,
                style: GoogleFonts.manrope(
                  color: LandingTheme.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(subtitle, style: LandingTheme.label),
            ],
          ),
        ),
        Text(date, style: LandingTheme.label),
      ],
    ),
  );
}
