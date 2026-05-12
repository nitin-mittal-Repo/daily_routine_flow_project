// lib/features/notepad/data/note_repository.dart
import 'package:sqflite/sqflite.dart';
import '../models/note_model.dart';



class NoteRepository {
  static final NoteRepository _instance = NoteRepository._internal();
  factory NoteRepository() => _instance;
  NoteRepository._internal();

  // ✅ Use a static database reference that can be shared
  static Database? _sharedDatabase;

  // ✅ Setter to receive the shared database from DatabaseHelper
  static void setDatabase(Database db) {
    _sharedDatabase = db;
  }

  Future<Database> get database async {
    if (_sharedDatabase != null) return _sharedDatabase!;
    throw Exception(
      'Database not initialized. Call NoteRepository.setDatabase() first.',
    );
  }

  // CREATE
  Future<int> insertNote(NoteModel note) async {
    final db = await database;
    return await db.insert('notes', note.toMap());
  }

  // READ - All notes, newest first
  Future<List<NoteModel>> getAllNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      orderBy: 'updated_at DESC',
    );
    return maps.map((map) => NoteModel.fromMap(map)).toList();
  }

  // READ - Notes for today
  Future<List<NoteModel>> getTodayNotes() async {
    final db = await database;
    final todayStart = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'created_at >= ? AND created_at < ?',
      whereArgs: [todayStart.toIso8601String(), todayEnd.toIso8601String()],
      orderBy: 'updated_at DESC',
    );
    return maps.map((map) => NoteModel.fromMap(map)).toList();
  }

  // READ - Notes grouped by date
  Future<Map<String, List<NoteModel>>> getNotesGroupedByDate() async {
    final notes = await getAllNotes();
    final Map<String, List<NoteModel>> grouped = {};

    for (final note in notes) {
      final dateKey =
          '${note.createdAt.year}-${note.createdAt.month.toString().padLeft(2, '0')}-${note.createdAt.day.toString().padLeft(2, '0')}';
      grouped.putIfAbsent(dateKey, () => []);
      grouped[dateKey]!.add(note);
    }

    return grouped;
  }

  // READ - Single note
  Future<NoteModel?> getNoteById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return NoteModel.fromMap(maps.first);
  }

  // UPDATE
  Future<int> updateNote(NoteModel note) async {
    final db = await database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // DELETE
  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // SEARCH
  Future<List<NoteModel>> searchNotes(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'title LIKE ? OR content LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'updated_at DESC',
    );
    return maps.map((map) => NoteModel.fromMap(map)).toList();
  }

  // Get count
  Future<int> getNoteCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM notes');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}