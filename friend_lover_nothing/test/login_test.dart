import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:friend_lover_nothing/pages/signin_page.dart';

void main() {
  testWidgets('empty username and password', (WidgetTester tester) async {
    LoginPage loginPage = const LoginPage();
    await tester.pumpWidget(MaterialApp(home: loginPage));
    await tester.pumpAndSettle();

    debugPrint("Getting form widget");
    expect(find.textContaining('Email'), findsOneWidget);
    expect(find.textContaining('Password'), findsOneWidget);
  });
}
