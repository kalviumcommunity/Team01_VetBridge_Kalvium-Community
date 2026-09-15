import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_glass_theme.dart';
import '../../models/branch_model.dart';
import '../common/info_row.dart';

class BranchCard extends StatelessWidget {
  const BranchCard({required this.branch, super.key});

  final Branch branch;

  @override
  Widget build(BuildContext context) {
    final accent = branchColor(branch.colorKey);
    return LightGlassPanel(
      padding: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(border: Border(top: BorderSide(color: accent, width: 3))),
        padding: const EdgeInsets.fromLTRB(18, 17, 18, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [Container(width: 8, height: 8, decoration: BoxDecoration(color: accent, shape: BoxShape.circle)), const SizedBox(width: 8), Expanded(child: Text(branch.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w800)))]),
            const SizedBox(height: 19),
            InfoRow(icon: Icons.location_on_outlined, label: 'Address', value: branch.address),
            const SizedBox(height: 14),
            InfoRow(icon: Icons.call_outlined, label: 'Phone', value: branch.phone),
            const SizedBox(height: 14),
            InfoRow(icon: Icons.mail_outline, label: 'Email', value: branch.email),
            const SizedBox(height: 18),
            Divider(color: AppColors.border.withValues(alpha: .8)),
            const SizedBox(height: 14),
            Row(children: [Expanded(child: _BranchStat(icon: Icons.pets_outlined, value: '${branch.activePetsCount}', label: 'Active Pets', color: accent)), const SizedBox(width: 10), Expanded(child: _BranchStat(icon: Icons.medical_services_outlined, value: '${branch.veterinariansCount}', label: 'Veterinarians', color: accent))]),
          ],
        ),
      ),
    );
  }
}

class _BranchStat extends StatelessWidget {
  const _BranchStat({required this.icon, required this.value, required this.label, required this.color});

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
      decoration: BoxDecoration(color: color.withValues(alpha: .06), borderRadius: BorderRadius.circular(12)),
      child: Row(children: [Icon(icon, color: color, size: 17), const SizedBox(width: 8), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 17, fontWeight: FontWeight.w800)), const SizedBox(height: 2), Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10))]))]),
    );
  }
}
