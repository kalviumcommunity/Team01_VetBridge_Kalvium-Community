import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_glass_theme.dart';
import '../../models/branch_model.dart';

class BranchConnectionBanner extends StatelessWidget {
  const BranchConnectionBanner({required this.branches, super.key});

  final List<Branch> branches;

  @override
  Widget build(BuildContext context) {
    return LightGlassPanel(
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: AppColors.mint.withValues(alpha: .55), borderRadius: BorderRadius.circular(11)),
            child: const Icon(Icons.hub_rounded, color: AppColors.primary, size: 21),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Medical history from all branches', style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                const Text('Every treatment, vaccination, and follow-up is shared across branches.', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.4)),
                const SizedBox(height: 13),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var index = 0; index < branches.length; index++) ...[
                        _BranchChip(branch: branches[index]),
                        if (index < branches.length - 1) const _ConnectionSeparator(),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BranchChip extends StatelessWidget {
  const _BranchChip({required this.branch});

  final Branch branch;

  @override
  Widget build(BuildContext context) {
    final color = branchColor(branch.colorKey);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(color: branchBgColor(branch.colorKey), borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)), const SizedBox(width: 6), Text(branch.name, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w800))]),
    );
  }
}

class _ConnectionSeparator extends StatelessWidget {
  const _ConnectionSeparator();

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(horizontal: 7), child: Icon(Icons.arrow_forward_rounded, color: AppColors.textSecondary.withValues(alpha: .55), size: 16));
}
