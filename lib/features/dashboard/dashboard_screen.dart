// lib/features/dashboard/presentation/dashboard_screen.dart
import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/animated_fab.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/progress_ring.dart';
import '../settings/provider/setting_provider.dart';
import '../tasks/providers/task_provider.dart';
import '../todo/providers/todo_provider.dart';
import '../../data/models/water_model.dart';
import '../water/providers/water_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch providers for dynamic data
    final todoStatsAsync = ref.watch(todoStatsProvider);
    final waterTotalAsync = ref.watch(todayTotalProvider);
    final waterGoalAsync = ref.watch(waterGoalProvider);
    final waterProgressAsync = ref.watch(waterProgressProvider);
    final taskStatsAsync = ref.watch(taskStatsProvider);
    final waterIntakeListAsync = ref.watch(todayIntakeProvider);
    final profileAsync = ref.watch(userProfileProvider);

    final fabMenuItems = [
      FabMenuItem(
        icon: Icons.check_circle_outline_rounded,
        label: 'Add Todo',
        color: AppColors.primaryPurple,
        onTap: () => context.push(AppRoutes.todoList),
      ),
      FabMenuItem(
        icon: Icons.water_drop_outlined,
        label: 'Log Water',
        color: AppColors.primaryTeal,
        onTap: () => context.push(AppRoutes.waterTracker),
      ),
      FabMenuItem(
        icon: Icons.calendar_today_rounded,
        label: 'Add Task',
        color: AppColors.primaryOrange,
        onTap: () => context.push(AppRoutes.taskScheduler),
      ),
      FabMenuItem(
        icon: Icons.note_add_rounded,
        label: 'Quick Note',
        color: AppColors.primaryMagenta,
        onTap: () => context.push(AppRoutes.notepad),
      ),
    ];

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D0D2B), Color(0xFF1A0A2E), Color(0xFF0D0D2B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Background decoration
              Positioned(
                top: -100,
                right: -50,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primaryPurple.withOpacity(0.15),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Main scrollable content
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Header with dynamic profile
                  SliverToBoxAdapter(
                    child: profileAsync.when(
                      data: (profile) => GreetingHeader(
                        userName: profile.name,
                        avatarEmoji: profile.avatarEmoji,
                        onAvatarTap: () => context.push(AppRoutes.settings),
                      ),
                      loading: () => const GreetingHeader(
                        onAvatarTap: null,
                      ),
                      error: (_, __) => const GreetingHeader(
                        onAvatarTap: null,
                      ),
                    ),
                  ),

                  // Water progress card - DYNAMIC
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: waterProgressAsync.when(
                        data: (progress) => waterTotalAsync.when(
                          data: (total) => waterGoalAsync.when(
                            data: (goal) => _WaterProgressCard(
                              progress: progress,
                              totalMl: total,
                              goalMl: goal,
                              onQuickAdd: (amountMl) {
                                ref
                                    .read(todayIntakeProvider.notifier)
                                    .addIntake(WaterModel(amountMl: amountMl));
                              },
                            ),
                            loading: () => const _WaterProgressShimmer(),
                            error: (_, __) => const _WaterProgressShimmer(),
                          ),
                          loading: () => const _WaterProgressShimmer(),
                          error: (_, __) => const _WaterProgressShimmer(),
                        ),
                        loading: () => const _WaterProgressShimmer(),
                        error: (_, __) => const _WaterProgressShimmer(),
                      ),
                    ),
                  ),

                  // Today's summary - DYNAMIC
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: _TodaySummary(
                        todoStatsAsync: todoStatsAsync,
                        taskStatsAsync: taskStatsAsync,
                        noteCountAsync: const AsyncData(0), // Will update with notepad
                      ),
                    ),
                  ),

                  // Quick actions
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: _QuickActions(),
                    ),
                  ),

                  // Bottom spacing for FAB
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 100),
                  ),
                ],
              ),

              // FAB Menu
              AnimatedFabMenu(
                items: fabMenuItems,
                mainIcon: Icons.add_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== DYNAMIC WATER PROGRESS CARD ====================
class _WaterProgressCard extends StatelessWidget {
  final double progress;
  final int totalMl;
  final int goalMl;
  final Function(int amountMl) onQuickAdd;

  const _WaterProgressCard({
    required this.progress,
    required this.totalMl,
    required this.goalMl,
    required this.onQuickAdd,
  });

  @override
  Widget build(BuildContext context) {
    // Convert ml to "glasses" (1 glass = 250ml) for display
    final glassesDrunk = (totalMl / 250).round();
    final dailyGoalGlasses = (goalMl / 250).round();

    return GlassCard(
      blur: 12,
      opacity: 0.08,
      child: Row(
        children: [
          // Progress ring
          SizedBox(
            width: 100,
            height: 100,
            child: ProgressRing(
              progress: progress,
              size: 100,
              strokeWidth: 10,
              gradient: progress >= 1.0
                  ? const LinearGradient(
                colors: [Color(0xFF00FF88), AppColors.primaryTeal],
              )
                  : AppGradients.tealMint,
              centerChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$glassesDrunk',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '/$dailyGoalGlasses',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 15),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.water_drop_rounded,
                      color: AppColors.primaryTeal,
                      size: 20,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Water Intake',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '$totalMl ml of $goalMl ml',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
                if (progress >= 1.0) ...[
                  const SizedBox(height: 4),
                  const Text(
                    '🎉 Goal reached! Amazing!',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF00FF88),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                Row(
                  children: [
                    Flexible(
                      child: _QuickAddButton(
                        icon: Icons.add_rounded,
                        label: '250ml',
                        color: AppColors.primaryTeal,
                        onTap: () => onQuickAdd(250),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: _QuickAddButton(
                        icon: Icons.add_rounded,
                        label: '500ml',
                        color: const Color(0xFF00B4D8),
                        onTap: () => onQuickAdd(500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WaterProgressShimmer extends StatelessWidget {
  const _WaterProgressShimmer();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      blur: 12,
      opacity: 0.08,
      child: SizedBox(
        height: 130,
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryTeal.withOpacity(0.5),
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}

class _QuickAddButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAddButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FittedBox(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== DYNAMIC TODAY SUMMARY ====================
class _TodaySummary extends StatelessWidget {
  final AsyncValue<Map<String, int>> todoStatsAsync;
  final AsyncValue<Map<String, int>> taskStatsAsync;
  final AsyncValue<int> noteCountAsync;

  const _TodaySummary({
    required this.todoStatsAsync,
    required this.taskStatsAsync,
    required this.noteCountAsync,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            "Today's Summary",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ),
        Row(
          children: [
            // Tasks Done
            Expanded(
              child: todoStatsAsync.when(
                data: (stats) => _SummaryCard(
                  icon: Icons.check_circle_rounded,
                  label: 'Tasks Done',
                  value: '${stats['completed'] ?? 0}/${stats['total'] ?? 0}',
                  gradient: [
                    AppColors.primaryPurple,
                    AppColors.primaryMagenta
                  ],
                ),
                loading: () => _SummaryCard(
                  icon: Icons.check_circle_rounded,
                  label: 'Tasks Done',
                  value: '...',
                  gradient: [
                    AppColors.primaryPurple,
                    AppColors.primaryMagenta
                  ],
                ),
                error: (_, __) => _SummaryCard(
                  icon: Icons.check_circle_rounded,
                  label: 'Tasks Done',
                  value: '0/0',
                  gradient: [
                    AppColors.primaryPurple,
                    AppColors.primaryMagenta
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Scheduled Tasks
            Expanded(
              child: taskStatsAsync.when(
                data: (stats) => _SummaryCard(
                  icon: Icons.calendar_today_rounded,
                  label: 'Scheduled',
                  value: '${stats['todayTotal'] ?? 0}',
                  gradient: [
                    AppColors.primaryOrange,
                    const Color(0xFFFFB84D)
                  ],
                ),
                loading: () => _SummaryCard(
                  icon: Icons.calendar_today_rounded,
                  label: 'Scheduled',
                  value: '...',
                  gradient: [
                    AppColors.primaryOrange,
                    const Color(0xFFFFB84D)
                  ],
                ),
                error: (_, __) => _SummaryCard(
                  icon: Icons.calendar_today_rounded,
                  label: 'Scheduled',
                  value: '0',
                  gradient: [
                    AppColors.primaryOrange,
                    const Color(0xFFFFB84D)
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Notes (placeholder until notepad is built)
            Expanded(
              child: _SummaryCard(
                icon: Icons.note_rounded,
                label: 'Notes',
                value: '0',
                gradient: [AppColors.primaryTeal, const Color(0xFF00B4D8)],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final List<Color> gradient;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      blur: 8,
      opacity: 0.06,
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: gradient),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.5),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ==================== QUICK ACTIONS ====================
class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _ActionCard(
                icon: Icons.checklist_rounded,
                label: 'Todo\nList',
                color: AppColors.primaryPurple,
                onTap: () => context.push(AppRoutes.todoList),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionCard(
                icon: Icons.water_drop_rounded,
                label: 'Water\nTracker',
                color: AppColors.primaryTeal,
                onTap: () => context.push(AppRoutes.waterTracker),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionCard(
                icon: Icons.calendar_month_rounded,
                label: 'Task\nCalendar',
                color: AppColors.primaryOrange,
                onTap: () => context.push(AppRoutes.taskScheduler),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionCard(
                icon: Icons.edit_note_rounded,
                label: 'Quick\nNote',
                color: AppColors.primaryMagenta,
                onTap: () => context.push(AppRoutes.notepad),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        blur: 8,
        opacity: 0.06,
        borderRadius: 20,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class GreetingHeader extends StatelessWidget {
  final String? userName;
  final String? avatarEmoji;
  final VoidCallback? onAvatarTap;

  const GreetingHeader({
    super.key,
    this.userName,
    this.avatarEmoji,
    this.onAvatarTap,
  });

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning ☀️';
    if (hour < 17) return 'Good Afternoon 🌤️';
    if (hour < 21) return 'Good Evening 🌅';
    return 'Good Night 🌙';
  }

  String _getMotivationalMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'A fresh day awaits! Let\'s make it count.';
    if (hour < 17) return 'Keep the momentum going! You\'ve got this.';
    if (hour < 21) return 'Finish strong! Reflect on today\'s wins.';
    return 'Rest well. Tomorrow is a new beginning.';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Personalized greeting
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          AppGradients.primary.createShader(bounds),
                      child: Text(
                        userName != null
                            ? '${_getGreeting().split(' ').first}, $userName!'
                            : _getGreeting(),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getMotivationalMessage(),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.5),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // Profile avatar with emoji
              GestureDetector(
                onTap: onAvatarTap,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppGradients.primary,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryPurple.withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      avatarEmoji ?? '😊',
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}