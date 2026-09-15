import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_glass_theme.dart';
import '../common/branch_badge.dart';

class CentralizedHistoryBanner extends StatelessWidget {
  const CentralizedHistoryBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return LightGlassPanel(
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: AppColors.mint.withValues(alpha: .50), borderRadius: BorderRadius.circular(11)),
            child: const Icon(Icons.hub_outlined, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final narrow = constraints.maxWidth < 500;
                final content = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Centralized Medical History', style: TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    const Text('Records below are aggregated from all clinic branches - Central, North, and South', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.4)),
                    if (narrow) ...[
                      const SizedBox(height: 10),
                      const _BranchChips(),
                    ],
                  ],
                );
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: content),
                    if (!narrow) const Padding(padding: EdgeInsets.only(left: 14, top: 4), child: _BranchChips()),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BranchChips extends StatelessWidget {
  const _BranchChips();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        BranchBadge(branchName: 'Central Clinic'),
        BranchBadge(branchName: 'North Clinic'),
        BranchBadge(branchName: 'South Clinic'),
      ],
    );
  }
}
