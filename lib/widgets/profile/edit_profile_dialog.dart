import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_glass_theme.dart';
import '../common/custom_text_field.dart';
import '../common/primary_button.dart';

class EditProfileDialog extends StatefulWidget {
  const EditProfileDialog({required this.initialFullName, required this.initialEmail, super.key});

  final String initialFullName;
  final String initialEmail;

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late final TextEditingController _nameController = TextEditingController(text: widget.initialFullName);
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: LightGlassPanel(
          padding: const EdgeInsets.all(22),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [const Expanded(child: Text('Edit Profile', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800))), IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, size: 19))]),
            const SizedBox(height: 14),
            CustomTextField(label: 'Full Name', controller: _nameController, prefixIcon: Icons.person_outline, validator: (value) => value == null || value.trim().isEmpty ? 'Enter your full name' : null),
            const SizedBox(height: 14),
            TextFormField(initialValue: widget.initialEmail, readOnly: true, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined), helperText: 'Email changes require verification - coming soon', filled: true, fillColor: Colors.white, border: OutlineInputBorder())),
            const SizedBox(height: 20),
            Row(children: [Expanded(child: SecondaryButton(label: 'Cancel', onPressed: () => Navigator.pop(context))), const SizedBox(width: 12), Expanded(child: PrimaryButton(label: 'Save', loadingLabel: 'Saving...', isLoading: _isLoading, onPressed: _save))]),
          ]),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty) return;
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    // TODO: Write the updated profile to Firestore `users/{uid}` in production.
    Navigator.pop(context, _nameController.text.trim());
  }
}
