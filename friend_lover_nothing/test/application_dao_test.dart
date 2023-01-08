import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:friend_lover_nothing/DAO/applicantion_dao.dart';
import 'package:friend_lover_nothing/application_config.dart';
import 'package:friend_lover_nothing/model/application.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nock/nock.dart';
import 'http_request_fetch_test.mocks.dart';

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks([http.Client])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('http_request_fetch', () {
    test('returns Appliaction from REST API', () async {
      final client = MockClient();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse(
              '$backendURL/$applicationPath/$ownerPath/51690ba7-ea0a-4e85-bb4c-f203da4208bf')))
          .thenAnswer((_) async => http.Response(
              "[    {        \"id\": 9,        \"account\": {            \"id\": \"uXWVpl0tMcYuvFWIV9Jl4pRtEap2\",            \"email\": \"celestino.hackett@huels.co.uk\",            \"firstName\": \"celestino\",            \"lastName\": \"hackett\",            \"age\": 22,            \"link\": \"test_f22d25badea5\",            \"description\": \"Hello I'm celestino hackett\",            \"phone\": \"1234567890\",            \"gender\": \"male\",            \"profileImageLocation\": \"https://i.pravatar.cc/300?u=celestino.hackett@huels.co.uk\",            \"interest1\": \"hiking\",            \"interest2\": \"foodie\",            \"interest3\": \"programing\"        },        \"eventImages\": [            {                \"id\": 25,                \"imageLocation\": \"https://elasticbeanstalk-us-west-2-649460546911.s3.us-west-2.amazonaws.com/data/event/9/image_0220612084941.jpg\",                \"imageDescription\": \"another drifting\"            },            {                \"id\": 26,                \"imageLocation\": \"https://elasticbeanstalk-us-west-2-649460546911.s3.us-west-2.amazonaws.com/data/event/9/image_1220612084941.jpg\",                \"imageDescription\": \"another hiking\"            },            {                \"id\": 27,                \"imageLocation\": \"https://elasticbeanstalk-us-west-2-649460546911.s3.us-west-2.amazonaws.com/data/event/9/image_2220612084941.jpeg\",                \"imageDescription\": \"another rock climbing\"            }        ],        \"videoLocation\": \"https://elasticbeanstalk-us-west-2-649460546911.s3.us-west-2.amazonaws.com/data/event/9/intro_video220612084940.mp4\",        \"closed\": false    }]",
              200));
      List<Application> applications = await fetchApplications(
          client, '51690ba7-ea0a-4e85-bb4c-f203da4208bf');
      expect(applications, isA<List<Application>>());
      expect(applications, isNotNull);
    });
    test('send close Appliaction instruction to rest api', () async {
      nock.init();
      Application application = Application.fromJson(json.decode(
          "{        \"id\": 9,        \"account\": {            \"id\": \"uXWVpl0tMcYuvFWIV9Jl4pRtEap2\",            \"email\": \"celestino.hackett@huels.co.uk\",            \"firstName\": \"celestino\",            \"lastName\": \"hackett\",            \"age\": 22,            \"link\": \"test_f22d25badea5\",            \"description\": \"Hello I'm celestino hackett\",            \"phone\": \"1234567890\",            \"gender\": \"male\",            \"profileImageLocation\": \"https://i.pravatar.cc/300?u=celestino.hackett@huels.co.uk\",            \"interest1\": \"hiking\",            \"interest2\": \"foodie\",            \"interest3\": \"programing\"        },        \"eventImages\": [            {                \"id\": 25,                \"imageLocation\": \"https://elasticbeanstalk-us-west-2-649460546911.s3.us-west-2.amazonaws.com/data/event/9/image_0220612084941.jpg\",                \"imageDescription\": \"another drifting\"            },            {                \"id\": 26,                \"imageLocation\": \"https://elasticbeanstalk-us-west-2-649460546911.s3.us-west-2.amazonaws.com/data/event/9/image_1220612084941.jpg\",                \"imageDescription\": \"another hiking\"            },            {                \"id\": 27,                \"imageLocation\": \"https://elasticbeanstalk-us-west-2-649460546911.s3.us-west-2.amazonaws.com/data/event/9/image_2220612084941.jpeg\",                \"imageDescription\": \"another rock climbing\"            }        ],        \"videoLocation\": \"https://elasticbeanstalk-us-west-2-649460546911.s3.us-west-2.amazonaws.com/data/event/9/intro_video220612084940.mp4\",        \"closed\": true    }"));
      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      nock(backendURL).post(
              '/$applicationPath/$closeApplicationPath/',
               (b) => b != null)
          .reply(200, "");
      await closeApplications(httpclient, application);
    });
  });
}
