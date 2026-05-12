// lib/features/todo/data/todo_repository.dart
import 'package:sqflite/sqflite.dart';
import '../models/todo_model.dart';

class TodoRepository {
  static Database? _database;

  static void setDatabase(Database db) {
    _database = db;
  }

  Database _getDatabase() {
    if (_database == null) {
      throw Exception('Database not initialized. Call setDatabase first.');
    }
    return _database!;
  }

  // ✅ Add this method - it's missing
  Future<List<TodoModel>> getAllTodos() async {
    final db = _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('todos');
    return maps.map((map) => TodoModel.fromMap(map)).toList();
  }

  // Insert a new todo
  Future<void> insertTodo(TodoModel todo) async {
    final db = _getDatabase();
    await db.insert('todos', todo.toMap());
  }

  // Update an existing todo
  Future<void> updateTodo(TodoModel todo) async {
    final db = _getDatabase();
    await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  // Delete a todo by id
  Future<void> deleteTodo(int id) async {
    final db = _getDatabase();
    await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }

  // Toggle todo completion status
  Future<void> toggleTodoComplete(int id) async {
    final db = _getDatabase();
    final todos = await getAllTodos();
    final todo = todos.firstWhere((t) => t.id == id);

    await db.update(
      'todos',
      {
        'is_completed': todo.isCompleted ? 0 : 1,
        'completed_at': !todo.isCompleted ? DateTime.now().toIso8601String() : null,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete all completed todos
  Future<void> deleteCompletedTodos() async {
    final db = _getDatabase();
    await db.delete('todos', where: 'is_completed = ?', whereArgs: [1]);
  }

  // Get todo by id (optional but useful)
  Future<TodoModel?> getTodoById(int id) async {
    final db = _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TodoModel.fromMap(maps.first);
    }
    return null;
  }

  // Get todos by priority (optional)
  Future<List<TodoModel>> getTodosByPriority(int priority) async {
    final db = _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      where: 'priority = ?',
      whereArgs: [priority],
      orderBy: 'due_date ASC',
    );
    return maps.map((map) => TodoModel.fromMap(map)).toList();
  }

  // Get overdue todos (optional)
  Future<List<TodoModel>> getOverdueTodos() async {
    final db = _getDatabase();
    final now = DateTime.now().toIso8601String();
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      where: 'is_completed = 0 AND due_date IS NOT NULL AND due_date < ?',
      whereArgs: [now],
      orderBy: 'due_date ASC',
    );
    return maps.map((map) => TodoModel.fromMap(map)).toList();
  }
}