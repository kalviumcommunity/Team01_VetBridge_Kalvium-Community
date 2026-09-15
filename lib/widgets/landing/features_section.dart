import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/landing_theme.dart';

/// Responsive grid of the six core VetBridge capabilities.
class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  static const features = [
    (
      Icons.folder_shared_rounded,
      'Centralized medical records',
      'One complete patient story, available wherever care happens.',
    ),
    (
      Icons.vaccines_rounded,
      'Vaccination tracking',
      'Know what is due, completed, or overdue at a glance.',
    ),
    (
      Icons.calendar_month_rounded,
      'Appointment management',
      'Keep every branch schedule clear and coordinated.',
    ),
    (
      Icons.notifications_active_rounded,
      'Follow-up tracking',
      'Turn the next step in every treatment into a visible action.',
    ),
    (
      Icons.account_tree_rounded,
      'Multi-branch access',
      'Give every care team the right context without duplication.',
    ),
    (
      Icons.pets_rounded,
      'Pet & owner management',
      'Keep pets, people, and their care relationships together.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= AppSpacing.tabletBreakpoint
        ? 3
        : width >= AppSpacing.mobileBreakpoint
        ? 2
        : 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Everything connected.',
          style: LandingTheme.display.copyWith(fontSize: 44),
        ),
        const SizedBox(height: 15),
        Text(
          'A calmer way to coordinate care across every branch, every visit, and every follow-up.',
          style: LandingTheme.body,
        ),
        const SizedBox(height: 34),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: features.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 210,
          ),
          itemBuilder: (context, index) => _FeatureCard(
            icon: features[index].$1,
            title: features[index].$2,
            description: features[index].$3,
          ),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatefulWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });
  final IconData icon;
  final String title;
  final String description;
  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform: Matrix4.translationValues(0, hovered ? -5 : 0, 0),
        decoration: BoxDecoration(
          boxShadow: hovered
              ? [
                  BoxShadow(
                    color: LandingTheme.mint.withValues(alpha: .14),
                    blurRadius: 24,
                  ),
                ]
              : [],
        ),
        child: GlassPanel(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: LandingTheme.mint.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(widget.icon, color: LandingTheme.mint),
              ),
              const SizedBox(height: 18),
              Text(
                widget.title,
                style: GoogleFonts.manrope(
                  color: LandingTheme.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                widget.description,
                style: LandingTheme.body.copyWith(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
