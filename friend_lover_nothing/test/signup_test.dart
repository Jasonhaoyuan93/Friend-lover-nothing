/*
Test page for the Signup page

Author:Sonam Shrestha 
*/

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:friend_lover_nothing/pages/signup_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test Sign up Page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: SignUpPage()));
    // finds the expected widgest using text and elevated buttons
    expect(find.text('Create an Account!'), findsOneWidget);
    expect(find.text('First Name'), findsOneWidget);
    expect(find.text('Last Name'), findsOneWidget);
    expect(find.text('Your email address'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Sign up'), findsOneWidget);
  });
}
