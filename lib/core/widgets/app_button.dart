// lib/shared/components/app_button.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../theme/app_colors.dart';

enum ButtonVariant { primary, secondary, outline, glass, icon }

enum ButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String? label;
  final Widget? icon;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final double? width;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  const AppButton({
    super.key,
    this.label,
    this.icon,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = true,
    this.width,
    this.borderRadius,
    this.padding,
  });

  // Factory constructors for convenience
  factory AppButton.primary(String label, {VoidCallback? onPressed}) =>
      AppButton(label: label, onPressed: onPressed, variant: ButtonVariant.primary);

  factory AppButton.secondary(String label, {VoidCallback? onPressed}) =>
      AppButton(label: label, onPressed: onPressed, variant: ButtonVariant.secondary);

  factory AppButton.outline(String label, {VoidCallback? onPressed}) =>
      AppButton(label: label, onPressed: onPressed, variant: ButtonVariant.outline);

  factory AppButton.iconButton(Widget icon, {VoidCallback? onPressed}) =>
      AppButton(icon: icon, onPressed: onPressed, variant: ButtonVariant.icon);

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;

    return SizedBox(
      width: isFullWidth ? (width ?? double.infinity) : (width ?? null),
      height: _buttonHeight,
      child: _buildVariant(context, isDisabled),
    );
  }

  Widget _buildVariant(BuildContext context, bool isDisabled) {
    switch (variant) {
      case ButtonVariant.primary:
        return _GradientButton(
          label: label,
          icon: icon,
          onPressed: isDisabled ? null : onPressed,
          isLoading: isLoading,
          gradient: AppGradients.primary,
          height: _buttonHeight,
          borderRadius: borderRadius ?? _borderRadius,
          padding: padding ?? _padding,
        );
      case ButtonVariant.secondary:
        return _NeonButton(
          label: label,
          icon: icon,
          onPressed: isDisabled ? null : onPressed,
          isLoading: isLoading,
          height: _buttonHeight,
          borderRadius: borderRadius ?? _borderRadius,
        );
      case ButtonVariant.outline:
        return _OutlineButton(
          label: label,
          icon: icon,
          onPressed: isDisabled ? null : onPressed,
          isLoading: isLoading,
          height: _buttonHeight,
          borderRadius: borderRadius ?? _borderRadius,
        );
      case ButtonVariant.glass:
        return _GlassButton(
          label: label,
          icon: icon,
          onPressed: isDisabled ? null : onPressed,
          isLoading: isLoading,
          height: _buttonHeight,
          borderRadius: borderRadius ?? _borderRadius,
        );
      case ButtonVariant.icon:
        return _IconButton(
          icon: icon!,
          onPressed: isDisabled ? null : onPressed,
          height: _buttonHeight,
        );
    }
  }

  double get _buttonHeight {
    switch (size) {
      case ButtonSize.small:
        return 40;
      case ButtonSize.medium:
        return 52;
      case ButtonSize.large:
        return 60;
    }
  }

  double get _borderRadius {
    switch (size) {
      case ButtonSize.small:
        return 12;
      case ButtonSize.medium:
        return 16;
      case ButtonSize.large:
        return 20;
    }
  }

  EdgeInsetsGeometry get _padding {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 14);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 18);
    }
  }
}

// --- Private Button Implementations ---

class _GradientButton extends StatelessWidget {
  final String? label;
  final Widget? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final LinearGradient gradient;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const _GradientButton({
    this.label,
    this.icon,
    this.onPressed,
    required this.isLoading,
    required this.gradient,
    required this.height,
    required this.borderRadius,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: height,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: onPressed != null
              ? [
            BoxShadow(
              color: AppColors.primaryPurple.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ]
              : null,
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.5,
            ),
          )
              : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[icon!, const SizedBox(width: 8)],
              if (label != null)
                Text(
                  label!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NeonButton extends StatelessWidget {
  final String? label;
  final Widget? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;
  final double borderRadius;

  const _NeonButton({
    this.label,
    this.icon,
    this.onPressed,
    required this.isLoading,
    required this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: AppColors.primaryPurple.withOpacity(0.15),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: AppColors.primaryPurple.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: AppColors.primaryPurple,
              strokeWidth: 2.5,
            ),
          )
              : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[icon!, const SizedBox(width: 8)],
              if (label != null)
                Text(
                  label!,
                  style: const TextStyle(
                    color: AppColors.primaryPurple,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String? label;
  final Widget? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;
  final double borderRadius;

  const _OutlineButton({
    this.label,
    this.icon,
    this.onPressed,
    required this.isLoading,
    required this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? Colors.white24 : Colors.black12;
    final textColor = isDark ? Colors.white70 : Colors.black87;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: textColor,
              strokeWidth: 2.5,
            ),
          )
              : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[icon!, const SizedBox(width: 8)],
              if (label != null)
                Text(
                  label!,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  final String? label;
  final Widget? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;
  final double borderRadius;

  const _GlassButton({
    this.label,
    this.icon,
    this.onPressed,
    required this.isLoading,
    required this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ColorFilter.mode(
            Colors.white.withOpacity(0.1),
            BlendMode.srcOver,
          ),
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
                  : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[icon!, const SizedBox(width: 8)],
                  if (label != null)
                    Text(
                      label!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final double height;

  const _IconButton({
    required this.icon,
    this.onPressed,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        width: height,
        decoration: BoxDecoration(
          gradient: AppGradients.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPurple.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(child: icon),
      ),
    );
  }
}