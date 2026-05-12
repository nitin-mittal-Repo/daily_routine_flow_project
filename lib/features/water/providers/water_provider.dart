// lib/features/water_tracker/providers/water_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repos/water_repository.dart';
import '../../../data/models/water_model.dart';

// Repository provider
final waterRepositoryProvider = Provider<WaterRepository>((ref) {
  return WaterRepository();
});

// ==================== GOAL PROVIDERS ====================

// Daily goal provider
final waterGoalProvider = AsyncNotifierProvider<WaterGoalNotifier, int>(
  WaterGoalNotifier.new,
);

class WaterGoalNotifier extends AsyncNotifier<int> {
  @override
  Future<int> build() async {
    final repository = ref.read(waterRepositoryProvider);
    return repository.getDailyGoal();
  }

  Future<void> setGoal(int newGoalMl) async {
    final repository = ref.read(waterRepositoryProvider);
    await repository.setDailyGoal(newGoalMl);
    state = AsyncData(newGoalMl);
  }
}

// ==================== INTAKE PROVIDERS ====================

// Today's intake list
final todayIntakeProvider =
AsyncNotifierProvider<TodayIntakeNotifier, List<WaterModel>>(
  TodayIntakeNotifier.new,
);

class TodayIntakeNotifier extends AsyncNotifier<List<WaterModel>> {
  @override
  Future<List<WaterModel>> build() async {
    final repository = ref.read(waterRepositoryProvider);
    return repository.getTodayIntake();
  }

  Future<void> addIntake(WaterModel water) async {
    final repository = ref.read(waterRepositoryProvider);
    await repository.addWaterIntake(water);
    ref.invalidateSelf();
    // Also invalidate total and streak
    ref.invalidate(todayTotalProvider);
    ref.invalidate(streakProvider);
  }

  Future<void> deleteIntake(int id) async {
    final repository = ref.read(waterRepositoryProvider);
    await repository.deleteWaterIntake(id);
    ref.invalidateSelf();
    ref.invalidate(todayTotalProvider);
    ref.invalidate(streakProvider);
  }
}

// Today's total in ml
final todayTotalProvider = AsyncNotifierProvider<TodayTotalNotifier, int>(
  TodayTotalNotifier.new,
);

class TodayTotalNotifier extends AsyncNotifier<int> {
  @override
  Future<int> build() async {
    final repository = ref.read(waterRepositoryProvider);
    return repository.getTodayTotal();
  }
}

// Progress percentage (0.0 to 1.0)
final waterProgressProvider = Provider<AsyncValue<double>>((ref) {
  final goalAsync = ref.watch(waterGoalProvider);
  final totalAsync = ref.watch(todayTotalProvider);

  if (goalAsync is AsyncData && totalAsync is AsyncData) {
    final goal = goalAsync.value;
    final total = totalAsync.value;
    final progress = goal! > 0 ? (total! / goal).clamp(0.0, 1.0) : 0.0;
    return AsyncData(progress);
  }

  if (goalAsync is AsyncLoading || totalAsync is AsyncLoading) {
    return const AsyncLoading();
  }

  return const AsyncData(0.0);
});

// Remaining ml
final waterRemainingProvider = Provider<AsyncValue<int>>((ref) {
  final goalAsync = ref.watch(waterGoalProvider);
  final totalAsync = ref.watch(todayTotalProvider);

  if (goalAsync is AsyncData && totalAsync is AsyncData) {
    final remaining = (goalAsync.value! - totalAsync.value!).clamp(0, 999999);
    return AsyncData(remaining);
  }

  return const AsyncData(0);
});

// Streak
final streakProvider = AsyncNotifierProvider<StreakNotifier, int>(
  StreakNotifier.new,
);

class StreakNotifier extends AsyncNotifier<int> {
  @override
  Future<int> build() async {
    final repository = ref.read(waterRepositoryProvider);
    return repository.getStreak();
  }
}

// Week summary
final weekSummaryProvider =
AsyncNotifierProvider<WeekSummaryNotifier, Map<String, int>>(
  WeekSummaryNotifier.new,
);

class WeekSummaryNotifier extends AsyncNotifier<Map<String, int>> {
  @override
  Future<Map<String, int>> build() async {
    final repository = ref.read(waterRepositoryProvider);
    return repository.getWeekSummary();
  }
}