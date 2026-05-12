// lib/features/settings/presentation/widgets/about_section.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AboutTile(
          icon: Icons.info_outline_rounded,
          title: 'Version',
          trailing: '1.0.0',
        ),
        const _Divider(),
        _AboutTile(
          icon: Icons.code_rounded,
          title: 'Built With',
          trailing: 'Flutter ❤️',
        ),
        const _Divider(),
        _AboutTile(
          icon: Icons.star_rounded,
          title: 'Rate App',
          trailing: null,
          onTap: () {
            // TODO: Open store rating
          },
        ),
        const _Divider(),
        _AboutTile(
          icon: Icons.share_rounded,
          title: 'Share with Friends',
          trailing: null,
          onTap: () {
            // TODO: Share app
          },
        ),
      ],
    );
  }
}

class _AboutTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailing;
  final VoidCallback? onTap;

  const _AboutTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: Colors.white54),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            if (trailing != null)
              Text(
                trailing!,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.4),
                  fontWeight: FontWeight.w500,
                ),
              ),
            if (onTap != null) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: Colors.white.withOpacity(0.3),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(height: 1, color: Colors.white.withOpacity(0.05)),
    );
  }
}