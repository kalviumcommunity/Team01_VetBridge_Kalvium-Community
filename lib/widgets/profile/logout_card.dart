import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_glass_theme.dart';

class LogoutCard extends StatelessWidget {
  const LogoutCard({required this.onLogout, super.key});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return LightGlassPanel(
      padding: const EdgeInsets.all(18),
      child: Container(
        decoration: BoxDecoration(color: AppColors.statusDanger.withValues(alpha: .055), borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(14),
        child: LayoutBuilder(builder: (context, constraints) {
          final narrow = constraints.maxWidth < 430;
          final text = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Sign out of VetBridge', style: TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w800)), const SizedBox(height: 4), const Text('You will be returned to the login screen.', style: TextStyle(color: AppColors.textSecondary, fontSize: 11))]);
          final button = SizedBox(width: 96, child: FilledButton.icon(onPressed: onLogout, icon: const Icon(Icons.logout_outlined, size: 15), label: const Text('Logout'), style: FilledButton.styleFrom(backgroundColor: AppColors.statusDanger, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10))));
          return narrow ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [text, const SizedBox(height: 12), button]) : Row(children: [Expanded(child: text), const SizedBox(width: 12), button]);
        }),
      ),
    );
  }
}
