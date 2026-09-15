import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_glass_theme.dart';
import '../../models/follow_up_model.dart';
import '../common/branch_badge.dart';
import '../common/primary_button.dart';
import '../common/status_badge.dart';

class FollowUpCard extends StatelessWidget {
  const FollowUpCard({required this.followUp, required this.onViewPet, required this.onMarkComplete, super.key, this.isCompleting = false});

  final FollowUp followUp;
  final VoidCallback onViewPet;
  final VoidCallback onMarkComplete;
  final bool isCompleting;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(followUp.status);
    final canComplete = followUp.status != FollowUpStatus.completed;
    return LightGlassPanel(
      padding: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(border: Border(left: BorderSide(color: color, width: 4))),
        padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [Expanded(child: Text(followUp.petName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w800))), StatusBadge(label: _statusLabel(followUp.status), color: color, backgroundColor: color.withValues(alpha: .10))]),
          const SizedBox(height: 9),
          Text(followUp.title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w800)),
          const SizedBox(height: 5),
          Text('Related: ${followUp.relatedTo}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
          const SizedBox(height: 12),
          Wrap(spacing: 12, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [BranchBadge(branchName: followUp.branch), Text('Due ${_formatDate(followUp.dueDate)}', style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700))]),
          if (followUp.note != null) ...[const SizedBox(height: 10), Text(followUp.note!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontStyle: FontStyle.italic))],
          const SizedBox(height: 14),
          Wrap(alignment: WrapAlignment.end, spacing: 10, runSpacing: 8, children: [SizedBox(width: 112, child: SecondaryButton(label: 'View Pet', onPressed: isCompleting ? null : onViewPet)), if (canComplete) SizedBox(width: 142, child: PrimaryButton(label: 'Mark Complete', loadingLabel: 'Saving...', isLoading: isCompleting, onPressed: onMarkComplete))]),
        ]),
      ),
    );
  }
}

Color _statusColor(FollowUpStatus status) => switch (status) { FollowUpStatus.pending => AppColors.statusWarning, FollowUpStatus.completed => AppColors.statusSuccess, FollowUpStatus.overdue => AppColors.statusDanger };
String _statusLabel(FollowUpStatus status) => switch (status) { FollowUpStatus.pending => 'Pending', FollowUpStatus.completed => 'Completed', FollowUpStatus.overdue => 'Overdue' };
String _formatDate(DateTime date) => '${date.day.toString().padLeft(2, '0')} ${_month(date.month)} ${date.year}';
String _month(int month) => const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][month - 1];