// lib/features/task_scheduler/presentation/widgets/calendar_strip.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/task_provider.dart';

class CalendarStrip extends ConsumerWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const CalendarStrip({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final datesWithTasksAsync = ref.watch(datesWithTasksProvider);

    return Container(
      height: 90,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Month header
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                _MonthText(selectedDate),
                const Spacer(),
                if (datesWithTasksAsync is AsyncData)
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${datesWithTasksAsync.value?.length} busy days',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.primaryOrange.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Date strip
          Expanded(
            child: datesWithTasksAsync.when(
              data: (datesWithTasks) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: 30, // Show next 30 days
                  itemBuilder: (context, index) {
                    final date =
                    DateTime.now().add(Duration(days: index));
                    final dateStr =
                        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                    final hasTask = datesWithTasks.contains(dateStr);
                    final isSelected = _isSameDay(date, selectedDate);
                    final isToday = _isSameDay(date, DateTime.now());

                    return _DateChip(
                      date: date,
                      hasTask: hasTask,
                      isSelected: isSelected,
                      isToday: isToday,
                      onTap: () => onDateSelected(date),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primaryOrange,
                  ),
                ),
              ),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _MonthText extends StatelessWidget {
  final DateTime date;
  const _MonthText(this.date);

  @override
  Widget build(BuildContext context) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return Text(
      '${months[date.month - 1]} ${date.year}',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  final DateTime date;
  final bool hasTask;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  const _DateChip({
    required this.date,
    required this.hasTask,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final weekday = weekdays[date.weekday - 1];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
            colors: [AppColors.primaryOrange, Color(0xFFFFB84D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: isSelected
              ? null
              : Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(16),
          border: isToday && !isSelected
              ? Border.all(
            color: AppColors.primaryOrange.withOpacity(0.5),
            width: 1.5,
          )
              : Border.all(
            color: Colors.white.withOpacity(0.06),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              weekday,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white.withOpacity(0.8)
                    : Colors.white.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : Colors.white70,
              ),
            ),
            const SizedBox(height: 4),
            // Task dot indicator
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: hasTask
                    ? isSelected
                    ? Colors.white
                    : AppColors.primaryOrange
                    : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}