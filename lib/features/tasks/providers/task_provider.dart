// lib/features/task_scheduler/providers/task_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repos/task_repository.dart';
import '../../../data/models/scheduled_task_model.dart';

// Repository provider
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository();
});

// Selected date provider (default: today)
final selectedDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

// Tasks for selected date
final tasksForDateProvider =
AsyncNotifierProvider<TasksNotifier, List<ScheduledTaskModel>>(
  TasksNotifier.new,
);

class TasksNotifier extends AsyncNotifier<List<ScheduledTaskModel>> {
  @override
  Future<List<ScheduledTaskModel>> build() async {
    final repository = ref.read(taskRepositoryProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    return repository.getTasksForDate(selectedDate);
  }

  Future<void> addTask(ScheduledTaskModel task) async {
    final repository = ref.read(taskRepositoryProvider);
    await repository.insertTask(task);
    ref.invalidateSelf();
    ref.invalidate(datesWithTasksProvider);
  }

  Future<void> toggleTask(int id) async {
    final repository = ref.read(taskRepositoryProvider);
    await repository.toggleTaskComplete(id);
    ref.invalidateSelf();
  }

  Future<void> updateTask(ScheduledTaskModel task) async {
    final repository = ref.read(taskRepositoryProvider);
    await repository.updateTask(task);
    ref.invalidateSelf();
  }

  Future<void> deleteTask(int id) async {
    final repository = ref.read(taskRepositoryProvider);
    await repository.deleteTask(id);
    ref.invalidateSelf();
    ref.invalidate(datesWithTasksProvider);
  }
}

// Dates that have tasks (for calendar dots)
final datesWithTasksProvider =
AsyncNotifierProvider<DatesWithTasksNotifier, Set<String>>(
  DatesWithTasksNotifier.new,
);

class DatesWithTasksNotifier extends AsyncNotifier<Set<String>> {
  @override
  Future<Set<String>> build() async {
    final repository = ref.read(taskRepositoryProvider);
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);
    return repository.getDatesWithTasks(monthStart, monthEnd);
  }
}

// Stats provider
final taskStatsProvider = AsyncNotifierProvider<TaskStatsNotifier, Map<String, int>>(
  TaskStatsNotifier.new,
);

class TaskStatsNotifier extends AsyncNotifier<Map<String, int>> {
  @override
  Future<Map<String, int>> build() async {
    final repository = ref.read(taskRepositoryProvider);
    return repository.getStats();
  }
}