import 'package:flutter_test/flutter_test.dart';
import 'package:friend_lover_nothing/DAO/account_dao.dart';
import 'package:friend_lover_nothing/application_config.dart';
import 'package:friend_lover_nothing/model/account.dart';
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
    test('returns profile from REST API', () async {
      final client = MockClient();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse(
              '$backendURL/$accountPath/51690ba7-ea0a-4e85-bb4c-f203da4208bf')))
          .thenAnswer((_) async => http.Response(
              "{\"id\": \"51690ba7-ea0a-4e85-bb4c-f203da4208bf\",\"email\": \"jasonhaoyuan@gmail.com\",\"firstName\": \"Hao\",\"lastName\": \"Yuan\",\"age\": 24,\"link\": \"test_f22d25badea5\",\"description\": \"Hello I'm Hao Yuan\",\"phone\": \"1234567890\",\"gender\": \"male\",\"profileImageLocation\": \"https://elasticbeanstalk-us-west-2-649460546911.s3.us-west-2.amazonaws.com/data/user/51690ba7-ea0a-4e85-bb4c-f203da4208bf/profile_image.jpg\",\"interest1\": \"hiking\",\"interest2\": \"foodie\",\"interest3\": \"programing\"}",
              200));
      Account? account =
          await fetchAccount(client, '51690ba7-ea0a-4e85-bb4c-f203da4208bf');
      expect(account, isA<Account>());
      expect(account.toJson(), isNotNull);
    });

    test('return error when response is not 200', () {
      final client = MockClient();

      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse('$backendURL/$accountPath/1')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(fetchAccount(client, '1'), throwsException);
    });

    test('test fetch public account', () async {
      nock.init();
      nock(backendURL)
          .get("/$accountPath/51690ba7-ea0a-4e85-bb4c-f203da4208bf")
          .reply(200,
              "{\"id\": \"51690ba7-ea0a-4e85-bb4c-f203da4208bf\",\"email\": \"jasonhaoyuan@gmail.com\",\"firstName\": \"Hao\",\"lastName\": \"Yuan\",\"age\": 24,\"link\": \"test_f22d25badea5\",\"description\": \"Hello I'm Hao Yuan\",\"phone\": \"1234567890\",\"gender\": \"male\",\"profileImageLocation\": \"https://elasticbeanstalk-us-west-2-649460546911.s3.us-west-2.amazonaws.com/data/user/51690ba7-ea0a-4e85-bb4c-f203da4208bf/profile_image.jpg\",\"interest1\": \"hiking\",\"interest2\": \"foodie\",\"interest3\": \"programing\"}");
      Account? account = await fetchAccount(
          httpclient, '51690ba7-ea0a-4e85-bb4c-f203da4208bf');
      expect(account, isA<Account>());
      expect(account.toJson(), isNotNull);
      nock.cleanAll();
    });

    test('test update account', () async {
      nock.init();
      Account account = Account(
          id: "15",
          firstName: "Hao",
          lastName: "Yuan",
          email: "jasonhaoyuan@gmail.com");
      nock(backendURL)
          .post(
              '/$accountPath/$updatePath/',(body)=>body!=null )
          .reply(200,
              "{\"id\": \"15\",\"email\": \"jasonhaoyuan@gmail.com\", \"firstName\": \"Hao\",  \"lastName\": \"Yuan\",  \"age\": 30,  \"link\": \"test_f22d25badea5\",  \"description\": \"Hello I'm Hao Yuan\",  \"phone\": \"1234567890\",  \"gender\": \"male\",  \"interest1\": \"hiking\",  \"interest2\": \"foodie\",  \"interest3\": \"programing\"}");
      account = await updateAccount(account, null);
      expect(account, isA<Account>());
      expect(account.toJson(), isNotNull);
      nock.cleanAll();
    });
    
    test('test create account', () async {
      nock.init();
      Account account = Account(
          id: "15",
          firstName: "Hao",
          lastName: "Yuan",
          email: "jasonhaoyuan@gmail.com");
      nock(backendURL)
          .post(
              '/$accountPath/$createPath/',(body)=>body!=null )
          .reply(200,
              "{\"id\": \"15\",\"email\": \"jasonhaoyuan@gmail.com\", \"firstName\": \"Hao\",  \"lastName\": \"Yuan\",  \"age\": 30,  \"link\": \"test_f22d25badea5\",  \"description\": \"Hello I'm Hao Yuan\",  \"phone\": \"1234567890\",  \"gender\": \"male\",  \"interest1\": \"hiking\",  \"interest2\": \"foodie\",  \"interest3\": \"programing\"}");
      account = await createAccount(account);
      expect(account, isA<Account>());
      expect(account.toJson(), isNotNull);
      nock.cleanAll();
    });
  });
}
