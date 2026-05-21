import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flatter_lab_2/app.dart';

void main() {
  testWidgets('App smoke test — renders BottomNavigationBar with 3 tabs',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(App(prefs: prefs));
    await tester.pumpAndSettle();

    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Профиль'), findsWidgets);
    expect(find.text('Галерея'), findsOneWidget);
    expect(find.text('Контакты'), findsOneWidget);
  });
}
