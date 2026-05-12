// lib/features/todo/providers/todo_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repos/todo_repository.dart';
import '../../../data/models/todo_model.dart';
import '../../../data/services/todo_notification_service.dart';

// Repository provider
final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  return TodoRepository();
});

// Add notification service provider
final todoNotificationServiceProvider = Provider<TodoNotificationService>((ref) {
  return TodoNotificationService();
});

// Filter enum
enum TodoFilter { all, active, completed }

// Filter state provider
final todoFilterProvider = StateProvider<TodoFilter>((ref) {
  return TodoFilter.all;
});

// Todos list provider
final todosProvider = AsyncNotifierProvider<TodosNotifier, List<TodoModel>>(
  TodosNotifier.new,
);

class TodosNotifier extends AsyncNotifier<List<TodoModel>> {
  @override
  Future<List<TodoModel>> build() async {
    final repository = ref.read(todoRepositoryProvider);
    return repository.getAllTodos();
  }

  Future<void> addTodo(TodoModel todo) async {
    final repository = ref.read(todoRepositoryProvider);
    final notificationService = ref.read(todoNotificationServiceProvider);

    await repository.insertTodo(todo);

    // Schedule notification if todo has due date
    if (todo.dueDate != null && !todo.isCompleted) {
      // Get the inserted todo with ID
      final todos = await repository.getAllTodos();
      final insertedTodo = todos.lastWhere(
            (t) => t.title == todo.title && t.createdAt == todo.createdAt,
        orElse: () => todo,
      );

      if (insertedTodo.id != null) {
        await notificationService.scheduleTodoNotification(insertedTodo);
      }
    }

    ref.invalidateSelf(); // Refresh the list
  }

  Future<void> toggleTodo(int id) async {
    final repository = ref.read(todoRepositoryProvider);
    final notificationService = ref.read(todoNotificationServiceProvider);

    // Get the todo before toggling
    final todos = await repository.getAllTodos();
    final todo = todos.firstWhere((t) => t.id == id);

    await repository.toggleTodoComplete(id);

    // If completing a todo, cancel notification and show success
    if (!todo.isCompleted) {
      await notificationService.onTodoCompleted(id, todo.title);
    }

    ref.invalidateSelf();
  }

  Future<void> updateTodo(TodoModel todo) async {
    final repository = ref.read(todoRepositoryProvider);
    final notificationService = ref.read(todoNotificationServiceProvider);

    await repository.updateTodo(todo);

    // Update notification
    await notificationService.updateTodoNotification(todo);

    ref.invalidateSelf();
  }

  Future<void> deleteTodo(int id) async {
    final repository = ref.read(todoRepositoryProvider);
    final notificationService = ref.read(todoNotificationServiceProvider);

    await repository.deleteTodo(id);

    // Cancel notification
    await notificationService.cancelTodoNotification(id);

    ref.invalidateSelf();
  }

  Future<void> clearCompleted() async {
    final repository = ref.read(todoRepositoryProvider);
    final notificationService = ref.read(todoNotificationServiceProvider);

    // Get completed todos before deleting
    final todos = await repository.getAllTodos();
    final completedTodos = todos.where((t) => t.isCompleted).toList();

    await repository.deleteCompletedTodos();

    // Cancel notifications for completed todos
    for (var todo in completedTodos) {
      if (todo.id != null) {
        await notificationService.cancelTodoNotification(todo.id!);
      }
    }

    ref.invalidateSelf();
  }
}

// Filtered todos provider
final filteredTodosProvider = Provider<AsyncValue<List<TodoModel>>>((ref) {
  final filter = ref.watch(todoFilterProvider);
  final todosAsync = ref.watch(todosProvider);

  return todosAsync.whenData((todos) {
    switch (filter) {
      case TodoFilter.all:
        return todos;
      case TodoFilter.active:
        return todos.where((t) => !t.isCompleted).toList();
      case TodoFilter.completed:
        return todos.where((t) => t.isCompleted).toList();
    }
  });
});

// Stats provider
final todoStatsProvider = Provider<AsyncValue<Map<String, int>>>((ref) {
  final todosAsync = ref.watch(todosProvider);

  return todosAsync.whenData((todos) {
    final total = todos.length;
    final completed = todos.where((t) => t.isCompleted).length;
    final pending = total - completed;

    return {
      'total': total,
      'completed': completed,
      'pending': pending,
    };
  });
});