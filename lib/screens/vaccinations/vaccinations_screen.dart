import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_glass_theme.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../models/vaccination_model.dart';
import '../../widgets/common/branch_badge.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/filter_tabs.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/pet_avatar.dart';
import '../../widgets/common/status_badge.dart';
import '../../widgets/vaccinations/vaccination_alert_banner.dart';

/// Vaccination schedule and attention queue across every clinic branch.
class VaccinationsScreen extends StatefulWidget {
  const VaccinationsScreen({super.key});

  @override
  State<VaccinationsScreen> createState() => _VaccinationsScreenState();
}

class _VaccinationsScreenState extends State<VaccinationsScreen> {
  VaccinationStatus? _selectedStatus;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVaccinations();
  }

  Future<void> _loadVaccinations() async {
    // TODO: Replace this mock delay with a Firestore vaccinations stream.
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (mounted) setState(() => _isLoading = false);
  }

  List<Vaccination> get _filteredVaccinations {
    final vaccinations = mockVaccinations.where((vaccination) => _selectedStatus == null || vaccination.status == _selectedStatus).toList();
    vaccinations.sort((a, b) => a.nextDueDate.compareTo(b.nextDueDate));
    return vaccinations;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const LoadingWidget(message: 'Loading vaccinations...');
    final overdueCount = countOverdueVaccinations(mockVaccinations);
    final dueSoonCount = countDueSoonVaccinations(mockVaccinations);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _Header(),
              const SizedBox(height: 20),
              LayoutBuilder(builder: (context, constraints) {
                final stacked = constraints.maxWidth < 600;
                final overdue = VaccinationAlertBanner(count: overdueCount, title: 'Overdue Vaccination${overdueCount == 1 ? '' : 's'}', subtitle: 'Require immediate attention', color: AppColors.statusDanger, backgroundColor: AppColors.statusDanger.withValues(alpha: .07), icon: Icons.warning_amber_rounded);
                final dueSoon = VaccinationAlertBanner(count: dueSoonCount, title: 'Due Soon', subtitle: 'Schedule within the next week', color: AppColors.statusWarning, backgroundColor: AppColors.statusWarning.withValues(alpha: .08), icon: Icons.schedule_outlined);
                return stacked ? Column(children: [overdue, const SizedBox(height: 12), dueSoon]) : Row(children: [Expanded(child: overdue), const SizedBox(width: 16), Expanded(child: dueSoon)]);
              }),
              const SizedBox(height: 20),
              FilterTabs<VaccinationStatus>(options: VaccinationStatus.values, selected: _selectedStatus, onChanged: (value) => setState(() => _selectedStatus = value), labelBuilder: _vaccinationLabel),
              const SizedBox(height: 18),
              if (_filteredVaccinations.isEmpty)
                const SizedBox(height: 300, child: EmptyState(icon: Icons.vaccines_outlined, title: 'No vaccinations found', message: 'No vaccinations match this filter.'))
              else if (MediaQuery.sizeOf(context).width < 600)
                _MobileVaccinations(vaccinations: _filteredVaccinations)
              else
                _DesktopVaccinations(vaccinations: _filteredVaccinations),
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
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Vaccinations', style: AppTypography.pageTitle), const SizedBox(height: 5), const Text('Track vaccination schedules across all patients.', style: AppTypography.pageSubtitle)]);
}

class _DesktopVaccinations extends StatelessWidget {
  const _DesktopVaccinations({required this.vaccinations});
  final List<Vaccination> vaccinations;

  @override
  Widget build(BuildContext context) => LightGlassPanel(padding: const EdgeInsets.fromLTRB(16, 14, 16, 4), child: Column(children: [const _TableHeader(), const Divider(height: 18), ...vaccinations.map((vaccination) => _DesktopVaccinationRow(vaccination: vaccination))]));
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();
  @override
  Widget build(BuildContext context) => const Row(children: [Expanded(flex: 2, child: _HeaderLabel('Patient')), Expanded(flex: 2, child: _HeaderLabel('Vaccine')), Expanded(child: _HeaderLabel('Administered')), Expanded(child: _HeaderLabel('Next Due')), Expanded(flex: 2, child: _HeaderLabel('Branch')), Expanded(flex: 2, child: _HeaderLabel('Veterinarian')), Expanded(child: _HeaderLabel('Status'))]);
}

