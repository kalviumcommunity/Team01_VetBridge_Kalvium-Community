import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../models/branch_model.dart';
import '../../widgets/branches/branch_card.dart';
import '../../widgets/branches/branch_connection_banner.dart';

/// Overview of VetBridge's connected clinic branches.
class BranchesScreen extends StatelessWidget {
  const BranchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              const BranchConnectionBanner(branches: mockBranches),
              const SizedBox(height: 22),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 1024 ? 3 : constraints.maxWidth >= 600 ? 2 : 1;
                  final gap = 16.0;
                  final cardWidth = (constraints.maxWidth - (gap * (columns - 1))) / columns;
                  return Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: mockBranches.map((branch) => SizedBox(width: cardWidth, child: BranchCard(branch: branch))).toList(),
                  );
                },
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
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Clinic Branches', style: AppTypography.pageTitle), const SizedBox(height: 5), const Text('VetBridge operates across 3 clinic branches in Bengaluru.', style: AppTypography.pageSubtitle)]);
}
