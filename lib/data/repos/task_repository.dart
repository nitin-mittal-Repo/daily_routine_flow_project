
// lib/features/task_scheduler/data/task_repository.dart
import 'package:sqflite/sqflite.dart';
import '../models/scheduled_task_model.dart';

class TaskRepository {
  static final TaskRepository _instance = TaskRepository._internal();
  factory TaskRepository() => _instance;
  TaskRepository._internal();

  // ✅ Shared database reference
  static Database? _sharedDatabase;

  // ✅ Setter to receive shared database from DatabaseHelper
  static void setDatabase(Database db) {
    _sharedDatabase = db;
  }

  // ✅ Simple getter - no more _initDatabase
  Future<Database> get database async {
    if (_sharedDatabase != null) return _sharedDatabase!;
    throw Exception(
        'Database not initialized. Call TaskRepository.setDatabase() first.');
  }

  // CREATE
  Future<int> insertTask(ScheduledTaskModel task) async {
    final db = await database;
    return await db.insert('scheduled_tasks', task.toMap());
  }

  // READ - Tasks for specific date
  Future<List<ScheduledTaskModel>> getTasksForDate(DateTime date) async {
    final db = await database;
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    final List<Map<String, dynamic>> maps = await db.query(
      'scheduled_tasks',
      where: 'scheduled_date = ?',
      whereArgs: [dateStr],
      orderBy: 'priority DESC, scheduled_time ASC',
    );
    return maps.map((map) => ScheduledTaskModel.fromMap(map)).toList();
  }

  // READ - All tasks
  Future<List<ScheduledTaskModel>> getAllTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'scheduled_tasks',
      orderBy: 'scheduled_date ASC, priority DESC',
    );
    return maps.map((map) => ScheduledTaskModel.fromMap(map)).toList();
  }

  // READ - Upcoming tasks with reminders
  Future<List<ScheduledTaskModel>> getUpcomingTasksWithReminders() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'scheduled_tasks',
      where: 'has_reminder = 1 AND is_completed = 0 AND scheduled_date >= ?',
      whereArgs: [
        '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}',
      ],
      orderBy: 'scheduled_date ASC, scheduled_time ASC',
    );
    return maps.map((map) => ScheduledTaskModel.fromMap(map)).toList();
  }

  // READ - Task counts for date range (calendar dots)
  Future<Set<String>> getDatesWithTasks(
      DateTime monthStart, DateTime monthEnd) async {
    final db = await database;
    final startStr =
        '${monthStart.year}-${monthStart.month.toString().padLeft(2, '0')}-${monthStart.day.toString().padLeft(2, '0')}';
    final endStr =
        '${monthEnd.year}-${monthEnd.month.toString().padLeft(2, '0')}-${monthEnd.day.toString().padLeft(2, '0')}';

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT DISTINCT scheduled_date FROM scheduled_tasks WHERE scheduled_date >= ? AND scheduled_date <= ?',
      [startStr, endStr],
    );

    return maps.map((m) => m['scheduled_date'] as String).toSet();
  }

  // UPDATE
  Future<int> updateTask(ScheduledTaskModel task) async {
    final db = await database;
    return await db.update(
      'scheduled_tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // DELETE
  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      'scheduled_tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // TOGGLE
  Future<void> toggleTaskComplete(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'scheduled_tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      final task = ScheduledTaskModel.fromMap(maps.first);
      final updated = task.copyWith(
        isCompleted: !task.isCompleted,
        completedAt: !task.isCompleted ? DateTime.now() : null,
      );
      await updateTask(updated);
    }
  }

  // Get stats
  Future<Map<String, int>> getStats() async {
    final db = await database;
    final todayStr =
        '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';

    final totalToday = await db.rawQuery(
      'SELECT COUNT(*) as count FROM scheduled_tasks WHERE scheduled_date = ?',
      [todayStr],
    );
    final completedToday = await db.rawQuery(
      'SELECT COUNT(*) as count FROM scheduled_tasks WHERE scheduled_date = ? AND is_completed = 1',
      [todayStr],
    );
    final totalAll = await db.rawQuery(
      'SELECT COUNT(*) as count FROM scheduled_tasks',
    );

    return {
      'todayTotal': Sqflite.firstIntValue(totalToday) ?? 0,
      'todayCompleted': Sqflite.firstIntValue(completedToday) ?? 0,
      'totalAll': Sqflite.firstIntValue(totalAll) ?? 0,
    };
  }
}