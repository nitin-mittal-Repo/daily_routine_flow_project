
import '../database/task_notification_helper.dart';
import '../models/todo_model.dart';

class TodoNotificationService {
  final TaskNotificationHelper _notificationHelper = TaskNotificationHelper();

  // Schedule notification for a todo
  Future<void> scheduleTodoNotification(TodoModel todo) async {
    if (todo.dueDate == null) return;

    // Schedule reminder 1 hour before due date
    await _notificationHelper.scheduleTodoReminder(
      todoId: todo.id!,
      title: todo.title,
      body: todo.description ?? 'Todo is due soon!',
      dueDate: todo.dueDate!,
      reminderMinutesBefore: 60, // 1 hour before
    );
  }

  // Cancel todo notification
  Future<void> cancelTodoNotification(int todoId) async {
    await _notificationHelper.cancelTodoReminder(todoId);
  }

  // Update notification when todo is edited
  Future<void> updateTodoNotification(TodoModel todo) async {
    await cancelTodoNotification(todo.id!);
    if (!todo.isCompleted && todo.dueDate != null) {
      await scheduleTodoNotification(todo);
    }
  }

  // Handle notification when todo is completed
  Future<void> onTodoCompleted(int todoId, String title) async {
    // Cancel the reminder if todo is completed
    await cancelTodoNotification(todoId);

    // Show success notification
    await _notificationHelper.showInstantNotification(
      title: '✅ Task Completed',
      body: 'Great job! You completed "$title"',
    );
  }
}