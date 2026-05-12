import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary vibrant palette
  static const Color primaryPurple = Color(0xFF7B2FF7);
  static const Color primaryMagenta = Color(0xFFFF2D95);
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color primaryTeal = Color(0xFF00D9C0);

  // Dark backgrounds
  static const Color bgDark = Color(0xFF0D0D2B);
  static const Color bgCard = Color(0xFF1A1A3E);
  static const Color bgCardLight = Color(0xFF252550);

  // Light mode
  static const Color bgLight = Color(0xFFF8F7FF);
  static const Color bgCardLightMode = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF2D2D4A);
  static const Color textSecondary = Color(0xFF7B7B9A);
  static const Color textOnDark = Color(0xFFF0F0FF);

  // Status
  static const Color success = Color(0xFF00D9C0);
  static const Color warning = Color(0xFFFFB84D);
  static const Color error = Color(0xFFFF4757);
}

class AppGradients {
  static const LinearGradient primary = LinearGradient(
    colors: [Color(0xFF7B2FF7), Color(0xFFFF2D95), Color(0xFFFF6B35)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGlow = LinearGradient(
    colors: [Color(0xFF7B2FF7), Color(0xFFFF2D95)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient tealMint = LinearGradient(
    colors: [Color(0xFF00D9C0), Color(0xFF00B4D8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sunset = LinearGradient(
    colors: [Color(0xFFFF6B35), Color(0xFFFF2D95)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient bgDarkGradient = const LinearGradient(
    colors: [Color(0xFF0D0D2B), Color(0xFF1A0A2E), Color(0xFF0D0D2B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

