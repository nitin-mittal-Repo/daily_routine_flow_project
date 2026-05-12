// lib/features/water_tracker/presentation/widgets/water_empty_state.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class WaterEmptyState extends StatelessWidget {
  const WaterEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: const Text('💧', style: TextStyle(fontSize: 64)),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'No water logged today',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap a quick add button above\nto start tracking!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.4),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}