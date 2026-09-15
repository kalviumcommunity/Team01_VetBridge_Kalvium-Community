import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_glass_theme.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../models/medical_record_model.dart';
import '../../models/medical_summary_model.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/filter_tabs.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/medical_records/centralized_banner.dart';
import '../../widgets/medical_records/medical_record_tile.dart';

/// Cross-branch medical history view.
class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  MedicalRecordType? _selectedFilter;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    // TODO: Replace this mock delay with a Firestore medicalRecords stream.
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (mounted) setState(() => _isLoading = false);
  }

  List<MedicalRecord> get _filteredRecords {
    final records = mockMedicalRecords.where((record) => _selectedFilter == null || record.type == _selectedFilter).toList();
    records.sort((a, b) => b.date.compareTo(a.date));
    return records;
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const LoadingWidget(message: 'Loading medical records...')
        : SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _Header(),
                    const SizedBox(height: 20),
                    FilterTabs<MedicalRecordType>(
                      options: const [
                        MedicalHistoryType.treatment,
                        MedicalHistoryType.vaccination,
                        MedicalHistoryType.followUp,
                      ],
                      selected: _selectedFilter,
                      onChanged: (value) => setState(() => _selectedFilter = value),
                      labelBuilder: medicalHistoryLabel,
                    ),
                    const SizedBox(height: 18),
                    const CentralizedHistoryBanner(),
                    const SizedBox(height: 20),
                    if (_filteredRecords.isEmpty)
                      const SizedBox(height: 300, child: EmptyState(icon: Icons.description_outlined, title: 'No records found', message: 'No medical records match this filter yet.'))
                    else
                      LightGlassPanel(
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text('Medical History', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 12),
                            ..._filteredRecords.map((record) => MedicalRecordTile(record: record)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Medical Records', style: AppTypography.pageTitle),
        const SizedBox(height: 5),
        const Text('Centralized medical history across all branches.', style: AppTypography.pageSubtitle),
      ],
    );
  }
}

