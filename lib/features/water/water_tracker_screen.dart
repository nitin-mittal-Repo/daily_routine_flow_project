// lib/features/water_tracker/presentation/screens/water_tracker_screen.dart
import 'package:daily_routine_flow/features/water/providers/water_provider.dart';
import 'package:daily_routine_flow/features/water/widgets/water_app_bar.dart';
import 'package:daily_routine_flow/features/water/widgets/water_empty_state.dart';
import 'package:daily_routine_flow/features/water/widgets/water_goal_setter.dart';
import 'package:daily_routine_flow/features/water/widgets/water_history_card.dart';
import 'package:daily_routine_flow/features/water/widgets/water_progress_hero.dart';
import 'package:daily_routine_flow/features/water/widgets/water_quick_add.dart';
import 'package:daily_routine_flow/features/water/widgets/water_streak_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/water_model.dart';

class WaterTrackerScreen extends ConsumerWidget {
  const WaterTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayIntakeAsync = ref.watch(todayIntakeProvider);
    final progressAsync = ref.watch(waterProgressProvider);
    final totalAsync = ref.watch(todayTotalProvider);
    final goalAsync = ref.watch(waterGoalProvider);
    final remainingAsync = ref.watch(waterRemainingProvider);
    final streakAsync = ref.watch(streakProvider);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D0D2B), Color(0xFF0A1A2E), Color(0xFF0D0D2B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              WaterAppBar(
                onGoalTap: () => _showGoalSetter(context, ref),
              ),

              // Scrollable content
              Expanded(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // Progress Hero Section
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: WaterProgressHero(
                          progressAsync: progressAsync,
                          totalAsync: totalAsync,
                          goalAsync: goalAsync,
                          remainingAsync: remainingAsync,
                        ),
                      ),
                    ),

                    // Streak Badge
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 4,
                        ),
                        child: streakAsync.when(
                          data: (streak) => WaterStreakBadge(streak: streak),
                          loading: () => const SizedBox(height: 60),
                          error: (_, __) => const SizedBox(height: 60),
                        ),
                      ),
                    ),

                    // Quick Add Section
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: WaterQuickAdd(
                          onAdd: (amountMl) {
                            ref.read(todayIntakeProvider.notifier).addIntake(
                              WaterModel(amountMl: amountMl),
                            );
                          },
                        ),
                      ),
                    ),

                    // History Header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Today's Log",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                            todayIntakeAsync.when(
                              data: (list) => Text(
                                '${list.length} entries',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.4),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              loading: () => const SizedBox.shrink(),
                              error: (_, __) => const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // History List
                    todayIntakeAsync.when(
                      data: (intakeList) {
                        if (intakeList.isEmpty) {
                          return const SliverFillRemaining(
                            hasScrollBody: false,
                            child: WaterEmptyState(),
                          );
                        }
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              final entry = intakeList[index];
                              return WaterHistoryCard(
                                entry: entry,
                                onDelete: () {
                                  ref
                                      .read(todayIntakeProvider.notifier)
                                      .deleteIntake(entry.id!);
                                },
                              );
                            },
                            childCount: intakeList.length,
                          ),
                        );
                      },
                      loading: () => const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryTeal,
                          ),
                        ),
                      ),
                      error: (error, _) => SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text(
                            'Something went wrong',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Bottom padding
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 100),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showGoalSetter(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => WaterGoalSetter(
        currentGoal: ref.read(waterGoalProvider).valueOrNull ?? 2000,
        onSetGoal: (newGoal) {
          ref.read(waterGoalProvider.notifier).setGoal(newGoal);
        },
      ),
    );
  }
}