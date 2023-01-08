/*
Test for the Create Event Page.

Author:Sonam Shrestha 
*/
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:friend_lover_nothing/pages/create_event_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test Create Event Page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: CreateEventPage()));
    // finds the expected widgest using text and icon buttons
    expect(find.text('Create your Event!'), findsOneWidget);
    expect(find.text('Event Title'), findsOneWidget);
    expect(find.byIcon(Icons.camera_alt_rounded), findsNWidgets(2));
  });
}
