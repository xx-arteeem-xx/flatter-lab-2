import 'package:flutter/material.dart';
import '../core/theme/theme_notifier.dart';

class ThemeToggleButton extends StatelessWidget {
  final ThemeNotifier notifier;

  const ThemeToggleButton({super.key, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: notifier,
      builder: (_, mode, __) => IconButton(
        icon: Icon(
          mode == ThemeMode.dark
              ? Icons.light_mode_outlined
              : Icons.dark_mode_outlined,
        ),
        tooltip: mode == ThemeMode.dark ? 'Светлая тема' : 'Тёмная тема',
        onPressed: notifier.toggle,
      ),
    );
  }
}
