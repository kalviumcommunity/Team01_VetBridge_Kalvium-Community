import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Dark landing-page-only colors, surfaces, and reusable glass primitives.
class LandingTheme {
  LandingTheme._();

  static const inkTeal = Color(0xFF08201E);
  static const deepTeal = Color(0xFF0F3A36);
  static const deepTealAlt = Color(0xFF123B37);
  static const mint = Color(0xFF6EE7B7);
  static const amber = Color(0xFFF2A65A);
  static const textPrimary = Color(0xFFF5F7F5);
  static const textSecondary = Color(0xFFB9CAC6);
  static const textMuted = Color(0xFF7E938E);
  static const red = Color(0xFFE8827A);

  static TextStyle get display => GoogleFonts.fraunces(
    color: textPrimary,
    fontWeight: FontWeight.w600,
    height: 1.08,
  );

  static TextStyle get body =>
      GoogleFonts.manrope(color: textSecondary, height: 1.6);

  static TextStyle get label => GoogleFonts.manrope(
    color: textMuted,
    fontWeight: FontWeight.w700,
    fontSize: 12,
  );
}

/// A frosted surface used throughout the landing page.
class GlassPanel extends StatelessWidget {
  const GlassPanel({
    required this.child,
    super.key,
    this.strong = false,
    this.padding,
    this.borderRadius = 20,
  });

  final Widget child;
  final bool strong;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: strong ? .10 : .06),
            borderRadius: radius,
            border: Border.all(
              color: Colors.white.withValues(alpha: strong ? .20 : .12),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// A decorative blurred radial glow positioned behind glass surfaces.
class GradientOrb extends StatelessWidget {
  const GradientOrb({required this.color, super.key, this.size = 300});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 36, sigmaY: 36),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color.withValues(alpha: .30),
                color.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The fixed atmospheric background behind all landing-page content.
class LandingBackground extends StatelessWidget {
  const LandingBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  LandingTheme.inkTeal,
                  LandingTheme.deepTeal,
                  LandingTheme.inkTeal,
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          top: -120,
          right: -100,
          child: GradientOrb(color: LandingTheme.mint, size: 460),
        ),
        const Positioned(
          top: 720,
          left: -180,
          child: GradientOrb(color: LandingTheme.deepTealAlt, size: 520),
        ),
        const Positioned(
          bottom: 260,
          right: -160,
          child: GradientOrb(color: LandingTheme.mint, size: 440),
        ),
        child,
      ],
    );
  }
}
