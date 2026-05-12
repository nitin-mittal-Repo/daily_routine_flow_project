// lib/shared/routing/app_router.dart
// Replace your existing router with this updated version

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/notes/notepad_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/splash/onboarding/presentation/onboarding_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/tasks/task_scheduler_screen.dart';
import '../../features/todo/todo_screen.dart';
import '../../features/water/water_tracker_screen.dart';

// Route path constants
class AppRoutes {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String dashboard = '/';
  static const String todoList = '/todo';
  static const String waterTracker = '/water-tracker';
  static const String taskScheduler = '/tasks';
  static const String notepad = '/notepad';
  static const String notepadDetail = '/notepad/:id';
  static const String settings = '/settings';

  AppRoutes._();
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),



  /*    GoRoute(
        path: AppRoutes.notepad,
        name: 'notepad',
        builder: (context, state) => const _PlaceholderScreen(title: 'Notepad'),
        routes: [
          GoRoute(
            path: ':id',
            name: 'notepad-detail',
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return _PlaceholderScreen(title: 'Note: $id');
            },
          ),
        ],
      ),*/


//////////////////////////////////////
//////////////////////////////////////
      GoRoute(
        path: AppRoutes.todoList,
        name: 'todo',
        builder: (context, state) => const TodoScreen(), // ✅ Now using real screen
      ),

      GoRoute(
        path: AppRoutes.waterTracker,
        name: 'water',
        builder: (context, state) => const WaterTrackerScreen(), // ✅ Real screen
      ),

      GoRoute(
        path: AppRoutes.taskScheduler,
        name: 'tasks',
        builder: (context, state) => const TaskSchedulerScreen(), // ✅
      ),

      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(), // ✅
      ),


      GoRoute(
        path: AppRoutes.notepad,
        name: 'notepad',
        builder: (context, state) => const NotepadScreen(), // ✅
      ),

    ],
  );
});

// Temporary placeholder
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Text(
          '$title Screen\n🔨 Building...',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}