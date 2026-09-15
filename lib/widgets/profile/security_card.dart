import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_glass_theme.dart';

class SecurityCard extends StatelessWidget {
  const SecurityCard({required this.onChangePassword, required this.twoFactorEnabled, required this.onTwoFactorChanged, super.key});

  final VoidCallback onChangePassword;
  final bool twoFactorEnabled;
  final ValueChanged<bool> onTwoFactorChanged;

  @override
  Widget build(BuildContext context) {
    return LightGlassPanel(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('Security', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 16),
        InkWell(onTap: onChangePassword, borderRadius: BorderRadius.circular(10), child: const _SecurityRow(icon: Icons.lock_outline, title: 'Change Password', subtitle: 'A reset link will be sent to your email', trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary))),
        const Divider(height: 25),
        _SecurityRow(icon: Icons.shield_outlined, title: 'Two-Factor Authentication', subtitle: 'Add an extra layer of security', trailing: Switch(value: twoFactorEnabled, onChanged: onTwoFactorChanged, activeThumbColor: AppColors.primary)),
      ]),
    );
  }
}

class _SecurityRow extends StatelessWidget {
  const _SecurityRow({required this.icon, required this.title, required this.subtitle, required this.trailing});

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) => Row(children: [Container(width: 34, height: 34, decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: .08), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: AppColors.primary, size: 18)), const SizedBox(width: 11), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700)), const SizedBox(height: 3), Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11))])), trailing]);
}