class _HeaderLabel extends StatelessWidget {
  const _HeaderLabel(this.label);
  final String label;
  @override
  Widget build(BuildContext context) => Text(label.toUpperCase(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w800));
}

class _DesktopVaccinationRow extends StatelessWidget {
  const _DesktopVaccinationRow({required this.vaccination});
  final Vaccination vaccination;

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Row(children: [Expanded(flex: 2, child: _PatientIdentity(vaccination: vaccination)), Expanded(flex: 2, child: Text(vaccination.vaccineName, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12))), Expanded(child: _DateText(date: vaccination.administeredDate)), Expanded(child: _DateText(date: vaccination.nextDueDate, emphasized: vaccination.status != VaccinationStatus.completed)), Expanded(flex: 2, child: BranchBadge(branchName: vaccination.branch)), Expanded(flex: 2, child: Text(vaccination.veterinarianName, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11))), Expanded(child: _VaccinationStatus(status: vaccination.status))]));
}

class _PatientIdentity extends StatelessWidget {
  const _PatientIdentity({required this.vaccination});
  final Vaccination vaccination;
  @override
  Widget build(BuildContext context) => Row(children: [PetAvatar(species: _speciesFor(vaccination.petName), size: 34), const SizedBox(width: 9), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(vaccination.petName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w700)), const SizedBox(height: 3), Text(vaccination.petId, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10))]))]);
}

class _DateText extends StatelessWidget {
  const _DateText({required this.date, this.emphasized = false});
  final DateTime date;
  final bool emphasized;
  @override
  Widget build(BuildContext context) => Text(_formatDate(date), style: TextStyle(color: emphasized ? AppColors.statusDanger : AppColors.textSecondary, fontSize: 11, fontWeight: emphasized ? FontWeight.w800 : FontWeight.w500));
}

class _VaccinationStatus extends StatelessWidget {
  const _VaccinationStatus({required this.status});
  final VaccinationStatus status;
  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    return StatusBadge(label: _vaccinationLabel(status), color: color, backgroundColor: color.withValues(alpha: .10));
  }
}

class _MobileVaccinations extends StatelessWidget {
  const _MobileVaccinations({required this.vaccinations});
  final List<Vaccination> vaccinations;
  @override
  Widget build(BuildContext context) => Column(children: vaccinations.map((vaccination) => Padding(padding: const EdgeInsets.only(bottom: 14), child: _MobileVaccinationCard(vaccination: vaccination))).toList());
}

class _MobileVaccinationCard extends StatelessWidget {
  const _MobileVaccinationCard({required this.vaccination});
  final Vaccination vaccination;
  @override
  Widget build(BuildContext context) => LightGlassPanel(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [PetAvatar(species: _speciesFor(vaccination.petName)), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(vaccination.petName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w800)), const SizedBox(height: 3), Text(vaccination.petId, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10))])), _VaccinationStatus(status: vaccination.status)]), const Divider(height: 24), _MobileDetail(label: 'Vaccine', value: vaccination.vaccineName), const SizedBox(height: 12), Row(children: [Expanded(child: _MobileDetail(label: 'Administered', value: _formatDate(vaccination.administeredDate))), Expanded(child: _MobileDetail(label: 'Next due', value: _formatDate(vaccination.nextDueDate)))]), const SizedBox(height: 12), _MobileDetail(label: 'Veterinarian', value: vaccination.veterinarianName), const SizedBox(height: 12), BranchBadge(branchName: vaccination.branch)]));
}

class _MobileDetail extends StatelessWidget {
  const _MobileDetail({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)), const SizedBox(height: 3), Text(value, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w700))]);
}

String _vaccinationLabel(VaccinationStatus status) => switch (status) { VaccinationStatus.completed => 'Completed', VaccinationStatus.dueSoon => 'Due Soon', VaccinationStatus.overdue => 'Overdue' };
Color _statusColor(VaccinationStatus status) => switch (status) { VaccinationStatus.completed => AppColors.statusSuccess, VaccinationStatus.dueSoon => AppColors.statusWarning, VaccinationStatus.overdue => AppColors.statusDanger };
String _formatDate(DateTime date) => '${date.day.toString().padLeft(2, '0')} ${_month(date.month)} ${date.year}';
String _month(int month) => const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][month - 1];
String _speciesFor(String petName) => switch (petName) { 'Luna' => 'Cat', 'Milo' => 'Rabbit', 'Coco' => 'Bird', _ => 'Dog' };
