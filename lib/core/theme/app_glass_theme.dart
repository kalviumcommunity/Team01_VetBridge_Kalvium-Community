import 'dart:ui';

import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Light glass surfaces for authenticated application screens.
///
/// This is the standard card treatment for Parts 6-13, not only Dashboard.
class LightGlassPanel extends StatelessWidget {
  const LightGlassPanel({
    required this.child,
    super.key,
    this.padding,
    this.borderRadius = 18,
    this.strong = false,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: strong ? .85 : .75),
            borderRadius: radius,
            boxShadow: const [
              BoxShadow(
                color: Color(0x160C4D48),
                blurRadius: 24,
                spreadRadius: 1,
                offset: Offset(0, 8),
              ),
            ],
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
                        Colors.white.withValues(alpha: strong ? 1.0 : .8),
                        const Color(0xFFB4E8D4).withValues(alpha: strong ? 0.6 : .2),
                        Colors.white.withValues(alpha: .0),
                      ],
                      stops: const [0.0, 0.4, 1.0],
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
                          Colors.white.withValues(alpha: strong ? 0.4 : 0.2),
                          Colors.white.withValues(alpha: 0.0),
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

class LightGlassBackground extends StatelessWidget {
  const LightGlassBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF1F8F6), Color(0xFFF7F8FA), Color(0xFFF8FAF9)],
            ),
          ),
        ),
        Positioned(
          top: -100,
          left: -80,
          child: _GlowOrb(color: AppColors.mint.withValues(alpha: .20), size: 330),
        ),
        Positioned(
          top: 170,
          right: -150,
          child: _GlowOrb(color: AppColors.teal.withValues(alpha: .10), size: 300),
        ),
        child,
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 36, sigmaY: 36),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}