import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    required this.label,
    super.key,
    this.controller,
    this.prefixIcon,
    this.hintText,
    this.obscureText = false,
    this.validator,
    this.autofillHints,
    this.keyboardType,
    this.textInputAction,
  });

  final String label;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final String? hintText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHints;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText = widget.obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      validator: widget.validator,
      autofillHints: widget.autofillHints,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      decoration: _decoration(
        widget.label,
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.obscureText
            ? IconButton(
                tooltip: _obscureText ? 'Show password' : 'Hide password',
                icon: Icon(
                  _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                ),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              )
            : null,
      ),
    );
  }
}

InputDecoration _decoration(
  String label, {
  String? hintText,
  IconData? prefixIcon,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    labelText: label,
    hintText: hintText,
    prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFD5E1DF)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFD5E1DF)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.teal, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFD14B4B)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFD14B4B), width: 2),
    ),
  );
}

class CustomDropdownField<T> extends StatelessWidget {
  const CustomDropdownField({
    required this.label,
    required this.items,
    required this.onChanged,
    super.key,
    this.value,
    this.prefixIcon,
    this.validator,
  });

  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final IconData? prefixIcon;
  final String? Function(T?)? validator;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      decoration: _decoration(label, prefixIcon: prefixIcon),
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
    );
  }
}
