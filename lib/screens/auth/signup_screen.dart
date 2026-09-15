import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../services/auth_service.dart';
import '../../widgets/auth/auth_split_shell.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/primary_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({required this.onSignUpSuccess, required this.onNavigateToLogin, super.key});

  final VoidCallback onSignUpSuccess;
  final VoidCallback onNavigateToLogin;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _clinic;
  String? _branch;
  bool _termsAccepted = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthSplitShell(
      headline: 'Care connected.',
      description: 'Bring every part of veterinary care into one calm, connected workspace.',
      formChild: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Create your account', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: AppColors.ink)),
            const SizedBox(height: 8),
            const Text('Set up your clinic workspace in a few simple steps.', style: TextStyle(color: Color(0xFF61716F))),
            const SizedBox(height: 24),
            if (_errorMessage != null) _ErrorBanner(message: _errorMessage!),
            CustomTextField(label: 'Full Name', controller: _fullNameController, prefixIcon: Icons.person_outline, textInputAction: TextInputAction.next, autofillHints: const [AutofillHints.name], validator: _required('Enter your full name')),
            const SizedBox(height: 14),
            CustomTextField(label: 'Email', controller: _emailController, prefixIcon: Icons.email_outlined, keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next, autofillHints: const [AutofillHints.email], validator: _emailValidator),
            const SizedBox(height: 14),
            CustomTextField(label: 'Phone', controller: _phoneController, prefixIcon: Icons.phone_outlined, keyboardType: TextInputType.phone, textInputAction: TextInputAction.next, autofillHints: const [AutofillHints.telephoneNumber], validator: _required('Enter your phone number')),
            const SizedBox(height: 14),
            CustomDropdownField<String>(label: 'Clinic', value: _clinic, prefixIcon: Icons.local_hospital_outlined, items: const [DropdownMenuItem(value: 'vetbridge_main_chain', child: Text('VetBridge Main Chain'))], onChanged: (value) => setState(() => _clinic = value), validator: (value) => value == null ? 'Select a clinic' : null),
            const SizedBox(height: 14),
            CustomDropdownField<String>(label: 'Branch', value: _branch, prefixIcon: Icons.location_on_outlined, items: const [DropdownMenuItem(value: 'central_clinic', child: Text('Central Clinic')), DropdownMenuItem(value: 'north_clinic', child: Text('North Clinic')), DropdownMenuItem(value: 'south_clinic', child: Text('South Clinic'))], onChanged: (value) => setState(() => _branch = value), validator: (value) => value == null ? 'Select a branch' : null),
            const SizedBox(height: 14),
            CustomTextField(label: 'Password', controller: _passwordController, prefixIcon: Icons.lock_outline, obscureText: true, textInputAction: TextInputAction.next, autofillHints: const [AutofillHints.newPassword], validator: _passwordValidator),
            const SizedBox(height: 14),
            CustomTextField(label: 'Confirm Password', controller: _confirmPasswordController, prefixIcon: Icons.lock_outline, obscureText: true, textInputAction: TextInputAction.done, autofillHints: const [AutofillHints.newPassword], validator: (value) {
              if (value == null || value.isEmpty) return 'Confirm your password';
              return value != _passwordController.text ? 'Passwords do not match' : null;
            }),
            const SizedBox(height: 10),
            _TermsCheckbox(value: _termsAccepted, onChanged: (value) => setState(() { _termsAccepted = value ?? false; _errorMessage = null; })),
            const SizedBox(height: 18),
            PrimaryButton(label: 'Create Account', isLoading: _isLoading, onPressed: _submit),
            const SizedBox(height: 22),
            Center(child: Wrap(alignment: WrapAlignment.center, children: [const Text('Already have an account? ', style: TextStyle(color: Color(0xFF61716F))), GestureDetector(onTap: widget.onNavigateToLogin, child: const Text('Log in', style: TextStyle(color: AppColors.teal, fontWeight: FontWeight.w800))) ])),
          ],
        ),
      ),
    );
  }

  String? Function(String?) _required(String message) => (value) => value == null || value.trim().isEmpty ? message : null;

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter your email';
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim()) ? null : 'Enter a valid email';
  }

  String? _passwordValidator(String? value) => value == null || value.length < 6 ? 'Use at least 6 characters' : null;

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() => _errorMessage = null);
    if (!_formKey.currentState!.validate()) return;
    if (!_termsAccepted) {
      setState(() => _errorMessage = 'Please agree to the Terms of Service and Privacy Policy.');
      return;
    }
    setState(() => _isLoading = true);
    try {
      await AuthService.instance.signUp(fullName: _fullNameController.text, email: _emailController.text, phone: _phoneController.text, clinicId: _clinic!, branchId: _branch!, password: _passwordController.text);
      if (mounted) widget.onSignUpSuccess();
    } on AuthException catch (exception) {
      if (mounted) setState(() => _errorMessage = exception.message);
    } catch (_) {
      if (mounted) setState(() => _errorMessage = 'Something went wrong');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) => Container(width: double.infinity, margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFFFEEEE), borderRadius: BorderRadius.circular(10)), child: Row(children: [const Icon(Icons.error_outline, color: Color(0xFFD14B4B), size: 20), const SizedBox(width: 8), Expanded(child: Text(message, style: const TextStyle(color: Color(0xFFAD3636), fontSize: 13)))]));
}

class _TermsCheckbox extends StatelessWidget {
  const _TermsCheckbox({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.teal,
          visualDensity: VisualDensity.compact,
        ),
        const Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text.rich(
              TextSpan(
                text: 'I agree to the ',
                style: TextStyle(color: Color(0xFF61716F), fontSize: 13),
                children: [
                  TextSpan(
                    text: 'Terms of Service',
                    style: TextStyle(color: AppColors.teal, fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(color: AppColors.teal, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
