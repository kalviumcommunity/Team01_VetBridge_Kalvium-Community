import 'dart:ui';

import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Light glass surfaces for authenticated application screens.
///
/// This is the standard card treatment for Parts 6-13, not only Dashboard.
class LightGlassPanel extends StatelessWidget {
  const LightGlassPanel({required this.child, super.key, this.padding, this.borderRadius = 18});

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .80),
            borderRadius: radius,
            border: Border.all(color: AppColors.border.withValues(alpha: .70)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x160C4D48),
                blurRadius: 24,
                spreadRadius: 1,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: child,
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