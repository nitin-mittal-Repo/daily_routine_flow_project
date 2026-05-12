// lib/features/todo/presentation/widgets/todo_list_view.dart
import 'package:flutter/material.dart';
import '../../../data/models/todo_model.dart';
import 'todo_card.dart';

class TodoListView extends StatelessWidget {
  final List<TodoModel> todos;
  final Function(int) onToggle;
  final Function(int) onDelete;
  final Function(TodoModel) onEdit;

  const TodoListView({
    super.key,
    required this.todos,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 100),
      physics: const BouncingScrollPhysics(),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return TodoCard(
          todo: todo,
          onToggle: () => onToggle(todo.id!),
          onDelete: () => onDelete(todo.id!),
          onEdit: () => onEdit(todo),
        );
      },
    );
  }
}