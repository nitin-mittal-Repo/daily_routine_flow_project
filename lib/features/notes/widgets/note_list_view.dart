// lib/features/notepad/presentation/widgets/note_list_view.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/note_model.dart';
import 'note_card.dart';

class NoteListView extends StatelessWidget {
  final Map<String, List<NoteModel>> groupedNotes;
  final Function(NoteModel) onNoteTap;
  final Function(NoteModel) onNoteDelete;

  const NoteListView({
    super.key,
    required this.groupedNotes,
    required this.onNoteTap,
    required this.onNoteDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Sort dates newest first
    final sortedDates = groupedNotes.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      physics: const BouncingScrollPhysics(),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final dateKey = sortedDates[index];
        final notes = groupedNotes[dateKey]!;
        final date = DateTime.parse(dateKey);

        return _DateGroup(
          date: date,
          notes: notes,
          onNoteTap: onNoteTap,
          onNoteDelete: onNoteDelete,
        );
      },
    );
  }
}

class _DateGroup extends StatelessWidget {
  final DateTime date;
  final List<NoteModel> notes;
  final Function(NoteModel) onNoteTap;
  final Function(NoteModel) onNoteDelete;

  const _DateGroup({
    required this.date,
    required this.notes,
    required this.onNoteTap,
    required this.onNoteDelete,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final noteDate = DateTime(date.year, date.month, date.day);
    final diff = today.difference(noteDate).inDays;

    String dateLabel;
    if (diff == 0) {
      dateLabel = 'Today';
    } else if (diff == 1) {
      dateLabel = 'Yesterday';
    } else if (diff < 7) {
      final weekdays = [
        'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
      ];
      dateLabel = weekdays[date.weekday - 1];
    } else {
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      dateLabel = '${date.day} ${months[date.month - 1]} ${date.year}';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date header
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primaryMagenta.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.calendar_today_rounded,
                  size: 14,
                  color: AppColors.primaryMagenta,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                dateLabel,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${notes.length}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.4),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Notes for this date
        ...notes.map((note) => NoteCard(
          note: note,
          onTap: () => onNoteTap(note),
          onDelete: () => onNoteDelete(note),
        )),
      ],
    );
  }
}