import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:friend_lover_nothing/pages/signup_page.dart';

void main() {
  testWidgets('empty username and password', (WidgetTester tester) async {
    SignUpPage signUpPage = const SignUpPage();
    await tester.pumpWidget(MaterialApp(home: signUpPage));
    await tester.pumpAndSettle();

    debugPrint("Getting form widget");
    expect(find.textContaining('Create an Account!'), findsOneWidget);
    expect(find.textContaining('First Name'), findsOneWidget);
    expect(find.textContaining('Last Name'), findsOneWidget);
    expect(find.textContaining('Email'), findsOneWidget);
    expect(find.textContaining('Password'), findsOneWidget);
    expect(find.textContaining('Required: Age'), findsOneWidget);
    expect(find.textContaining('Optional: Phone Number'), findsOneWidget);
  });
}
