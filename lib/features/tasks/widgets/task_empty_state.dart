// lib/features/task_scheduler/presentation/widgets/task_empty_state.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class TaskEmptyState extends StatelessWidget {
  final DateTime selectedDate;

  const TaskEmptyState({super.key, required this.selectedDate});

  bool get _isToday {
    final now = DateTime.now();
    return selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;
  }

  bool get _isPast {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return selectedDate.isBefore(today);
  }

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
                  child: Text(
                    _isPast ? '✅' : '📋',
                    style: const TextStyle(fontSize: 64),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              _isPast ? 'No tasks this day' : 'No tasks scheduled',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _isPast
                  ? 'You had no tasks on this date.'
                  : _isToday
                  ? 'Tap + to add a task for today!'
                  : 'Tap + to plan ahead for this day.',
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