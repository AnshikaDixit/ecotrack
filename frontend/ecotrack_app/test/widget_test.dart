import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ecotrack_app/main.dart';
import 'package:ecotrack_app/providers/auth_provider.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    final authProvider = AuthProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: authProvider),
        ],
        child: MyApp(),
      ),
    );

    // Verify that login screen is shown initially.
    expect(find.byType(TextField), findsWidgets);
  });
}
