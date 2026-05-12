// lib/features/task_scheduler/domain/scheduled_task_model.dart
import 'package:flutter/material.dart';

class ScheduledTaskModel {
  final int? id;
  final String title;
  final String? description;
  final DateTime scheduledDate;
  final TimeOfDay? scheduledTime;
  final bool isCompleted;
  final int priority; // 0 = low, 1 = medium, 2 = high
  final bool hasReminder;
  final int? reminderMinutesBefore; // e.g., 15, 30, 60
  final DateTime createdAt;
  final DateTime? completedAt;

  ScheduledTaskModel({
    this.id,
    required this.title,
    this.description,
    required this.scheduledDate,
    this.scheduledTime,
    this.isCompleted = false,
    this.priority = 0,
    this.hasReminder = false,
    this.reminderMinutesBefore,
    this.completedAt,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  ScheduledTaskModel copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? scheduledDate,
    TimeOfDay? scheduledTime,
    bool? isCompleted,
    int? priority,
    bool? hasReminder,
    int? reminderMinutesBefore,
    DateTime? completedAt,
    DateTime? createdAt,
  }) {
    return ScheduledTaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      hasReminder: hasReminder ?? this.hasReminder,
      reminderMinutesBefore:
      reminderMinutesBefore ?? this.reminderMinutesBefore,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description ?? '',
      'scheduled_date': scheduledDate.toIso8601String().split('T')[0],
      'scheduled_time': scheduledTime != null
          ? '${scheduledTime!.hour.toString().padLeft(2, '0')}:${scheduledTime!.minute.toString().padLeft(2, '0')}'
          : null,
      'is_completed': isCompleted ? 1 : 0,
      'priority': priority,
      'has_reminder': hasReminder ? 1 : 0,
      'reminder_minutes_before': reminderMinutesBefore,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  factory ScheduledTaskModel.fromMap(Map<String, dynamic> map) {
    TimeOfDay? scheduledTime;
    if (map['scheduled_time'] != null) {
      final parts = (map['scheduled_time'] as String).split(':');
      scheduledTime = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }

    return ScheduledTaskModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String?,
      scheduledDate: DateTime.parse(map['scheduled_date'] as String),
      scheduledTime: scheduledTime,
      isCompleted: (map['is_completed'] as int) == 1,
      priority: map['priority'] as int,
      hasReminder: (map['has_reminder'] as int) == 1,
      reminderMinutesBefore: map['reminder_minutes_before'] as int?,
      createdAt: DateTime.parse(map['created_at'] as String),
      completedAt: map['completed_at'] != null
          ? DateTime.parse(map['completed_at'] as String)
          : null,
    );
  }

  // Helpers
  String get priorityLabel {
    switch (priority) {
      case 2:
        return 'High';
      case 1:
        return 'Medium';
      default:
        return 'Low';
    }
  }

  String get formattedTime {
    if (scheduledTime == null) return 'All day';
    final hour = scheduledTime!.hourOfPeriod;
    final minute =
    scheduledTime!.minute.toString().padLeft(2, '0');
    final period = scheduledTime!.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour == 0 ? 12 : hour}:$minute $period';
  }

  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate =
    DateTime(scheduledDate.year, scheduledDate.month, scheduledDate.day);
    final diff = taskDate.difference(today).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff == -1) return 'Yesterday';
    if (diff > 1 && diff < 7) {
      final weekdays = [
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
        'Sun'
      ];
      return weekdays[scheduledDate.weekday - 1];
    }
    return '${scheduledDate.day}/${scheduledDate.month}/${scheduledDate.year}';
  }

  bool get isOverdue {
    if (isCompleted) return false;
    final now = DateTime.now();
    final taskDateTime = scheduledTime != null
        ? DateTime(scheduledDate.year, scheduledDate.month, scheduledDate.day,
        scheduledTime!.hour, scheduledTime!.minute)
        : DateTime(scheduledDate.year, scheduledDate.month, scheduledDate.day,
        23, 59);
    return taskDateTime.isBefore(now);
  }
}