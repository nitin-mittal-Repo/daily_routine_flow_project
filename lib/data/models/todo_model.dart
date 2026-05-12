// lib/features/todo/domain/todo_model.dart
class TodoModel {
  final int? id;
  final String title;
  final String? description;
  final bool isCompleted;
  final int priority; // 0 = low, 1 = medium, 2 = high
  final DateTime createdAt;
  final DateTime? dueDate;
  final DateTime? completedAt;

  TodoModel({
    this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.priority = 0,
    DateTime? createdAt,
    this.dueDate,
    this.completedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Copy with method for immutability
  TodoModel copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    int? priority,
    DateTime? createdAt,
    DateTime? dueDate,
    DateTime? completedAt,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  // Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description ?? '',
      'is_completed': isCompleted ? 1 : 0,
      'priority': priority,
      'created_at': createdAt.toIso8601String(),
      'due_date': dueDate?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  // Create from Map (SQLite)
  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String?,
      isCompleted: (map['is_completed'] as int) == 1,
      priority: map['priority'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      dueDate: map['due_date'] != null
          ? DateTime.parse(map['due_date'] as String)
          : null,
      completedAt: map['completed_at'] != null
          ? DateTime.parse(map['completed_at'] as String)
          : null,
    );
  }

  // Priority helpers
  String get priorityLabel {
    switch (priority) {
      case 2:
        return 'High';
      case 1:
        return 'Medium';
      case 0:
        return 'Low';
      default:
        return 'Low';
    }
  }

  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return dueDate!.isBefore(DateTime.now());
  }
}