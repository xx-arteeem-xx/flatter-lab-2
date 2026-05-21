import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ValueNotifier<ThemeMode> {
  final SharedPreferences _prefs;
  static const _key = 'themeMode';

  ThemeNotifier(this._prefs)
      : super(
          _prefs.getString(_key) == 'light' ? ThemeMode.light : ThemeMode.dark,
        );

  void toggle() {
    value = value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _prefs.setString(_key, value == ThemeMode.dark ? 'dark' : 'light');
  }

  bool get isDark => value == ThemeMode.dark;
}
