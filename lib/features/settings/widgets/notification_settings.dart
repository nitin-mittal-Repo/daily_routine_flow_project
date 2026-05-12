// lib/features/settings/presentation/widgets/notification_settings.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../core/theme/app_colors.dart';
import '../provider/setting_provider.dart';

class NotificationSettingsWidget extends ConsumerWidget {
  const NotificationSettingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(notificationSettingsProvider);

    return settingsAsync.when(
      data: (settings) => Column(
        children: [
          _NotificationTile(
            icon: Icons.water_drop_rounded,
            iconColor: AppColors.primaryTeal,
            title: 'Water Reminders',
            subtitle: 'Periodic hydration alerts',
            value: settings.waterReminder,
            onChanged: (val) {
              ref.read(notificationSettingsProvider.notifier).toggleWaterReminder(val);
            },
          ),
          const _Divider(),
          _NotificationTile(
            icon: Icons.task_alt_rounded,
            iconColor: AppColors.primaryOrange,
            title: 'Task Reminders',
            subtitle: 'Alerts for scheduled tasks',
            value: settings.taskReminder,
            onChanged: (val) {
              ref.read(notificationSettingsProvider.notifier).toggleTaskReminder(val);
            },
          ),
          const _Divider(),
          _NotificationTile(
            icon: Icons.summarize_rounded,
            iconColor: AppColors.primaryPurple,
            title: 'Daily Summary',
            subtitle: 'End of day overview',
            value: settings.dailySummary,
            onChanged: (val) {
              ref.read(notificationSettingsProvider.notifier).toggleDailySummary(val);
            },
          ),
        ],
      ),
      loading: () => const SizedBox(height: 60,
          child: Center(child: CircularProgressIndicator())),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final Function(bool) onChanged;

  const _NotificationTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.white38),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryPurple,
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(height: 1, color: Colors.white.withOpacity(0.05)),
    );
  }
}