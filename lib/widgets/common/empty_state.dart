import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class EmptyState extends StatelessWidget {
	const EmptyState({
		required this.icon,
		required this.title,
		required this.message,
		super.key,
		this.action,
	});

	final IconData icon;
	final String title;
	final String message;
	final Widget? action;

	@override
	Widget build(BuildContext context) {
		return Center(
			child: Column(
				mainAxisSize: MainAxisSize.min,
				children: [
					Container(
						width: 76,
						height: 76,
						decoration: const BoxDecoration(color: Color(0xFFE4F4F0), shape: BoxShape.circle),
						child: Icon(icon, color: AppColors.primary, size: 34),
					),
					const SizedBox(height: 18),
					Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
					const SizedBox(height: 8),
					ConstrainedBox(
						constraints: const BoxConstraints(maxWidth: 320),
						child: Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary)),
					),
					if (action != null) ...[const SizedBox(height: 18), action!],
				],
			),
		);
	}
}
