// lib/features/water_tracker/presentation/widgets/water_history_list.dart
import 'package:flutter/material.dart';
import '../../../data/models/water_model.dart';
import 'water_history_card.dart';

class WaterHistoryList extends StatelessWidget {
  final List<WaterModel> intakeList;
  final Function(int) onDelete;

  const WaterHistoryList({
    super.key,
    required this.intakeList,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: intakeList.length,
      itemBuilder: (context, index) {
        final entry = intakeList[index];
        return WaterHistoryCard(
          entry: entry,
          onDelete: () => onDelete(entry.id!),
        );
      },
    );
  }
}