// lib/features/notepad/presentation/screens/notepad_screen.dart
import 'package:daily_routine_flow/features/notes/providers/note_provider.dart';
import 'package:daily_routine_flow/features/notes/widgets/add_note_sheet.dart';
import 'package:daily_routine_flow/features/notes/widgets/note_app_bar.dart';
import 'package:daily_routine_flow/features/notes/widgets/note_empty_state.dart';
import 'package:daily_routine_flow/features/notes/widgets/note_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/note_model.dart';

class NotepadScreen extends ConsumerStatefulWidget {
  const NotepadScreen({super.key});

  @override
  ConsumerState<NotepadScreen> createState() => _NotepadScreenState();
}

class _NotepadScreenState extends ConsumerState<NotepadScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(allNotesProvider);
    final groupedAsync = ref.watch(groupedNotesProvider);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D0D2B), Color(0xFF1A0A2E), Color(0xFF0D0D2B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar with search
              NoteAppBar(
                onSearchChanged: (query) {
                  setState(() => _searchQuery = query);
                },
              ),

              // Notes list
              Expanded(
                child: groupedAsync.when(
                  data: (grouped) {
                    if (grouped.isEmpty) {
                      return const NoteEmptyState();
                    }
                    return NoteListView(
                      groupedNotes: grouped,
                      onNoteTap: (note) => _showEditSheet(note),
                      onNoteDelete: (note) => _confirmDelete(note),
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryMagenta,
                    ),
                  ),
                  error: (_, __) => Center(
                    child: Text(
                      'Something went wrong',
                      style: TextStyle(color: Colors.white.withOpacity(0.6)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // FAB - Quick add note
      floatingActionButton: GestureDetector(
        onTap: () => _showAddSheet(),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primaryMagenta, AppColors.primaryPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryMagenta.withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.add_rounded,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddNoteSheet(
        onSave: (note) {
          ref.read(allNotesProvider.notifier).addNote(note);
        },
      ),
    );
  }

  void _showEditSheet(NoteModel note) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddNoteSheet(
        note: note,
        onSave: (updatedNote) {
          ref.read(allNotesProvider.notifier).updateNote(updatedNote);
        },
      ),
    );
  }

  void _confirmDelete(NoteModel note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A3E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Delete Note',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'Are you sure you want to delete this note?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              ref.read(allNotesProvider.notifier).deleteNote(note.id!);
              Navigator.pop(context);
            },
            child: const Text('Delete',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}