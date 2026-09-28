import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class EmptyState extends StatelessWidget {
	const EmptyState({
		required this.icon,
		required this.title,
		required this.message,
		super.key,
		this.action,
		this.compact = false,
	});

	final IconData icon;
	final String title;
	final String message;
	final Widget? action;
	final bool compact;

	@override
	Widget build(BuildContext context) {
		return Center(
			child: Column(
				mainAxisSize: MainAxisSize.min,
				children: [
					Container(
						width: compact ? 48 : 76,
						height: compact ? 48 : 76,
						decoration: const BoxDecoration(color: Color(0xFFE4F4F0), shape: BoxShape.circle),
						child: Icon(icon, color: AppColors.primary, size: compact ? 24 : 34),
					),
					SizedBox(height: compact ? 12 : 18),
					Text(title, style: TextStyle(color: AppColors.textPrimary, fontSize: compact ? 14 : 18, fontWeight: FontWeight.w800)),
					SizedBox(height: compact ? 4 : 8),
					ConstrainedBox(
						constraints: const BoxConstraints(maxWidth: 320),
						child: Text(message, textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary, fontSize: compact ? 12 : 14)),
					),
					if (action != null) ...[SizedBox(height: compact ? 12 : 18), action!],
				],
			),
		);
	}
}
