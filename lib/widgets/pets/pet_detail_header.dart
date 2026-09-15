import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/pet_model.dart';
import '../common/branch_badge.dart';
import '../common/pet_avatar.dart';
import '../common/status_badge.dart';

class PetDetailHeader extends StatelessWidget {
  const PetDetailHeader({required this.pet, required this.onBack, required this.onEdit, super.key});

  final Pet pet;
  final VoidCallback onBack;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 18,
      runSpacing: 16,
      children: [
        IconButton(onPressed: onBack, tooltip: 'Back to pets', icon: const Icon(Icons.arrow_back_rounded)),
        PetAvatar(species: pet.species, size: 82),
        SizedBox(
          width: 240,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(pet.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 27, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text('${pet.species} · ${pet.breed}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 8),
              Text(pet.id, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Wrap(spacing: 8, runSpacing: 6, children: [
                StatusBadge(label: pet.status == PetStatus.active ? 'Active' : 'Inactive', color: pet.status == PetStatus.active ? AppColors.statusSuccess : AppColors.textSecondary, backgroundColor: pet.status == PetStatus.active ? AppColors.statusSuccess.withValues(alpha: .10) : AppColors.border),
                BranchBadge(branchName: pet.currentBranch),
              ]),
            ],
          ),
        ),
        OutlinedButton.icon(onPressed: onEdit, icon: const Icon(Icons.edit_outlined, size: 16), label: const Text('Edit'), style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary, side: const BorderSide(color: AppColors.primary))),
      ],
    );
  }
}
