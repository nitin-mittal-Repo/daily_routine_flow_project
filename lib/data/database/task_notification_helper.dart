import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class TaskNotificationHelper {
  static final TaskNotificationHelper _instance =
  TaskNotificationHelper._internal();
  factory TaskNotificationHelper() => _instance;
  TaskNotificationHelper._internal();

  final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  // Track active water reminders to avoid duplicates
  final Set<int> _activeWaterReminders = {};

  // Initialize the plugin
  Future<void> initialize() async {
    // Initialize timezone data
    tz_data.initializeTimeZones();

    // Set local timezone - this uses the device's system timezone
    tz.setLocalLocation(tz.local);

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Create notification channels
    await _createNotificationChannels();

    // Request permissions on Android 13+
    await _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  // Create notification channels for better organization
  Future<void> _createNotificationChannels() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      // Task Reminder Channel
      const taskChannel = AndroidNotificationChannel(
        'task_reminder_channel',
        'Task Reminders',
        description: 'Notifications for scheduled task reminders',
        importance: Importance.high,
        enableVibration: true,
        playSound: true,
      );
      await androidPlugin.createNotificationChannel(taskChannel);

      // Todo Reminder Channel
      const todoChannel = AndroidNotificationChannel(
        'todo_reminder_channel',
        'Todo Reminders',
        description: 'Reminders for your todos',
        importance: Importance.high,
        enableVibration: true,
        playSound: true,
      );
      await androidPlugin.createNotificationChannel(todoChannel);

      // Water Reminder Channel
      const waterChannel = AndroidNotificationChannel(
        'water_reminder_channel',
        'Water Reminders',
        description: 'Stay hydrated reminders',
        importance: Importance.low,
        enableVibration: true,
      );
      await androidPlugin.createNotificationChannel(waterChannel);

      // General Channel
      const generalChannel = AndroidNotificationChannel(
        'general_channel',
        'General Notifications',
        description: 'General app notifications',
        importance: Importance.low,
      );
      await androidPlugin.createNotificationChannel(generalChannel);
    }
  }

  // Handle notification tap (foreground)
  void _onNotificationTap(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    // TODO: Navigate based on payload
  }

  // Handle notification tap (background)
  @pragma('vm:entry-point')
  static void _onBackgroundNotificationTap(NotificationResponse response) {
    debugPrint('Background notification tapped: ${response.payload}');
  }

  // ==================== TASK NOTIFICATIONS ====================

  // Schedule a task reminder
  Future<bool> scheduleTaskReminder({
    required int taskId,
    required String title,
    required String body,
    required DateTime scheduledDate,
    TimeOfDay? scheduledTime,
    int? reminderMinutesBefore,
  }) async {
    try {
      if (reminderMinutesBefore == null) return false;

      // Calculate the reminder time
      final scheduledDateTime = DateTime(
        scheduledDate.year,
        scheduledDate.month,
        scheduledDate.day,
        scheduledTime?.hour ?? 9,
        scheduledTime?.minute ?? 0,
      );

      final reminderTime = scheduledDateTime.subtract(
        Duration(minutes: reminderMinutesBefore),
      );

      // Don't schedule if reminder time is in the past
      if (reminderTime.isBefore(DateTime.now())) return false;

      final notificationId = taskId * 100;

      const androidDetails = AndroidNotificationDetails(
        'task_reminder_channel',
        'Task Reminders',
        channelDescription: 'Task reminder notifications',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        styleInformation: BigTextStyleInformation(''),
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _plugin.zonedSchedule(
        notificationId,
        title,
        body,
        tz.TZDateTime.from(reminderTime, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
        payload: 'task_$taskId',
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      );

      debugPrint('Task reminder scheduled for $reminderTime');
      return true;
    } catch (e) {
      debugPrint('Error scheduling task reminder: $e');
      return false;
    }
  }

  // Cancel a task reminder
  Future<void> cancelTaskReminder(int taskId) async {
    final notificationId = taskId * 100;
    await _plugin.cancel(notificationId);
    debugPrint('Task reminder cancelled for task $taskId');
  }

  // ==================== TODO NOTIFICATIONS ====================

  // Schedule a todo reminder
  Future<bool> scheduleTodoReminder({
    required int todoId,
    required String title,
    required String body,
    required DateTime dueDate,
    int reminderMinutesBefore = 30,
  }) async {
    try {
      final reminderTime = dueDate.subtract(Duration(minutes: reminderMinutesBefore));

      if (reminderTime.isBefore(DateTime.now())) return false;

      final notificationId = todoId * 100 + 1;

      const androidDetails = AndroidNotificationDetails(
        'todo_reminder_channel',
        'Todo Reminders',
        channelDescription: 'Todo task reminders',
        importance: Importance.high,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _plugin.zonedSchedule(
        notificationId,
        '📝 Todo Due: $title',
        body,
        tz.TZDateTime.from(reminderTime, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: 'todo_$todoId',
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      );

      debugPrint('Todo reminder scheduled for $reminderTime');
      return true;
    } catch (e) {
      debugPrint('Error scheduling todo reminder: $e');
      return false;
    }
  }

  // Cancel a todo reminder
  Future<void> cancelTodoReminder(int todoId) async {
    final notificationId = todoId * 100 + 1;
    await _plugin.cancel(notificationId);
    debugPrint('Todo reminder cancelled for todo $todoId');
  }

  // Show todo completed notification
  Future<void> showTodoCompletedNotification(String title) async {
    await showInstantNotification(
      title: '✅ Task Completed',
      body: 'Great job! You completed "$title"',
    );
  }

  // ==================== WATER DRINKING NOTIFICATIONS ====================

  // Schedule hourly water reminders
  Future<void> scheduleWaterReminder({
    int id = 999,
    String title = '💧 Stay Hydrated!',
    String body = 'Time to drink a glass of water',
    int intervalHours = 1,
    DateTime? startTime,
    DateTime? endTime,
  }) async {
    try {
      // Cancel existing if any
      if (_activeWaterReminders.contains(id)) {
        await cancelWaterReminder(id);
      }

      const androidDetails = AndroidNotificationDetails(
        'water_reminder_channel',
        'Water Reminders',
        channelDescription: 'Stay hydrated reminders',
        importance: Importance.low,
        priority: Priority.low,
        showWhen: true,
        styleInformation: BigTextStyleInformation(''),
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: false,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _plugin.periodicallyShow(
        id,
        title,
        body,
        RepeatInterval.hourly,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );

      _activeWaterReminders.add(id);
      debugPrint('Water reminder scheduled every $intervalHours hour(s)');
    } catch (e) {
      debugPrint('Error scheduling water reminder: $e');
    }
  }

  // Schedule multiple water reminders throughout the day
  Future<void> scheduleSpecificWaterReminders({
    required List<TimeOfDay> reminderTimes,
    String title = '💧 Stay Hydrated!',
    String body = 'Time to drink a glass of water',
  }) async {
    for (int i = 0; i < reminderTimes.length; i++) {
      final time = reminderTimes[i];
      final now = DateTime.now();
      final scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );

      // If time passed today, schedule for tomorrow
      final finalTime = scheduledTime.isBefore(now)
          ? scheduledTime.add(const Duration(days: 1))
          : scheduledTime;

      const androidDetails = AndroidNotificationDetails(
        'water_reminder_channel',
        'Water Reminders',
        channelDescription: 'Stay hydrated reminders',
        importance: Importance.low,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: false,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _plugin.zonedSchedule(
        2000 + i,
        title,
        body,
        tz.TZDateTime.from(finalTime, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'water_reminder_$i',
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
    debugPrint('${reminderTimes.length} water reminders scheduled');
  }

  // Cancel water reminder
  Future<void> cancelWaterReminder(int id) async {
    await _plugin.cancel(id);
    _activeWaterReminders.remove(id);
    debugPrint('Water reminder cancelled');
  }

  // ==================== GENERAL NOTIFICATIONS ====================

  // Show instant notification
  Future<void> showInstantNotification({
    required String title,
    required String body,
    String? payload,
    String channel = 'general_channel',
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'general_channel',
      'General Notifications',
      channelDescription: 'General app notifications',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      details,
      payload: payload,
    );
  }

  // Show success notification
  Future<void> showSuccessNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'task_reminder_channel',
      'Success',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      styleInformation: BigTextStyleInformation(''),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(1000000),
      '✅ $title',
      body,
      details,
    );
  }

  // ==================== UTILITY METHODS ====================

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
    _activeWaterReminders.clear();
    debugPrint('All notifications cancelled');
  }

  // Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _plugin.pendingNotificationRequests();
  }

  // Check if notification is scheduled
  Future<bool> isNotificationScheduled(int id) async {
    final pending = await _plugin.pendingNotificationRequests();
    return pending.any((request) => request.id == id);
  }
}

// Helper class for TimeOfDay
extension TimeOfDayExtension on TimeOfDay {
  String toFormattedString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}