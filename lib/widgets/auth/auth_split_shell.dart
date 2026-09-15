import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class AuthSplitShell extends StatelessWidget {
  const AuthSplitShell({
    required this.formChild,
    required this.headline,
    required this.description,
    super.key,
  });

  final Widget formChild;
  final String headline;
  final String description;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 600;
    final split = width >= 1024;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: split
            ? Row(
                children: [
                  Expanded(flex: 5, child: _BrandPanel(headline: headline, description: description)),
                  Expanded(flex: 6, child: _FormArea(child: formChild)),
                ],
              )
            : Column(
                children: [
                  if (compact) const _CompactBrandHeader(),
                  if (!compact)
                    SizedBox(
                      height: 190,
                      child: _BrandPanel(headline: headline, description: description),
                    ),
                  Expanded(child: _FormArea(child: formChild)),
                ],
              ),
      ),
    );
  }
}

class _FormArea extends StatelessWidget {
  const _FormArea({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 420), child: child),
        ),
      ),
    );
  }
}

class _BrandPanel extends StatelessWidget {
  const _BrandPanel({required this.headline, required this.description});

  final String headline;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.tealDark,
      padding: const EdgeInsets.all(48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _BrandMark(),
          const Spacer(),
          Text(headline, style: const TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.w800, height: 1.1)),
          const SizedBox(height: 16),
          Text(description, style: TextStyle(color: Colors.white.withValues(alpha: .78), fontSize: 16, height: 1.5)),
          const SizedBox(height: 28),
          const _Feature(icon: Icons.account_tree_outlined, text: 'Multi-branch records'),
          const _Feature(icon: Icons.assignment_outlined, text: 'Complete history per patient'),
          const _Feature(icon: Icons.notifications_active_outlined, text: 'Smart follow-up & vaccination alerts'),
          const Spacer(),
          Text('© 2026 VetBridge. Care connected.', style: TextStyle(color: Colors.white.withValues(alpha: .55), fontSize: 12)),
        ],
      ),
    );
  }
}

class _CompactBrandHeader extends StatelessWidget {
  const _CompactBrandHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.tealDark,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      child: const _BrandMark(),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(color: AppColors.mint, borderRadius: BorderRadius.circular(11)),
          child: const Icon(Icons.pets_rounded, color: AppColors.tealDark),
        ),
        const SizedBox(width: 12),
        const Text('VetBridge', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _Feature extends StatelessWidget {
  const _Feature({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Icon(icon, color: AppColors.mint, size: 20),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(color: Colors.white.withValues(alpha: .88), fontSize: 14)),
        ],
      ),
    );
  }
}
