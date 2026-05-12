
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class GradientBorderPainter extends CustomPainter {
  final LinearGradient gradient;
  final double strokeWidth;
  final double borderRadius;

  GradientBorderPainter({
    required this.gradient,
    this.strokeWidth = 2,
    this.borderRadius = 24,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );
    final paint = Paint()
      ..shader = gradient.createShader(rect.outerRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawRRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AnimatedGradientBorder extends StatefulWidget {
  final Widget child;
  final double borderRadius;

  const AnimatedGradientBorder({
    super.key,
    required this.child,
    this.borderRadius = 24,
  });

  @override
  State<AnimatedGradientBorder> createState() => _AnimatedGradientBorderState();
}

class _AnimatedGradientBorderState extends State<AnimatedGradientBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: GradientBorderPainter(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryPurple,
                AppColors.primaryMagenta,
                AppColors.primaryOrange,
                AppColors.primaryPurple,
              ],
              transform: _GradientRotation(_controller.value * 2 * 3.14159),
            ),
            borderRadius: widget.borderRadius,
          ),
          child: widget.child,
        );
      },
    );
  }
}

class _GradientRotation extends GradientTransform {
  final double angle;
  const _GradientRotation(this.angle);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.rotationZ(angle);
  }
}