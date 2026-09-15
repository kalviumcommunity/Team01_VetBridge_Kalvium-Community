import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_glass_theme.dart';
import '../common/info_row.dart';

class AccountInfoCard extends StatelessWidget {
  const AccountInfoCard({required this.fullName, required this.email, required this.role, required this.branch, required this.onEdit, super.key});

  final String fullName;
  final String email;
  final String role;
  final String branch;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return LightGlassPanel(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [const Expanded(child: Text('Account Information', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w800))), TextButton.icon(onPressed: onEdit, icon: const Icon(Icons.edit_outlined, size: 15), label: const Text('Edit'), style: TextButton.styleFrom(foregroundColor: AppColors.primary, padding: EdgeInsets.zero))]),
        const SizedBox(height: 18),
        LayoutBuilder(builder: (context, constraints) {
          final width = constraints.maxWidth < 460 ? constraints.maxWidth : (constraints.maxWidth - 14) / 2;
          return Wrap(spacing: 14, runSpacing: 17, children: [SizedBox(width: width, child: InfoRow(icon: Icons.person_outline, label: 'Full Name', value: fullName)), SizedBox(width: width, child: InfoRow(icon: Icons.email_outlined, label: 'Email Address', value: email)), SizedBox(width: width, child: InfoRow(icon: Icons.badge_outlined, label: 'Role', value: role)), SizedBox(width: width, child: InfoRow(icon: Icons.location_on_outlined, label: 'Assigned Branch', value: branch))]);
        }),
      ]),
    );
  }
}
