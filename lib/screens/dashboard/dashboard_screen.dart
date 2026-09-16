import 'package:flutter/material.dart';

import '../../core/constants/nav_items.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_glass_theme.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../models/appointment_model.dart';
import '../../models/dashboard_models.dart';
import '../../models/follow_up_model.dart';
import '../../models/pet_model.dart';
import '../../services/appointment_service.dart';
import '../../services/follow_up_service.dart';
import '../../services/pet_service.dart';
import '../../widgets/appointments/schedule_appointment_dialog.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/pet_avatar.dart';
import '../../widgets/common/status_badge.dart';

/// Dashboard overview for the authenticated clinic workspace.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({required this.userName, super.key, this.onSectionSelected});

  final String userName;
  final ValueChanged<AppSection>? onSectionSelected;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  /// Builds [DashboardData] from real Firestore collections.
  DashboardData _buildDashboardData(
    List<Pet> pets,
    List<Appointment> appointments,
    List<FollowUp> followUps,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    // Stats
    final todaysAppointments = appointments
        .where((a) {
          final d = DateTime(a.dateTime.year, a.dateTime.month, a.dateTime.day);
          return d == today && a.status == AppointmentStatus.scheduled;
        })
        .length;

    final upcomingAppointments = appointments
        .where((a) =>
            a.dateTime.isAfter(tomorrow) &&
            a.status == AppointmentStatus.scheduled)
        .length;

    final pendingFollowUps =
        followUps.where((f) => f.status == FollowUpStatus.pending).length;

    // Today's appointment rows (max 5 for dashboard)
    final todaysApptList = appointments
        .where((a) {
          final d = DateTime(a.dateTime.year, a.dateTime.month, a.dateTime.day);
          return d == today && a.status == AppointmentStatus.scheduled;
        })
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    final dashboardAppts = todaysApptList.take(5).map((a) {
      final t = a.dateTime;
      final time =
          '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
      return DashboardAppointment(
        petName: a.petName,
        ownerName: a.ownerName,
        time: time,
        reason: a.reason,
        status: 'Scheduled',
        icon: Icons.pets_outlined,
        iconColor: AppColors.statusInfo,
      );
    }).toList();

    // Upcoming follow-up rows — pending only, soonest first (max 5)
    final upcomingFollowUps = followUps
        .where((f) => f.status == FollowUpStatus.pending)
        .toList()
      ..sort((a, b) => a.followUpDate.compareTo(b.followUpDate));

    final dashboardFollowUps = upcomingFollowUps.take(5).map((f) {
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      final d = f.followUpDate;
      final dateStr =
          '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}';
      final isOverdue = f.isOverdue;
      return DashboardFollowUp(
        petName: f.petName,
        reason: f.reason,
        date: dateStr,
        status: isOverdue ? 'Overdue' : 'Pending',
        statusColor:
            isOverdue ? AppColors.statusDanger : AppColors.statusInfo,
      );
    }).toList();

    // Recent pets — newest registered first (max 5)
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final sortedPets = [...pets];
    // We don't have a registeredAt field on Pet, so show up to first 5
    final recentPets = sortedPets.take(5).map((p) {
      final lv = p.lastVisit;
      final lastVisitStr = lv != null
          ? '${lv.day.toString().padLeft(2, '0')} ${months[lv.month - 1]} ${lv.year}'
          : '—';
      return DashboardPet(
        name: p.name,
        ownerName: p.ownerName,
        species: p.species,
        breed: p.breed,
        lastVisit: lastVisitStr,
        status: p.status.name[0].toUpperCase() + p.status.name.substring(1),
      );
    }).toList();

    return DashboardData(
      stats: DashboardStats(
        todaysAppointments: todaysAppointments,
        registeredPets: pets.length,
        upcomingAppointments: upcomingAppointments,
        pendingFollowUps: pendingFollowUps,
      ),
      appointments: dashboardAppts,
      followUps: dashboardFollowUps,
      recentPets: recentPets,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LightGlassBackground(
      child: StreamBuilder<List<Pet>>(
        stream: PetService.instance.streamPets(),
        builder: (context, petSnapshot) {
          if (petSnapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget(message: 'Loading dashboard...');
          }
          if (petSnapshot.hasError) {
            return Center(
              child: EmptyState(
                icon: Icons.error_outline,
                title: 'Error loading dashboard',
                message: petSnapshot.error.toString(),
              ),
            );
          }

          return StreamBuilder<List<Appointment>>(
            stream: AppointmentService.instance.streamAppointments(),
            builder: (context, apptSnapshot) {
              if (apptSnapshot.connectionState == ConnectionState.waiting) {
                return const LoadingWidget(message: 'Loading dashboard...');
              }

              return StreamBuilder<List<FollowUp>>(
                stream: FollowUpService.instance.streamFollowUps(),
                builder: (context, fuSnapshot) {
                  if (fuSnapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingWidget(message: 'Loading dashboard...');
                  }

                  final pets = petSnapshot.data ?? [];
                  final appointments = apptSnapshot.data ?? [];
                  final followUps = fuSnapshot.data ?? [];
                  final dashData =
                      _buildDashboardData(pets, appointments, followUps);

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Center(
                          child: ConstrainedBox(
                            constraints:
                                const BoxConstraints(maxWidth: 1240),
                            child: _DashboardContent(
                              data: dashData,
                              userName: widget.userName,
                              onSectionSelected: widget.onSectionSelected,
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
        },
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.data, required this.userName, this.onSectionSelected});

  final DashboardData data;
  final String userName;
  final ValueChanged<AppSection>? onSectionSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _GreetingHeader(userName: userName, onSectionSelected: onSectionSelected),
        const SizedBox(height: 26),
        _StatsGrid(stats: data.stats),
        const SizedBox(height: 26),
        LayoutBuilder(
          builder: (context, constraints) {
            final stacked = constraints.maxWidth < 820;
            if (stacked) {
              return Column(
                children: [
                  _AppointmentsCard(appointments: data.appointments, onViewAll: () => onSectionSelected?.call(AppSection.appointments)),
                  const SizedBox(height: 20),
                  _FollowUpsCard(followUps: data.followUps, onViewAll: () => onSectionSelected?.call(AppSection.followUps)),
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _AppointmentsCard(appointments: data.appointments, onViewAll: () => onSectionSelected?.call(AppSection.appointments))),
                const SizedBox(width: 20),
                Expanded(child: _FollowUpsCard(followUps: data.followUps, onViewAll: () => onSectionSelected?.call(AppSection.followUps))),
              ],
            );
          },
        ),
        const SizedBox(height: 26),
        _RecentPetsCard(pets: data.recentPets, onViewAll: () => onSectionSelected?.call(AppSection.pets)),
      ],
    );
  }
}

/// Greeting header converted to [StatefulWidget] to support opening the
/// [ScheduleAppointmentDialog] directly from the Dashboard.
class _GreetingHeader extends StatefulWidget {
  const _GreetingHeader({required this.userName, this.onSectionSelected});

  final String userName;
  final ValueChanged<AppSection>? onSectionSelected;

  @override
  State<_GreetingHeader> createState() => _GreetingHeaderState();
}

class _GreetingHeaderState extends State<_GreetingHeader> {
  /// Opens [ScheduleAppointmentDialog] from the Dashboard greeting area.
  ///
  /// Appointments are written to Firestore by the dialog itself; the shared
  /// Firestore stream on the Appointments screen will pick them up automatically.
  Future<void> _scheduleAppointment() async {
    final newAppointment = await showDialog<Appointment>(
      context: context,
      builder: (_) => const ScheduleAppointmentDialog(),
    );
    if (!mounted || newAppointment == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Appointment scheduled.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 16,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$greeting, ${widget.userName.split(' ').first}',
              style: AppTypography.textTheme.headlineMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Here's an overview of today's clinic activity.",
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton.icon(
              onPressed: () => widget.onSectionSelected?.call(AppSection.pets),
              icon: const Icon(Icons.search, size: 17),
              label: const Text('Search Pet'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.border.withValues(alpha: .8)),
                backgroundColor: Colors.white.withValues(alpha: .55),
              ),
            ),
            const SizedBox(width: 10),
            FilledButton.icon(
              onPressed: _scheduleAppointment,
              icon: const Icon(Icons.add, size: 17),
              label: const Text('Schedule Appointment'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.stats});

  final DashboardStats stats;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 580 ? 1 : constraints.maxWidth < 900 ? 2 : 4;
        final width = (constraints.maxWidth - ((columns - 1) * 16)) / columns;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _StatCard(width: width, icon: Icons.calendar_today_outlined, iconColor: AppColors.statusInfo, label: "Today's Appointments", value: '${stats.todaysAppointments}'),
            _StatCard(width: width, icon: Icons.pets_outlined, iconColor: AppColors.statusSuccess, label: 'Registered Pets', value: '${stats.registeredPets}'),
            _StatCard(width: width, icon: Icons.schedule_outlined, iconColor: AppColors.statusWarning, label: 'Upcoming Appointments', value: '${stats.upcomingAppointments}'),
            _StatCard(width: width, icon: Icons.notifications_none_outlined, iconColor: AppColors.statusDanger, label: 'Pending Follow-Ups', value: '${stats.pendingFollowUps}'),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.width, required this.icon, required this.iconColor, required this.label, required this.value});

  final double width;
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: LightGlassPanel(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: iconColor.withValues(alpha: .10), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppointmentsCard extends StatelessWidget {
  const _AppointmentsCard({required this.appointments, required this.onViewAll});

  final List<DashboardAppointment> appointments;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      title: "Today's Appointments",
      action: 'View all',
      onAction: onViewAll,
      child: appointments.isEmpty
          ? const SizedBox(height: 120, child: EmptyState(icon: Icons.event_available_outlined, title: 'No appointments today', message: 'There are no appointments scheduled for today.'))
          : Column(children: appointments.map((appointment) => _AppointmentRow(appointment: appointment)).toList()),
    );
  }
}

class _AppointmentRow extends StatelessWidget {
  const _AppointmentRow({required this.appointment});

  final DashboardAppointment appointment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: appointment.iconColor.withValues(alpha: .14), shape: BoxShape.circle),
            child: Icon(appointment.icon, color: appointment.iconColor, size: 17),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(appointment.petName, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary, fontSize: 13)),
                const SizedBox(height: 2),
                Text('${appointment.ownerName} · ${appointment.reason}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(appointment.time, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.textPrimary, fontSize: 12)),
              const SizedBox(height: 4),
              StatusBadge(label: appointment.status, color: AppColors.statusSuccess, backgroundColor: AppColors.statusSuccess.withValues(alpha: .10)),
            ],
          ),
        ],
      ),
    );
  }
}

