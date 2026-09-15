import 'package:flutter/material.dart';


class SearchField extends StatelessWidget {
	const SearchField({
		required this.controller,
		required this.hint,
		super.key,
		this.onChanged,
	});

	final TextEditingController controller;
	final String hint;
	final ValueChanged<String>? onChanged;

	@override
	Widget build(BuildContext context) {
		return TextField(
			controller: controller,
			onChanged: onChanged,
			decoration: InputDecoration(
				hintText: hint,
				prefixIcon: const Icon(Icons.search, size: 20),
				filled: true,
				fillColor: Colors.white.withValues(alpha: .72),
				contentPadding: const EdgeInsets.symmetric(vertical: 12),
				border: OutlineInputBorder(
					borderRadius: BorderRadius.circular(12),
					borderSide: BorderSide.none,
				),
			),
		);
	}
}
