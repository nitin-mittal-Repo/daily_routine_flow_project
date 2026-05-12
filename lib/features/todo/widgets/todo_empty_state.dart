// lib/features/todo/presentation/widgets/todo_empty_state.dart
import 'package:flutter/material.dart';
import '../providers/todo_provider.dart';

class TodoEmptyState extends StatelessWidget {
  final TodoFilter filter;

  const TodoEmptyState({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated emoji
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Text(
                    _getEmoji(),
                    style: const TextStyle(fontSize: 72),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              _getTitle(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getSubtitle(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.5),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getEmoji() {
    switch (filter) {
      case TodoFilter.all:
        return '📝';
      case TodoFilter.active:
        return '💪';
      case TodoFilter.completed:
        return '🎉';
    }
  }

  String _getTitle() {
    switch (filter) {
      case TodoFilter.all:
        return 'No todos yet!';
      case TodoFilter.active:
        return 'All caught up!';
      case TodoFilter.completed:
        return 'Nothing completed yet';
    }
  }

  String _getSubtitle() {
    switch (filter) {
      case TodoFilter.all:
        return 'Tap the + button to create\nyour first todo.';
      case TodoFilter.active:
        return 'You\'ve completed\neverything. Amazing!';
      case TodoFilter.completed:
        return 'Complete a todo and it will\nappear here.';
    }
  }
}