class _FollowUpsCard extends StatelessWidget {
  const _FollowUpsCard({required this.followUps, required this.onViewAll});

  final List<DashboardFollowUp> followUps;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      title: 'Upcoming Follow-Ups',
      action: 'View all',
      onAction: onViewAll,
      child: followUps.isEmpty
          ? const SizedBox(height: 120, child: EmptyState(icon: Icons.event_repeat_outlined, title: 'No upcoming follow-ups', message: 'There are no follow-ups to show.'))
          : Column(children: followUps.map((followUp) => _FollowUpRow(followUp: followUp)).toList()),
    );
  }
}

class _FollowUpRow extends StatelessWidget {
  const _FollowUpRow({required this.followUp});

  final DashboardFollowUp followUp;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(width: 4, height: 38, decoration: BoxDecoration(color: followUp.statusColor, borderRadius: BorderRadius.circular(4))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(child: Text(followUp.petName, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary, fontSize: 13))),
                    const SizedBox(width: 6),
                    StatusBadge(label: followUp.status, color: followUp.statusColor, backgroundColor: followUp.statusColor.withValues(alpha: .10)),
                  ],
                ),
                const SizedBox(height: 3),
                Text(followUp.reason, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(followUp.date, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}

class _RecentPetsCard extends StatelessWidget {
  const _RecentPetsCard({required this.pets, required this.onViewAll});

  final List<DashboardPet> pets;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      title: 'Recently Registered Pets',
      action: 'View all',
      onAction: onViewAll,
      child: pets.isEmpty
          ? const SizedBox(height: 120, child: EmptyState(icon: Icons.pets_outlined, title: 'No recently registered pets', message: 'Newly registered pets will appear here.'))
          : Column(children: pets.map((pet) => _PetRow(pet: pet)).toList()),
    );
  }
}

class _PetRow extends StatelessWidget {
  const _PetRow({required this.pet});

  final DashboardPet pet;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          PetAvatar(species: pet.species, size: 34),
          const SizedBox(width: 10),
          Expanded(flex: 2, child: _PetInfo(label: pet.name, value: pet.ownerName)),
          Expanded(flex: 2, child: _PetInfo(label: pet.species, value: pet.breed)),
          Expanded(child: _PetInfo(label: 'Last visit', value: pet.lastVisit)),
          StatusBadge(label: pet.status, color: AppColors.statusSuccess, backgroundColor: AppColors.statusSuccess.withValues(alpha: .10)),
        ],
      ),
    );
  }
}

class _PetInfo extends StatelessWidget {
  const _PetInfo({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({required this.title, required this.action, required this.onAction, required this.child});

  final String title;
  final String action;
  final VoidCallback onAction;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LightGlassPanel(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w800))),
              TextButton(onPressed: onAction, child: Text(action, style: const TextStyle(color: AppColors.primary, fontSize: 12))),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

