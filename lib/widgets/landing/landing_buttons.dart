import 'package:flutter/material.dart';

import '../../core/theme/landing_theme.dart';

/// Primary and secondary actions used across the landing page.
class LandingButton extends StatefulWidget {
  const LandingButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.amber = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool amber;

  @override
  State<LandingButton> createState() => _LandingButtonState();
}

class _LandingButtonState extends State<LandingButton> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.amber ? LandingTheme.amber : LandingTheme.mint;
    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: AnimatedScale(
        scale: hovered ? 1.03 : 1,
        duration: const Duration(milliseconds: 180),
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: LandingTheme.inkTeal,
            elevation: hovered ? 12 : 0,
            shadowColor: color.withValues(alpha: .42),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            widget.label,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
}

/// A quiet text action for the navbar and footer.
class LandingTextButton extends StatelessWidget {
  const LandingTextButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(foregroundColor: LandingTheme.textSecondary),
      child: Text(label),
    );
  }
}
