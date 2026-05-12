// lib/features/onboarding/presentation/widgets/onboarding_page.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class OnboardingPageData {
  final IconData icon;
  final List<Color> gradientColors;
  final String title;
  final String subtitle;
  final String emoji;

  const OnboardingPageData({
    required this.icon,
    required this.gradientColors,
    required this.title,
    required this.subtitle,
    required this.emoji,
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingPageData data;

  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Floating emoji
          TweenAnimationBuilder<double>(
            tween: Tween(begin: -10.0, end: 10.0),
            duration: const Duration(seconds: 2),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, value),
                child: child,
              );
            },
            child: Text(
              data.emoji,
              style: const TextStyle(fontSize: 60),
            ),
          ),

          const SizedBox(height: 40),

          // Animated icon container
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: data.gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: data.gradientColors.first.withOpacity(0.5),
                        blurRadius: 40,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    data.icon,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 48),

          // Title
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: data.gradientColors,
            ).createShader(bounds),
            child: Text(
              data.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Subtitle
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.6),
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}