import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_glass_theme.dart';
import '../../core/theme/app_spacing.dart';
import '../../models/pet_model.dart';
import '../../widgets/common/info_row.dart';
import '../../widgets/pets/medical_summary_card.dart';
import '../../widgets/pets/pet_detail_header.dart';

/// Detailed profile view for one pet, pushed from the Pets list.
class PetDetailsScreen extends StatelessWidget {
  const PetDetailsScreen({required this.pet, required this.onBack, super.key});

  final Pet pet;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1240),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PetDetailHeader(
                    pet: pet,
                    onBack: onBack,
                    onEdit: () {
                      // TODO: Pet editing is outside Part 7 scope.
                    },
                  ),
                  const SizedBox(height: 26),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final desktop = constraints.maxWidth >= 1024;
                      final left = Column(children: [_KeyFactsCard(pet: pet), const SizedBox(height: 20), _OwnerCard(pet: pet)]);
                      final right = Column(children: [MedicalSummaryCard(pet: pet), const SizedBox(height: 20), _NotesCard()]);
                      if (!desktop) return Column(children: [left, const SizedBox(height: 20), right]);
                      return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 35, child: left), const SizedBox(width: 22), Expanded(flex: 65, child: right)]);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _KeyFactsCard extends StatelessWidget {
  const _KeyFactsCard({required this.pet});
  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return LightGlassPanel(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const _Title(title: 'Key Facts'),
        const SizedBox(height: 18),
        _FactsGrid(items: [
          InfoRow(icon: Icons.cake_outlined, label: 'Age', value: _ageFor(pet.dateOfBirth)),
          InfoRow(icon: Icons.wc_outlined, label: 'Gender', value: pet.gender),
          InfoRow(icon: Icons.monitor_weight_outlined, label: 'Weight', value: pet.weightKg == null ? '—' : '${pet.weightKg} kg'),
          InfoRow(icon: Icons.palette_outlined, label: 'Color', value: pet.color.isEmpty ? '—' : pet.color),
          InfoRow(icon: Icons.memory_outlined, label: 'Microchip ID', value: pet.microchipId ?? '—'),
        ]),
      ]),
    );
  }
}

class _OwnerCard extends StatelessWidget {
  const _OwnerCard({required this.pet});
  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return LightGlassPanel(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const _Title(title: 'Owner & Contact'),
        const SizedBox(height: 18),
        InfoRow(icon: Icons.person_outline, label: 'Owner', value: pet.ownerName),
        const SizedBox(height: 14),
        InfoRow(icon: Icons.phone_outlined, label: 'Phone', value: pet.ownerPhone),
        const SizedBox(height: 14),
        InfoRow(icon: Icons.email_outlined, label: 'Email', value: pet.ownerEmail ?? '—'),
        const SizedBox(height: 14),
        InfoRow(icon: Icons.location_on_outlined, label: 'Address', value: pet.ownerAddress ?? '—'),
      ]),
    );
  }
}

class _FactsGrid extends StatelessWidget {
  const _FactsGrid({required this.items});
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = (constraints.maxWidth - 12) / 2;
      return Wrap(spacing: 12, runSpacing: 16, children: items.map((item) => SizedBox(width: width, child: item)).toList());
    });
  }
}

class _NotesCard extends StatelessWidget {
  const _NotesCard();

  @override
  Widget build(BuildContext context) {
    return LightGlassPanel(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const _Title(title: 'Notes'),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.background.withValues(alpha: .65), borderRadius: BorderRadius.circular(12)),
          child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.notes_outlined, color: AppColors.textSecondary, size: 18), SizedBox(width: 10), Expanded(child: Text('No notes added yet.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)))]),
        ),
        // TODO: Add editable pet notes when the pet details workflow is expanded.
      ]),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 17, fontWeight: FontWeight.w800));
}

String _ageFor(DateTime birthDate) {
  final now = DateTime.now();
  var years = now.year - birthDate.year;
  var months = now.month - birthDate.month;
  if (now.day < birthDate.day) months--;
  if (months < 0) {
    years--;
    months += 12;
  }
  if (years > 0) return '$years ${years == 1 ? 'year' : 'years'}';
  return '$months ${months == 1 ? 'month' : 'months'}';
}
