import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'data/database/database_helper.dart';
import 'data/database/task_notification_helper.dart';
import 'features/settings/provider/setting_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with error handling
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase initialized successfully');
  } catch (e) {
    debugPrint('❌ Firebase initialization error: $e');
  }

  // Initialize Database
  try {
    await DatabaseHelper().database;
    debugPrint('✅ Database initialized successfully');
  } catch (e) {
    debugPrint('❌ Database initialization error: $e');
  }

  // ✅ Initialize Notifications (ADD THIS)
  try {
    await TaskNotificationHelper().initialize();
    debugPrint('✅ Notifications initialized successfully');
  } catch (e) {
    debugPrint('❌ Notifications initialization error: $e');
  }

  runApp(const ProviderScope(child: DailyRoutineFlowApp()));
}

class DailyRoutineFlowApp extends ConsumerWidget {
  const DailyRoutineFlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Daily Routine Flow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,  // We need to add this
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode.valueOrNull ?? ThemeMode.dark,
      routerConfig: router,
    );
  }
}
