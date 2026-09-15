import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_glass_theme.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../models/appointment_model.dart';
import '../../widgets/appointments/today_appointments_banner.dart';
import '../../widgets/common/branch_badge.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/filter_tabs.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/pet_avatar.dart';
import '../../widgets/common/status_badge.dart';

/// Appointment schedule with today's highlights and cross-branch filtering.
class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  AppointmentStatus? _selectedStatus;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    // TODO: Replace this mock delay with a Firestore appointments stream.
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (mounted) setState(() => _isLoading = false);
  }

  List<Appointment> get _filteredAppointments {
    final appointments = mockAppointments.where((appointment) => _selectedStatus == null || appointment.status == _selectedStatus).toList();
    appointments.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return appointments;
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const LoadingWidget(message: 'Loading appointments...')
        : SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1240),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Header(onSchedule: _showSchedulePlaceholder),
                    const SizedBox(height: 20),
                    TodayAppointmentsBanner(todaysAppointments: todaysAppointmentsFor(mockAppointments)),
                    const SizedBox(height: 20),
                    FilterTabs<AppointmentStatus>(
                      options: AppointmentStatus.values,
                      selected: _selectedStatus,
                      onChanged: (value) => setState(() => _selectedStatus = value),
                      labelBuilder: _statusLabel,
                    ),
                    const SizedBox(height: 18),
                    if (_filteredAppointments.isEmpty)
                      const SizedBox(height: 300, child: EmptyState(icon: Icons.event_available_outlined, title: 'No appointments found', message: 'No appointments match this filter.'))
                    else if (MediaQuery.sizeOf(context).width < 600)
                      _MobileAppointments(appointments: _filteredAppointments)
                    else
                      _DesktopAppointments(appointments: _filteredAppointments),
                  ],
                ),
              ),
            ),
          );
  }

  void _showSchedulePlaceholder() {
    // TODO: Build ScheduleAppointmentDialog using the RegisterPetDialog pattern.
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Scheduling appointments is coming soon.')));
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onSchedule});

  final VoidCallback onSchedule;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 14,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Appointments', style: AppTypography.pageTitle), const SizedBox(height: 5), const Text('Manage clinic appointments and schedules.', style: AppTypography.pageSubtitle)]),
        FilledButton.icon(onPressed: onSchedule, icon: const Icon(Icons.add, size: 18), label: const Text('Schedule Appointment'), style: FilledButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13))),
      ],
    );
  }
}

class _DesktopAppointments extends StatelessWidget {
  const _DesktopAppointments({required this.appointments});

  final List<Appointment> appointments;

  @override
  Widget build(BuildContext context) {
    return LightGlassPanel(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      child: Column(children: [
        const _TableHeader(),
        const Divider(height: 18),
        ...appointments.map((appointment) => _DesktopAppointmentRow(appointment: appointment)),
      ]),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(children: [Expanded(flex: 2, child: _HeaderLabel('Pet & Owner')), Expanded(flex: 2, child: _HeaderLabel('Date & Time')), Expanded(flex: 2, child: _HeaderLabel('Reason')), Expanded(flex: 2, child: _HeaderLabel('Veterinarian')), Expanded(flex: 2, child: _HeaderLabel('Branch')), Expanded(child: _HeaderLabel('Status')), SizedBox(width: 28)]);
  }
}

class _HeaderLabel extends StatelessWidget {
  const _HeaderLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Text(label.toUpperCase(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w800));
}

class _DesktopAppointmentRow extends StatelessWidget {
  const _DesktopAppointmentRow({required this.appointment});

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: Appointment details are outside Part 9 scope.
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(children: [
          Expanded(flex: 2, child: _PetOwner(appointment: appointment)),
          Expanded(flex: 2, child: _DateTimeText(dateTime: appointment.dateTime)),
          Expanded(flex: 2, child: Text(appointment.reason, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12))),
          Expanded(flex: 2, child: Text(appointment.veterinarianName, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11))),
          Expanded(flex: 2, child: BranchBadge(branchName: appointment.branch)),
          Expanded(child: _AppointmentStatus(status: appointment.status)),
          const SizedBox(width: 28, child: Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20)),
        ]),
      ),
    );
  }
}

class _PetOwner extends StatelessWidget {
  const _PetOwner({required this.appointment});
  final Appointment appointment;

  @override
  Widget build(BuildContext context) => Row(children: [PetAvatar(species: _speciesFor(appointment.petName), size: 34), const SizedBox(width: 9), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(appointment.petName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w700)), const SizedBox(height: 3), Text(appointment.ownerName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10))]))]);
}

class _DateTimeText extends StatelessWidget {
  const _DateTimeText({required this.dateTime});
  final DateTime dateTime;

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(_formatDate(dateTime), style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w700)), const SizedBox(height: 3), Text(_formatTime(dateTime), style: const TextStyle(color: AppColors.textSecondary, fontSize: 11))]);
}

class _AppointmentStatus extends StatelessWidget {
  const _AppointmentStatus({required this.status});
  final AppointmentStatus status;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    return StatusBadge(label: _statusLabel(status), color: color, backgroundColor: color.withValues(alpha: .10));
  }
}

class _MobileAppointments extends StatelessWidget {
  const _MobileAppointments({required this.appointments});
  final List<Appointment> appointments;

  @override
  Widget build(BuildContext context) => Column(children: appointments.map((appointment) => Padding(padding: const EdgeInsets.only(bottom: 14), child: _MobileAppointmentCard(appointment: appointment))).toList());
}

class _MobileAppointmentCard extends StatelessWidget {
  const _MobileAppointmentCard({required this.appointment});
  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: Appointment details are outside Part 9 scope.
      },
      borderRadius: BorderRadius.circular(18),
      child: LightGlassPanel(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [PetAvatar(species: _speciesFor(appointment.petName)), const SizedBox(width: 10), Expanded(child: _PetOwner(appointment: appointment)), _AppointmentStatus(status: appointment.status)]),
          const Divider(height: 24),
          Row(children: [Expanded(child: _MobileDetail(label: 'Date & time', value: '${_formatDate(appointment.dateTime)} · ${_formatTime(appointment.dateTime)}')), Expanded(child: _MobileDetail(label: 'Veterinarian', value: appointment.veterinarianName))]),
          const SizedBox(height: 12),
          _MobileDetail(label: 'Reason', value: appointment.reason),
          const SizedBox(height: 12),
          BranchBadge(branchName: appointment.branch),
        ]),
      ),
    );
  }
}

class _MobileDetail extends StatelessWidget {
  const _MobileDetail({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)), const SizedBox(height: 3), Text(value, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w700))]);
}

String _statusLabel(AppointmentStatus status) => switch (status) { AppointmentStatus.scheduled => 'Scheduled', AppointmentStatus.completed => 'Completed', AppointmentStatus.cancelled => 'Cancelled' };
Color _statusColor(AppointmentStatus status) => switch (status) { AppointmentStatus.scheduled => AppColors.statusInfo, AppointmentStatus.completed => AppColors.statusSuccess, AppointmentStatus.cancelled => AppColors.textSecondary };
String _formatTime(DateTime date) => '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
String _formatDate(DateTime date) => '${date.day.toString().padLeft(2, '0')} ${_month(date.month)} ${date.year}';
String _month(int month) => const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][month - 1];
String _speciesFor(String petName) => switch (petName) { 'Luna' => 'Cat', 'Milo' => 'Rabbit', 'Coco' => 'Bird', _ => 'Dog' };
