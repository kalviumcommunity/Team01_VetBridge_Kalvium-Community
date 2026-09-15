import 'package:flutter/material.dart';

class PetAvatar extends StatelessWidget {
  const PetAvatar({required this.species, super.key, this.size = 40});

  final String species;
  final double size;

  @override
  Widget build(BuildContext context) {
    final normalized = species.toLowerCase();
    final isCat = normalized == 'cat';
    final isRabbit = normalized == 'rabbit';
    final color = isCat
        ? const Color(0xFF8A6DC0)
        : isRabbit
            ? const Color(0xFF3F9C91)
            : const Color(0xFFE49A52);
    final icon = isRabbit ? Icons.cruelty_free_outlined : Icons.pets_outlined;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color.withValues(alpha: .14), shape: BoxShape.circle),
      child: Icon(icon, color: color, size: size * .48),
    );
  }
}