// lib/features/task_scheduler/presentation/widgets/add_task_sheet.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../data/models/scheduled_task_model.dart';

class AddTaskSheet extends StatefulWidget {
  final ScheduledTaskModel? task;
  final DateTime initialDate;
  final Function(ScheduledTaskModel) onSave;

  const AddTaskSheet({
    super.key,
    this.task,
    required this.initialDate,
    required this.onSave,
  });

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late DateTime _selectedDate;
  TimeOfDay? _selectedTime;
  int _priority = 0;
  bool _hasReminder = false;
  int _reminderMinutes = 15;

  bool get isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    if (isEditing) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description ?? '';
      _priority = widget.task!.priority;
      _selectedTime = widget.task!.scheduledTime;
      _hasReminder = widget.task!.hasReminder;
      _reminderMinutes = widget.task!.reminderMinutesBefore ?? 15;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    if (_titleController.text.trim().isEmpty) return;

    final task = ScheduledTaskModel(
      id: widget.task?.id,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      scheduledDate: _selectedDate,
      scheduledTime: _selectedTime,
      priority: _priority,
      hasReminder: _hasReminder,
      reminderMinutesBefore: _hasReminder ? _reminderMinutes : null,
      createdAt: widget.task?.createdAt,
      isCompleted: widget.task?.isCompleted ?? false,
    );

    widget.onSave(task);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A3E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              isEditing ? 'Edit Task' : 'Add New Task',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // Title
            AppTextField(
              controller: _titleController,
              hintText: 'Task title',
              label: 'TITLE',
              autofocus: true,
              fillColor: const Color(0xFF252550),
            ),
            const SizedBox(height: 14),

            // Description
            AppTextField(
              controller: _descriptionController,
              hintText: 'Add details...',
              label: 'DESCRIPTION (OPTIONAL)',
              maxLines: 2,
              fillColor: const Color(0xFF252550),
            ),
            const SizedBox(height: 18),

            // Date
            _buildDatePicker(),
            const SizedBox(height: 14),

            // Time
            _buildTimePicker(),
            const SizedBox(height: 14),

            // Priority
            _buildPrioritySelector(),
            const SizedBox(height: 14),

            // Reminder
            _buildReminderToggle(),
            if (_hasReminder) ...[
              const SizedBox(height: 12),
              _buildReminderOptions(),
            ],

            const SizedBox(height: 28),
            AppButton.primary(
              isEditing ? 'Update Task' : 'Add Task',
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF252550),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_rounded,
                size: 18, color: AppColors.primaryOrange),
            const SizedBox(width: 12),
            Text(
              _selectedDate == DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
                  ? 'Today'
                  : '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker() {
    return GestureDetector(
      onTap: _pickTime,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF252550),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time_rounded,
                size: 18, color: AppColors.primaryOrange),
            const SizedBox(width: 12),
            Text(
              _selectedTime != null
                  ? _selectedTime!.format(context)
                  : 'All day (tap to set time)',
              style: TextStyle(
                color: _selectedTime != null
                    ? Colors.white
                    : Colors.white.withOpacity(0.4),
                fontSize: 14,
              ),
            ),
            const Spacer(),
            if (_selectedTime != null)
              GestureDetector(
                onTap: () => setState(() => _selectedTime = null),
                child: const Icon(Icons.close_rounded,
                    size: 18, color: Colors.white38),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PRIORITY',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.5),
                letterSpacing: 1)),
        const SizedBox(height: 10),
        Row(
          children: [
            _PriorityChip(label: 'Low', color: AppColors.success,
                isSelected: _priority == 0,
                onTap: () => setState(() => _priority = 0)),
            const SizedBox(width: 10),
            _PriorityChip(label: 'Medium', color: AppColors.warning,
                isSelected: _priority == 1,
                onTap: () => setState(() => _priority = 1)),
            const SizedBox(width: 10),
            _PriorityChip(label: 'High', color: AppColors.error,
                isSelected: _priority == 2,
                onTap: () => setState(() => _priority = 2)),
          ],
        ),
      ],
    );
  }

  Widget _buildReminderToggle() {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        'Set Reminder',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white.withOpacity(0.7),
        ),
      ),
      subtitle: _hasReminder
          ? Text(
        '$_reminderMinutes minutes before',
        style: TextStyle(
            fontSize: 12, color: AppColors.primaryOrange.withOpacity(0.7)),
      )
          : null,
      value: _hasReminder,
      activeColor: AppColors.primaryOrange,
      onChanged: (val) => setState(() => _hasReminder = val),
    );
  }

  Widget _buildReminderOptions() {
    final options = [5, 15, 30, 60];
    return Row(
      children: options.map((mins) {
        final isSelected = _reminderMinutes == mins;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _reminderMinutes = mins),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryOrange.withOpacity(0.15)
                    : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryOrange.withOpacity(0.5)
                      : Colors.white.withOpacity(0.1),
                ),
              ),
              child: Text(
                '$mins min',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? AppColors.primaryOrange
                      : Colors.white.withOpacity(0.5),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primaryOrange,
            surface: Color(0xFF1A1A3E),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: AppColors.primaryOrange),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }
}

class _PriorityChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _PriorityChip({
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color.withOpacity(0.5) : Colors.white.withOpacity(0.1),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? color : Colors.white.withOpacity(0.4),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}