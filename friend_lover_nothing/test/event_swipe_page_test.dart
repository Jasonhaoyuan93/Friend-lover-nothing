
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:friend_lover_nothing/DAO/account_dao.dart';
import 'package:friend_lover_nothing/application_config.dart';
import 'package:friend_lover_nothing/pages/event_swipe_page.dart';
import 'package:nock/nock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('event page display', (WidgetTester tester) async {
    nock.init();
    globalAccountId = "51690ba7-ea0a-4e85-bb4c-f203da4208bf";
    nock(backendURL)
        .get("/$accountPath/51690ba7-ea0a-4e85-bb4c-f203da4208bf")
        .reply(200,
            "{\"id\": \"51690ba7-ea0a-4e85-bb4c-f203da4208bf\",\"email\": \"jasonhaoyuan@gmail.com\",\"firstName\": \"Hao\",\"lastName\": \"Yuan\",\"age\": 24,\"link\": \"test_f22d25badea5\",\"description\": \"Hello I'm Hao Yuan\",\"phone\": \"1234567890\",\"gender\": \"male\",\"profileImageLocation\": \"https://elasticbeanstalk-us-west-2-649460546911.s3.us-west-2.amazonaws.com/data/user/51690ba7-ea0a-4e85-bb4c-f203da4208bf/profile_image.jpg\",\"interest1\": \"hiking\",\"interest2\": \"foodie\",\"interest3\": \"programing\"}");

    nock(backendURL).get('/$eventPath/51690ba7-ea0a-4e85-bb4c-f203da4208bf').reply(
        200,
        "[    {        \"id\": 9,        \"account\": {            \"id\": \"uXWVpl0tMcYuvFWIV9Jl4pRtEap2\",            \"email\": \"celestino.hackett@huels.co.uk\",            \"firstName\": \"celestino\",            \"lastName\": \"hackett\",            \"age\": 22,            \"link\": \"test_f22d25badea5\",            \"description\": \"Hello I'm celestino hackett\",            \"phone\": \"1234567890\",            \"gender\": \"male\",            \"profileImageLocation\": \"https://i.pravatar.cc/300?u=celestino.hackett@huels.co.uk\",            \"interest1\": \"hiking\",            \"interest2\": \"foodie\",            \"interest3\": \"programing\"        },        \"eventImages\": [            {                \"id\": 25,                \"imageLocation\": \"https://elasticbeanstalk-us-west-2-649460546911.s3.us-west-2.amazonaws.com/data/event/9/image_0220612084941.jpg\",                \"imageDescription\": \"another drifting\"            },            {                \"id\": 26,                \"imageLocation\": \"https://elasticbeanstalk-us-west-2-649460546911.s3.us-west-2.amazonaws.com/data/event/9/image_1220612084941.jpg\",                \"imageDescription\": \"another hiking\"            },            {                \"id\": 27,                \"imageLocation\": \"https://elasticbeanstalk-us-west-2-649460546911.s3.us-west-2.amazonaws.com/data/event/9/image_2220612084941.jpeg\",                \"imageDescription\": \"another rock climbing\"            }        ],        \"videoLocation\": \"https://elasticbeanstalk-us-west-2-649460546911.s3.us-west-2.amazonaws.com/data/event/9/intro_video220612084940.mp4\",        \"closed\": false    }]");

    // Build our app and trigger a frame.
    isLoggedIn = true;
    globalAccount = fetchAccount(httpclient, globalAccountId);

    await tester.pumpWidget(const MaterialApp(home: SwipePage()));
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byIcon(Icons.refresh), findsOneWidget);
  });
}
