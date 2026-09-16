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
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: strong ? .10 : .06),
            borderRadius: radius,
          ),
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  child: ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) => LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: strong ? .6 : .3),
                        Colors.white.withValues(alpha: .0),
                      ],
                    ).createShader(bounds),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: radius,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 100,
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(borderRadius),
                        topRight: Radius.circular(borderRadius),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: strong ? .15 : .08),
                          Colors.white.withValues(alpha: .0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: padding ?? EdgeInsets.zero,
                child: child,
              ),
            ],
          ),
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

class LandingBackground extends StatefulWidget {
  const LandingBackground({required this.child, super.key});
  final Widget child;

  @override
  State<LandingBackground> createState() => _LandingBackgroundState();
}

class _LandingBackgroundState extends State<LandingBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _driftAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
    _driftAnimation = Tween<double>(begin: -15.0, end: 15.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _driftAnimation,
      builder: (context, child) {
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
            Positioned(
              top: -120 + _driftAnimation.value,
              right: -100 - _driftAnimation.value * 0.5,
              child: const GradientOrb(color: LandingTheme.mint, size: 460),
            ),
            Positioned(
              top: 720 - _driftAnimation.value,
              left: -180 + _driftAnimation.value * 0.8,
              child: const GradientOrb(color: LandingTheme.deepTealAlt, size: 520),
            ),
            Positioned(
              bottom: 260 + _driftAnimation.value * 1.2,
              right: -160 - _driftAnimation.value,
              child: const GradientOrb(color: LandingTheme.mint, size: 440),
            ),
            widget.child,
          ],
        );
      },
    );
  }
}
