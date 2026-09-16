import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_glass_theme.dart';
import '../../models/follow_up_model.dart';
import '../common/primary_button.dart';
import '../common/status_badge.dart';

class FollowUpCard extends StatelessWidget {
  const FollowUpCard({
    required this.followUp,
    required this.onViewPet,
    required this.onMarkComplete,
    super.key,
    this.isCompleting = false,
  });

  final FollowUp followUp;
  final VoidCallback onViewPet;
  final VoidCallback onMarkComplete;
  final bool isCompleting;

  @override
  Widget build(BuildContext context) {
    // Derive effective status for display: overdue items show as danger even
    // though their stored status is still `pending`.
    final effectiveColor = _statusColor(followUp);
    final effectiveLabel = _statusLabel(followUp);
    final canComplete = followUp.status != FollowUpStatus.completed;

    return LightGlassPanel(
      padding: EdgeInsets.zero,
      child: Container(
        decoration:
            BoxDecoration(border: Border(left: BorderSide(color: effectiveColor, width: 4))),
        padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Expanded(
              child: Text(
                followUp.petName,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            StatusBadge(
              label: effectiveLabel,
              color: effectiveColor,
              backgroundColor: effectiveColor.withValues(alpha: .10),
            ),
          ]),
          const SizedBox(height: 9),
          // `reason` is the PRD-aligned field name (was `title`)
          Text(
            followUp.reason,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (followUp.relatedTreatmentId != null) ...[
            const SizedBox(height: 5),
            Text(
              'Related treatment: ${followUp.relatedTreatmentId}',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            'Due ${_formatDate(followUp.followUpDate)}',
            style: TextStyle(
              color: effectiveColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (followUp.note != null) ...[
            const SizedBox(height: 10),
            Text(
              followUp.note!,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 14),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: 10,
            runSpacing: 8,
            children: [
              SizedBox(
                width: 112,
                child: SecondaryButton(
                  label: 'View Pet',
                  onPressed: isCompleting ? null : onViewPet,
                ),
              ),
              if (canComplete)
                SizedBox(
                  width: 142,
                  child: PrimaryButton(
                    label: 'Mark Complete',
                    loadingLabel: 'Saving...',
                    isLoading: isCompleting,
                    onPressed: onMarkComplete,
                  ),
                ),
            ],
          ),
        ]),
      ),
    );
  }
}

/// Derives display color from the follow-up, considering [isOverdue].
Color _statusColor(FollowUp followUp) {
  if (followUp.status == FollowUpStatus.completed) return AppColors.statusSuccess;
  if (followUp.isOverdue) return AppColors.statusDanger;
  return AppColors.statusWarning;
}

/// Derives display label from the follow-up, considering [isOverdue].
String _statusLabel(FollowUp followUp) {
  if (followUp.status == FollowUpStatus.completed) return 'Completed';
  if (followUp.isOverdue) return 'Overdue';
  return 'Pending';
}

String _formatDate(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')} ${_month(date.month)} ${date.year}';
String _month(int month) =>
    const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][month - 1];