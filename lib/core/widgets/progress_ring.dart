// lib/shared/components/progress_ring.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../theme/app_colors.dart';

class ProgressRing extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final Widget? centerChild;
  final LinearGradient? gradient;
  final Color? backgroundColor;
  final bool isAnimated;
  final Duration animationDuration;

  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 120,
    this.strokeWidth = 12,
    this.centerChild,
    this.gradient,
    this.backgroundColor,
    this.isAnimated = true,
    this.animationDuration = const Duration(milliseconds: 1000),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          CustomPaint(
            size: Size(size, size),
            painter: _CirclePainter(
              progress: 1.0,
              strokeWidth: strokeWidth,
              color: backgroundColor ?? Colors.white.withOpacity(0.1),
              isBackground: true,
            ),
          ),
          // Progress arc
          CustomPaint(
            size: Size(size, size),
            painter: _CirclePainter(
              progress: progress.clamp(0.0, 1.0),
              strokeWidth: strokeWidth,
              color: gradient ?? AppGradients.primary,
              isBackground: false,
            ),
          ),
          // Center content
          if (centerChild != null) centerChild!,
        ],
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final dynamic color;
  final bool isBackground;

  _CirclePainter({
    required this.progress,
    required this.strokeWidth,
    required this.color,
    required this.isBackground,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    if (color is LinearGradient && !isBackground) {
      // Create gradient shader
      final rect = Rect.fromCircle(center: center, radius: radius);
      paint.shader = (color as LinearGradient).createShader(rect);
    } else if (color is Color) {
      paint.color = color as Color;
    }

    // Draw arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      2 * math.pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CirclePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}