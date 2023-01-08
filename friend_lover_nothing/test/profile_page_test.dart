import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:friend_lover_nothing/application_config.dart';
import 'package:friend_lover_nothing/model/account.dart';
import 'package:friend_lover_nothing/pages/private_profile_page.dart';
import 'package:friend_lover_nothing/pages/public_profile_page.dart';
import 'package:nock/nock.dart';

void main() {
  testWidgets('private profile page display', (WidgetTester tester) async {
    nock.init();
    String json =
        "{\"id\": \"51690ba7-ea0a-4e85-bb4c-f203da4208bf\",\"email\": \"jasonhaoyuan@gmail.com\",\"firstName\": \"Hao\",\"lastName\": \"Yuan\",\"age\": 24,\"link\": \"test_f22d25badea5\",\"description\": \"Hello I'm Hao Yuan\",\"phone\": \"1234567890\",\"gender\": \"male\",\"interest1\": \"hiking\",\"interest2\": \"foodie\",\"interest3\": \"programing\"}";
    nock(backendURL)
        .get("/$accountPath/51690ba7-ea0a-4e85-bb4c-f203da4208bf")
        .reply(200, json);
    globalAccount =
        Future.delayed(Duration.zero, () => Account.fromJson(jsonDecode(json)));
    globalAccountId = "51690ba7-ea0a-4e85-bb4c-f203da4208bf";
    // Build our app and trigger a frame.
    isLoggedIn = true;
    await tester.pumpWidget(const MaterialApp(home: PrivateProfilePage()));
    await tester.pumpAndSettle();
    expect(find.textContaining('Hao Yuan'), findsNWidgets(3));
    expect(find.textContaining('male'), findsOneWidget);
    expect(find.textContaining('1234567890'), findsOneWidget);
    expect(find.textContaining('BASIC PROFILE'), findsOneWidget);
    nock.cleanAll();
  });

  testWidgets('public profile page display', (WidgetTester tester) async {
    nock.init();
    String json =
        "{\"id\": \"51690ba7-ea0a-4e85-bb4c-f203da4208bf\",\"email\": \"jasonhaoyuan@gmail.com\",\"firstName\": \"Hao\",\"lastName\": \"Yuan\",\"age\": 24,\"link\": \"test_f22d25badea5\",\"description\": \"Hello I'm Hao Yuan\",\"phone\": \"1234567890\",\"gender\": \"male\",\"interest1\": \"hiking\",\"interest2\": \"foodie\",\"interest3\": \"programing\"}";
    nock.init();
    nock(backendURL)
        .get("/$accountPath/51690ba7-ea0a-4e85-bb4c-f203da4208bf")
        .reply(200, json);
    nock(backendURL)
        .get("/$accountPath/51690ba7-ea0a-4e85-bb4c-f203da4208bf")
        .reply(200, json);
    // Build our app and trigger a frame.
    isLoggedIn = true;
    await tester.pumpWidget(const MaterialApp(
        home: PublicProfilePage(
      accountId: "51690ba7-ea0a-4e85-bb4c-f203da4208bf",
    )));
    await tester.pumpAndSettle();
    expect(find.textContaining('Hao Yuan'), findsNWidgets(3));
    expect(find.textContaining('male'), findsOneWidget);
    nock.cleanAll();
  });
}
