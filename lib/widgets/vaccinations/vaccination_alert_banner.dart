import 'package:flutter/material.dart';

import '../../core/theme/app_glass_theme.dart';

class VaccinationAlertBanner extends StatelessWidget {
  const VaccinationAlertBanner({
    required this.count,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.backgroundColor,
    required this.icon,
    super.key,
  });

  final int count;
  final String title;
  final String subtitle;
  final Color color;
  final Color backgroundColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return LightGlassPanel(
      padding: EdgeInsets.zero,
      borderRadius: 16,
      child: Container(
        decoration: BoxDecoration(color: backgroundColor, border: Border(left: BorderSide(color: color, width: 4))),
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Container(width: 38, height: 38, decoration: BoxDecoration(color: color.withValues(alpha: .12), shape: BoxShape.circle), child: Icon(icon, color: color, size: 20)),
          const SizedBox(width: 12),
          Text('$count', style: TextStyle(color: color, fontSize: 26, fontWeight: FontWeight.w900)),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w800)), const SizedBox(height: 3), Text(subtitle, style: TextStyle(color: color.withValues(alpha: .82), fontSize: 11))])),
        ]),
      ),
    );
  }
}