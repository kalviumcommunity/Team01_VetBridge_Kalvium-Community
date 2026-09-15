import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_glass_theme.dart';
import '../../models/medical_summary_model.dart';
import '../../models/pet_model.dart';

class MedicalSummaryCard extends StatelessWidget {
  const MedicalSummaryCard({required this.pet, super.key});

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    final history = mockMedicalHistoryFor(pet.id);
    return LightGlassPanel(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _CardTitle(title: 'Medical Summary', subtitle: 'A quick overview of this patient\'s care.'),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = (constraints.maxWidth - 24) / 4;
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _QuickStat(width: width, value: '4', label: 'Vaccinations', color: AppColors.statusSuccess),
                  _QuickStat(width: width, value: '6', label: 'Completed treatments', color: AppColors.statusInfo),
                  _QuickStat(width: width, value: '1', label: 'Upcoming appointments', color: AppColors.statusWarning),
                  _QuickStat(width: width, value: '2', label: 'Pending follow-ups', color: AppColors.statusDanger),
                ],
              );
            },
          ),
          const SizedBox(height: 22),
          const Text('Recent Medical History', style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          ...history.map((entry) => _HistoryRow(entry: entry)),
        ],
      ),
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 17, fontWeight: FontWeight.w800)), const SizedBox(height: 4), Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12))]);
  }
}

class _QuickStat extends StatelessWidget {
  const _QuickStat({required this.width, required this.value, required this.label, required this.color});

  final double width;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width < 80 ? 100 : width,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: color.withValues(alpha: .07), borderRadius: BorderRadius.circular(11)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w800)), const SizedBox(height: 3), Text(label, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10))]),
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.entry});

  final MedicalHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final color = medicalHistoryColor(entry.type);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(width: 4, height: 42, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Text(medicalHistoryLabel(entry.type), style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w800)), const SizedBox(width: 8), Flexible(child: Text(entry.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w700)))]),
              const SizedBox(height: 4),
              Text(_formatDate(entry.date), style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
            ]),
          ),
        ],
      ),
    );
  }
}

String _formatDate(DateTime date) => '${date.day.toString().padLeft(2, '0')} ${_month(date.month)} ${date.year}';
String _month(int month) => const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][month - 1];
