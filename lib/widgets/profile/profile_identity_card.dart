import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_glass_theme.dart';
import '../common/branch_badge.dart';

class ProfileIdentityCard extends StatelessWidget {
  const ProfileIdentityCard({required this.fullName, required this.role, required this.branch, required this.initials, super.key});

  final String fullName;
  final String role;
  final String branch;
  final String initials;

  @override
  Widget build(BuildContext context) {
    return LightGlassPanel(
      padding: const EdgeInsets.all(22),
      child: Row(children: [
        CircleAvatar(radius: 38, backgroundColor: AppColors.primary, child: Text(initials, style: const TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w800))),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(fullName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800)), const SizedBox(height: 8), Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: .10), borderRadius: BorderRadius.circular(20)), child: Text(role, style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w800))), const SizedBox(height: 10), BranchBadge(branchName: branch)])),
      ]),
    );
  }
}
