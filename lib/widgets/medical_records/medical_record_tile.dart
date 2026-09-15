import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/medical_record_model.dart';
import '../../models/medical_summary_model.dart';
import '../common/branch_badge.dart';
import '../common/status_badge.dart';

class MedicalRecordTile extends StatelessWidget {
  const MedicalRecordTile({required this.record, super.key});

  final MedicalRecord record;

  @override
  Widget build(BuildContext context) {
    final color = medicalHistoryColor(record.type);
    return Container(
      decoration: BoxDecoration(border: Border(left: BorderSide(color: color, width: 3))),
      padding: const EdgeInsets.fromLTRB(14, 12, 4, 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final narrow = constraints.maxWidth < 620;
          final body = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  StatusBadge(label: medicalHistoryLabel(record.type), color: color, backgroundColor: color.withValues(alpha: .10)),
                  BranchBadge(branchName: record.branch),
                ],
              ),
              const SizedBox(height: 9),
              Text(record.title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text('${record.petName} (${record.petId}) · ${record.veterinarianName}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
              if (record.description != null) ...[
                const SizedBox(height: 4),
                Text(record.description!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
              ],
            ],
          );
          if (narrow) {
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [body, const SizedBox(height: 8), _DateLabel(date: record.date)]);
          }
          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: body), const SizedBox(width: 16), _DateLabel(date: record.date)]);
        },
      ),
    );
  }
}

class _DateLabel extends StatelessWidget {
  const _DateLabel({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Text(_formatDate(date), style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600));
  }
}

String _formatDate(DateTime date) => '${date.day.toString().padLeft(2, '0')} ${_month(date.month)} ${date.year}';
String _month(int month) => const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][month - 1];
