// lib/features/notepad/domain/note_model.dart
import 'dart:ui';

class NoteModel {
  final int? id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int colorIndex; // 0-7 for color coding

  NoteModel({
    this.id,
    required this.title,
    required this.content,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.colorIndex = 0,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  NoteModel copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? colorIndex,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      colorIndex: colorIndex ?? this.colorIndex,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'color_index': colorIndex,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      colorIndex: map['color_index'] as int? ?? 0,
    );
  }

  // Color palette for notes
  static const List<List<Color>> noteColors = [
    [Color(0xFF7B2FF7), Color(0xFFFF2D95)], // Purple-Pink
    [Color(0xFF00D9C0), Color(0xFF00B4D8)], // Teal-Blue
    [Color(0xFFFF6B35), Color(0xFFFFB84D)], // Orange-Yellow
    [Color(0xFF2DCE89), Color(0xFF2DCE89)], // Green
    [Color(0xFF11CDEF), Color(0xFF1171EF)], // Sky Blue
    [Color(0xFFF5365C), Color(0xFFF56036)], // Red-Coral
    [Color(0xFF8965E0), Color(0xFFBC65E0)], // Purple
    [Color(0xFFFB6340), Color(0xFFFBB140)], // Warm
  ];

  List<Color> get colors => noteColors[colorIndex % noteColors.length];

  String get previewContent {
    if (content.length <= 80) return content;
    return '${content.substring(0, 80)}...';
  }

  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final noteDate = DateTime(createdAt.year, createdAt.month, createdAt.day);
    final diff = today.difference(noteDate).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) {
      final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return weekdays[createdAt.weekday - 1];
    }
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }

  String get formattedTime {
    return '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
  }
}