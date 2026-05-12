// lib/features/task_scheduler/presentation/screens/task_scheduler_screen.dart
import 'package:daily_routine_flow/features/tasks/providers/task_provider.dart';
import 'package:daily_routine_flow/features/tasks/widgets/add_task_sheet.dart';
import 'package:daily_routine_flow/features/tasks/widgets/calendar_strip.dart';
import 'package:daily_routine_flow/features/tasks/widgets/task_app_bar.dart';
import 'package:daily_routine_flow/features/tasks/widgets/task_empty_state.dart';
import 'package:daily_routine_flow/features/tasks/widgets/task_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/scheduled_task_model.dart';

class TaskSchedulerScreen extends ConsumerWidget {
  const TaskSchedulerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final tasksAsync = ref.watch(tasksForDateProvider);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D0D2B), Color(0xFF1A0A2E), Color(0xFF0D0D2B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              const TaskAppBar(),

              // Calendar Strip
              CalendarStrip(
                selectedDate: selectedDate,
                onDateSelected: (date) {
                  ref.read(selectedDateProvider.notifier).state = date;
                },
              ),

              const SizedBox(height: 12),

              // Task list for selected date
              Expanded(
                child: tasksAsync.when(
                  data: (tasks) {
                    if (tasks.isEmpty) {
                      return TaskEmptyState(selectedDate: selectedDate);
                    }
                    return TaskListView(
                      tasks: tasks,
                      onToggle: (id) {
                        ref.read(tasksForDateProvider.notifier).toggleTask(id);
                      },
                      onDelete: (id) {
                        _confirmDelete(context, ref, id);
                      },
                      onEdit: (task) {
                        _showEditSheet(context, ref, task);
                      },
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryOrange,
                    ),
                  ),
                  error: (_, __) => Center(
                    child: Text(
                      'Something went wrong',
                      style: TextStyle(color: Colors.white.withOpacity(0.6)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // FAB - Add task
      floatingActionButton: GestureDetector(
        onTap: () => _showAddSheet(context, ref, selectedDate),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primaryOrange, Color(0xFFFFB84D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryOrange.withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.add_rounded,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showAddSheet(BuildContext context, WidgetRef ref, DateTime date) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddTaskSheet(
        initialDate: date,
        onSave: (task) {
          ref.read(tasksForDateProvider.notifier).addTask(task);
        },
      ),
    );
  }

  void _showEditSheet(BuildContext context, WidgetRef ref, ScheduledTaskModel task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddTaskSheet(
        task: task,
        initialDate: task.scheduledDate,
        onSave: (updatedTask) {
          ref.read(tasksForDateProvider.notifier).updateTask(updatedTask);
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A3E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Delete Task',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'Are you sure you want to delete this task?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              ref.read(tasksForDateProvider.notifier).deleteTask(id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}