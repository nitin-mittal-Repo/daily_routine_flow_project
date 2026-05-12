// lib/features/water_tracker/presentation/widgets/water_progress_hero.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/progress_ring.dart';

class WaterProgressHero extends StatelessWidget {
  final AsyncValue<double> progressAsync;
  final AsyncValue<int> totalAsync;
  final AsyncValue<int> goalAsync;
  final AsyncValue<int> remainingAsync;

  const WaterProgressHero({
    super.key,
    required this.progressAsync,
    required this.totalAsync,
    required this.goalAsync,
    required this.remainingAsync,
  });

  @override
  Widget build(BuildContext context) {
    return progressAsync.when(
      data: (progress) => totalAsync.when(
        data: (total) => goalAsync.when(
          data: (goal) => _buildContent(context, progress, total, goal),
          loading: () => _buildShimmer(context),
          error: (_, __) => _buildShimmer(context),
        ),
        loading: () => _buildShimmer(context),
        error: (_, __) => _buildShimmer(context),
      ),
      loading: () => _buildShimmer(context),
      error: (_, __) => _buildShimmer(context),
    );
  }

  Widget _buildContent(
      BuildContext context,
      double progress,
      int total,
      int goal,
      ) {
    final isGoalReached = progress >= 1.0;
    final totalFormatted = total >= 1000
        ? '${(total / 1000).toStringAsFixed(1)}L'
        : '${total}ml';
    final goalFormatted = goal >= 1000
        ? '${(goal / 1000).toStringAsFixed(1)}L'
        : '${goal}ml';

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          colors: [
            AppColors.primaryTeal.withOpacity(0.08),
            const Color(0xFF00B4D8).withOpacity(0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Progress Ring
          SizedBox(
            width: 200,
            height: 200,
            child: ProgressRing(
              progress: progress,
              size: 200,
              strokeWidth: 16,
              gradient: isGoalReached
                  ? const LinearGradient(
                colors: [Color(0xFF00FF88), AppColors.primaryTeal],
              )
                  : AppGradients.tealMint,
              backgroundColor: Colors.white.withOpacity(0.05),
              centerChild: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: isGoalReached
                    ? Column(
                  key: const ValueKey('celebration'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '🎉',
                      style: TextStyle(fontSize: 40),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Goal Met!',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF00FF88),
                      ),
                    ),
                  ],
                )
                    : Column(
                  key: const ValueKey('progress'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      totalFormatted,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '/ $goalFormatted',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Remaining text
          remainingAsync.when(
            data: (remaining) {
              if (remaining <= 0) {
                return const Text(
                  'Amazing! You\'re fully hydrated! 🌊',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF00FF88),
                    fontWeight: FontWeight.w600,
                  ),
                );
              }
              final remainingFormatted = remaining >= 1000
                  ? '${(remaining / 1000).toStringAsFixed(1)}L'
                  : '${remaining}ml';
              return Text(
                '$remainingFormatted more to go',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.5),
                  fontWeight: FontWeight.w500,
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // Percentage
          const SizedBox(height: 4),
          Text(
            '${(progress * 100).toInt()}%',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.primaryTeal.withOpacity(0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return Container(
      height: 340,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.white.withOpacity(0.03),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryTeal,
        ),
      ),
    );
  }
}