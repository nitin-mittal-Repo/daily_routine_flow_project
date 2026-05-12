// lib/features/water_tracker/presentation/widgets/water_quick_add.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class WaterQuickAdd extends StatelessWidget {
  final Function(int amountMl) onAdd;

  const WaterQuickAdd({super.key, required this.onAdd});

  static const List<_QuickAddOption> _options = [
    _QuickAddOption(amount: 150, label: 'Small\nGlass', icon: '🥃', ml: 150),
    _QuickAddOption(amount: 250, label: 'Glass', icon: '🥛', ml: 250),
    _QuickAddOption(amount: 500, label: 'Bottle', icon: '🧴', ml: 500),
    _QuickAddOption(amount: 1000, label: 'Large\nBottle', icon: '🫗', ml: 1000),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Quick Add',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ),
        Row(
          children: _options.map((option) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _QuickAddCard(
                  option: option,
                  onTap: () => onAdd(option.ml),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _QuickAddOption {
  final int amount;
  final String label;
  final String icon;
  final int ml;

  const _QuickAddOption({
    required this.amount,
    required this.label,
    required this.icon,
    required this.ml,
  });
}

class _QuickAddCard extends StatefulWidget {
  final _QuickAddOption option;
  final VoidCallback onTap;

  const _QuickAddCard({required this.option, required this.onTap});

  @override
  State<_QuickAddCard> createState() => _QuickAddCardState();
}

class _QuickAddCardState extends State<_QuickAddCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _rippleController;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() => _isPressed = true);
    _rippleController.forward().then((_) {
      _rippleController.reverse().then((_) {
        if (mounted) setState(() => _isPressed = false);
      });
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _rippleController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_rippleController.value * 0.05),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              decoration: BoxDecoration(
                color: _isPressed
                    ? AppColors.primaryTeal.withOpacity(0.15)
                    : Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isPressed
                      ? AppColors.primaryTeal.withOpacity(0.5)
                      : Colors.white.withOpacity(0.08),
                  width: _isPressed ? 1.5 : 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    widget.option.icon,
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.option.ml}ml',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.option.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white.withOpacity(0.4),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}