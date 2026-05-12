// lib/features/water_tracker/presentation/widgets/water_goal_setter.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';

class WaterGoalSetter extends StatefulWidget {
  final int currentGoal;
  final Function(int) onSetGoal;

  const WaterGoalSetter({super.key, required this.currentGoal, required this.onSetGoal});

  @override
  State<WaterGoalSetter> createState() => _WaterGoalSetterState();
}

class _WaterGoalSetterState extends State<WaterGoalSetter> {
  late int _selectedGoal;

  static const List<int> _goalOptions = [
    1000, // 1L
    1500, // 1.5L
    2000, // 2L
    2500, // 2.5L
    3000, // 3L
    3500, // 3.5L
    4000, // 4L
  ];

  @override
  void initState() {
    super.initState();
    _selectedGoal = widget.currentGoal;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A3E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'Daily Water Goal',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text('How much water do you want to drink daily?', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.5))),
          const SizedBox(height: 24),

          // Goal grid
          Wrap(
            spacing: 10,
            runSpacing: 5,
            children: _goalOptions.map((goal) {
              final isSelected = _selectedGoal == goal;
              final goalFormatted = goal >= 1000 ? '${(goal / 1000)}L' : '${goal}ml';

              return GestureDetector(
                onTap: () => setState(() => _selectedGoal = goal),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppGradients.tealMint : null,
                    color: isSelected ? null : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: isSelected ? AppColors.primaryTeal.withOpacity(0.5) : Colors.white.withOpacity(0.08), width: isSelected ? 1 : 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('💧', style: TextStyle(fontSize: isSelected ? 16 : 16)),
                      const SizedBox(width: 6),
                      Text(
                        goalFormatted,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: isSelected ? Colors.white : Colors.white70),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 18),

          // Save button
          AppButton.primary(
            'Set Goal',
            onPressed: () {
              widget.onSetGoal(_selectedGoal);
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
