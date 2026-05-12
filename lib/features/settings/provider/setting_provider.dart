// lib/features/settings/providers/settings_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Theme mode provider
final themeModeProvider =
AsyncNotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends AsyncNotifier<ThemeMode> {
  @override
  Future<ThemeMode> build() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('is_dark_mode') ?? true;
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = state.value == ThemeMode.dark;
    final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
    await prefs.setBool('is_dark_mode', !isDark);
    state = AsyncData(newMode);
  }
}

// User profile provider
final userProfileProvider =
AsyncNotifierProvider<UserProfileNotifier, UserProfile>(
  UserProfileNotifier.new,
);

class UserProfile {
  final String name;
  final String? avatarEmoji;

  const UserProfile({this.name = 'User', this.avatarEmoji = '😊'});

  UserProfile copyWith({String? name, String? avatarEmoji}) {
    return UserProfile(
      name: name ?? this.name,
      avatarEmoji: avatarEmoji ?? this.avatarEmoji,
    );
  }
}

class UserProfileNotifier extends AsyncNotifier<UserProfile> {
  @override
  Future<UserProfile> build() async {
    final prefs = await SharedPreferences.getInstance();
    return UserProfile(
      name: prefs.getString('user_name') ?? 'User',
      avatarEmoji: prefs.getString('user_avatar') ?? '😊',
    );
  }

  Future<void> updateName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    state = AsyncData(state.value!.copyWith(name: name));
  }

  Future<void> updateAvatar(String emoji) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_avatar', emoji);
    state = AsyncData(state.value!.copyWith(avatarEmoji: emoji));
  }
}

// Notification settings provider
final notificationSettingsProvider =
AsyncNotifierProvider<NotificationSettingsNotifier, NotificationSettings>(
  NotificationSettingsNotifier.new,
);

class NotificationSettings {
  final bool waterReminder;
  final bool taskReminder;
  final bool dailySummary;

  const NotificationSettings({
    this.waterReminder = false,
    this.taskReminder = true,
    this.dailySummary = false,
  });

  NotificationSettings copyWith({
    bool? waterReminder,
    bool? taskReminder,
    bool? dailySummary,
  }) {
    return NotificationSettings(
      waterReminder: waterReminder ?? this.waterReminder,
      taskReminder: taskReminder ?? this.taskReminder,
      dailySummary: dailySummary ?? this.dailySummary,
    );
  }
}

class NotificationSettingsNotifier
    extends AsyncNotifier<NotificationSettings> {
  @override
  Future<NotificationSettings> build() async {
    final prefs = await SharedPreferences.getInstance();
    return NotificationSettings(
      waterReminder: prefs.getBool('notif_water') ?? false,
      taskReminder: prefs.getBool('notif_task') ?? true,
      dailySummary: prefs.getBool('notif_daily') ?? false,
    );
  }

  Future<void> toggleWaterReminder(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_water', value);
    state = AsyncData(state.value!.copyWith(waterReminder: value));
  }

  Future<void> toggleTaskReminder(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_task', value);
    state = AsyncData(state.value!.copyWith(taskReminder: value));
  }

  Future<void> toggleDailySummary(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_daily', value);
    state = AsyncData(state.value!.copyWith(dailySummary: value));
  }
}

// Clear all data provider
final clearDataProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // Clear database
    // await DatabaseHelper().clearAllTables();
  };
});