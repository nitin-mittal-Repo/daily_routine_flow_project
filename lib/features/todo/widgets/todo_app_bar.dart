// lib/features/todo/presentation/widgets/todo_app_bar.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TodoAppBar extends StatelessWidget {
  final VoidCallback? onClearCompleted;

  const TodoAppBar({
    super.key,
    this.onClearCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),

          // Title
          ShaderMask(
            shaderCallback: (bounds) => AppGradients.primary.createShader(bounds),
            child: const Text(
              'My Todos',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ),

          // Menu
          PopupMenuButton<String>(
            offset: const Offset(0, 44),
            color: const Color(0xFF1A1A3E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.more_horiz_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            onSelected: (value) {
              if (value == 'clear' && onClearCompleted != null) {
                onClearCompleted!();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_sweep_rounded,
                      color: AppColors.error,
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Clear Completed',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}