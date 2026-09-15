import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_glass_theme.dart';
import '../../models/appointment_model.dart';
import '../common/pet_avatar.dart';

class TodayAppointmentsBanner extends StatelessWidget {
  const TodayAppointmentsBanner({required this.todaysAppointments, super.key});

  final List<Appointment> todaysAppointments;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final date = '${_month(now.month)} ${now.day}, ${now.year}';
    return LightGlassPanel(
      padding: const EdgeInsets.all(18),
      borderRadius: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(width: 34, height: 34, decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: .12), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.today_outlined, color: AppColors.primary, size: 19)),
              const SizedBox(width: 10),
              Text('Today - $date', style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 14),
          if (todaysAppointments.isEmpty)
            const Text('No appointments scheduled for today.', style: TextStyle(color: AppColors.textSecondary, fontSize: 12))
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: todaysAppointments.map((appointment) => Padding(padding: const EdgeInsets.only(right: 10), child: _AppointmentChip(appointment: appointment))).toList()),
            ),
        ],
      ),
    );
  }
}

class _AppointmentChip extends StatelessWidget {
  const _AppointmentChip({required this.appointment});

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: .07), borderRadius: BorderRadius.circular(13), border: Border.all(color: AppColors.primary.withValues(alpha: .10))),
      child: Row(
        children: [
          PetAvatar(species: 'Dog', size: 32),
          const SizedBox(width: 9),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Expanded(child: Text(appointment.petName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w800))), Text(_time(appointment.dateTime), style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w800))]),
              const SizedBox(height: 3),
              Text(appointment.ownerName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
              const SizedBox(height: 3),
              Text(appointment.reason, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
            ]),
          ),
        ],
      ),
    );
  }
}

String _time(DateTime date) => '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
String _month(int month) => const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][month - 1];
