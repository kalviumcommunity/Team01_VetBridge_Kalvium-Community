import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_glass_theme.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../models/medical_record_model.dart';
import '../../models/medical_summary_model.dart';
import '../../models/treatment_model.dart';
import '../../models/vaccination_model.dart';
import '../../models/follow_up_model.dart';
import '../../services/treatment_service.dart';
import '../../services/vaccination_service.dart';
import '../../services/follow_up_service.dart';
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
  List<MedicalRecord> _filterRecords(List<Treatment> treatments, List<Vaccination> vaccinations, List<FollowUp> followUps) {
    final records = buildMedicalTimeline(
      treatments: treatments,
      vaccinations: vaccinations,
      followUps: followUps,
    ).where((record) => _selectedFilter == null || record.type == _selectedFilter).toList();
    records.sort((a, b) => b.date.compareTo(a.date));
    return records;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Treatment>>(
      stream: TreatmentService.instance.streamTreatments(),
      builder: (context, tSnapshot) {
        if (tSnapshot.hasError) return _errorState(tSnapshot.error);
        if (tSnapshot.connectionState == ConnectionState.waiting) return const LoadingWidget(message: 'Loading records...');

        return StreamBuilder<List<Vaccination>>(
          stream: VaccinationService.instance.streamVaccinations(),
          builder: (context, vSnapshot) {
            if (vSnapshot.hasError) return _errorState(vSnapshot.error);
            if (vSnapshot.connectionState == ConnectionState.waiting) return const LoadingWidget(message: 'Loading records...');

            return StreamBuilder<List<FollowUp>>(
              stream: FollowUpService.instance.streamFollowUps(),
              builder: (context, fSnapshot) {
                if (fSnapshot.hasError) return _errorState(fSnapshot.error);
                if (fSnapshot.connectionState == ConnectionState.waiting) return const LoadingWidget(message: 'Loading records...');

                final treatments = tSnapshot.data ?? [];
                final vaccinations = vSnapshot.data ?? [];
                final followUps = fSnapshot.data ?? [];
                final filteredRecords = _filterRecords(treatments, vaccinations, followUps);

                return SingleChildScrollView(
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
                          if (filteredRecords.isEmpty)
                            const SizedBox(height: 300, child: EmptyState(icon: Icons.description_outlined, title: 'No records found', message: 'No medical records match this filter yet.'))
                          else
                            LightGlassPanel(
                              padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text('Medical History', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w800)),
                                  const SizedBox(height: 12),
                                  ...filteredRecords.map((record) => MedicalRecordTile(record: record)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _errorState(Object? error) {
    return Center(
      child: EmptyState(
        icon: Icons.error_outline,
        title: 'Error loading records',
        message: error.toString(),
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

