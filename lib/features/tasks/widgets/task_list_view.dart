// lib/features/task_scheduler/presentation/widgets/task_list_view.dart
import 'package:flutter/material.dart';
import '../../../data/models/scheduled_task_model.dart';
import 'task_card.dart';

class TaskListView extends StatelessWidget {
  final List<ScheduledTaskModel> tasks;
  final Function(int) onToggle;
  final Function(int) onDelete;
  final Function(ScheduledTaskModel) onEdit;

  const TaskListView({
    super.key,
    required this.tasks,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    // Group tasks: incomplete first, then completed
    final incomplete = tasks.where((t) => !t.isCompleted).toList();
    final completed = tasks.where((t) => t.isCompleted).toList();

    return ListView(
      padding: const EdgeInsets.only(bottom: 100),
      physics: const BouncingScrollPhysics(),
      children: [
        ...incomplete.map((task) => TaskCard(
          task: task,
          onToggle: () => onToggle(task.id!),
          onDelete: () => onDelete(task.id!),
          onEdit: () => onEdit(task),
        )),
        if (completed.isNotEmpty) ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Completed (${completed.length})',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
          const SizedBox(height: 4),
          ...completed.map((task) => TaskCard(
            task: task,
            onToggle: () => onToggle(task.id!),
            onDelete: () => onDelete(task.id!),
            onEdit: () => onEdit(task),
          )),
        ],
      ],
    );
  }
}