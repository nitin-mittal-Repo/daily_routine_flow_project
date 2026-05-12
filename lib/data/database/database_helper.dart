// lib/shared/database/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../repos/note_repository.dart';
import '../repos/task_repository.dart';
import '../repos/todo_repository.dart';
import '../repos/water_repository.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  static bool _isInitialized = false;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'daily_routine_flow.db');

    final db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );

    // Share with all repositories (only once)
    if (!_isInitialized) {
      TodoRepository.setDatabase(db);
      WaterRepository.setDatabase(db);
      TaskRepository.setDatabase(db);
      NoteRepository.setDatabase(db);
      _isInitialized = true;
    }

    return db;
  }


  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT DEFAULT '',
        is_completed INTEGER DEFAULT 0,
        priority INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        due_date TEXT,
        completed_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS water_intake (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount_ml INTEGER NOT NULL,
        timestamp TEXT NOT NULL,
        note TEXT DEFAULT ''
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS water_goal (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        goal_ml INTEGER NOT NULL DEFAULT 2000,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.insert('water_goal', {
      'goal_ml': 2000,
      'updated_at': DateTime.now().toIso8601String(),
    });

    await db.execute('''
      CREATE TABLE IF NOT EXISTS scheduled_tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT DEFAULT '',
        scheduled_date TEXT NOT NULL,
        scheduled_time TEXT,
        is_completed INTEGER DEFAULT 0,
        priority INTEGER DEFAULT 0,
        has_reminder INTEGER DEFAULT 0,
        reminder_minutes_before INTEGER,
        created_at TEXT NOT NULL,
        completed_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL DEFAULT '',
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        color_index INTEGER DEFAULT 0
      )
    ''');
  }
}