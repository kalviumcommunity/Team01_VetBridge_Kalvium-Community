import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../services/auth_service.dart';
import '../../widgets/auth/auth_split_shell.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/primary_button.dart';

/// Login form for clinic staff and veterinarians.
class LoginScreen extends StatefulWidget {
  const LoginScreen({
    required this.onLoginSuccess,
    required this.onNavigateToSignUp,
    required this.onForgotPassword,
    super.key,
  });

  final VoidCallback onLoginSuccess;
  final VoidCallback onNavigateToSignUp;
  final VoidCallback onForgotPassword;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // TODO (backend integration): persist this with secure storage or Firebase
  // auth persistence settings when real authentication is connected.
  bool _rememberMe = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthSplitShell(
      headline: 'Complete pet history,\nacross every branch.',
      description: 'VetBridge centralizes veterinary medical records across all clinic branches, so your team has the full picture - every visit, every treatment, every vaccination.',
      formChild: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sign in to your account',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.ink,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Access your clinic's centralized records.",
              style: TextStyle(color: Color(0xFF61716F)),
            ),
            const SizedBox(height: 20),
            const _DemoHint(),
            const SizedBox(height: 18),
            CustomTextField(
              label: 'Email address',
              hintText: 'you@vetbridge.com',
              controller: _emailController,
              prefixIcon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              validator: _emailValidator,
            ),
            const SizedBox(height: 14),
            CustomTextField(
              label: 'Password',
              hintText: 'Enter your password',
              controller: _passwordController,
              prefixIcon: Icons.lock_outline,
              obscureText: true,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              validator: (value) => value == null || value.isEmpty
                  ? 'Enter your password'
                  : null,
            ),
            const SizedBox(height: 8),
            _RememberAndResetRow(
              rememberMe: _rememberMe,
              onRememberMeChanged: (value) {
                setState(() => _rememberMe = value ?? false);
              },
              onForgotPassword: _forgotPassword,
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 10),
              _ErrorBanner(message: _errorMessage!),
            ],
            const SizedBox(height: 14),
            PrimaryButton(
              label: 'Sign In',
              loadingLabel: 'Signing in...',
              isLoading: _isLoading,
              onPressed: _submit,
            ),
            const SizedBox(height: 22),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Color(0xFF61716F)),
                  ),
                  GestureDetector(
                    onTap: widget.onNavigateToSignUp,
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        color: AppColors.teal,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter your email';
    final email = value.trim();
    return email.contains('@') && email.contains('.')
        ? null
        : 'Enter a valid email';
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() => _errorMessage = null);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await AuthService.instance.login(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (mounted) widget.onLoginSuccess();
    } on AuthException catch (exception) {
      if (mounted) setState(() => _errorMessage = exception.message);
    } catch (_) {
      if (mounted) {
        setState(() => _errorMessage = 'Something went wrong. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isNotEmpty) {
      await AuthService.instance.sendPasswordResetEmail(email);
    }
    if (!mounted) return;
    widget.onForgotPassword();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'If an account exists for that email, a reset link has been sent.',
        ),
      ),
    );
  }
}

class _DemoHint extends StatelessWidget {
  const _DemoHint();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.teal.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: AppColors.teal, size: 18),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Demo: ananya@vetbridge.com or rahul@vetbridge.com | Password: password',
              style: TextStyle(color: AppColors.tealDark, fontSize: 12, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

class _RememberAndResetRow extends StatelessWidget {
  const _RememberAndResetRow({
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onForgotPassword,
  });

  final bool rememberMe;
  final ValueChanged<bool?> onRememberMeChanged;
  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: rememberMe,
          onChanged: onRememberMeChanged,
          activeColor: AppColors.teal,
          visualDensity: VisualDensity.compact,
        ),
        const Text('Remember me', style: TextStyle(color: Color(0xFF61716F), fontSize: 13)),
        const Spacer(),
        TextButton(
          onPressed: onForgotPassword,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.teal,
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
          ),
          child: const Text('Forgot password?'),
        ),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEEEE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFD14B4B), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Color(0xFFAD3636), fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
