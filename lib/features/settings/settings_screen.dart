// lib/features/settings/presentation/screens/settings_screen.dart
import 'package:daily_routine_flow/features/settings/widgets/about_section.dart';
import 'package:daily_routine_flow/features/settings/widgets/danger_zone.dart';
import 'package:daily_routine_flow/features/settings/widgets/notification_settings.dart';
import 'package:daily_routine_flow/features/settings/widgets/profile_section.dart';
import 'package:daily_routine_flow/features/settings/widgets/settings_app_bar.dart';
import 'package:daily_routine_flow/features/settings/widgets/settings_section.dart';
import 'package:daily_routine_flow/features/settings/widgets/theme_toggle.dart';
import 'package:daily_routine_flow/features/settings/widgets/water_goal_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0D0D2B),
              Color(0xFF1A0A2E),
              Color(0xFF0D0D2B),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const SafeArea(
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              // App Bar
              SliverToBoxAdapter(
                child: SettingsAppBar(),
              ),

              // Profile Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: ProfileSection(),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 16)),

              // Appearance Section
              SliverToBoxAdapter(
                child: SettingsSection(
                  title: 'Appearance',
                  icon: Icons.palette_outlined,
                  children: [
                    ThemeToggle(),
                  ],
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 12)),

              // Preferences Section
              SliverToBoxAdapter(
                child: SettingsSection(
                  title: 'Preferences',
                  icon: Icons.tune_rounded,
                  children: [
                    WaterGoalTile(),
                  ],
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 12)),

              // Notifications Section
              SliverToBoxAdapter(
                child: SettingsSection(
                  title: 'Notifications',
                  icon: Icons.notifications_outlined,
                  children: [
                    NotificationSettingsWidget(),
                  ],
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 12)),

              // About Section
              SliverToBoxAdapter(
                child: SettingsSection(
                  title: 'About',
                  icon: Icons.info_outline_rounded,
                  children: [
                    AboutSection(),
                  ],
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 12)),

              // Danger Zone
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: DangerZone(),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        ),
      ),
    );
  }
}