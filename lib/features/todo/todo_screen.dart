// lib/features/todo/presentation/screens/todo_screen.dart
import 'package:daily_routine_flow/features/todo/providers/todo_provider.dart';
import 'package:daily_routine_flow/features/todo/widgets/add_todo_sheet.dart';
import 'package:daily_routine_flow/features/todo/widgets/todo_app_bar.dart';
import 'package:daily_routine_flow/features/todo/widgets/todo_empty_state.dart';
import 'package:daily_routine_flow/features/todo/widgets/todo_filter_bar.dart';
import 'package:daily_routine_flow/features/todo/widgets/todo_list_view.dart';
import 'package:daily_routine_flow/features/todo/widgets/todo_stats_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/todo_model.dart';

class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredTodosAsync = ref.watch(filteredTodosProvider);
    final statsAsync = ref.watch(todoStatsProvider);
    final filter = ref.watch(todoFilterProvider);

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
              TodoAppBar(
                onClearCompleted: () {
                  _showClearCompletedDialog(context, ref);
                },
              ),

              // Stats bar
              statsAsync.when(
                data: (stats) => TodoStatsBar(
                  total: stats['total'] ?? 0,
                  completed: stats['completed'] ?? 0,
                ),
                loading: () => const SizedBox(height: 4),
                error: (_, __) => const SizedBox(height: 4),
              ),

              // Filter tabs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: TodoFilterBar(
                  currentFilter: filter,
                  onFilterChanged: (newFilter) {
                    ref.read(todoFilterProvider.notifier).state = newFilter;
                  },
                ),
              ),

              const SizedBox(height: 8),

              // Todo list
              Expanded(
                child: filteredTodosAsync.when(
                  data: (todos) {
                    if (todos.isEmpty) {
                      return TodoEmptyState(filter: filter);
                    }
                    return TodoListView(
                      todos: todos,
                      onToggle: (id) {
                        ref.read(todosProvider.notifier).toggleTodo(id);
                      },
                      onDelete: (id) {
                        _showDeleteConfirmDialog(context, ref, id);
                      },
                      onEdit: (todo) {
                        _showEditTodoSheet(context, ref, todo);
                      },
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryPurple,
                    ),
                  ),
                  error: (error, _) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 48,
                          color: Colors.white.withOpacity(0.5),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Something went wrong',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Floating action button
      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: AppGradients.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPurple.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => _showAddTodoSheet(context, ref),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add_rounded, size: 30, color: Colors.white),
        ),
      ),
    );
  }

  void _showAddTodoSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddTodoSheet(
        onSave: (todo) {
          ref.read(todosProvider.notifier).addTodo(todo);
        },
      ),
    );
  }

  void _showEditTodoSheet(BuildContext context, WidgetRef ref, TodoModel todo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddTodoSheet(
        todo: todo,
        onSave: (updatedTodo) {
          ref.read(todosProvider.notifier).updateTodo(updatedTodo);
        },
      ),
    );
  }

  void _showClearCompletedDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A3E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Clear Completed',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'Remove all completed todos? This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(todosProvider.notifier).clearCompleted();
              Navigator.pop(context);
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, WidgetRef ref, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A3E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Delete Todo',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'Are you sure you want to delete this todo?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              ref.read(todosProvider.notifier).deleteTodo(id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}