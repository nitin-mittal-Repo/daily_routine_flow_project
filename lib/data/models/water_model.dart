// lib/features/water_tracker/domain/water_model.dart
class WaterModel {
  final int? id;
  final int amountMl;       // Amount in milliliters
  final DateTime timestamp;
  final String? note;       // Optional note (e.g., "After workout")

  WaterModel({
    this.id,
    required this.amountMl,
    DateTime? timestamp,
    this.note,
  }) : timestamp = timestamp ?? DateTime.now();

  WaterModel copyWith({
    int? id,
    int? amountMl,
    DateTime? timestamp,
    String? note,
  }) {
    return WaterModel(
      id: id ?? this.id,
      amountMl: amountMl ?? this.amountMl,
      timestamp: timestamp ?? this.timestamp,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'amount_ml': amountMl,
      'timestamp': timestamp.toIso8601String(),
      'note': note ?? '',
    };
  }

  factory WaterModel.fromMap(Map<String, dynamic> map) {
    return WaterModel(
      id: map['id'] as int?,
      amountMl: map['amount_ml'] as int,
      timestamp: DateTime.parse(map['timestamp'] as String),
      note: (map['note'] as String?)?.isNotEmpty == true
          ? map['note'] as String
          : null,
    );
  }

  // Helper getters
  String get formattedAmount {
    if (amountMl >= 1000) {
      return '${(amountMl / 1000).toStringAsFixed(1)}L';
    }
    return '${amountMl}ml';
  }

  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  String get timeFormatted {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  // Glass emoji based on amount
  String get glassEmoji {
    if (amountMl <= 150) return '🥃';
    if (amountMl <= 250) return '🥛';
    if (amountMl <= 500) return '🧴';
    return '🫗';
  }
}