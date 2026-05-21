import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_notifier.dart';
import 'features/about/about_screen.dart';
import 'features/contacts/contacts_screen.dart';
import 'features/gallery/gallery_screen.dart';
import 'features/profile/profile_screen.dart';
import 'widgets/theme_toggle_button.dart';

class App extends StatefulWidget {
  final SharedPreferences prefs;

  const App({super.key, required this.prefs});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final ThemeNotifier _themeNotifier;

  @override
  void initState() {
    super.initState();
    _themeNotifier = ThemeNotifier(widget.prefs);
  }

  @override
  void dispose() {
    _themeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeNotifier,
      builder: (_, mode, __) => MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: mode,
        home: _MainScaffold(themeNotifier: _themeNotifier),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _MainScaffold extends StatefulWidget {
  final ThemeNotifier themeNotifier;

  const _MainScaffold({required this.themeNotifier});

  @override
  State<_MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<_MainScaffold> {
  int _tab = 0;

  // IndexedStack preserves scroll state across tab switches
  static const _screens = <Widget>[
    ProfileScreen(),
    GalleryScreen(),
    ContactsScreen(),
  ];

  static const _titles = <String>[
    AppStrings.tabProfile,
    AppStrings.tabGallery,
    AppStrings.tabContacts,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_tab]),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            tooltip: AppStrings.aboutTitle,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AboutScreen()),
            ),
          ),
          ThemeToggleButton(notifier: widget.themeNotifier),
          const SizedBox(width: 4),
        ],
      ),
      body: IndexedStack(
        index: _tab,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: AppStrings.tabProfile,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library_outlined),
            activeIcon: Icon(Icons.photo_library_rounded),
            label: AppStrings.tabGallery,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts_outlined),
            activeIcon: Icon(Icons.contacts_rounded),
            label: AppStrings.tabContacts,
          ),
        ],
      ),
    );
  }
}
