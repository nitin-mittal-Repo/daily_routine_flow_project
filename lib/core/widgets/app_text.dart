// lib/shared/components/app_text.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  final String text;
  final AppTextStyle style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? letterSpacing;
  final double? height;

  const AppText(
      this.text, {
        super.key,
        this.style = AppTextStyle.body,
        this.color,
        this.textAlign,
        this.maxLines,
        this.overflow,
        this.fontSize,
        this.fontWeight,
        this.letterSpacing,
        this.height,
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: _getStyle(context),
    );
  }

  TextStyle _getStyle(BuildContext context) {
    final baseStyle = style.textStyle(context);
    return baseStyle.copyWith(
      color: color ?? baseStyle.color,
      fontSize: fontSize ?? baseStyle.fontSize,
      fontWeight: fontWeight ?? baseStyle.fontWeight,
      letterSpacing: letterSpacing ?? baseStyle.letterSpacing,
      height: height ?? baseStyle.height,
    );
  }
}

enum AppTextStyle {
  displayLarge,
  displayMedium,
  displaySmall,
  heading,
  subheading,
  body,
  bodySmall,
  caption,
  label,
  button,
}

extension AppTextStyleExtension on AppTextStyle {
  TextStyle textStyle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? Colors.white : const Color(0xFF2D2D4A);
    final secondaryText =
    isDark ? Colors.white70 : const Color(0xFF7B7B9A);

    switch (this) {
      case AppTextStyle.displayLarge:
        return GoogleFonts.poppins(
          fontSize: 36,
          fontWeight: FontWeight.w800,
          color: primaryText,
          letterSpacing: -0.5,
          height: 1.2,
        );
      case AppTextStyle.displayMedium:
        return GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: primaryText,
          letterSpacing: -0.3,
          height: 1.3,
        );
      case AppTextStyle.displaySmall:
        return GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: primaryText,
          height: 1.3,
        );
      case AppTextStyle.heading:
        return GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: primaryText,
          height: 1.4,
        );
      case AppTextStyle.subheading:
        return GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: primaryText,
          height: 1.4,
        );
      case AppTextStyle.body:
        return GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: primaryText,
          height: 1.5,
        );
      case AppTextStyle.bodySmall:
        return GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: secondaryText,
          height: 1.5,
        );
      case AppTextStyle.caption:
        return GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: secondaryText,
          letterSpacing: 0.5,
        );
      case AppTextStyle.label:
        return GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: primaryText,
          letterSpacing: 0.8,
          height: 1.2,
        );
      case AppTextStyle.button:
        return GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.5,
        );
    }
  }
}