// lib/features/notepad/providers/note_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repos/note_repository.dart';
import '../../../data/models/note_model.dart';

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  return NoteRepository();
});

// All notes
final allNotesProvider =
AsyncNotifierProvider<NotesNotifier, List<NoteModel>>(
  NotesNotifier.new,
);

class NotesNotifier extends AsyncNotifier<List<NoteModel>> {
  @override
  Future<List<NoteModel>> build() async {
    final repository = ref.read(noteRepositoryProvider);
    return repository.getAllNotes();
  }

  Future<void> addNote(NoteModel note) async {
    final repository = ref.read(noteRepositoryProvider);
    await repository.insertNote(note);
    ref.invalidateSelf();
  }

  Future<void> updateNote(NoteModel note) async {
    final repository = ref.read(noteRepositoryProvider);
    await repository.updateNote(note);
    ref.invalidateSelf();
  }

  Future<void> deleteNote(int id) async {
    final repository = ref.read(noteRepositoryProvider);
    await repository.deleteNote(id);
    ref.invalidateSelf();
  }
}

// Notes grouped by date
final groupedNotesProvider =
Provider<AsyncValue<Map<String, List<NoteModel>>>>((ref) {
  final notesAsync = ref.watch(allNotesProvider);

  return notesAsync.whenData((notes) {
    final Map<String, List<NoteModel>> grouped = {};
    for (final note in notes) {
      final dateKey =
          '${note.createdAt.year}-${note.createdAt.month.toString().padLeft(2, '0')}-${note.createdAt.day.toString().padLeft(2, '0')}';
      grouped.putIfAbsent(dateKey, () => []);
      grouped[dateKey]!.add(note);
    }
    return grouped;
  });
});

// Note count (for dashboard)
final noteCountProvider = AsyncNotifierProvider<NoteCountNotifier, int>(
  NoteCountNotifier.new,
);

class NoteCountNotifier extends AsyncNotifier<int> {
  @override
  Future<int> build() async {
    final repository = ref.read(noteRepositoryProvider);
    return repository.getNoteCount();
  }
}