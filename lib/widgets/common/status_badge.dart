import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
	const StatusBadge({
		required this.label,
		required this.color,
		required this.backgroundColor,
		super.key,
	});

	final String label;
	final Color color;
	final Color backgroundColor;

	@override
	Widget build(BuildContext context) {
		return Container(
			padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
			decoration: BoxDecoration(
				color: backgroundColor,
				borderRadius: BorderRadius.circular(20),
			),
			child: Row(
				mainAxisSize: MainAxisSize.min,
				children: [
					Container(
						width: 5,
						height: 5,
						decoration: BoxDecoration(color: color, shape: BoxShape.circle),
					),
					const SizedBox(width: 5),
					Text(
						label,
						style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700),
					),
				],
			),
		);
	}
}
