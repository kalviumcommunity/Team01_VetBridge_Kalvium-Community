import 'package:flutter/material.dart';

import '../core/theme/landing_theme.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/app_shell/app_shell.dart';
import '../screens/landing/landing_screen.dart';

/// Root MaterialApp for the VetBridge frontend.
class VetBridgeApp extends StatelessWidget {
  const VetBridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VetBridge',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: LandingTheme.inkTeal,
      ),
      home: LandingScreen(
        onLogin: (context) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => LoginScreen(
                onLoginSuccess: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      // TODO: Replace hardcoded userName with real session data.
                      builder: (_) => const AppShell(
                        userName: 'Rahul Mehta',
                        userInitials: 'RM',
                      ),
                    ),
                    (route) => false,
                  );
                },
                onNavigateToSignUp: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => _buildSignUpScreen(context),
                    ),
                  );
                },
                onForgotPassword: () {},
              ),
            ),
          );
        },
        onGetStarted: (context) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => _buildSignUpScreen(context),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSignUpScreen(BuildContext context) {
    return SignUpScreen(
      onSignUpSuccess: () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            // TODO: Replace hardcoded userName with real session data.
            builder: (_) => const AppShell(
              userName: 'Rahul Mehta',
              userInitials: 'RM',
            ),
          ),
          (route) => false,
        );
      },
      onNavigateToLogin: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => LoginScreen(
              onLoginSuccess: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => const AppShell(
                      userName: 'Rahul Mehta',
                      userInitials: 'RM',
                    ),
                  ),
                  (route) => false,
                );
              },
              onNavigateToSignUp: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => _buildSignUpScreen(context)),
                );
              },
              onForgotPassword: () {},
            ),
          ),
        );
      },
    );
  }
}
