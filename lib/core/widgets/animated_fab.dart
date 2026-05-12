// lib/shared/components/animated_fab.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../theme/app_colors.dart';

class FabMenuItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const FabMenuItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}

class AnimatedFabMenu extends StatefulWidget {
  final List<FabMenuItem> items;
  final IconData mainIcon;
  final Color? mainColor;

  const AnimatedFabMenu({
    super.key,
    required this.items,
    this.mainIcon = Icons.add_rounded,
    this.mainColor,
  });

  @override
  State<AnimatedFabMenu> createState() => _AnimatedFabMenuState();
}

class _AnimatedFabMenuState extends State<AnimatedFabMenu>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 0.125).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Backdrop overlay
        if (_isOpen)
          GestureDetector(
            onTap: _toggle,
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),

        // Menu items
        ...List.generate(widget.items.length, (index) {
          final angle = (math.pi / 2) * (index / (widget.items.length - 1));
          final radius = 140.0;
          final dx = -radius * math.cos(angle);
          final dy = -radius * math.sin(angle);

          return AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Positioned(
                bottom: _isOpen ? 16 + dy : 0,
                right: _isOpen ? 16 + dx : 0,
                child: Transform.scale(
                  scale: _isOpen ? _scaleAnimation.value : 0,
                  child: _FabItem(
                    icon: widget.items[index].icon,
                    label: widget.items[index].label,
                    color: widget.items[index].color,
                    onTap: () {
                      widget.items[index].onTap();
                      _toggle();
                    },
                  ),
                ),
              );
            },
          );
        }),

        // Main FAB
        Positioned(
          bottom: 16,
          right: 16,
          child: GestureDetector(
            onTap: _toggle,
            child: AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value * (2 * math.pi),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: widget.mainColor != null
                          ? LinearGradient(
                        colors: [widget.mainColor!, widget.mainColor!],
                      )
                          : AppGradients.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (widget.mainColor ?? AppColors.primaryPurple)
                              .withOpacity(0.5),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      _isOpen ? Icons.close_rounded : widget.mainIcon,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _FabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _FabItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Icon button
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
        ],
      ),
    );
  }
}