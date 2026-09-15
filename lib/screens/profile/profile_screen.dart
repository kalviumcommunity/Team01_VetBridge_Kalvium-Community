import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../screens/landing/landing_screen.dart';
import '../../services/auth_service.dart';
import '../../widgets/profile/account_info_card.dart';
import '../../widgets/profile/edit_profile_dialog.dart';
import '../../widgets/profile/logout_card.dart';
import '../../widgets/profile/profile_identity_card.dart';
import '../../widgets/profile/security_card.dart';

/// Account profile and security settings for the authenticated user.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({required this.userName, required this.userInitials, super.key});

  final String userName;
  final String userInitials;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _fullName = widget.userName;
  bool _twoFactorEnabled = false;

  // TODO: Replace hardcoded profile fields with real session data from
  // AuthService/Firestore. AuthService's mock login already returns AppUser.
  final String _role = 'Clinic Staff';
  final String _email = 'rahul@vetbridge.com';
  final String _branch = 'North Clinic';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const _Header(),
            const SizedBox(height: 22),
            ProfileIdentityCard(fullName: _fullName, role: _role, branch: _branch, initials: widget.userInitials),
            const SizedBox(height: 18),
            AccountInfoCard(fullName: _fullName, email: _email, role: _role, branch: _branch, onEdit: _editProfile),
            const SizedBox(height: 18),
            SecurityCard(onChangePassword: _sendPasswordReset, twoFactorEnabled: _twoFactorEnabled, onTwoFactorChanged: (value) => setState(() => _twoFactorEnabled = value)),
            const SizedBox(height: 18),
            LogoutCard(onLogout: _confirmLogout),
          ]),
        ),
      ),
    );
  }

  Future<void> _editProfile() async {
    final updatedName = await showDialog<String>(context: context, builder: (_) => EditProfileDialog(initialFullName: _fullName, initialEmail: _email));
    if (updatedName != null && mounted) setState(() => _fullName = updatedName);
  }

  void _sendPasswordReset() {
    // TODO: Replace with AuthService.instance.sendPasswordResetEmail(_email).
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password reset link sent to your email. (mock)')));
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log out of VetBridge?'),
        content: const Text("You'll need to sign in again to access your clinic records."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true), style: FilledButton.styleFrom(backgroundColor: AppColors.statusDanger), child: const Text('Logout')),
        ],
      ),
    );
    if (shouldLogout == true) await _logout();
  }

  Future<void> _logout() async {
    await AuthService.instance.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => LandingScreen(
          onLogin: (landingContext) => ScaffoldMessenger.of(landingContext).showSnackBar(const SnackBar(content: Text('Please sign in again.'))),
          onGetStarted: (landingContext) => ScaffoldMessenger.of(landingContext).showSnackBar(const SnackBar(content: Text('Please create an account again.'))),
        ),
      ),
      (route) => false,
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Profile', style: AppTypography.pageTitle), const SizedBox(height: 5), const Text('Manage your account information and security settings.', style: AppTypography.pageSubtitle)]);
}
