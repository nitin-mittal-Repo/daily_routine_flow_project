// lib/features/water_tracker/data/water_repository.dart
import 'package:sqflite/sqflite.dart';

import '../models/water_model.dart';


class WaterRepository {
  static final WaterRepository _instance = WaterRepository._internal();
  factory WaterRepository() => _instance;
  WaterRepository._internal();

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
        'Database not initialized. Call WaterRepository.setDatabase() first.');
  }

  // ==================== WATER INTAKE CRUD ====================

  // CREATE
  Future<int> addWaterIntake(WaterModel water) async {
    final db = await database;
    return await db.insert('water_intake', water.toMap());
  }

  // READ - Today's intake
  Future<List<WaterModel>> getTodayIntake() async {
    final db = await database;
    final todayStart = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final todayEnd = todayStart.add(const Duration(days: 1));

    final List<Map<String, dynamic>> maps = await db.query(
      'water_intake',
      where: 'timestamp >= ? AND timestamp < ?',
      whereArgs: [todayStart.toIso8601String(), todayEnd.toIso8601String()],
      orderBy: 'timestamp DESC',
    );
    return maps.map((map) => WaterModel.fromMap(map)).toList();
  }

  // READ - Intake for specific date
  Future<List<WaterModel>> getIntakeForDate(DateTime date) async {
    final db = await database;
    final dateStart = DateTime(date.year, date.month, date.day);
    final dateEnd = dateStart.add(const Duration(days: 1));

    final List<Map<String, dynamic>> maps = await db.query(
      'water_intake',
      where: 'timestamp >= ? AND timestamp < ?',
      whereArgs: [dateStart.toIso8601String(), dateEnd.toIso8601String()],
      orderBy: 'timestamp DESC',
    );
    return maps.map((map) => WaterModel.fromMap(map)).toList();
  }

  // READ - Last 7 days summary (for streak)
  Future<Map<String, int>> getWeekSummary() async {
    final db = await database;
    final result = <String, int>{};

    for (int i = 0; i < 7; i++) {
      final date = DateTime.now().subtract(Duration(days: i));
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final dateStart = DateTime(date.year, date.month, date.day);
      final dateEnd = dateStart.add(const Duration(days: 1));

      final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT SUM(amount_ml) as total FROM water_intake WHERE timestamp >= ? AND timestamp < ?',
        [dateStart.toIso8601String(), dateEnd.toIso8601String()],
      );

      final total = (maps.first['total'] as int?) ?? 0;
      result[dateKey] = total;
    }

    return result;
  }

  // READ - Today's total
  Future<int> getTodayTotal() async {
    final db = await database;
    final todayStart = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final todayEnd = todayStart.add(const Duration(days: 1));

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT SUM(amount_ml) as total FROM water_intake WHERE timestamp >= ? AND timestamp < ?',
      [todayStart.toIso8601String(), todayEnd.toIso8601String()],
    );

    return (maps.first['total'] as int?) ?? 0;
  }

  // UPDATE
  Future<int> updateWaterIntake(WaterModel water) async {
    final db = await database;
    return await db.update(
      'water_intake',
      water.toMap(),
      where: 'id = ?',
      whereArgs: [water.id],
    );
  }

  // DELETE
  Future<int> deleteWaterIntake(int id) async {
    final db = await database;
    return await db.delete(
      'water_intake',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== GOAL CRUD ====================

  // READ - Get current goal
  Future<int> getDailyGoal() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'water_goal',
      orderBy: 'updated_at DESC',
      limit: 1,
    );

    if (maps.isEmpty) {
      // Insert default
      await db.insert('water_goal', {
        'goal_ml': 2000,
        'updated_at': DateTime.now().toIso8601String(),
      });
      return 2000;
    }

    return maps.first['goal_ml'] as int;
  }

  // UPDATE - Set new goal
  Future<void> setDailyGoal(int goalMl) async {
    final db = await database;
    await db.insert('water_goal', {
      'goal_ml': goalMl,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  // Calculate streak (consecutive days meeting goal)
  Future<int> getStreak() async {
    final goal = await getDailyGoal();
    int streak = 0;

    for (int i = 0; i < 365; i++) {
      final date = DateTime.now().subtract(Duration(days: i));
      final dateStart = DateTime(date.year, date.month, date.day);
      final dateEnd = dateStart.add(const Duration(days: 1));

      final db = await database;
      final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT SUM(amount_ml) as total FROM water_intake WHERE timestamp >= ? AND timestamp < ?',
        [dateStart.toIso8601String(), dateEnd.toIso8601String()],
      );

      final total = (maps.first['total'] as int?) ?? 0;

      if (total >= goal) {
        streak++;
      } else if (i > 0) {
        break;
      }
    }

    return streak;
  }
}