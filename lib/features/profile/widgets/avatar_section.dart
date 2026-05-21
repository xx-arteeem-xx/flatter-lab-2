import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class AvatarSection extends StatelessWidget {
  final int age;

  const AvatarSection({super.key, required this.age});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? AppColors.accent : AppColors.accentLight;

    return Column(
      children: [
        // Glow border + avatar
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: accent, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(0.3),
                blurRadius: 24,
                spreadRadius: 2,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 62,
            backgroundColor: accent.withOpacity(0.15),
            child: ClipOval(
              child: Image.asset(
                AppStrings.avatarAsset,
                width: 124,
                height: 124,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Text(
                  AppStrings.initials,
                  style: TextStyle(
                    fontSize: 36,
                    color: accent,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        // Full name
        Text(
          AppStrings.fullName,
          style: theme.textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        // City + age row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on_outlined, size: 16, color: accent),
            const SizedBox(width: 4),
            Text(AppStrings.city, style: theme.textTheme.bodyMedium),
            const SizedBox(width: 16),
            _AgeBadge(age: age, accent: accent),
          ],
        ),
      ],
    );
  }
}

class _AgeBadge extends StatelessWidget {
  final int age;
  final Color accent;

  const _AgeBadge({required this.age, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.12),
        border: Border.all(color: accent.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$age лет',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: accent),
      ),
    );
  }
}
