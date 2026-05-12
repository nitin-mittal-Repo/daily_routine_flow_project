// lib/features/notepad/presentation/widgets/add_note_sheet.dart
import 'package:flutter/material.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../data/models/note_model.dart';

class AddNoteSheet extends StatefulWidget {
  final NoteModel? note;
  final Function(NoteModel) onSave;

  const AddNoteSheet({
    super.key,
    this.note,
    required this.onSave,
  });

  @override
  State<AddNoteSheet> createState() => _AddNoteSheetState();
}

class _AddNoteSheetState extends State<AddNoteSheet> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  int _selectedColor = 0;

  bool get isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _selectedColor = widget.note!.colorIndex;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _save() {
    if (_titleController.text.trim().isEmpty) {
      _titleController.text = 'Untitled Note';
    }

    final note = NoteModel(
      id: widget.note?.id,
      title: _titleController.text.trim().isEmpty
          ? 'Untitled Note'
          : _titleController.text.trim(),
      content: _contentController.text.trim(),
      colorIndex: _selectedColor,
      createdAt: widget.note?.createdAt,
      updatedAt: DateTime.now(),
    );

    widget.onSave(note);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A3E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              isEditing ? 'Edit Note' : 'Quick Note',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // Title
            AppTextField(
              controller: _titleController,
              hintText: 'Note title...',
              label: 'TITLE',
              autofocus: true,
              fillColor: const Color(0xFF252550),
            ),
            const SizedBox(height: 14),

            // Content
            AppTextField(
              controller: _contentController,
              hintText: 'Write your thoughts...',
              label: 'CONTENT',
              maxLines: 5,
              fillColor: const Color(0xFF252550),
            ),
            const SizedBox(height: 16),

            // Color picker
            Text(
              'NOTE COLOR',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.5),
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                NoteModel.noteColors.length,
                    (index) => GestureDetector(
                  onTap: () => setState(() => _selectedColor = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: NoteModel.noteColors[index],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: _selectedColor == index
                          ? Border.all(color: Colors.white, width: 2.5)
                          : null,
                      boxShadow: _selectedColor == index
                          ? [
                        BoxShadow(
                          color: NoteModel.noteColors[index]
                              .first
                              .withOpacity(0.5),
                          blurRadius: 8,
                        ),
                      ]
                          : null,
                    ),
                    child: _selectedColor == index
                        ? const Icon(Icons.check_rounded,
                        color: Colors.white, size: 16)
                        : null,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),
            AppButton.primary(
              isEditing ? 'Update Note' : 'Save Note',
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}