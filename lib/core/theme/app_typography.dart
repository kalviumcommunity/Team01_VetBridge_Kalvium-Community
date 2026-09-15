import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Shared type helpers for the wider application shell.
class AppTypography {
  AppTypography._();

  static TextTheme textTheme = TextTheme(
    bodyLarge: GoogleFonts.manrope(fontSize: 16),
    bodyMedium: GoogleFonts.manrope(fontSize: 14),
    headlineMedium: GoogleFonts.fraunces(fontWeight: FontWeight.w600),
  );

  static TextStyle get pageTitle => textTheme.headlineMedium!.copyWith(
        color: const Color(0xFF102C2A),
        fontSize: 25,
        fontWeight: FontWeight.w800,
      );

  static const pageSubtitle = TextStyle(
    color: Color(0xFF657572),
    fontSize: 14,
  );
}
