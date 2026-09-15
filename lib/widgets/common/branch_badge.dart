import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class BranchBadge extends StatelessWidget {
	const BranchBadge({required this.branchName, super.key});

	final String branchName;

	@override
	Widget build(BuildContext context) {
		final colors = _colorsFor(branchName);
		return Container(
			padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
			decoration: BoxDecoration(color: colors.$2, borderRadius: BorderRadius.circular(20)),
			child: Row(
				mainAxisSize: MainAxisSize.min,
				children: [
					Container(width: 5, height: 5, decoration: BoxDecoration(color: colors.$1, shape: BoxShape.circle)),
					const SizedBox(width: 5),
					Text(branchName, style: TextStyle(color: colors.$1, fontSize: 10, fontWeight: FontWeight.w700)),
				],
			),
		);
	}

	(Color, Color) _colorsFor(String branch) {
		final normalized = branch.toLowerCase();
		if (normalized.contains('north')) return (AppColors.branchNorth, AppColors.branchNorthBg);
		if (normalized.contains('south')) return (AppColors.branchSouth, AppColors.branchSouthBg);
		return (AppColors.branchCentral, AppColors.branchCentralBg);
	}
}
